//
//  JFTTestEmojiInputView.h
//  JFTKeyboardManager
//
//  Created by syfll on 2018/3/10.
//  Copyright © 2018年 syfll. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JFTTestEmojiInputView : UIView
@property (nonatomic, copy) void(^emojiItemDidClick)(NSString *emojiItem);
@end
