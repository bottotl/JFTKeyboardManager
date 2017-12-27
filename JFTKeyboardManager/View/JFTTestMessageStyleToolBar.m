//
//  JFTTestMessageStyleToolBar.m
//  JFTKeyboardManager
//
//  Created by syfll on 2017/12/26.
//  Copyright © 2017年 syfll. All rights reserved.
//

#import "JFTTestMessageStyleToolBar.h"
#import "Masonry.h"
#import "UITextView+JFTInputView.h"
#import "JFTKeyboardManager.h"

static const CGSize emojiButtonSize = {50, 50};
@interface JFTTestMessageStyleToolBar ()

@property (nonatomic, strong) JFTTextView *textView;
@property (nonatomic, strong) UIButton   *emojiButton;
@property (nonatomic, assign) BOOL isEmojiKeyboard;

@end

@implementation JFTTestMessageStyleToolBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor lightGrayColor];
        _textView = [JFTTextView new];
        _textView.backgroundColor = [UIColor grayColor];
        _textView.font = [UIFont systemFontOfSize:18 weight:UIFontWeightRegular];
        _textView.textContainerInset = UIEdgeInsetsMake(2.5, 0, 3, 0);
        _textView.placeholderAttributedText = [self placeHolder];
        [self addSubview:_textView];
        
        _emojiButton = [UIButton new];
        [_emojiButton setTitleColor:self.tintColor forState:UIControlStateNormal];
        [_emojiButton addTarget:self action:@selector(changeKeyboard) forControlEvents:UIControlEventTouchUpInside];
        [_emojiButton setTitle:@"emoji" forState:UIControlStateNormal];
        _emojiButton.backgroundColor = [UIColor greenColor];
        [self addSubview:_emojiButton];
        
        [_emojiButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).with.offset(-10);
            make.right.equalTo(self.mas_right);
            make.width.equalTo(@(emojiButtonSize.width));
            make.height.equalTo(@(emojiButtonSize.height));
        }];
        
        UIEdgeInsets textViewPadding = UIEdgeInsetsMake(10, 10, 10, 10);
        [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(textViewPadding.top); //with is an optional semantic filler
            make.left.equalTo(self.mas_left).with.offset(textViewPadding.left);
            make.bottom.equalTo(self.mas_bottom).with.offset(-textViewPadding.bottom);
            make.right.equalTo(_emojiButton.mas_left).with.offset(-textViewPadding.right);
        }];
        
    }
    return self;
}

- (void)changeKeyboard {
    self.isEmojiKeyboard = !self.isEmojiKeyboard;
    JFTKeyboardManager *manager = [JFTKeyboardManager sharedManager];
    if (self.isEmojiKeyboard) {
        self.textView.inputView = nil;
        [self.textView reloadInputViews];
        [self.emojiButton setTitle:@"system" forState:UIControlStateNormal];
    } else {
        self.textView.inputView = manager.customInputView;
        [self.textView reloadInputViews];
        [self.emojiButton setTitle:@"emoji" forState:UIControlStateNormal];
    }
}


//- (CGSize)sizeThatFits:(CGSize)size {
//    CGRect textViewFrame = self.textView.frame;
//    self.textView.frame = CGRectMake(15, 15, self.textViewWidth, CGRectGetHeight(textViewFrame));
//    [self.textView sizeToFit];
//    return CGSizeMake(size.width, self.textView.contentSize.height + 30);
//}

//- (CGFloat)textViewWidth {
//    CGRect windowRect = [UIApplication sharedApplication].keyWindow.bounds;
//    return CGRectGetWidth(windowRect) - 30 - emojiButtonSize.width;
//}
- (NSAttributedString *)placeHolder {
    UIFont *systemFont = [UIFont systemFontOfSize:18.0f];
    NSDictionary * fontAttributes = [[NSDictionary alloc] initWithObjectsAndKeys:systemFont, NSFontAttributeName, nil];
    NSMutableAttributedString *libTitle = [[NSMutableAttributedString alloc] initWithString:@"写点什么吧" attributes:fontAttributes];
    
    return libTitle;
}
@end
