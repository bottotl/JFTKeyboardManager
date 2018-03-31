//
//  UIResponder+JFTKeyboard.m
//  JFTKeyboardManager
//
//  Created by syfll on 2018/3/10.
//  Copyright © 2018年 syfll. All rights reserved.
//

#import "UIResponder+JFTKeyboard.h"
#import <objc/runtime.h>
#import "JFTKeyboardManager.h"
#import "JFTInputAccessoryProtocol.h"

static void *JFTNeedAvoidKeyboardHideKey         = &JFTNeedAvoidKeyboardHideKey;
static void *JFTNeedInputAccessoryViewKey        = &JFTNeedInputAccessoryViewKey;
static void *JFTShouldResignOnTouchOutsideKey    = &JFTShouldResignOnTouchOutsideKey;
static void *JFTNeedEmojiInputButtonKey        = &JFTNeedEmojiInputButtonKey;
static void *JFTInputAccessoryLeftViewKey        = &JFTInputAccessoryLeftViewKey;

@implementation UIResponder (JFTKeyboard)

- (void)setJft_shouldResignOnTouchOutside:(BOOL)jft_shouldResignOnTouchOutside {
    __unused id x = [JFTKeyboardManager sharedManager];
    objc_setAssociatedObject(self, JFTShouldResignOnTouchOutsideKey, @(jft_shouldResignOnTouchOutside), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)jft_shouldResignOnTouchOutside {
    return [(NSNumber *)objc_getAssociatedObject(self, JFTShouldResignOnTouchOutsideKey) boolValue];
}

- (void)setJft_needAvoidKeyboardHide:(BOOL)jft_needAvoidKeyboardHide {
    __unused id x = [JFTKeyboardManager sharedManager];
    objc_setAssociatedObject(self, JFTNeedAvoidKeyboardHideKey, @(jft_needAvoidKeyboardHide), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)jft_needAvoidKeyboardHide {
    return [(NSNumber *)objc_getAssociatedObject(self, JFTNeedAvoidKeyboardHideKey) boolValue];
}

- (void)setJft_needInputAccessoryView:(BOOL)jft_needInputAccessoryView {
    __unused id x = [JFTKeyboardManager sharedManager];;
    objc_setAssociatedObject(self, JFTNeedInputAccessoryViewKey, @(jft_needInputAccessoryView), OBJC_ASSOCIATION_RETAIN);
    if (![self conformsToProtocol:@protocol(JFTInputAccessoryProtocol)]) return;
    id<JFTInputAccessoryProtocol> obj = (id<JFTInputAccessoryProtocol>)self;
    if(jft_needInputAccessoryView) {
        obj.jft_inputAccessoryViewStyle = JFTInputAccessoryViewStyleEmoji;
    } else {
        obj.jft_inputAccessoryViewStyle = JFTInputAccessoryViewStyleNone;
    }
}

- (BOOL)jft_needInputAccessoryView {
    return [(NSNumber *)objc_getAssociatedObject(self, JFTNeedInputAccessoryViewKey) boolValue];
}

- (void)setJft_needEomjiInputButton:(BOOL)jft_needEomjiInputButton {
    __unused id x = [JFTKeyboardManager sharedManager];;
    objc_setAssociatedObject(self, JFTNeedEmojiInputButtonKey, @(jft_needEomjiInputButton), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)jft_needEomjiInputButton {
    return [(NSNumber *)objc_getAssociatedObject(self, JFTNeedEmojiInputButtonKey) boolValue];
}

- (void)setJft_inputAccessoryLeftView:(UIView *)jft_inputAccessoryLeftView {
    __unused id x = [JFTKeyboardManager sharedManager];;
    objc_setAssociatedObject(self, JFTInputAccessoryLeftViewKey, jft_inputAccessoryLeftView, OBJC_ASSOCIATION_RETAIN);
}

- (UIView *)jft_inputAccessoryLeftView {
    return objc_getAssociatedObject(self, JFTInputAccessoryLeftViewKey);
}

@end
