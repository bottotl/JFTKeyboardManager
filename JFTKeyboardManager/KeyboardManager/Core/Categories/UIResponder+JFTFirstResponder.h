//
//  UIResponder+JFTFirstResponder.h
//  JFTKeyboardManager
//
//  Created by syfll on 2017/12/25.
//  Copyright © 2017年 syfll. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIResponder (JFTFirstResponder)

+ (UIResponder *)jft_currentFirstResponder;

- (UIViewController *)nearestViewController;

@property (nullable, nonatomic, strong) __kindof UIView *jft_inputView;
@property (nullable, nonatomic, strong) __kindof UIView *jft_inputAccessoryView;

@end

NS_ASSUME_NONNULL_END
