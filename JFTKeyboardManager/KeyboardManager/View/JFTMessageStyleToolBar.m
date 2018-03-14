//
//  JFTMessageStyleToolBar.m
//  JFTKeyboardManager
//
//  Created by syfll on 2017/12/26.
//  Copyright © 2017年 syfll. All rights reserved.
//

#import "JFTMessageStyleToolBar.h"
#import "Masonry.h"
#import "UITextView+JFTInputView.h"
#import "JFTKeyboardManager+Private.h"

static const CGFloat kToolBarDefaultHeight = 60.f;
//static const CGSize  kEmojiButtonSize = {30, 30};
//static const UIEdgeInsets kEmojiPadding = {0, 0, 10, 10};
static const UIEdgeInsets kTextViewPadding = {15, 10, 10, 15};

@interface JFTMessageStyleToolBar ()<UITextViewDelegate>

@property (nonatomic, strong) UIView              *seperateLine;
@property (nonatomic, strong) JFTAutosizeTextView *textView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

//@property (nonatomic, strong) UIButton   *emojiButton;
@property (nonatomic, assign) BOOL isEmojiKeyboard;
@property (nonatomic, strong) RACSignal *rac_heightChangeSignal;

@property (nonatomic, assign) CGFloat currentHeight;

@end

@implementation JFTMessageStyleToolBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        CGFloat textViewHeight = kToolBarDefaultHeight - kTextViewPadding.top - kTextViewPadding.bottom;
        self.backgroundColor = [UIColor whiteColor];
//        CGFloat textViewWidth = CGRectGetWidth(frame) - kTextViewPadding.left - kTextViewPadding.right -
//        kEmojiButtonSize.width - kEmojiPadding.right;
        _seperateLine = [UIView new];
        _seperateLine.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_seperateLine];
        
        [_seperateLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.equalTo(@(1));
        }];
        
        _textView = [JFTAutosizeTextView new];
        _textView.layer.borderColor = [UIColor grayColor].CGColor;
        _textView.layer.borderWidth = 1;
        _textView.layer.cornerRadius = 5;
        _textView.textContainerInset = UIEdgeInsetsMake(6, 0, 6, 0);
        _textView.font = [UIFont systemFontOfSize:15];
        _textView.returnKeyType = UIReturnKeySend;
        _textView.enablesReturnKeyAutomatically = YES;
        _textView.minTextHeight = textViewHeight;
        [self addSubview:_textView];
        
//        _emojiButton = [UIButton new];
//        [_emojiButton setTitleColor:self.tintColor forState:UIControlStateNormal];
//        [_emojiButton addTarget:self action:@selector(changeKeyboard) forControlEvents:UIControlEventTouchUpInside];
//        [_emojiButton setTitle:@"⌨️" forState:UIControlStateNormal];
//        _emojiButton.backgroundColor = [UIColor greenColor];
//        [self addSubview:_emojiButton];
        
//        [_emojiButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(self.mas_bottom)
//            .with.offset(-kEmojiPadding.bottom);
//
//            make.right.equalTo(self.mas_right)
//            .with.offset(-kEmojiPadding.right);
//
//            make.width.equalTo(@(kEmojiButtonSize.width));
//            make.height.equalTo(@(kEmojiButtonSize.height));
//
//            make.top.lessThanOrEqualTo(self.mas_top);
//        }];

