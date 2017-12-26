//
//  UITextView+JFTInputView.h
//  JFTKeyboardManager
//
//  Created by syfll on 2017/12/26.
//  Copyright © 2017年 syfll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFTKeyboardManager.h"

@interface UITextView (JFTInputView)
- (void)jft_changeToCustomInputView:(UIView *)customView;
- (void)jft_changeToDefaultInputView;
@end
