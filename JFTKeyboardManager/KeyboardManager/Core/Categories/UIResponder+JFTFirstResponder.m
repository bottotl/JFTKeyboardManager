//
//  UIResponder+JFTFirstResponder.m
//  JFTKeyboardManager
//
//  Created by syfll on 2017/12/25.
//  Copyright © 2017年 syfll. All rights reserved.
//

#import "UIResponder+JFTFirstResponder.h"

static __weak id _jft_currentFirstResponder = nil;

@implementation UIResponder (JFTFirstResponder)

+ (UIResponder *)jft_currentFirstResponder {
    _jft_currentFirstResponder = nil;
    ///The default implementation dispatches the action method to the given target object or, if no target is specified, to the first responder.
    [[UIApplication sharedApplication] sendAction:@selector(jft_firstRepnderReceiveMessage) to:nil from:nil forEvent:nil];
    return _jft_currentFirstResponder;
}


/**
 the first responder will receive this message
 */
- (void)jft_firstRepnderReceiveMessage {
//    NSLog(@"jft_firstRepnderReceiveMessage:%@", self);
    _jft_currentFirstResponder = self;
}

- (UIViewController *)nearestViewController {
    UIResponder *responder = self;
    while (![responder isKindOfClass:[UIViewController class]]) {
        responder = responder.nextResponder;
    }
    if ([responder isKindOfClass:[UIViewController class]]) {
        return (UIViewController *)responder;
    }
    return nil;
}

@end
