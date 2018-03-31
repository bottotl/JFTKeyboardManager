//
//  JFTKeyboardManager.m
//  JFTKeyBoardManager
//
//  Created by syfll on 2017/12/22.
//  Copyright © 2017年 syfll. All rights reserved.
//

#import "JFTKeyboardManager.h"
#import <objc/runtime.h>
#import "UIView+JFTKeyboardHierarchy.h"
#import "JFTKeyboardModel.h"
#import "UIResponder+JFTFirstResponder.h"
#import "UIScrollView+JFTKeyboardManager.h"
#import "UIView+JFTTextInput.h"
#import "RACEXTScope.h"
#import "UIViewController+JFTTextInput.h"
#import "UIResponder+JFTKeyboard.h"
#import "JFTKeyboardManager+Private.h"
#import "UIView+JFTTextInputTrigger.h"
#import "UIScrollView+JFTDisableKeyboardManager.h"

static JFTKeyboardManager * _sharadManager = nil;

@interface JFTKeyboardManager()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) NSHashTable<UIViewController*> *messageBarViewController;
@property (nonatomic, readonly) UIView<UITextInput> *currentActiveTextView;
@property (nonatomic, strong) JFTKeyboardModel *keyboardModel;///< save keyboard info
@property (nonatomic, strong) JFTTestEmojiInputAccessoryView *customInputAccessoryView;
@property (nonatomic, strong) UITapGestureRecognizer *touchOutSideTapGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *touchOutSidePanGesture;

@property (nonatomic, weak) UIView *textInputTrigger;
@end

@implementation JFTKeyboardManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharadManager = [[JFTKeyboardManager alloc] init];
        [_sharadManager registerAllNotifications];
    });
    return _sharadManager;
}

- (instancetype)init {
    if (self = [super init]) {
        _messageBarViewController = [NSHashTable weakObjectsHashTable];
        
        [self setupInputAccessoryView];
        
        _touchOutSideTapGesture = [UITapGestureRecognizer new];
        [_touchOutSideTapGesture addTarget:self action:@selector(resignOnTouchOutside)];
        _touchOutSideTapGesture.delegate = self;
        _touchOutSidePanGesture = [UIPanGestureRecognizer new];
        [_touchOutSidePanGesture addTarget:self action:@selector(resignOnTouchOutside)];
        _touchOutSidePanGesture.delegate = self;
    }
    return self;
}

- (void)registerAllNotifications {
    //  Registering for keyboard notification.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)keyboardFrameWillChange:(NSNotification *)aNotification {
    [self updateKeyboardModelWithKeyboardNotification:aNotification];
    [self updateMessageBar];
    [self adjustScrollViewOffsetIfNeed];
}

- (void)updateMessageBar {
    if (!self.keyboardModel) return;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat bottomInsert = screenHeight - self.keyboardModel.frameEnd.origin.y;
    [self.messageBarViewController.allObjects enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // 这个方法会在 keyboardFrameWillChange 中调用，因此所有关于视图变化都会被包在键盘的动画中，因此需要 jft_updateMaskViewWithOutAnimation 会把layer的动画手动移除
        if (bottomInsert > 0) {
            [obj jft_hideMaskView];
        } else {
            [obj jft_showMaskView];
        }
        [obj jft_updateMaskViewWithOutAnimation];
        [obj jft_updateToolBarBottomInset:bottomInsert];
        
        [UIView animateKeyframesWithDuration:self.keyboardModel.animationDuraiton delay:0 options:self.keyboardModel.animationCurve | UIViewKeyframeAnimationOptionBeginFromCurrentState animations:^{
            [obj.jft_messageBar.superview layoutIfNeeded];
            [obj.jft_vcMaskView.superview layoutIfNeeded];
            if (bottomInsert > 0) {
                [obj jft_showMaskView];
            } else {
                [obj jft_hideMaskView];
            }
        } completion:nil];
    }];
}

- (void)keyboardWillShow:(NSNotification *)aNotification {
    [self updateKeyboardModelWithKeyboardNotification:aNotification];
    [self updateInputAccessoryViewWithTextInputView:self.currentActiveTextView];
}

