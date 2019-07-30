//
//  MLDPromoterAnalyTableViewController.m
//  MobLinkProDemo
//
//  Created by lujh on 2019/1/16.
//  Copyright © 2019 mob. All rights reserved.
//

#import "MLDPromoterAnalyTableViewController.h"

@interface MLDPromoterAnalyTableViewController ()

@end

@implementation MLDPromoterAnalyTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"地推推广记录";
    
    __weak typeof(self) weakSelf = self;
    //请求数据
    [[MLDNetworkManager sharedManager] getRecordWithCurrentUserID:[MLDUserManager sharedManager].currentUserId promoteType:MLDAnalyTypePromoter completion:^(NSArray * _Nonnull dataArray, NSError * _Nonnull error) {

        weakSelf.dataArray = dataArray;
        [weakSelf.tableView reloadData];
    }];
}

- (NSArray *)dictKey
{
    return @[@"row", @"date", @"num"];
}

- (NSArray *)headerArray
{
    return @[@"序号", @"日期", @"推广次数"];
}

@end
