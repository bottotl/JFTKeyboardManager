//
//  UIView+JFTTextInputTrigger.m
//  JFTKeyboardManager
//
//  Created by syfll on 2018/3/12.
//  Copyright © 2018年 syfll. All rights reserved.
//

#import "UIView+JFTTextInputTrigger.h"
#import "UIResponder+JFTKeyboard.h"
#import "JFTKeyboardManager.h"
#import <objc/runtime.h>

static void *JFTBottomOffsetKey = &JFTBottomOffsetKey;

@implementation UIView (JFTTextInputTrigger)
- (void)jft_becomeTextInputTrigger {
    self.jft_needAvoidKeyboardHide = YES;
    [[JFTKeyboardManager sharedManager] registerTextInputTrigger:self];
}

- (void)setJft_bottomOffset:(CGFloat)jft_bottomOffset {
    __unused id x = [JFTKeyboardManager sharedManager];;
    objc_setAssociatedObject(self, JFTBottomOffsetKey, @(jft_bottomOffset), OBJC_ASSOCIATION_RETAIN);
}

- (CGFloat)jft_bottomOffset {
    return [(NSNumber *)objc_getAssociatedObject(self, JFTBottomOffsetKey) floatValue];
}

@end
