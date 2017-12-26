//
//  JFTKeyboardManager.h
//  JFTKeyBoardManager
//
//  Created by syfll on 2017/12/22.
//  Copyright © 2017年 syfll. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JFTKeyboardManager : NSObject

+ (instancetype)sharedManager;

@property(nonatomic, readonly) NSMutableSet<Class> *enabledClasses;

@property (nonatomic, strong) UIView *customInputView;
- (void)adjustFrameIfNeed;
@end
