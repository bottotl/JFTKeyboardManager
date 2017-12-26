//
//  UITextView+JFTInputView.m
//  JFTKeyboardManager
//
//  Created by syfll on 2017/12/26.
//  Copyright © 2017年 syfll. All rights reserved.
//

#import "UITextView+JFTInputView.h"

@implementation UITextView (JFTInputView)

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
