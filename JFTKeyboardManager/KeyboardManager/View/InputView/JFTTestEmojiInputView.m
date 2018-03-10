//
//  JFTTestEmojiInputView.m
//  JFTKeyboardManager
//
//  Created by syfll on 2018/3/10.
//  Copyright © 2018年 syfll. All rights reserved.
//

#import "JFTTestEmojiInputView.h"

@interface JFTTestEmojiInputView()
@property (nonatomic, strong) UIButton *exampleEmojiButton;
@end

@implementation JFTTestEmojiInputView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _exampleEmojiButton = [UIButton new];
        [_exampleEmojiButton setTitle:@"😊" forState:UIControlStateNormal];
        [self addSubview:_exampleEmojiButton];
        [_exampleEmojiButton addTarget:self action:@selector(didClickEmojiButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)didClickEmojiButton:(UIButton *)sender {
    if (self.emojiItemDidClick) {
        self.emojiItemDidClick(sender.titleLabel.text);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.exampleEmojiButton.frame = self.bounds;
}

@end
