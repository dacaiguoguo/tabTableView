//
//  TouchTableViewCell.m
//  tabTableView
//
//  Created by sunyanguo on 15/5/28.
//  Copyright (c) 2015年 sunyanguo. All rights reserved.
//

#import "TouchTableViewCell.h"

@implementation TouchTableViewCell
- (IBAction)button1:(id)sender {
    NSLog(@"dacaiguoguo:\n%s\n%@",__func__,sender);

}
- (IBAction)button2:(id)sender {
    NSLog(@"dacaiguoguo:\n%s\n%@",__func__,sender);

}
- (IBAction)button3:(id)sender {
    NSLog(@"dacaiguoguo:\n%s\n%@",__func__,sender);

}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
