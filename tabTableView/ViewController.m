//
//  ViewController.m
//  testTableView
//
//  Created by sunyanguo on 15/5/25.
//  Copyright (c) 2015年 sunyanguo. All rights reserved.
//

#import "ViewController.h"
#import "UIView+AutoLayout.h"
#import "TouchTableViewCell.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *smallTableView;
@property (strong, nonatomic) IBOutlet UITableView *bigTableView;
@property (strong, nonatomic) IBOutlet UITableView *smailTwoTableView;
@property (strong, nonatomic) IBOutlet UITableView *smailThirdTableView;
@property (strong, nonatomic) UILabel *headView;
@end

@implementation ViewController {
    NSArray *smallTables;
    int headerHeight;
    float topOffset;
    BOOL isSetting;
    NSString *IDENTIFIER;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    IDENTIFIER = @"TouchTableViewCell";
    headerHeight = 44;
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [_bigTableView setLayoutMargins:UIEdgeInsetsZero];
    smallTables = @[_smallTableView,_smailTwoTableView,_smailThirdTableView];
    _bigTableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    _widthConstraint.constant = CGRectGetWidth(self.view.frame);
    [self.view bringSubviewToFront:_bigTableView];
    UITapGestureRecognizer *tab = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCellAction:)];
    [self.view addGestureRecognizer:tab];
    [_smallTableView registerNib:[UINib nibWithNibName:@"TouchTableViewCell" bundle:nil] forCellReuseIdentifier:IDENTIFIER];
    [_smailTwoTableView registerNib:[UINib nibWithNibName:@"TouchTableViewCell" bundle:nil] forCellReuseIdentifier:IDENTIFIER];
    [_smailThirdTableView registerNib:[UINib nibWithNibName:@"TouchTableViewCell" bundle:nil] forCellReuseIdentifier:IDENTIFIER];

    
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_bigTableView reloadData];
    [_bigTableView setBackgroundView:nil];
    [_bigTableView setBackgroundColor:[UIColor clearColor]];
    topOffset = [_bigTableView rectForSection:0].size.height;
    topOffset += headerHeight;
    isSetting = YES;
    [_smallTableView setContentInset:UIEdgeInsetsMake(topOffset, 0, 0, 0)];
    [_smailTwoTableView setContentInset:UIEdgeInsetsMake(topOffset, 0, 0, 0)];
    [_smailThirdTableView setContentInset:UIEdgeInsetsMake(topOffset, 0, 0, 0)];
    [_smallTableView setContentOffset:CGPointMake(0, -topOffset)];
    [_smailTwoTableView setContentOffset:CGPointMake(0, -topOffset)];
    [_smailThirdTableView setContentOffset:CGPointMake(0, -topOffset)];
    isSetting = NO;
}
#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView.tag >= 999) {
        return 1;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag >= 999) {
        if (tableView.tag == 999) {
            return 30;
        }
        if (tableView.tag == 1000) {
            return 20;
        }
        return 10;
    }
    if (section == 1) {
        return 1;
    }
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag >= 999) {
        return 44;
    }
    if (indexPath.section == 1 ) {
        int absss =  fabs(_leftSpace.constant/CGRectGetWidth(self.view.bounds));
        if (absss == 0) {
            return  30 * 44;
        }
        if (absss == 1) {
            return 20* 44;
        }
        return 44*10;
    }
    return 100;
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (isSetting) {
        return;
    }
//    return;
    if (_bigTableView == scrollView) {
        isSetting = YES;
        CGPoint ppp = CGPointMake(0, scrollView.contentOffset.y - topOffset);
        _smallTableView.contentOffset = ppp;
        _smailTwoTableView.contentOffset = ppp;
        _smailThirdTableView.contentOffset = ppp;
        isSetting = NO;
    }
    if (scrollView.tag == 779) {
        _leftSpace.constant = -scrollView.contentOffset.x;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"dacaiguoguo:\n%s\n%@",__func__,tableView);

}

