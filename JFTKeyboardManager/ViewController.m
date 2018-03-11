//
//  ViewController.m
//  JFTKeyBoardManager
//
//  Created by syfll on 2017/12/21.
//  Copyright © 2017年 syfll. All rights reserved.
//

#import "ViewController.h"
#import "JFTKeyboardManager.h"
#import "UIViewController+JFTTextInput.h"
#import "UIResponder+JFTKeyboard.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, assign) double stepperValue;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jft_needMessageBar = YES;
    self.textView.jft_needInputAccessoryView = YES;
    self.textView.jft_needAvoidKeyboardHide  = YES;
    self.textView.jft_shouldResignOnTouchOutside = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
