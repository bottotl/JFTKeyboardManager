//
//  UIResponder+JFTKeyboard.h
//  JFTKeyboardManager
//
//  Created by syfll on 2018/3/10.
//  Copyright © 2018年 syfll. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIResponder (JFTKeyboard)
@property (nonatomic, assign) BOOL jft_shouldResignOnTouchOutside;
@property (nonatomic, assign) BOOL jft_needInputAccessoryView;
@property (nonatomic, assign) BOOL jft_needAvoidKeyboardHide;
@end
