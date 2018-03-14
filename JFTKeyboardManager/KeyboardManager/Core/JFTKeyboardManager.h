//
//  JFTKeyboardManager.h
//  JFTKeyBoardManager
//
//  Created by syfll on 2017/12/22.
//  Copyright © 2017年 syfll. All rights reserved.
//

#import <UIKit/UIKit.h>
/// emoji views
#import "JFTTestEmojiInputAccessoryView.h"
#import "JFTTestEmojiInputView.h"

@interface JFTKeyboardManager : NSObject
@property (nonatomic, strong) JFTTestEmojiInputView *customInputView;
@property (nonatomic, readonly) JFTTestEmojiInputAccessoryView *customInputAccessoryView;

/**
 这是测试用的 API
 */
- (void)adjustScrollViewOffsetIfNeed;

/**
 注册一个需要 messageBar 的 viewController。
 messageBar 的位置会被 manager 控制
 
 @param viewController vc
 */
- (void)registerViewController:(UIViewController *)viewController;

/**
 取消注册 viewController，messageBar 的位置不再受控制。
 
 @param viewController vc
 */
- (void)resignViewController:(UIViewController *)viewController;


/**
 注册一个 textInput trigger
 
 @param view trigger
 */
- (void)registerTextInputTrigger:(UIView *)view;

/**
 外界没必要手动取消注册，内部会在键盘隐藏的时候自动删除引用
 */
- (void)resignTextInputTrigger;

+ (instancetype)sharedManager;

@end
