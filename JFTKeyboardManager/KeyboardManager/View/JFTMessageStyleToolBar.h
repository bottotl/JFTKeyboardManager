//
//  JFTMessageStyleToolBar.h
//  JFTKeyboardManager
//
//  Created by syfll on 2017/12/26.
//  Copyright © 2017年 syfll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFTAutosizeTextView.h"

@interface JFTMessageStyleToolBar : UIView

@property (nonatomic, copy) void(^beginEdit)(JFTMessageStyleToolBar *bar);
@property (nonatomic, copy) void(^endEdit)(JFTMessageStyleToolBar *bar);
@property (nonatomic, copy) void(^returnClick)(NSString *text);

/**
 never change this textView's delegate
 */
@property (nonatomic, readonly) JFTAutosizeTextView *textView;
@property (nonatomic, readonly) UIButton            *emojiButton;
@property (nonatomic, copy)     NSString            *text;
@property (nonatomic, copy)     NSString            *placeHolder;

@property (nonatomic, readonly) CGFloat    currentHeight;
@property (nonatomic, readonly) RACSignal *rac_heightChangeSignal;
- (BOOL)becomeFirstResponder;
+ (BOOL)jft_isIPhoneX;
+ (CGFloat)jft_homeIndicatorHeight;
@end
