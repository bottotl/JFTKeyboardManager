//
//  JFTTextView.m
//  JFTKeyboardManager
//
//  Created by syfll on 2018/3/11.
//  Copyright © 2018年 syfll. All rights reserved.
//

#import "JFTTextView.h"

@interface JFTTextView()
@property (nonatomic, assign) CGFloat currentHeight;
@property (nonatomic, strong) RACSignal *rac_heightChangeSignal;
@end

@implementation JFTTextView

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
    JFTTextView *textView = [super alloc];
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
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

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

@end