- (void)keyboardDidShow:(NSNotification *)aNotification {
    [self updateKeyboardModelWithKeyboardNotification:aNotification];
    [self attachGestures];
}

- (void)keyboardWillHide:(NSNotification *)aNotification {
    [self updateKeyboardModelWithKeyboardNotification:aNotification];
}

- (void)keyboardDidHide:(NSNotification *)aNotification {
    [self updateKeyboardModelWithKeyboardNotification:aNotification];
    [self reset];
}

- (void)reset {
    self.currentActiveTextView.jft_inputView = nil;
    self.keyboardModel = nil;
    [self.customInputAccessoryView reset];
    [self resetInputAccessoryView];
    [self resignTextInputTrigger];
    [self removeGestures];
}

- (void)adjustScrollViewOffsetIfNeed {
    if (!self.keyboardModel) return;
    /// 正常有两种情况
    /// 1.scroll view 中的 TextView 成为 firstResponder 触发的键盘
    /// 2.scroll view 中的某个按钮（或者其他什么）让某个 textView （比如 message bar 中的 textView）成为 firstResponder
    /// 第二种拥有更高的优先级
    
    /// 还有特殊情况的列子：某个按钮成为 trigger 以后 push 到了另外一个页面，另外的页面主动把 TextView 设为 firstResponder，这种做为一个特例排除
    UIView *textInputTrigger = ({
        UIView *trigger;
        if (self.textInputTrigger && self.textInputTrigger.window) {
            trigger = self.textInputTrigger;
        } else {
            trigger = self.currentActiveTextView;
        }
        trigger;
    });
    
    if (!textInputTrigger.jft_needAvoidKeyboardHide) return;
    
    UIScrollView *superScrollView = nil;
    UIScrollView *superView = (UIScrollView*)[textInputTrigger superviewOfClassType:[UIScrollView class]];
    //Getting UIScrollView whose scrolling is enabled.
    while (superView) {
        if (superView.isScrollEnabled) {
            superScrollView = superView;
            break;
        } else {
            superView = (UIScrollView*)[superView superviewOfClassType:[UIScrollView class]];
        }
    }
    // adjust frame
    if (!superView || superView.jft_shouldDisableKeyboardManager) return;
    
    UIWindow *keyWindow = textInputTrigger.window;
    
    CGRect triggerRectInWindow = ({
        CGRect triggerRect = textInputTrigger.bounds;
        CGFloat customBottomInsert = textInputTrigger.jft_bottomOffset;
        CGRect customedTriggerRect = CGRectMake(triggerRect.origin.x, triggerRect.origin.y, triggerRect.size.width, triggerRect.size.height + customBottomInsert);
        [textInputTrigger convertRect:customedTriggerRect toView:keyWindow];
    });
    
    
    CGRect internalKeyboardFrame = ({
        CGRect keyboardFrame = self.keyboardModel.frameEnd;
        UIViewController *triggerNearestVC = textInputTrigger.nearestViewController;
        /// 计算键盘的高度的时候不能直接拿到 MessageBar convertRect to window
        /// 因为这时候还
        CGFloat msgBarHeight = 0;
        if (triggerNearestVC.jft_needMessageBar) {
            msgBarHeight = triggerNearestVC.jft_messageBar.currentHeight;
            msgBarHeight -= [JFTMessageStyleToolBar jft_homeIndicatorHeight];
        }
        CGRectMake(keyboardFrame.origin.x, keyboardFrame.origin.y - msgBarHeight, keyboardFrame.size.width, keyboardFrame.size.height + msgBarHeight);
    });
    
//    BOOL keyboardCoverdTrigger = [self isKeyboardCoverTextView:internalKeyboardFrame rectInWindow:triggerRectInWindow];
//    if (!keyboardCoverdTrigger) return;
    
    CGFloat offsetY = ({/// offset need to add to scroll view
        CGFloat triggerMaxY = CGRectGetMaxY(triggerRectInWindow);
        CGFloat keyboardMinY = CGRectGetMinY(internalKeyboardFrame);
        triggerMaxY - keyboardMinY;
    });
    
    CGFloat targetContentOffsetY = superView.contentOffset.y + offsetY;
    /// 没空间向下移了
    if (targetContentOffsetY<0) targetContentOffsetY = 0;
    [UIView animateKeyframesWithDuration:self.keyboardModel.animationDuraiton delay:0 options: self.keyboardModel.animationCurve | UIViewKeyframeAnimationOptionBeginFromCurrentState animations:^{
        superView.contentOffset = CGPointMake(superView.contentOffset.x, targetContentOffsetY);
    } completion:nil];
}

