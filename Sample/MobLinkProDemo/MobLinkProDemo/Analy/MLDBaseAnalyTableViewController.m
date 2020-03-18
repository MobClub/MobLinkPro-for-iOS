//
//  MLDBaseAnalyTableViewController.m
//  MobLinkProDemo
//
//  Created by lujh on 2019/1/16.
//  Copyright © 2019 mob. All rights reserved.
//

#import "MLDBaseAnalyTableViewController.h"

#import "MLDBaseAnalyTableViewCell.h"

@interface MLDBaseAnalyTableViewController ()

@end

@implementation MLDBaseAnalyTableViewController

static NSString * const analyReuseIdentifier = @"MLDBaseAnalyTableViewCellId";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.bounces = NO;
    self.tableView.allowsSelection = NO;
    
    [self.tableView registerClass:[MLDBaseAnalyTableViewCell class] forCellReuseIdentifier:analyReuseIdentifier];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MLDBaseAnalyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:analyReuseIdentifier forIndexPath:indexPath];
    
    cell.dict = @{
                  @"row" : @(indexPath.row),
                  @"dictKey" : self.dictKey,
                  @"dataDict" : self.dataArray[indexPath.row],
                  };
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40.0);
    view.backgroundColor = [UIColor whiteColor];
    NSInteger count = self.headerArray.count;
    [self.headerArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0 + SCREEN_WIDTH / count * idx, 0, SCREEN_WIDTH / count, 40.0)];
        label.text = obj;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = Font(PingFangSemibold,   15);
        label.textColor = [UIColor colorWithRed:157/255.0 green:164/255.0 blue:184/255.0 alpha:1/1.0];
        [view addSubview:label];
    }];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0;
}

@end
