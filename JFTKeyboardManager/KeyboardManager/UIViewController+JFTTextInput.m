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
#import "UIResponder+JFTFirstResponder.h"
#import "MASViewAttribute.h"

static void *JFTVCMessageBarKey = &JFTVCMessageBarKey;
static void *JFTVCNeedMessageBarKey = &JFTVCNeedMessageBarKey;
static void *JFTVCMessageBarStyleKey = &JFTVCMessageBarStyleKey;
static void *JFTVCMessageBarBottomInsetKey = &JFTVCMessageBarBottomInsetKey;

//static CGFloat kMessageBarDefaultHeight = 200.f;

@interface UIViewController()
@property (nonatomic, readwrite) CGFloat jft_messageBarBottomInset;
@property (nonatomic, readwrite) JFTMessageStyleToolBar *jft_messageBar;
@end

@implementation UIViewController (JFTMessageBar)

#pragma mark - Property

#pragma mark - Need Text view

- (void)setJft_needMessageBar:(BOOL)jft_needMessageBar {
    objc_setAssociatedObject(self, JFTVCNeedMessageBarKey, @(jft_needMessageBar), OBJC_ASSOCIATION_RETAIN);
    if (jft_needMessageBar) {
        [[JFTKeyboardManager sharedManager] registerViewController:self];
        [self jft_showMessageBar];
    } else {
        [[JFTKeyboardManager sharedManager] resignViewController:self];
        [self jft_hideMessageBar];
    }
}

- (BOOL)jft_needMessageBar {
    return [(NSNumber *)objc_getAssociatedObject(self, JFTVCNeedMessageBarKey) boolValue];
}

- (void)jft_showMessageBar {
    JFTMessageStyleToolBar *msgBar = self.jft_messageBar;
    msgBar.hidden = NO;
    NSAssert(![self.view isKindOfClass:[UIScrollView class]], @" ViewController 的 view 不允许是 UIScrollView");
    [self.view addSubview:msgBar];
    
    switch (self.jft_messageBarStyle) {
        case JFTMessageBarStyleAlwaysShow:
            [self updateAlwaysShowMsgBarConstraints:self.jft_messageBar isKeyboardShowing:NO bottom:0];
            break;
        case JFTMessageBarStyleHiddenWhenNoNeed:
            [self updateHiddenWhenNoNeedMsgBarConstraints:self.jft_messageBar isKeyboardShowing:NO bottom:0];
            break;
    }
}

- (void)jft_hideMessageBar {
    self.jft_messageBar.hidden = YES;
}
#pragma mark - messageBar style
- (JFTMessageBarStyle)jft_messageBarStyle {
    return [(NSNumber *)objc_getAssociatedObject(self, JFTVCMessageBarStyleKey) unsignedIntegerValue];
}

- (void)setJft_messageBarStyle:(JFTMessageBarStyle)jft_messageBarStyle {
    objc_setAssociatedObject(self, JFTVCMessageBarStyleKey, @(jft_messageBarStyle), OBJC_ASSOCIATION_RETAIN);
    [self jft_showMessageBar];
}

#pragma mark - messageBar
- (JFTMessageStyleToolBar *)jft_messageBar {
    JFTMessageStyleToolBar *msgBar = objc_getAssociatedObject(self, JFTVCMessageBarKey);
    if (!msgBar) {
        msgBar = [JFTMessageStyleToolBar new];
        self.jft_messageBar = msgBar;
    }
    return msgBar;
}

- (void)setJft_messageBar:(JFTMessageStyleToolBar *)jft_messageBar {
    objc_setAssociatedObject(self, JFTVCMessageBarKey, jft_messageBar, OBJC_ASSOCIATION_RETAIN);
}

#pragma mark Inset

- (CGFloat)jft_messageBarBottomInset {
    NSNumber *inset = objc_getAssociatedObject(self, JFTVCMessageBarBottomInsetKey);
    return inset.floatValue;
}

- (void)setJft_messageBarBottomInset:(CGFloat)jft_messageBarBottomInset {
    objc_setAssociatedObject(self, JFTVCMessageBarBottomInsetKey, @(jft_messageBarBottomInset), OBJC_ASSOCIATION_RETAIN);
}

#pragma Constraints

- (void)jft_updateToolBarBottomInset:(CGFloat)bottom {
    self.jft_messageBarBottomInset = bottom;
    switch (self.jft_messageBarStyle) {
        case JFTMessageBarStyleAlwaysShow:
            [self updateAlwaysShowMsgBarConstraints:self.jft_messageBar isKeyboardShowing:(bottom>0?YES:NO) bottom:bottom];
            break;
        case JFTMessageBarStyleHiddenWhenNoNeed:
            [self updateHiddenWhenNoNeedMsgBarConstraints:self.jft_messageBar isKeyboardShowing:(bottom>0?YES:NO) bottom:bottom];
            break;
    }
}

- (void)updateAlwaysShowMsgBarConstraints:(JFTMessageStyleToolBar *)msgBar isKeyboardShowing:(BOOL)keyboardShowing bottom:(CGFloat)bottom {
    if (keyboardShowing) {
        [msgBar mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.bottom.equalTo(self.view.mas_bottom).offset(-bottom+[JFTMessageStyleToolBar jft_homeIndicatorHeight]);
            make.width.equalTo(self.view.mas_width);
        }];
    } else {
        [msgBar mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.bottom.equalTo(self.view.mas_bottom);
            make.width.equalTo(self.view.mas_width);
        }];
    }
}

- (void)updateHiddenWhenNoNeedMsgBarConstraints:(JFTMessageStyleToolBar *)msgBar isKeyboardShowing:(BOOL)keyboardShowing bottom:(CGFloat)bottom {
    if (keyboardShowing) {
        [msgBar mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.bottom.equalTo(self.view.mas_bottom).offset(-bottom+[JFTMessageStyleToolBar jft_homeIndicatorHeight]);
            make.width.equalTo(self.view.mas_width);
        }];
    } else {
        [msgBar mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_bottom);
            make.centerX.equalTo(self.view.mas_centerX);
            make.width.equalTo(self.view.mas_width);
        }];
    }
}

@end
