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
#import "UITextView+JFTInputView.h"
#import "RACEXTScope.h"
#import "UIViewController+JFTTextInput.h"
#import "UIResponder+JFTKeyboard.h"
#import "JFTKeyboardManager+Private.h"

static JFTKeyboardManager * _sharadManager = nil;

@interface JFTKeyboardManager()
@property (nonatomic, strong) JFTTestEmojiInputView *customInputView;
@property (nonatomic, strong) NSHashTable<UIViewController*> *messageBarViewController;
@property (nonatomic, readonly) UITextView *currentActiveTextView;
@property (nonatomic, strong) JFTKeyboardModel *keyboardModel;///< save keyboard info
@property (nonatomic, strong) JFTTestEmojiInputAccessoryView *customInputAccessoryView;
//@property (nonatomic, strong) UITapGestureRecognizer *touchOutSideTapGesture;
@end

@implementation JFTKeyboardManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharadManager = [[JFTKeyboardManager alloc] init];
        [_sharadManager registerAllNotifications];
        _sharadManager.keyboardModel = [JFTKeyboardModel new];
    });
    return _sharadManager;
}

- (instancetype)init {
    if (self = [super init]) {
        _messageBarViewController = [NSHashTable weakObjectsHashTable];
        @weakify(self);
        _customInputView = [JFTTestEmojiInputView new];
        _customInputView.emojiItemDidClick = ^(NSString *emojiItem) {
            @strongify(self);
            if (self.currentActiveTextView) {
                [self addEmojiItem:emojiItem toTextView:self.currentActiveTextView];
            }
        };
        CGRect windowRect = [UIApplication sharedApplication].keyWindow.bounds;
        _customInputView.frame = CGRectMake(0, 0, CGRectGetWidth(windowRect), 210);
        _customInputView.backgroundColor = [UIColor blueColor];
        
        _customInputAccessoryView = [[JFTTestEmojiInputAccessoryView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(windowRect), 100)];
        
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
    return self;
}

- (void)addEmojiItem:(NSString *)emoji toTextView:(UITextView *)textView {
    NSParameterAssert(textView || emoji);
    UITextRange *range = textView.selectedTextRange;
    [self.currentActiveTextView replaceRange:range withText:emoji];
}

- (void)registerAllNotifications {
    //  Registering for keyboard notification.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    //  Registering for UITextView notification.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidBeginEditing:) name:UITextViewTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidEndEditing:) name:UITextViewTextDidEndEditingNotification object:nil];
}

- (void)keyboardFrameWillChange:(NSNotification *)aNotification {
    [self updateKeyboardModelWithKeyboardNotification:aNotification];
    [self updateMessageBar];
    [self adjustScrollViewOffsetIfNeed];
}

- (void)updateMessageBar {
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat bottomInsert = screenHeight - self.keyboardModel.frameEnd.origin.y;
    [self.messageBarViewController.allObjects enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [UIView animateWithDuration:self.keyboardModel.animationDuraiton delay:0 options:self.keyboardModel.animationCurve animations:^{
            [obj jft_updateToolBarBottomInsert:bottomInsert];
        } completion:nil];
    }];
}

- (void)keyboardWillShow:(NSNotification *)aNotification {
    [self updateKeyboardModelWithKeyboardNotification:aNotification];
    [self adjustScrollViewOffsetIfNeed];
}

- (void)keyboardDidShow:(NSNotification *)aNotification {
    [self updateKeyboardModelWithKeyboardNotification:aNotification];
}

- (void)keyboardWillHide:(NSNotification *)aNotification {
    [self.customInputAccessoryView reset];
    self.currentActiveTextView.inputView = nil;
    [self updateKeyboardModelWithKeyboardNotification:aNotification];
    [self adjustScrollViewOffsetIfNeed];
}

- (void)keyboardDidHide:(NSNotification *)aNotification {
    [self updateKeyboardModelWithKeyboardNotification:aNotification];
}

