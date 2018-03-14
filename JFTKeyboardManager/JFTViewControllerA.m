//
//  JFTViewControllerA.m
//  JFTKeyboardManager
//
//  Created by syfll on 2018/3/10.
//  Copyright © 2018年 syfll. All rights reserved.
//

#import "JFTViewControllerA.h"
#import "JFTKeyboard.h"
#import "JFTTestTriggerCell.h"

@interface JFTViewControllerA ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableview;
@end

@implementation JFTViewControllerA

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableview = [[UITableView alloc] initWithFrame:self.view.bounds];
    [self.tableview registerClass:[JFTTestTriggerCell class] forCellReuseIdentifier:@"cell"];
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    [self.view addSubview:self.tableview];
    
    self.jft_needMessageBar = YES;
    self.jft_messageBarStyle = JFTMessageBarStyleHiddenWhenNoNeed;
    self.jft_messageBar.textView.jft_shouldResignOnTouchOutside = YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JFTTestTriggerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell.triggerA addTarget:self action:@selector(triggerTestA:) forControlEvents:UIControlEventTouchUpInside];
    [cell.triggerB addTarget:self action:@selector(triggerTestA:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

- (void)triggerTestA:(UIButton *)sender {
    [sender jft_becomeTextInputTrigger];
    [self.jft_messageBar becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
