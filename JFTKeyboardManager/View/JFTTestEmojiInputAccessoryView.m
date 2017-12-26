//
//  JFTTestEmojiInputAccessoryView.m
//  JFTKeyboardManager
//
//  Created by syfll on 2017/12/26.
//  Copyright © 2017年 syfll. All rights reserved.
//

#import "JFTTestEmojiInputAccessoryView.h"

@interface JFTTestEmojiInputAccessoryView ()
@property (nonatomic, strong) UIBarButtonItem *flexibleSpaceItem;
@property (nonatomic, strong) UIButton *dismissButton;
@property (nonatomic, strong) UIButton *emojiButton;
@property (nonatomic, assign) JFTTestEmojiInputAccessoryKeyboardState keyboardState;
@end

@implementation JFTTestEmojiInputAccessoryView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _flexibleSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                           target:nil
                                                                           action:nil];
        
        _dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _dismissButton.frame = CGRectMake(4, 5, 80, 50);
        [_dismissButton setTitleColor:self.tintColor forState:UIControlStateNormal];
        [_dismissButton addTarget:self action:@selector(dismissKeyboard) forControlEvents:UIControlEventTouchUpInside];
        [_dismissButton setTitle:@"dismiss" forState:UIControlStateNormal];
        _dismissButton.backgroundColor = [UIColor redColor];
        UIBarButtonItem *dissmissItem = [[UIBarButtonItem alloc] initWithCustomView:_dismissButton];
        
        _keyboardState = JFTTestEmojiInputAccessoryKeyboardStateSystem;
        _emojiButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _emojiButton.frame = CGRectMake(4, 5, 80, 50);
        [_emojiButton setTitleColor:self.tintColor forState:UIControlStateNormal];
        [_emojiButton addTarget:self action:@selector(changeKeyboard) forControlEvents:UIControlEventTouchUpInside];
        [_emojiButton setTitle:@"emoji" forState:UIControlStateNormal];
        _emojiButton.backgroundColor = [UIColor greenColor];
        UIBarButtonItem *emojiItem = [[UIBarButtonItem alloc] initWithCustomView:_emojiButton];
        
        self.items = @[_flexibleSpaceItem, dissmissItem , emojiItem];
    }
    return self;
}

- (void)changeKeyboard {
    if (self.keyboardState == JFTTestEmojiInputAccessoryKeyboardStateEmoji) {
        self.keyboardState = JFTTestEmojiInputAccessoryKeyboardStateSystem;
    } else {
        self.keyboardState = JFTTestEmojiInputAccessoryKeyboardStateEmoji;
    }
    [self updateEmojiItem];
    if (self.keyboardStateChangeBlock) {
        self.keyboardStateChangeBlock(self.keyboardState);
    }
}

- (void)updateEmojiItem {
    if (self.keyboardState == JFTTestEmojiInputAccessoryKeyboardStateEmoji) {
        [self.emojiButton setTitle:@"keyboard" forState:UIControlStateNormal];
    } else {
        [self.emojiButton setTitle:@"emoji" forState:UIControlStateNormal];
    }
}

- (void)dismissKeyboard {
    if (self.dismissKeyboardBlock) {
        self.dismissKeyboardBlock();
    }
}

@end
