//
//  UIScrollView+JFTKeyboardManager.m
//  JFTKeyboardManager
//
//  Created by syfll on 2017/12/26.
//  Copyright © 2017年 syfll. All rights reserved.
//

#import "UIScrollView+JFTKeyboardManager.h"
#import <objc/runtime.h>

static void *JFTScrollViewOriginContentInsetsKey = &JFTScrollViewOriginContentInsetsKey;

@implementation UIScrollView (JFTKeyboardManager)

- (void)setJft_originContentInsetValue:(NSValue *)jft_originContentInsetValue {
    objc_setAssociatedObject(self, JFTScrollViewOriginContentInsetsKey, jft_originContentInsetValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSValue *)jft_originContentInsetValue {
    return objc_getAssociatedObject(self, JFTScrollViewOriginContentInsetsKey);
}

@end
