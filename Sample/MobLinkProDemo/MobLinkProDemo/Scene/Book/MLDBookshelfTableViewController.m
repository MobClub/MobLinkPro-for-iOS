//
//  MLDBookshelfTableViewController.m
//  MobLinkProDemo
//
//  Created by lujh on 2019/1/9.
//  Copyright © 2019 mob. All rights reserved.
//

#import "MLDBookshelfTableViewController.h"

#import "MLDBookTableViewCell.h"

#import "MLDBookViewController.h"

@interface MLDBookshelfTableViewController ()

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation MLDBookshelfTableViewController

static NSString * const bookReuseIdentifier = @"bookCellId";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"小说阅读还原";
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

    [self.tableView registerNib:[UINib nibWithNibName:@"MLDBookTableViewCell" bundle:nil] forCellReuseIdentifier:bookReuseIdentifier];
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
    return 135;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MLDBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:bookReuseIdentifier forIndexPath:indexPath];
    
    cell.dict = self.dataArray[indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MLDBookViewController *bookViewController = [[MLDBookViewController alloc] init];
    bookViewController.novelDict = self.dataArray[indexPath.row];
    
    [self.navigationController pushViewController:bookViewController animated:YES];
}

#pragma mark - 懒加载

- (NSArray *)dataArray
{
    if (_dataArray == nil)
    {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"NovelList" ofType:@"plist"];
        _dataArray = [NSArray arrayWithContentsOfFile:filePath];
    }
    return _dataArray;
}

@end
