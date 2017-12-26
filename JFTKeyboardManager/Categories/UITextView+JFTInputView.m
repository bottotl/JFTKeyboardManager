//
//  UITextView+JFTInputView.m
//  JFTKeyboardManager
//
//  Created by syfll on 2017/12/26.
//  Copyright © 2017年 syfll. All rights reserved.
//

#import "UITextView+JFTInputView.h"
#import <objc/runtime.h>

static void *JFTInputAccessoryViewStyleKey = &JFTInputAccessoryViewStyleKey;

@implementation UITextView (JFTInputView)

- (JFTInputAccessoryViewStyle)jft_inputAccessoryViewStyle {
    NSNumber *styleNumber = objc_getAssociatedObject(self, JFTInputAccessoryViewStyleKey);
    switch (styleNumber.integerValue) {
        case JFTInputAccessoryViewStyleNone:
            return JFTInputAccessoryViewStyleNone;
            break;
        case JFTInputAccessoryViewStyleEmoji:
            return JFTInputAccessoryViewStyleEmoji;
            break;
        default:
            return JFTInputAccessoryViewStyleNone;
            break;
    }
    return JFTInputAccessoryViewStyleNone;
}

- (void)setJft_inputAccessoryViewStyle:(JFTInputAccessoryViewStyle)jft_inputAccessoryViewStyle {
    NSNumber *styleNumber;
    switch (jft_inputAccessoryViewStyle) {
        case JFTInputAccessoryViewStyleNone:
            styleNumber = @(JFTInputAccessoryViewStyleNone);
            self.inputAccessoryView = nil;
            break;
        case JFTInputAccessoryViewStyleEmoji:
            styleNumber = @(JFTInputAccessoryViewStyleEmoji);
            self.inputAccessoryView = [JFTKeyboardManager sharedManager].customInputAccessoryView;
            break;
        default:
            self.inputAccessoryView = nil;
            styleNumber = @(JFTInputAccessoryViewStyleNone);
            break;
    }
    
    objc_setAssociatedObject(self, JFTInputAccessoryViewStyleKey, styleNumber, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)jft_changeToCustomInputView:(UIView *)customView {
    if (customView) {
        self.inputView = customView;
        [self reloadInputViews];
    }
}

- (void)jft_changeToDefaultInputView {
    self.inputView = nil;
    [self reloadInputViews];
}

@end
