//
//  JFTKeyboardModel.h
//  JFTKeyBoardManager
//
//  Created by syfll on 2017/12/22.
//  Copyright © 2017年 syfll. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 描述当前键盘的状况
 */
@interface JFTKeyboardModel : NSObject
@property (nonatomic, assign) NSInteger animationCurve;
@property (nonatomic, assign) CGFloat animationDuraiton;
@property (nonatomic, assign) CGRect frameBegin;
@property (nonatomic, assign) CGRect frameEnd;
//@property (nonatomic, assign) BOOL isLocal;
@end
