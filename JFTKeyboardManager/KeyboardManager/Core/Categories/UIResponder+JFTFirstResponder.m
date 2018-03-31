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

- (void)setJft_inputView:(__kindof UIView *)jft_inputView {
    if ([self isKindOfClass:[UITextView class]]) {
        [(UITextView *)self setInputView:jft_inputView];
    } else if ([self isKindOfClass:[UITextField class]]) {
        [(UITextField *)self setInputView:jft_inputView];
    }
}

- (UIView *)jft_inputView {
    if ([self isKindOfClass:[UITextView class]]) {
        return [(UITextView *)self inputView];
    } else if ([self isKindOfClass:[UITextField class]]) {
        return [(UITextField *)self inputView];
    }
    return nil;
}

- (void)setJft_inputAccessoryView:(__kindof UIView *)jft_inputAccessoryView {
    if ([self isKindOfClass:[UITextView class]]) {
        [(UITextView *)self setInputAccessoryView:jft_inputAccessoryView];
    } else if ([self isKindOfClass:[UITextField class]]) {
        [(UITextField *)self setInputAccessoryView:jft_inputAccessoryView];
    }
}

- (UIView *)jft_inputAccessoryView {
    if ([self isKindOfClass:[UITextView class]]) {
        return [(UITextView *)self inputAccessoryView];
    } else if ([self isKindOfClass:[UITextField class]]) {
        return [(UITextField *)self inputAccessoryView];
    }
    return nil;
}

@end
