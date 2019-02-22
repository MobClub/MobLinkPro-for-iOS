//
//  MLDShareAnalyTableViewController.m
//  MobLinkProDemo
//
//  Created by lujh on 2019/1/16.
//  Copyright © 2019 mob. All rights reserved.
//

#import "MLDShareAnalyTableViewController.h"

@interface MLDShareAnalyTableViewController ()

@end

@implementation MLDShareAnalyTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"社交推广记录";
    
    __weak typeof(self) weakSelf = self;
    //请求数据
    [[MLDNetworkManager sharedManager] getRecordWithCurrentUserID:[MLDUserManager sharedManager].currentUserId promoteType:MLDAnalyTypeShare completion:^(NSArray * _Nonnull dataArray, NSError * _Nonnull error) {
        
        weakSelf.dataArray = dataArray;
        [weakSelf.tableView reloadData];
    }];
}

- (NSArray *)dictKey
{
    return @[@"row", @"date", @"channel", @"num"];
}

- (NSArray *)headerArray
{
    return @[@"序号", @"日期", @"社交渠道", @"推广次数"];
}

@end
