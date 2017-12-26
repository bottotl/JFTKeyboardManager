//
//  ViewController.m
//  JFTKeyBoardManager
//
//  Created by syfll on 2017/12/21.
//  Copyright © 2017年 syfll. All rights reserved.
//

#import "ViewController.h"
#import "JFTKeyboardManager.h"
#import "TestContentTextView.h"
#import "UIResponder+JFTFirstResponder.h"

#import "UITextView+JFTInputView.h"

static const CGFloat emojiKeyboardHeight = 216;
@interface ViewController ()

@property (weak, nonatomic) IBOutlet TestContentTextView *textView;
@property (nonatomic, assign) double stepperValue;

@end

@implementation ViewController
- (IBAction)stepperValueChanged:(UIStepper *)sender {
    self.stepperValue = sender.value;
//    NSLog(@"%@", [NSValue valueWithCGPoint:self.textView.inputAccessoryView.center]);
//    NSLog(@"%@", [NSValue valueWithCGRect:self.textView.inputAccessoryView.frame]);
//    UIView *inputAccessoryView = self.textView.inputAccessoryView;
//    [self.textView reloadInputViews];
    [[JFTKeyboardManager sharedManager] adjustFrameIfNeed];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [JFTKeyboardManager sharedManager];
    ((UIScrollView *)self.view).contentInset = UIEdgeInsetsMake(1000, 0, 1000, 0);
}

- (IBAction)buttonClick:(id)sender {
    [self.textView resignFirstResponder];
}

- (IBAction)testFirstResponder:(id)sender {
    [UIResponder jft_currentFirstResponder];
    if (self.textView.inputView) {
        [self.textView jft_changeToDefaultInputView];
    } else {
        [self.textView jft_changeToCustomInputView:[JFTKeyboardManager sharedManager].customInputView];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