- (void)textViewDidBeginEditing:(NSNotification *)aNotification {
    [self adjustScrollViewOffsetIfNeed];
}

- (void)textViewDidEndEditing:(NSNotification *)aNotification {
}

- (void)adjustScrollViewOffsetIfNeed {
    if (!self.currentActiveTextView) return;
    if (!self.currentActiveTextView.jft_needAvoidKeyboardHide) return;
    UITextView *textView = self.currentActiveTextView;
    
    UIScrollView *superScrollView = nil;
    UIScrollView *superView = (UIScrollView*)[textView superviewOfClassType:[UIScrollView class]];
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
    if (!superView) return;
    
    UIWindow *keyWindow = textView.window;
    CGRect textViewRect = [textView convertRect:textView.bounds
                                         toView:keyWindow];
    if (![self isKeyboardCoverTextView:self.keyboardModel textViewRectInWindow:textViewRect]) {
        /// keyboard does not cover textview nothing need to do, direct return
        return;
    }
    
    CGFloat offsetY = 0;
    {
        CGRect keyboardFrame = self.keyboardModel.frameEnd;
        CGRect intersectRect = CGRectIntersection(textViewRect, keyboardFrame);
        offsetY = intersectRect.size.height;
    }
    
    CGFloat maxOffset = superView.contentOffset.y + superView.bounds.size.height + superView.contentInset.bottom + superView.contentInset.top;
    
    CGFloat targetContentOffsetY = superView.contentOffset.y + offsetY;
    if (maxOffset < targetContentOffsetY) {
        superView.jft_originContentInsetValue = [NSValue valueWithUIEdgeInsets:superView.contentInset];
        CGFloat offset = targetContentOffsetY - maxOffset;
        UIEdgeInsets newContentInset;
        newContentInset = superView.contentInset;
        newContentInset.bottom += offset;
    }
    
    superView.contentOffset = CGPointMake(superView.contentOffset.x, targetContentOffsetY);
//    NSLog(@"isKeyboardCoverTextView === %@", @());
}

- (BOOL)isKeyboardCoverTextView:(JFTKeyboardModel *)keyboardModel textViewRectInWindow:(CGRect)rect {
    CGRect keyboardFrame = keyboardModel.frameEnd;
    CGRect intersectRect = CGRectIntersection(rect, keyboardFrame);
    if (CGRectIsNull(intersectRect)) {
        return NO;
    }
    return YES;
}

- (UITextView *)currentActiveTextView {
    UIResponder *firstResponder = [UIResponder jft_currentFirstResponder];
    if (!firstResponder) return nil;
    if ([firstResponder isKindOfClass:[UITextView class]]) {
        return (UITextView *)firstResponder;
    } else {
        return nil;
    }
}

- (void)updateKeyboardModelWithKeyboardNotification:(NSNotification *)aNotification {
    NSDictionary *userInfo = aNotification.userInfo;
    if (!userInfo) return;
    
    self.keyboardModel.animationCurve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    self.keyboardModel.animationDuraiton = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    self.keyboardModel.frameBegin = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    self.keyboardModel.frameEnd = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.keyboardModel.isLocal = [[userInfo objectForKey:UIKeyboardIsLocalUserInfoKey] boolValue];
}

- (void)registViewController:(UIViewController *)viewController {
    [self.messageBarViewController addObject:viewController];
}

- (void)resignViewController:(UIViewController *)viewController {
    [self.messageBarViewController removeObject:viewController];
}

#pragma mark - Gesture delegate

//
//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//    //  Should not recognize gesture if the clicked view is either UIControl or UINavigationBar(<Back button etc...)    (Bug ID: #145)
//    for (Class aClass in self.touchResignedGestureIgnoreClasses)
//    {
//        if ([[touch view] isKindOfClass:aClass])
//        {
//            return NO;
//        }
//    }
//
//    return YES;
//}


@end
