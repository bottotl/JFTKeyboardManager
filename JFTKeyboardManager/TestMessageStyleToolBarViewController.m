//
//  TestMessageStyleToolBarViewController.m
//  JFTKeyboardManager
//
//  Created by syfll on 2017/12/26.
//  Copyright © 2017年 syfll. All rights reserved.
//

#import "TestMessageStyleToolBarViewController.h"
#import "JFTTestMessageStyleToolBar.h"
#import "Masonry.h"

@interface TestMessageStyleToolBarViewController ()
@property (nonatomic, strong) JFTTestMessageStyleToolBar *jft_toolBar;
@end

@implementation TestMessageStyleToolBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jft_toolBar = [[JFTTestMessageStyleToolBar alloc] initWithFrame:CGRectMake(0, 200, CGRectGetWidth(self.view.frame), 200)];
    [self.view addSubview:self.jft_toolBar];
    
    [self.jft_toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_centerY);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
}

- (IBAction)updateHeight:(id)sender {
    [self.jft_toolBar setNeedsUpdateConstraints];
    [self.jft_toolBar updateConstraintsIfNeeded];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
