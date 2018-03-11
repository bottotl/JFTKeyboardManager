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
#import "JFTKeyboardManager+Private.h"

static const CGFloat kToolBarDefaultHeight = 60.f;
static const CGSize  kEmojiButtonSize = {50, 50};
static const UIEdgeInsets kEmojiPadding = {0, 0, 10, 10};
static const UIEdgeInsets kTextViewPadding = {10, 10, 10, 10};

@interface JFTTestMessageStyleToolBar ()

@property (nonatomic, strong) JFTTextView *textView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@property (nonatomic, strong) UIButton   *emojiButton;
@property (nonatomic, assign) BOOL isEmojiKeyboard;

@end

@implementation JFTTestMessageStyleToolBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor lightGrayColor];
        CGFloat textViewHeight = kToolBarDefaultHeight - kTextViewPadding.top - kTextViewPadding.bottom;
//        CGFloat textViewWidth = CGRectGetWidth(frame) - kTextViewPadding.left - kTextViewPadding.right -
//        kEmojiButtonSize.width - kEmojiPadding.right;
        
        _textView = [JFTTextView new];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.font = [UIFont systemFontOfSize:18 weight:UIFontWeightRegular];
        _textView.textContainerInset = UIEdgeInsetsMake(2.5, 0, 3, 0);
        _textView.minTextHeight = textViewHeight;
        [self addSubview:_textView];
        
        _emojiButton = [UIButton new];
        [_emojiButton setTitleColor:self.tintColor forState:UIControlStateNormal];
        [_emojiButton addTarget:self action:@selector(changeKeyboard) forControlEvents:UIControlEventTouchUpInside];
        [_emojiButton setTitle:@"emoji" forState:UIControlStateNormal];
        _emojiButton.backgroundColor = [UIColor greenColor];
        [self addSubview:_emojiButton];
        
        [_emojiButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).with.offset(-kEmojiPadding.bottom);
            make.right.equalTo(self.mas_right).with.offset(-kEmojiPadding.right);
            make.width.equalTo(@(kEmojiButtonSize.width));
            make.height.equalTo(@(kEmojiButtonSize.height));
        }];
        
        [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).with.offset(kTextViewPadding.left);
            make.bottom.equalTo(self.mas_bottom).with.offset(-kTextViewPadding.bottom);
            make.right.equalTo(_emojiButton.mas_left).with.offset(-kTextViewPadding.right);
            make.height.equalTo(@(textViewHeight));
            make.top.equalTo(self.mas_top).with.offset(kTextViewPadding.top);
        }];
        @weakify(self);
        [_textView.rac_heightChangeSignal subscribeNext:^(NSNumber *height) {
            @strongify(self);
            [self willChangeHeight:height.floatValue];
        }];
        
        self.tapGesture = [UITapGestureRecognizer new];
        [self.tapGesture addTarget:self action:@selector(startEdit)];
        [self addGestureRecognizer:self.tapGesture];
    }
    return self;
}

- (void)startEdit {
    if ([self.textView canBecomeFirstResponder]) {
        [self.textView becomeFirstResponder];
    }
}

- (void)willChangeHeight:(CGFloat)height {
    CGFloat viewHeight = height;
    viewHeight += (kTextViewPadding.bottom + kTextViewPadding.top);
    [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(viewHeight));
    }];
    
}

- (void)changeKeyboard {
    self.isEmojiKeyboard = !self.isEmojiKeyboard;
    JFTKeyboardManager *manager = [JFTKeyboardManager sharedManager];
    if (self.isEmojiKeyboard) {
        self.textView.inputView = nil;
        [self.emojiButton setTitle:@"system" forState:UIControlStateNormal];
    } else {
        self.textView.inputView = manager.customInputView;
        [self.emojiButton setTitle:@"emoji" forState:UIControlStateNormal];
    }
    [self.textView reloadInputViews];
    [self startEdit];
}

- (NSAttributedString *)placeHolder {
    UIFont *systemFont = [UIFont systemFontOfSize:18.0f];
    NSDictionary * fontAttributes = [[NSDictionary alloc] initWithObjectsAndKeys:systemFont, NSFontAttributeName, nil];
    NSMutableAttributedString *libTitle = [[NSMutableAttributedString alloc] initWithString:@"写点什么吧" attributes:fontAttributes];
    
    return libTitle;
}
@end
