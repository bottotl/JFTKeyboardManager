//
//  JFTKeyboardManager+Private.h
//  JFTKeyboardManager
//
//  Created by syfll on 2018/3/10.
//  Copyright © 2018年 syfll. All rights reserved.
//
#import "JFTKeyboardManager.h"
/// emoji views
#import "JFTTestEmojiInputAccessoryView.h"
#import "JFTTestEmojiInputView.h"

@interface JFTKeyboardManager (Private)

@property (nonatomic, strong) JFTTestEmojiInputView *customInputView;
@property (nonatomic, readonly) JFTTestEmojiInputAccessoryView *customInputAccessoryView;

- (void)adjustScrollViewOffsetIfNeed;

- (void)registViewController:(UIViewController *)viewController;
- (void)resignViewController:(UIViewController *)viewController;
@end
