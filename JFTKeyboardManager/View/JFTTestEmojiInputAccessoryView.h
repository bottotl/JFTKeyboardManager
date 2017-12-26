//
//  JFTTestEmojiInputAccessoryView.h
//  JFTKeyboardManager
//
//  Created by syfll on 2017/12/26.
//  Copyright © 2017年 syfll. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, JFTTestEmojiInputAccessoryKeyboardState) {
    JFTTestEmojiInputAccessoryKeyboardStateSystem,
    JFTTestEmojiInputAccessoryKeyboardStateEmoji
};
@interface JFTTestEmojiInputAccessoryView : UIToolbar
@property (nonatomic, readonly) JFTTestEmojiInputAccessoryKeyboardState keyboardState;
@property (nonatomic, copy) void(^dismissKeyboardBlock)(void);
@property (nonatomic, copy) void(^keyboardStateChangeBlock)(JFTTestEmojiInputAccessoryKeyboardState state);
@end
