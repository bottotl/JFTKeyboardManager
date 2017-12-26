//
//  JFTKeyboardManager.h
//  JFTKeyBoardManager
//
//  Created by syfll on 2017/12/22.
//  Copyright © 2017年 syfll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFTTestEmojiInputAccessoryView.h"

@interface JFTKeyboardManager : NSObject

+ (instancetype)sharedManager;

@property(nonatomic, readonly) NSMutableSet<Class> *enabledClasses;

@property (nonatomic, strong) UIView *customInputView;
@property (nonatomic, readonly) JFTTestEmojiInputAccessoryView *customInputAccessoryView;
- (void)adjustFrameIfNeed;
@end
