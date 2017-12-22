//
//  UIScrollView+JFTKeyboardAvoid.m
//  JFTKeyBoardManager
//
//  Created by syfll on 2017/12/22.
//  Copyright © 2017年 syfll. All rights reserved.
//

#import "UIScrollView+JFTKeyboardAvoid.h"
#import <objc/runtime.h>

static const void *JFTOriginContentInsetKey = &JFTOriginContentInsetKey;
static const void *JFTOriginContentOffsetKey = &JFTOriginContentOffsetKey;

@implementation UIScrollView (JFTKeyboardAvoid)

- (void)setJft_originContentOffset:(NSNumber *)JFT_originContentOffset {
    objc_setAssociatedObject(self,
                             JFTOriginContentOffsetKey,
                             JFT_originContentOffset,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)jft_originContentOffset {
    return objc_getAssociatedObject(self, JFTOriginContentOffsetKey);
}

- (void)setJft_originContentInset:(NSValue *)JFT_originContentInset {
    objc_setAssociatedObject(self,
                             JFTOriginContentInsetKey,
                             JFT_originContentInset,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSValue *)jft_originContentInset {
    return objc_getAssociatedObject(self, JFTOriginContentInsetKey);
}

@end
