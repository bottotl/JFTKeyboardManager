//
//  JFTTextView.m
//  JFTKeyboardManager
//
//  Created by syfll on 2018/3/11.
//  Copyright © 2018年 syfll. All rights reserved.
//

#import "JFTAutosizeTextView.h"
#import "RACDelegateProxy.h"
#import "NSObject+RACDescription.h"

@interface JFTAutosizeTextView()<UITextViewDelegate>

@property (nonatomic, assign) BOOL showPlaceHolder;

@property (nonatomic, assign) CGFloat currentHeight;
@property (nonatomic, strong) RACSignal *rac_heightChangeSignal;

@end

@implementation JFTAutosizeTextView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self jft_commonInit];
    }
    return self;
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self jft_commonInit];
    }
    return self;
}

/// UITextView 会在 init 的时候修改 ContentSize，这时候 maxTextHeight 如果没有来得及被初始化，会显示异常
+ (instancetype)alloc {
    JFTAutosizeTextView *textView = [super alloc];
    [textView setupHeightProperty];
    return textView;
}

- (void)setupHeightProperty {
    _maxTextHeight = CGFLOAT_MAX;
    _minTextHeight = 0;
}

- (void)jft_commonInit {
    self.rac_heightChangeSignal = [[self rac_valuesAndChangesForKeyPath:@"currentHeight" options:NSKeyValueObservingOptionNew observer:nil] map:^id(id x) {
        RACTupleUnpack(NSNumber *newHeight) = x;
        return newHeight;
    }];
    self.placeHolder = @"写点评论吧";
    self.showPlaceHolder = YES;
    self.delegate = self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (!self.font) return;
    self.showPlaceHolder = ((self.text.length > 0)?NO:YES);
    if (self.showPlaceHolder && self.placeHolder.length) {
        NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
        style.alignment = self.textAlignment;
        style.lineBreakMode = NSLineBreakByTruncatingTail;
        CGFloat leftPadding = 5;
        [self.placeHolder drawInRect:CGRectMake(leftPadding, self.textContainerInset.top + self.contentInset.top, self.frame.size.width - leftPadding * 2, self.font.lineHeight)
                      withAttributes:@{
                                       NSFontAttributeName:self.font,
                                       NSForegroundColorAttributeName:self.placeholderColor?:[UIColor colorWithRed:(193.0/255.0) green:(193.0/255.0) blue:(193.0/255.0) alpha:1.0],
                                       NSParagraphStyleAttributeName:style
                                       }];
    }
}

#pragma mark - Layout

- (void)setContentSize:(CGSize)contentSize {
    [super setContentSize:contentSize];
    [self updateBoundsIfNeeded];
}

- (void)updateBoundsIfNeeded {
    self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y,self.contentSize.width, self.contentSize.height);
    if (CGRectGetHeight(self.bounds) > self.maxTextHeight) {
        self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, CGRectGetWidth(self.bounds), self.maxTextHeight);
    }
    if (CGRectGetHeight(self.bounds) < self.minTextHeight) {
        self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, CGRectGetWidth(self.bounds), self.minTextHeight);
    }
    //// check if height really changed, avoid height change signal be called frequently
    if (CGRectGetHeight(self.bounds) != self.currentHeight) {
        self.currentHeight = CGRectGetHeight(self.bounds);
    }
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self setNeedsDisplay];
}

#pragma mark - textView delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        if (![textView.text stringByReplacingOccurrencesOfString:@" " withString:@""].length) return NO;
        if (self.returnClick) self.returnClick(textView.text);
        return NO;
    }
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (self.beginEdit) {
        self.beginEdit(self);
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if (self.endEdit) {
        self.endEdit(self);
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    [self setNeedsDisplay];
}

@end
