//
//  JFTTestMessageStyleToolBar.h
//  JFTKeyboardManager
//
//  Created by syfll on 2017/12/26.
//  Copyright © 2017年 syfll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFTTextView.h"

@interface JFTTestMessageStyleToolBar : UIView

@property (nonatomic, readonly) JFTTextView *textView;
@property (nonatomic, readonly) UIButton   *emojiButton;

@end
