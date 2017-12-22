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

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIScrollView *view;

@property (weak, nonatomic) IBOutlet TestContentTextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [JFTKeyboardManager sharedManager];
    self.view.contentInset = UIEdgeInsetsMake(1000, 0, 1000, 0);
}

- (IBAction)buttonClick:(id)sender {
    [self.textView resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
