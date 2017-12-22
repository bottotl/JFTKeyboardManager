//
//  UIScrollView+JFTKeyboardAvoid.h
//  JFTKeyBoardManager
//
//  Created by syfll on 2017/12/22.
//  Copyright © 2017年 syfll. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (JFTKeyboardAvoid)
@property (nonatomic, strong) NSValue *jft_originContentInset;
@property (nonatomic, strong) NSNumber *jft_originContentOffset;
@end
