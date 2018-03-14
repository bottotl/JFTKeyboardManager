//
//  UIView+JFTKeyboardHierarchy.h
//  JFTKeyBoardManager
//
//  Created by syfll on 2017/12/22.
//  Copyright © 2017年 syfll. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (JFTKeyboardHierarchy)

- (nullable UIView *)superviewOfClassType:(nonnull Class)classType;
- (nullable NSArray *)subviewsOfClassType:(nonnull Class)classType;
@end
