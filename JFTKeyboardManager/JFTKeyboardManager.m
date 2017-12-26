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
#import "JFTTestEmojiInputAccessoryView.h"

static JFTKeyboardManager * _sharadManager = nil;

@interface JFTKeyboardManager()
@property (nonatomic, strong) NSMutableSet<Class> *enabledClasses;
@property (nonatomic, readonly) UITextView *currentActiveTextView;
@property (nonatomic, strong) JFTKeyboardModel *keyboardModel;///< save keyboard info
@property (nonatomic, strong) JFTTestEmojiInputAccessoryView *customInputAccessoryView;
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
        _customInputView = [UIView new];
        CGRect windowRect = [UIApplication sharedApplication].keyWindow.bounds;
        _customInputView.frame = CGRectMake(0, 0, CGRectGetWidth(windowRect), 210);
        _customInputView.backgroundColor = [UIColor blueColor];
        
        _customInputAccessoryView = [[JFTTestEmojiInputAccessoryView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(windowRect), 100)];
        __weak typeof(self) WeakSelf = self;
        _customInputAccessoryView.dismissKeyboardBlock = ^(void) {
            if ([WeakSelf.currentActiveTextView isFirstResponder]) {
                [WeakSelf.currentActiveTextView resignFirstResponder];
            }
        };
        
        _customInputAccessoryView.keyboardStateChangeBlock = ^(JFTTestEmojiInputAccessoryKeyboardState state) {
            if (state == JFTTestEmojiInputAccessoryKeyboardStateSystem) {
                [WeakSelf.currentActiveTextView jft_changeToDefaultInputView];
            } else {
                [WeakSelf.currentActiveTextView jft_changeToCustomInputView:WeakSelf.customInputView];
            }
        };
        
    }
    return self;
}

- (NSMutableSet<Class> *)enabledClasses {
    if (!_enabledClasses) {
        NSMutableSet *classList = [NSMutableSet set];
        if (objc_getClass("TestContentTextView")) {
            [classList addObject:objc_getClass("TestContentTextView")];
        }
        _enabledClasses = classList;
    }
    return _enabledClasses;
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
    [self adjustFrameIfNeed];
}

- (void)keyboardWillShow:(NSNotification *)aNotification {
    [self updateKeyboardModelWithKeyboardNotification:aNotification];
    [self adjustFrameIfNeed];
}

- (void)keyboardDidShow:(NSNotification *)aNotification {
    [self updateKeyboardModelWithKeyboardNotification:aNotification];
}

- (void)keyboardWillHide:(NSNotification *)aNotification {
    [self updateKeyboardModelWithKeyboardNotification:aNotification];
    [self adjustFrameIfNeed];
}

- (void)keyboardDidHide:(NSNotification *)aNotification {
    [self updateKeyboardModelWithKeyboardNotification:aNotification];
}

- (void)textViewDidBeginEditing:(NSNotification *)aNotification {
    [self adjustFrameIfNeed];
}

- (void)textViewDidEndEditing:(NSNotification *)aNotification {
}

- (void)adjustFrameIfNeed {
    if (!self.currentActiveTextView) return;
    
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
    NSObject *firstResponder = [UIResponder jft_currentFirstResponder];
    if (!firstResponder) return nil;
    if ([self.enabledClasses containsObject:firstResponder.class]) {
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

@end