- (UILabel *)headView {
    if (nil == _headView) {
        _headView = [[UILabel alloc] init];
        _headView.textAlignment = NSTextAlignmentCenter;
        _headView.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:.6];
        _headView.layer.borderWidth = 1;
        _headView.text = @"tabView1,       tabView2,      tabView3";
        _headView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeaderAction:)];
        [_headView addGestureRecognizer:tap];
    }
    return _headView;
}

- (void)tapHeaderAction:(UITapGestureRecognizer *)tap {
    CGPoint p = [tap locationInView:tap.view];
    int xDe = p.x / ((int)CGRectGetWidth(self.view.bounds)/3);
    _leftSpace.constant = -xDe * CGRectGetWidth(self.view.bounds);
    [_bigTableView reloadData];
}


- (NSUInteger)nowTableIndex {
    for (NSUInteger i=0; i<smallTables.count; i++) {
        
    }
   __block NSInteger ret = -1;
    [smallTables enumerateObjectsUsingBlock:^(UITableView* obj, NSUInteger idx, BOOL *stop) {
        if (obj.center.x > 0 && obj.center.x < [[UIApplication sharedApplication] keyWindow].bounds.size.width) {
            ret = idx;
            *stop = YES;
        }
    }];
    return ret;
}

- (void)tapCellAction:(UITapGestureRecognizer *)tap {
    NSUInteger nowindex = [self nowTableIndex];
    UITableView *currentTableView = [smallTables objectAtIndex:nowindex];
    CGPoint tapPoint = [tap locationInView:currentTableView];
    [[currentTableView visibleCells] enumerateObjectsUsingBlock:^(UITableViewCell *obj, NSUInteger idx, BOOL *stop) {
        if (CGRectContainsPoint(obj.frame, tapPoint) == true) {
            NSIndexPath *index = [currentTableView indexPathForCell:obj];
            NSLog(@"-%zd---%zd->%zd",nowindex,index.section, index.row);
            [[[obj contentView] subviews] enumerateObjectsUsingBlock:^(UIButton *subobj, NSUInteger subidx, BOOL *substop) {
                if ([subobj isKindOfClass:[UIButton class]]) {
                   CGRect subRECT =  [currentTableView convertRect:[subobj frame] fromView:obj];
                    if (CGRectContainsPoint(subRECT, tapPoint) == true) {
                        NSLog(@"----->%@",[subobj titleForState:UIControlStateNormal]);
                    }
                }
            }];
        }
    }];

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.tag == 779) {
        [_bigTableView reloadData];
    }
//    if (scrollView.tag == 779) {
//        int index =  scrollView.contentOffset.x/scrollView.bounds.size.width;
//        UITableView *currentTable = smallTables[index];
//        currentTable.contentOffset = CGPointMake(0, _bigTableView.contentOffset.y+64);
//
//    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == _bigTableView) {
        if (section == 1) {
            return self.headView;
        }
    }
    UIView *v = [UIView new];
    return v;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *v = [UIView new];
    return v;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView ==_bigTableView) {
        if (section == 1) {
            return headerHeight;
        }
        return 0;
    }
    return 0;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.tag >= 999) {
        TouchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER];
        cell.textLabel.text = [NSString stringWithFormat:@"Small Cell %ld--%ld", (long)indexPath.row,tableView.tag - 998];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Small Cell %ld--%ld", (long)indexPath.row,tableView.tag - 998];
        return cell;
    }
    
    
    if (indexPath.section == 1) {
        static NSString *cellIdentifier = @"BigCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:cell.bounds];
            scrollView.tag = 779;
            [cell addSubview:scrollView];
            scrollView.pagingEnabled = YES;
            scrollView.delegate = self;
            scrollView.contentSize = CGSizeMake([[UIApplication sharedApplication] keyWindow].bounds.size.width *3, cell.bounds.size.height) ;
            scrollView.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:.4];
            [scrollView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.backgroundView = nil;
        return cell;
    }
    
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setClipsToBounds:YES];
        cell.backgroundView = nil;
    }
    cell.textLabel.text = [NSString stringWithFormat:@"Cell %ld", (long)indexPath.row];
    return cell;
}


@end
