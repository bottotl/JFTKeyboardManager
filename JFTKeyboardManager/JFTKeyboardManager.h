//
//  JFTKeyboardManager.h
//  JFTKeyBoardManager
//
//  Created by syfll on 2017/12/22.
//  Copyright © 2017年 syfll. All rights reserved.
//

#import <UIKit/UIKit.h>
/// emoji views
#import "JFTTestEmojiInputAccessoryView.h"
#import "JFTTestEmojiInputView.h"

@interface JFTKeyboardManager : NSObject

+ (instancetype)sharedManager;

@property(nonatomic, readonly) NSMutableSet<Class> *enabledClasses;

@property (nonatomic, strong) JFTTestEmojiInputView *customInputView;
@property (nonatomic, readonly) JFTTestEmojiInputAccessoryView *customInputAccessoryView;

- (void)adjustFrameIfNeed;

- (void)registViewController:(UIViewController *)viewController;
- (void)resignViewController:(UIViewController *)viewController;
@end
