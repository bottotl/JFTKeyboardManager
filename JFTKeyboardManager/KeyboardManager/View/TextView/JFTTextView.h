//
//  JFTTextView.h
//  JFTKeyboardManager
//
//  Created by syfll on 2018/3/11.
//  Copyright © 2018年 syfll. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JFTTextView : UITextView
@property (nonatomic, assign) CGFloat minTextHeight;///< defaule is 0
@property (nonatomic, assign) CGFloat maxTextHeight;///< defaule is CGFLOAT_MAX
@end
