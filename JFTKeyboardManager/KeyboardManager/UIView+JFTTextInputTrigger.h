//
//  UIView+JFTTextInputTrigger.h
//  JFTKeyboardManager
//
//  Created by syfll on 2018/3/12.
//  Copyright © 2018年 syfll. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 配合 jft_needAvoidKeyboardHide 使用。
 全局有且仅有一个 textInputTrigger（被 JFTKeyBoardManager 管理）
 务必在控件触发键盘弹起以前调用 jft_becomeTextInputTrigger
 可以通过修改 bottomOffset 调整键盘弹起以后键盘顶部距离当前 view 的偏移量
 */
@interface UIView (JFTTextInputTrigger)

/**
 default is 0
 键盘顶部紧贴 view
 */
@property (nonatomic, assign) CGFloat jft_bottomOffset;

/**
 Reginst view into manager.Will set jft_needAvoidKeyboardHide to YES
 */
- (void)jft_becomeTextInputTrigger;
@end
