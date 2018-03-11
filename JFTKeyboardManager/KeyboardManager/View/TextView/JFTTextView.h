//
//  JFTTextView.h
//  JFTKeyboardManager
//
//  Created by syfll on 2018/3/11.
//  Copyright © 2018年 syfll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface JFTTextView : UITextView

@property (nonatomic, assign) CGFloat minTextHeight;///< defaule is 0
@property (nonatomic, assign) CGFloat maxTextHeight;///< defaule is CGFLOAT_MAX
@property (nonatomic, readonly) CGFloat currentHeight;
@property (nonatomic, readonly) RACSignal *rac_heightChangeSignal;

@end
