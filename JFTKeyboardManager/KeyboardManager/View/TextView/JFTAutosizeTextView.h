//
//  JFTTextView.h
//  JFTKeyboardManager
//
//  Created by syfll on 2018/3/11.
//  Copyright © 2018年 syfll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
/**
 ！不要修改它的 delegate
 */
@interface JFTAutosizeTextView : UITextView

@property (nonatomic, copy) void(^beginEdit)(JFTAutosizeTextView *textView);
@property (nonatomic, copy) void(^endEdit)(JFTAutosizeTextView *textView);
@property (nonatomic, copy) void(^returnClick)(NSString *text);

@property (nonatomic, strong) NSString *placeHolder;
@property (nonatomic, strong) UIColor *placeholderColor;

@property (nonatomic, assign) CGFloat minTextHeight;///< defaule is 0
@property (nonatomic, assign) CGFloat maxTextHeight;///< defaule is CGFLOAT_MAX
@property (nonatomic, readonly) CGFloat currentHeight;
@property (nonatomic, readonly) RACSignal *rac_heightChangeSignal;

@end