//        [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.mas_left)
//            .with.offset(kTextViewPadding.left);
//
//            make.right.equalTo(_emojiButton.mas_left)
//            .with.offset(-kTextViewPadding.right);
//
//            make.height.equalTo(@(textViewHeight));
//
//            make.top.equalTo(self.mas_top)
//            .with.offset(kTextViewPadding.top);
//
//            make.bottom.equalTo(self.mas_bottom).
//            with.offset(-(kTextViewPadding.bottom + [JFTMessageStyleToolBar jft_homeIndicatorHeight]));
//        }];
        [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left)
            .with.offset(kTextViewPadding.left);
            
            make.right.equalTo(self.mas_right)
            .with.offset(-kTextViewPadding.right);
            
            make.height.equalTo(@(textViewHeight));
            
            make.top.equalTo(self.mas_top)
            .with.offset(kTextViewPadding.top);
            
            make.bottom.equalTo(self.mas_bottom).
            with.offset(-(kTextViewPadding.bottom + [JFTMessageStyleToolBar jft_homeIndicatorHeight]));
        }];
        
        @weakify(self);
        [_textView.rac_heightChangeSignal subscribeNext:^(NSNumber *height) {
            @strongify(self);
            [self willChangeHeight:height.floatValue];
        }];
        
        self.tapGesture = [UITapGestureRecognizer new];
        [self.tapGesture addTarget:self action:@selector(startEdit)];
        [self addGestureRecognizer:self.tapGesture];
        
        self.rac_heightChangeSignal = [[self rac_valuesAndChangesForKeyPath:@"currentHeight" options:NSKeyValueObservingOptionNew observer:nil] map:^id(id x) {
            RACTupleUnpack(NSNumber *newHeight) = x;
            return newHeight;
        }];
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
    CGFloat currentHeight = kTextViewPadding.top + viewHeight + kTextViewPadding.bottom + [JFTMessageStyleToolBar jft_homeIndicatorHeight];
    [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(viewHeight));
    }];
    self.currentHeight = currentHeight;
}

//- (void)changeKeyboard {
//    self.isEmojiKeyboard = !self.isEmojiKeyboard;
//    JFTKeyboardManager *manager = [JFTKeyboardManager sharedManager];
//    if (self.isEmojiKeyboard) {
//        self.textView.inputView = nil;
//        [self.emojiButton setTitle:@"⌨️" forState:UIControlStateNormal];
//    } else {
//        self.textView.inputView = manager.customInputView;
//        [self.emojiButton setTitle:@"😊" forState:UIControlStateNormal];
//    }
//    [self.textView reloadInputViews];
//    [self startEdit];
//}

- (void)setBeginEdit:(void (^)(JFTMessageStyleToolBar *))beginEdit {
    _beginEdit = beginEdit;
    @weakify(self);
    self.textView.beginEdit = ^(JFTAutosizeTextView *textView) {
        @strongify(self);
        if (self.beginEdit) self.beginEdit(self);
    };
}

- (void)setEndEdit:(void (^)(JFTMessageStyleToolBar *))endEdit {
    _endEdit = endEdit;
    @weakify(self);
    self.textView.endEdit = ^(JFTAutosizeTextView *textView) {
        @strongify(self);
        if (self.endEdit) self.endEdit(self);
    };
}

- (void)setReturnClick:(void (^)(NSString *))returnClick {
    _returnClick = returnClick;
    @weakify(self);
    self.textView.returnClick = ^(NSString *text) {
        @strongify(self);
        if (self.returnClick) self.returnClick(text);
    };
}

- (void)setText:(NSString *)text {
    [self.textView setText:text];
}

- (NSString *)text {
    return [self.textView text];
}

- (void)setPlaceHolder:(NSString *)placeHolder {
    [self.textView setPlaceHolder:placeHolder];
}

- (NSString *)placeHolder {
    return [self.textView placeHolder];
}

#pragma mark - overwrite

- (BOOL)becomeFirstResponder {
    BOOL isFirstResponder = [self.textView becomeFirstResponder];
    /// 如果涉及到不同 textInputTrigger 切换的时候 manager 中的手势会先导致键盘落下并且弹起
    /// 但是一定情况下手势并不会起作用（原因不明）
    /// 所以这里暂时手动调用，保证切换能够正常进行
    [UIView animateWithDuration:0.25 animations:^{
        [[JFTKeyboardManager sharedManager] adjustScrollViewOffsetIfNeed];
    }];
    return isFirstResponder;
}

- (BOOL)isFirstResponder {
    return [self.textView isFirstResponder];
}

- (BOOL)resignFirstResponder {
    return [self.textView resignFirstResponder];
}

- (BOOL)canBecomeFirstResponder {
    return [self.textView canBecomeFirstResponder];
}

#pragma mark - Util

+ (BOOL)jft_isIPhoneX {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && (NSInteger)[UIScreen mainScreen].nativeBounds.size.height == 2436;
}

+ (CGFloat)jft_homeIndicatorHeight {
    return [self jft_isIPhoneX] ? 34 : 0;
}

@end
