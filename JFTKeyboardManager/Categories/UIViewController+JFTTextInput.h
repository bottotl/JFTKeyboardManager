//
//  UIViewController+JFTTextInput.h
//  JFTKeyboardManager
//
//  Created by syfll on 2018/3/10.
//  Copyright © 2018年 syfll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFTTestMessageStyleToolBar.h"
#import "JFTKeyboardManager.h"

@interface UIViewController (JFTMessageBar)

/**
 设置当前视图是否需要在底部展示一个输入框
 如果 ViewController 的 view 是一个 UIScrollView 请不要用！
 */
@property (nonatomic, assign)   BOOL    jft_needMessageBar;

@property (nonatomic, readonly) CGFloat jft_messageBarBottomInsert;

@property (nonatomic, readonly) JFTTestMessageStyleToolBar *jft_messageBar;

- (void)jft_updateToolBarBottomInsert:(CGFloat)bottom;

@end
