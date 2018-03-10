//
//  UIResponder+JFTFirstResponder.h
//  JFTKeyboardManager
//
//  Created by syfll on 2017/12/25.
//  Copyright © 2017年 syfll. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIResponder (JFTFirstResponder)
+ (UIResponder *)jft_currentFirstResponder;
@end
