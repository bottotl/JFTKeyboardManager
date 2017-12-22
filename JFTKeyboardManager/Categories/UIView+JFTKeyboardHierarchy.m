//
//  UIView+JFTKeyboardHierarchy.m
//  JFTKeyBoardManager
//
//  Created by syfll on 2017/12/22.
//  Copyright © 2017年 syfll. All rights reserved.
//

#import "UIView+JFTKeyboardHierarchy.h"

@implementation UIView (JFTKeyboardHierarchy)
- (UIView*)superviewOfClassType:(Class)classType
{
    UIView *superview = self.superview;
    while (superview) {
        if ([superview isKindOfClass:classType]) {
            
            //If it's UIScrollView, then validating for special cases
            if ([superview isKindOfClass:[UIScrollView class]]) {
                NSString *classNameString = NSStringFromClass([superview class]);
                
                //  If it's not UITableViewWrapperView class, this is internal class which is actually manage in UITableview. The speciality of this class is that it's superview is UITableView.
                //  If it's not UITableViewCellScrollView class, this is internal class which is actually manage in UITableviewCell. The speciality of this class is that it's superview is UITableViewCell.
                //If it's not _UIQueuingScrollView class, actually we validate for _ prefix which usually used by Apple internal classes
                if ([superview.superview isKindOfClass:[UITableView class]] == NO &&
                    [superview.superview isKindOfClass:[UITableViewCell class]] == NO &&
                    [classNameString hasPrefix:@"_"] == NO) {
                    return superview;
                }
            } else {
                return superview;
            }
        }
        
        superview = superview.superview;
    }
    
    return nil;
}

@end
