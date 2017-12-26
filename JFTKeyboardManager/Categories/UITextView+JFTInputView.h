//
//  UITextView+JFTInputView.h
//  JFTKeyboardManager
//
//  Created by syfll on 2017/12/26.
//  Copyright © 2017年 syfll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFTKeyboardManager.h"

typedef NS_ENUM(NSInteger, JFTInputAccessoryViewStyle) {
    JFTInputAccessoryViewStyleNone,
    JFTInputAccessoryViewStyleEmoji
};

@interface UITextView (JFTInputView)
@property (nonatomic, assign) JFTInputAccessoryViewStyle jft_inputAccessoryViewStyle;
- (void)jft_changeToCustomInputView:(UIView *)customView;
- (void)jft_changeToDefaultInputView;
@end
