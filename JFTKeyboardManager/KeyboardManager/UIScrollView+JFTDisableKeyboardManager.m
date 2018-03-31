//
//  UIScrollView+JFTDisableKeyboardManager.m
//  JFTBase
//
//  Created by syfll on 2018/3/15.
//

#import "UIScrollView+JFTDisableKeyboardManager.h"
#import <objc/runtime.h>
#import "JFTKeyboardManager.h"

static void *kJFTDisableKeyboardManagerKey = &kJFTDisableKeyboardManagerKey;

@implementation UIScrollView (JFTDisableKeyboardManager)

- (void)setJft_shouldDisableKeyboardManager:(BOOL)jft_shouldDisableKeyboardManager {
    __unused id x = [JFTKeyboardManager sharedManager];
    objc_setAssociatedObject(self, kJFTDisableKeyboardManagerKey, @(jft_shouldDisableKeyboardManager), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)jft_shouldDisableKeyboardManager {
    return [(NSNumber *)objc_getAssociatedObject(self, kJFTDisableKeyboardManagerKey) boolValue];
}

@end
