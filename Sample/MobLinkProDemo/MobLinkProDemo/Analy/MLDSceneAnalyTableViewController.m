//
//  MLDSceneAnalyTableViewController.m
//  MobLinkProDemo
//
//  Created by lujh on 2019/1/16.
//  Copyright © 2019 mob. All rights reserved.
//

#import "MLDSceneAnalyTableViewController.h"

@interface MLDSceneAnalyTableViewController ()

@end

@implementation MLDSceneAnalyTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"场景还原记录";
    
    __weak typeof(self) weakSelf = self;
    //请求数据
    [[MLDNetworkManager sharedManager] getRecordWithCurrentUserID:[MLDUserManager sharedManager].currentUserId promoteType:MLDAnalyTypeScene completion:^(NSArray * _Nonnull dataArray, NSError * _Nonnull error) {
        
        weakSelf.dataArray = dataArray;
        [weakSelf.tableView reloadData];
    }];
}

- (NSArray *)dictKey
{
    return @[@"row", @"date", @"scene", @"num"];
}

- (NSArray *)headerArray
{
    return @[@"序号", @"日期", @"场景", @"推广次数"];
}

@end
