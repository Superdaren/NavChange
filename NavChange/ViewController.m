//
//  ViewController.m
//  NavChange
//
//  Created by super on 2017/10/28.
//  Copyright © 2017年 super. All rights reserved.
//

#import "ViewController.h"
#import "YGNavigationBar.h"

static NSString *const menuCellIdentifer = @"menuCellIdentifer";

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"导航栏渐变";
    
    self.tableView = ({
        UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStyleGrouped];
        [table setDelegate:self];
        [table setDataSource:self];
        [table setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        [table registerClass:[UITableViewCell class]
               forCellReuseIdentifier:menuCellIdentifer];
        
        table;
    });
    
    [self.view addSubview:self.tableView];
    
    [self initBarManager];
}


- (void)initBarManager {
    [YGNavigationBar sharedManager].managerViewController(self).addBarColor([UIColor yellowColor]);
}

#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [[YGNavigationBar sharedManager] changeAlphaWithCurrentOffset:scrollView.contentOffset.y];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:menuCellIdentifer forIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row];
    
    return cell;
}

@end