- (BOOL)isKeyboardCoverTextView:(CGRect)keyboardFrame rectInWindow:(CGRect)rect {
    CGRect intersectRect = CGRectIntersection(rect, keyboardFrame);
    if (CGRectIsNull(intersectRect)) {
        return NO;
    }
    return YES;
}

- (UIView<UITextInput> *)currentActiveTextView {
    UIResponder *firstResponder = [UIResponder jft_currentFirstResponder];
    if (!firstResponder) return nil;
    if ([firstResponder conformsToProtocol:@protocol(UITextInput)] && [firstResponder isKindOfClass:[UIView class]]) {
        return (UIView<UITextInput> *)firstResponder;
    } else {
        return nil;
    }
}

- (void)updateKeyboardModelWithKeyboardNotification:(NSNotification *)aNotification {
    NSDictionary *userInfo = aNotification.userInfo;
    if (!userInfo) return;
    self.keyboardModel = [JFTKeyboardModel new];
    self.keyboardModel.animationCurve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    self.keyboardModel.animationDuraiton = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    self.keyboardModel.frameBegin = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    self.keyboardModel.frameEnd = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    self.keyboardModel.isLocal = [[userInfo objectForKey:UIKeyboardIsLocalUserInfoKey] boolValue];
}

- (void)registerViewController:(UIViewController *)viewController {
    [self.messageBarViewController addObject:viewController];
}

- (void)resignViewController:(UIViewController *)viewController {
    [self.messageBarViewController removeObject:viewController];
}

#pragma mark - Gesture

- (void)attachGestures {
    if (!self.currentActiveTextView.jft_shouldResignOnTouchOutside) return;
    UIWindow *keywindow = [UIApplication sharedApplication].keyWindow;
    [keywindow addGestureRecognizer:self.touchOutSideTapGesture];
    [keywindow addGestureRecognizer:self.touchOutSidePanGesture];
}

- (void)removeGestures {
    if (!self.currentActiveTextView.jft_shouldResignOnTouchOutside) return;
    [self.touchOutSideTapGesture.view removeGestureRecognizer:self.touchOutSideTapGesture];
    [self.touchOutSidePanGesture.view removeGestureRecognizer:self.touchOutSidePanGesture];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return [self gestureShouldRespond:gestureRecognizer touch:touch];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return [self gestureOwned:gestureRecognizer];
}

- (BOOL)gestureShouldRespond:(UIGestureRecognizer *)gestureRecognizer touch:(UITouch *)touch {
    if (!self.currentActiveTextView) {
        NSLog(@"这里有问题");
        return NO;
    }
    
    BOOL gestureOwned, rectOutSideViewOwned, rectOutSideKeyboard;
    
    gestureOwned = [self gestureOwned:gestureRecognizer];
    
    CGPoint point = [touch locationInView:[UIApplication sharedApplication].keyWindow];
//    NSLog(@"%@", [NSValue valueWithCGPoint:point]);
    CGRect currentActiveTextViewRectInWindow = [self.currentActiveTextView convertRect:self.currentActiveTextView.bounds toView:[UIApplication sharedApplication].keyWindow];
    rectOutSideViewOwned = !CGRectContainsPoint(currentActiveTextViewRectInWindow, point);
//    NSLog(@"【rectOutSideViewOwned:%@】", @(rectOutSideViewOwned));
    
    CGRect keyboardFrame = self.keyboardModel.frameEnd;
    rectOutSideKeyboard = !CGRectContainsPoint(keyboardFrame, point);
//    NSLog(@"【rectOutSideKeyboard%@】", @(rectOutSideKeyboard));
    return gestureOwned && rectOutSideViewOwned && rectOutSideKeyboard;
}

