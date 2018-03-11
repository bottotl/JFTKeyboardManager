//
//  JFTViewControllerA.m
//  JFTKeyboardManager
//
//  Created by syfll on 2018/3/10.
//  Copyright © 2018年 syfll. All rights reserved.
//

#import "JFTViewControllerA.h"
#import "UIResponder+JFTKeyboard.h"

@interface JFTViewControllerA ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation JFTViewControllerA

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textView.jft_needInputAccessoryView = YES;
    self.textView.jft_needAvoidKeyboardHide  = YES;
    self.textView.jft_shouldResignOnTouchOutside = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
