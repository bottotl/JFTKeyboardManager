//
//  UIResponder+JFTKeyboard.m
//  JFTKeyboardManager
//
//  Created by syfll on 2018/3/10.
//  Copyright © 2018年 syfll. All rights reserved.
//

#import "UIResponder+JFTKeyboard.h"
#import "UITextView+JFTInputView.h"
#import <objc/runtime.h>

static void *JFTNeedAvoidKeyboardHideKey         = &JFTNeedAvoidKeyboardHideKey;
static void *JFTNeedInputAccessoryViewKey        = &JFTNeedInputAccessoryViewKey;
static void *JFTShouldResignOnTouchOutsideKey    = &JFTShouldResignOnTouchOutsideKey;

@implementation UIResponder (JFTKeyboard)

- (void)setJft_shouldResignOnTouchOutside:(BOOL)jft_shouldResignOnTouchOutside {
    objc_setAssociatedObject(self, JFTShouldResignOnTouchOutsideKey, @(jft_shouldResignOnTouchOutside), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)jft_shouldResignOnTouchOutside {
    return [(NSNumber *)objc_getAssociatedObject(self, JFTShouldResignOnTouchOutsideKey) boolValue];
}

- (void)setJft_needAvoidKeyboardHide:(BOOL)jft_needAvoidKeyboardHide {
    objc_setAssociatedObject(self, JFTNeedAvoidKeyboardHideKey, @(jft_needAvoidKeyboardHide), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)jft_needAvoidKeyboardHide {
    return [(NSNumber *)objc_getAssociatedObject(self, JFTNeedAvoidKeyboardHideKey) boolValue];
}

- (void)setJft_needInputAccessoryView:(BOOL)jft_needInputAccessoryView {
    objc_setAssociatedObject(self, JFTNeedInputAccessoryViewKey, @(jft_needInputAccessoryView), OBJC_ASSOCIATION_RETAIN);
    if (![self isKindOfClass:[UITextView class]]) return;
    if(jft_needInputAccessoryView) {
        ((UITextView *)self).jft_inputAccessoryViewStyle = JFTInputAccessoryViewStyleEmoji;
    } else {
        ((UITextView *)self).jft_inputAccessoryViewStyle = JFTInputAccessoryViewStyleNone;
    }
}

- (BOOL)jft_needInputAccessoryView {
    return [(NSNumber *)objc_getAssociatedObject(self, JFTNeedInputAccessoryViewKey) boolValue];
}


@end
