//
//  UIView+JFTTextInput.m
//  JFTKeyboard
//
//  Created by syfll on 2018/3/16.
//

#import "UIView+JFTTextInput.h"
#import <objc/runtime.h>
#import "JFTKeyboardManager+Private.h"
#import "UIResponder+JFTFirstResponder.h"

static void *JFTInputAccessoryViewStyleKey = &JFTInputAccessoryViewStyleKey;

@implementation UIView (JFTTextInput)
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
            self.jft_inputAccessoryView = nil;
            break;
        case JFTInputAccessoryViewStyleEmoji:
            styleNumber = @(JFTInputAccessoryViewStyleEmoji);
            self.jft_inputAccessoryView = [JFTKeyboardManager sharedManager].customInputAccessoryView;
            break;
        default:
            self.jft_inputAccessoryView = nil;
            styleNumber = @(JFTInputAccessoryViewStyleNone);
            break;
    }
    
    objc_setAssociatedObject(self, JFTInputAccessoryViewStyleKey, styleNumber, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)jft_changeToCustomInputView:(UIView *)customView {
    if (customView) {
        self.jft_inputView = customView;
        [self reloadInputViews];
    }
}

- (void)jft_changeToDefaultInputView {
    self.jft_inputView = nil;
    [self reloadInputViews];
}
@end
