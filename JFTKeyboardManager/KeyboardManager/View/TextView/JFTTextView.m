//
//  JFTTextView.m
//  JFTKeyboardManager
//
//  Created by syfll on 2018/3/11.
//  Copyright © 2018年 syfll. All rights reserved.
//

#import "JFTTextView.h"

@interface JFTTextView()
@end

@implementation JFTTextView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
//        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
//        [self setup];
    }
    return self;
}

+ (instancetype)alloc {
    JFTTextView *textView = [super alloc];
    [textView setup];
    return textView;
}

- (void)setup {
    _maxTextHeight = CGFLOAT_MAX;
    _minTextHeight = 0;
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
}

@end
