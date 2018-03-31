//
//  UIResponder+JFTKeyboard.h
//  JFTKeyboardManager
//
//  Created by syfll on 2018/3/10.
//  Copyright © 2018年 syfll. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIResponder (JFTKeyboard)
#pragma mark keyboard
@property (nonatomic, assign) BOOL jft_shouldResignOnTouchOutside;
@property (nonatomic, assign) BOOL jft_needAvoidKeyboardHide;

#pragma mark - Input view
@property (nonatomic, assign) BOOL jft_needInputAccessoryView;
@property (nonatomic, assign) BOOL jft_needEomjiInputButton;
#pragma mark left view
/**
 Manager 在键盘弹起的时候会自动把这个 View 放在 inputAccessoryView 的左边定制化区域。请不要把它加在其他视图上
 */
@property (nullable, strong) UIView *jft_inputAccessoryLeftView;

@end
