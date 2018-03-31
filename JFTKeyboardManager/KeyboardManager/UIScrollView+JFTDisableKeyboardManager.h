//
//  UIScrollView+JFTDisableKeyboardManager.h
//  JFTBase
//
//  Created by syfll on 2018/3/15.
//

#import <UIKit/UIKit.h>

/**
 可以暂时给 tableView 设置下面这个属性为 YES，防止异常状况的发生
 */
@interface UIScrollView (JFTDisableKeyboardManager)
@property (nonatomic, assign) BOOL jft_shouldDisableKeyboardManager;
@end