- (BOOL)gestureOwned:(UIGestureRecognizer *)gestureRecognizer {
    return gestureRecognizer == self.touchOutSidePanGesture || gestureRecognizer == self.touchOutSideTapGesture;
}

- (void)resignOnTouchOutside {
    [self resignTextInputTrigger];
    [self recoverScrollViewBeforeResignFirstResponder:self.currentActiveTextView];
    [self.currentActiveTextView resignFirstResponder];
}

/**
 为了解决 adjustScrollViewOffsetIfNeed 过程中设置过多 contentOffset 的问题
 但是思路似乎不通用，不知道会不会有什么坑

 @param currentActiveTextView 当前激活的 TextView
 */
- (void)recoverScrollViewBeforeResignFirstResponder:(UIView *)currentActiveTextView {
    // find scroll view
    UIView *rootView = currentActiveTextView.nearestViewController.view;
    NSArray <UIScrollView *>*scrollViews = [rootView subviewsOfClassType:[UIScrollView class]];
    
    [scrollViews enumerateObjectsUsingBlock:^(UIScrollView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGFloat minContentOffset = -obj.contentInset.top;
        
        CGFloat maxContentOffset = 0;
        CGFloat customContentHeight = obj.contentSize.height + obj.contentInset.top + obj.contentInset.bottom;
        if (customContentHeight > obj.bounds.size.height) {
            maxContentOffset = customContentHeight - obj.bounds.size.height - obj.contentInset.top;
        } else {
            maxContentOffset = minContentOffset;
        }
        
        if (obj.contentOffset.y > maxContentOffset) {
            obj.contentOffset = CGPointMake(obj.contentOffset.x, maxContentOffset);
        }
    }];
    
}

#pragma mark - TextInput trigger

- (void)registerTextInputTrigger:(UIView *)view {
    self.textInputTrigger = view;
}

- (void)resignTextInputTrigger {
    self.textInputTrigger = nil;
}

#pragma mark - Input Accessory view

- (void)setupInputAccessoryView {
    @weakify(self);
    _customInputView = [JFTTestEmojiInputView new];
    _customInputView.emojiItemDidClick = ^(NSString *emoji) {
        @strongify(self);
        if (self.currentActiveTextView) {
            [self addEmojiItem:emoji toTextInputView:self.currentActiveTextView];
        }
    };
    
    CGRect windowRect = [UIApplication sharedApplication].keyWindow.bounds;
    _customInputView.frame = CGRectMake(0, 0, CGRectGetWidth(windowRect), 220);
    
    _customInputAccessoryView = [[JFTTestEmojiInputAccessoryView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(windowRect), 44)];
    
    _customInputAccessoryView.dismissKeyboardBlock = ^(void) {
        @strongify(self);
        if ([self.currentActiveTextView isFirstResponder]) {
            [self.currentActiveTextView resignFirstResponder];
        }
    };
    _customInputAccessoryView.keyboardStateChangeBlock = ^(JFTTestEmojiInputAccessoryKeyboardState state) {
        @strongify(self);
        if (state == JFTTestEmojiInputAccessoryKeyboardStateSystem) {
            [self.currentActiveTextView jft_changeToDefaultInputView];
        } else {
            [self.currentActiveTextView jft_changeToCustomInputView:self.customInputView];
        }
    };
}

- (void)addEmojiItem:(NSString *)emoji toTextInputView:(id<UITextInput>)inputView {
    NSParameterAssert(inputView || emoji);
    UITextRange *range = inputView.selectedTextRange;
    [self.currentActiveTextView replaceRange:range withText:emoji];
}

- (void)updateInputAccessoryViewWithTextInputView:(UIView<UITextInput> *)view {
//    self.customInputAccessoryView.needEmojiButton = view.jft_needEomjiInputButton;
    if (view.jft_inputAccessoryLeftView) {
//        self.customInputAccessoryView.customView = view.jft_inputAccessoryLeftView;
    }
    [self.customInputAccessoryView setNeedsLayout];
    [self.customInputAccessoryView layoutIfNeeded];
}

- (void)resetInputAccessoryView {
//    self.customInputAccessoryView.needEmojiButton = NO;
//    self.customInputAccessoryView.customView = nil;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
