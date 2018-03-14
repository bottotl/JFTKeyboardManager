//
//  JFTTestTriggerCell.m
//  JFTKeyboardManager
//
//  Created by syfll on 2018/3/14.
//  Copyright © 2018年 syfll. All rights reserved.
//

#import "JFTTestTriggerCell.h"

@implementation JFTTestTriggerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _triggerA = [UIButton new];
        [_triggerA setTitle:@"TriggerA" forState:UIControlStateNormal];
        [_triggerA setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _triggerA.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_triggerA];
        
        _triggerB = [UIButton new];
        [_triggerB setTitle:@"TriggerB" forState:UIControlStateNormal];
        [_triggerB setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _triggerB.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_triggerB];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.triggerA sizeToFit];
    self.triggerA.frame = CGRectMake(30, 10, CGRectGetWidth(self.triggerA.bounds), CGRectGetHeight(self.triggerA.bounds));
    
    [self.triggerB sizeToFit];
    self.triggerB.frame = CGRectMake(30, 80, CGRectGetWidth(self.triggerB.bounds), CGRectGetHeight(self.triggerB.bounds));
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
