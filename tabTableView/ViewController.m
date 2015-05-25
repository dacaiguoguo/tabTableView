//
//  ViewController.m
//  testTableView
//
//  Created by sunyanguo on 15/5/25.
//  Copyright (c) 2015年 sunyanguo. All rights reserved.
//

#import "ViewController.h"
#import "UIView+AutoLayout.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *smallTableView;
@property (strong, nonatomic) IBOutlet UITableView *bigTableView;
@property (strong, nonatomic) IBOutlet UITableView *smailTwoTableView;
@property (strong, nonatomic) IBOutlet UITableView *smailThirdTableView;
@property (strong, nonatomic) UILabel *headView;
@end

@implementation ViewController {
    NSArray *smallTables;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    smallTables = @[_smallTableView,_smailTwoTableView,_smailThirdTableView];
    _bigTableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    UIView *v = [UIView new];
    v.frame = CGRectMake(0, 0, 320, 400);
    _smallTableView.tableHeaderView = v;
    
    v = [UIView new];
    v.frame = CGRectMake(0, 0, 320, 400);
    _smailThirdTableView.tableHeaderView = v;
    
    v = [UIView new];
    v.frame = CGRectMake(0, 0, 320, 400);
    _smailTwoTableView.tableHeaderView = v;
    
    _widthConstraint.constant = CGRectGetWidth(self.view.frame);
    [self.view bringSubviewToFront:_bigTableView];
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView.tag >= 999) {
        return 1;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag >= 999) {
        return 100;
    }
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag >= 999) {
        return 44;
    }
    if (indexPath.row == 4 ) {
        return 44*100;
    }
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView ==_bigTableView) {
        return 44;
    }
    return 0;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_bigTableView == scrollView) {
        if (_leftSpace.constant == 0) {
            _smallTableView.contentOffset = CGPointMake(0, scrollView.contentOffset.y+64);
        }
        else if (_leftSpace.constant == -scrollView.bounds.size.width) {
            _smailTwoTableView.contentOffset = CGPointMake(0, scrollView.contentOffset.y+64);
        }
        else {
            _smailThirdTableView.contentOffset = CGPointMake(0, scrollView.contentOffset.y+64);
        }
    }
    if (scrollView.tag == 779) {
        _leftSpace.constant = -scrollView.contentOffset.x;
    }
}

- (UILabel *)headView {
    if (nil == _headView) {
        _headView = [[UILabel alloc] init];
        _headView.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:.6];
        _headView.text = @"headView";
    }
    return _headView;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.tag == 779) {
        int index =  scrollView.contentOffset.x/scrollView.bounds.size.width;
        UITableView *currentTable = smallTables[index];
        currentTable.contentOffset = CGPointMake(0, _bigTableView.contentOffset.y+64);

    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == _bigTableView) {
        UILabel *headView = [[UILabel alloc] init];
        headView.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:.6];
        headView.text = @"headView";
        return headView;
    }
    return nil;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.tag >= 999) {
        static NSString *cellIdentifier = @"SmaillCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if(cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.text = [NSString stringWithFormat:@"Small Cell %ld--%ld", (long)indexPath.row,tableView.tag - 999];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Small Cell %ld--%ld", (long)indexPath.row,tableView.tag - 999];
        return cell;
    }
    
    
    if (indexPath.row == 4) {
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
            scrollView.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:.4];
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
    }
    cell.textLabel.text = [NSString stringWithFormat:@"Cell %ld", (long)indexPath.row];

    cell.backgroundColor = [UIColor whiteColor];
    cell.backgroundView = nil;
    return cell;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
