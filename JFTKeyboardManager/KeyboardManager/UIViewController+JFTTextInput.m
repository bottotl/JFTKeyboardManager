//
//  UIViewController+JFTTextInput.m
//  JFTKeyboardManager
//
//  Created by syfll on 2018/3/10.
//  Copyright © 2018年 syfll. All rights reserved.
//

#import "UIViewController+JFTTextInput.h"
#import <objc/runtime.h>
#import "Masonry.h"
#import "JFTKeyboardManager+Private.h"

static void *JFTVCMessageBarKey = &JFTVCMessageBarKey;
static void *JFTVCNeedMeeageBarKey = &JFTVCNeedMeeageBarKey;
static void *JFTVCMessageBarBottomInsertKey = &JFTVCMessageBarBottomInsertKey;

static CGFloat kMessageBarDefaultHeight = 200.f;

@interface UIViewController()
@property (nonatomic, readwrite) CGFloat jft_messageBarBottomInsert;
@property (nonatomic, readwrite) JFTTestMessageStyleToolBar *jft_messageBar;
@end

@implementation UIViewController (JFTMessageBar)

#pragma mark - Property

#pragma mark - Need Text view

- (void)setJft_needMessageBar:(BOOL)jft_needTextView {
    objc_setAssociatedObject(self, JFTVCNeedMeeageBarKey, @(jft_needTextView), OBJC_ASSOCIATION_RETAIN);
    if (jft_needTextView) {
        [[JFTKeyboardManager sharedManager] registViewController:self];
        [self jft_showMessageBar];
    } else {
        [[JFTKeyboardManager sharedManager] resignViewController:self];
        [self jft_hiddenMessageBar];
    }
}

- (void)jft_showMessageBar {
    JFTTestMessageStyleToolBar *msgBar = self.jft_messageBar;
    msgBar.hidden = NO;
    NSAssert(![self.view isKindOfClass:[UIScrollView class]], @" ViewController 的 view 不允许是 UIScrollView");
    [self.view addSubview:msgBar];
    CGFloat safeAreaBottm = 0;
    if (@available(iOS 11, *)) {
        safeAreaBottm = self.view.safeAreaInsets.bottom;
    }
    
    [msgBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(@(0));
        make.right.equalTo(self.view.mas_right);
    }];
}

- (void)jft_hiddenMessageBar {
    self.jft_messageBar.hidden = YES;
}

- (BOOL)jft_needMessageBar {
    return [(NSNumber *)objc_getAssociatedObject(self, JFTVCNeedMeeageBarKey) boolValue];
}

#pragma mark

- (JFTTestMessageStyleToolBar *)jft_messageBar {
    JFTTestMessageStyleToolBar *msgBar = objc_getAssociatedObject(self, JFTVCMessageBarKey);
    if (!msgBar) {
        msgBar = [JFTTestMessageStyleToolBar new];
        self.jft_messageBar = msgBar;
    }
    return msgBar;
}



- (void)setJft_messageBar:(JFTTestMessageStyleToolBar *)jft_messageBar {
    objc_setAssociatedObject(self, JFTVCMessageBarKey, jft_messageBar, OBJC_ASSOCIATION_RETAIN);
}

#pragma mark Insert

- (CGFloat)jft_messageBarBottomInsert {
    NSNumber *insert = objc_getAssociatedObject(self, JFTVCMessageBarBottomInsertKey);
    return insert.floatValue;
}

- (void)setJft_messageBarBottomInsert:(CGFloat)jft_messageBarBottomInsert {
    objc_setAssociatedObject(self, JFTVCMessageBarBottomInsertKey, @(jft_messageBarBottomInsert), OBJC_ASSOCIATION_RETAIN);
}

#pragma Constraints

- (void)jft_updateToolBarBottomInsert:(CGFloat)bottom {
    self.jft_messageBarBottomInsert = bottom;
    [self.jft_messageBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-bottom);
    }];
}

@end
