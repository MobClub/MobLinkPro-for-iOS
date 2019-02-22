//
//  MLDPersonalTableViewController.m
//  MobLinkProDemo
//
//  Created by lujh on 2018/12/11.
//  Copyright © 2018 mob. All rights reserved.
//

#import "MLDPersonalTableViewController.h"

#import "MLDPromoterTableViewController.h"
#import "MLDSharePromoteViewController.h"
#import "MLDFriendsListTableViewController.h"

#import "MLDUserTableViewCell.h"
#import "MLDEarningsTableViewCell.h"

#import "MLDUser.h"
#import "MLDEarnings.h"
#import "MLDPersonalModel.h"

#import "MLDUserManager.h"
#import "MLDNetworkManager.h"

@interface MLDPersonalTableViewController ()

@property (strong, nonatomic) NSArray *dataArray;

@end

@implementation MLDPersonalTableViewController

@synthesize person = _person;

static NSString * const userReuseIdentifier = @"MLDUserTableViewCell";
static NSString * const earningsReuseIdentifier = @"MLDEarningsTableViewCell";
static NSString * const staticReuseIdentifier = @"MLDStaticTableViewCell";

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, SCREEN_WIDTH, 0, 0)];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MLDUserTableViewCell" bundle:nil] forCellReuseIdentifier:userReuseIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"MLDEarningsTableViewCell" bundle:nil] forCellReuseIdentifier:earningsReuseIdentifier];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:staticReuseIdentifier];
    
    self.dataArray = @[self.person.user, self.person.earnings, self.person.tasks];
    
    [self.tableView reloadData];
}

- (void)setPerson:(MLDPersonalModel *)person
{
    _person = person;
    
    self.dataArray = @[person.user, person.earnings, person.tasks];
    
    [self.tableView reloadData];
}

- (MLDPersonalModel *)person
{
    if (!_person)
    {
        
        MLDPersonalModel *person = [[MLDPersonalModel alloc] init];

        _person = person;
        
        _person.tasks = @[@"地推", @"社交分享", @"好友列表"];
    }
    
    MLDUser *user = [MLDUserManager sharedManager].currentUser;
    
    if (user)
    {
        MLDEarnings *earnings = [[MLDEarnings alloc] init];
        earnings.earningsCount = user.earnings.earningsCount;
        earnings.promoteCount = user.earnings.promoteCount;
        
        _person.user = @[user];
        _person.earnings = @[earnings];
    }
    else
    {
        // 设置默认值
        MLDUser *user = [[MLDUser alloc] init];
        user.uid = @"12345";
        user.nickName = @"默认用户";
        
        MLDEarnings *earnings = [[MLDEarnings alloc] init];
        earnings.earningsCount = 0;
        earnings.promoteCount = 0;
        
        _person.user = @[user];
        _person.earnings = @[earnings];
    }
    
    return _person;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    __weak typeof(self) weakSelf = self;
    [[MLDNetworkManager sharedManager] queryEarningsWithCurrentUid:[MLDUserManager sharedManager].currentUserId completion:^(MLDEarnings * _Nonnull earnings, NSError * _Nonnull error) {
        MLDPersonalModel *person = weakSelf.person;
        if (earnings)
        {
            person.earnings = @[earnings];
        }
        
        [weakSelf setPerson:person];
        [weakSelf.tableView reloadData];
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    switch (indexPath.section)
    {
        case 0:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:userReuseIdentifier forIndexPath:indexPath];
            ((MLDUserTableViewCell *)cell).user = self.dataArray[indexPath.section][indexPath.row];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        }
        case 1:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:earningsReuseIdentifier forIndexPath:indexPath];
            ((MLDEarningsTableViewCell *)cell).earnings = self.dataArray[indexPath.section][indexPath.row];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        }
        case 2:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:staticReuseIdentifier forIndexPath:indexPath];
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = self.dataArray[indexPath.section][indexPath.row];
            cell.imageView.image = [UIImage imageNamed:@"dt"];
            cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
            break;
        }
        default:
            break;
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
        {
            return 100 * PUBLICSCALE;
        }
        case 1:
        {
            return 150 * PUBLICSCALE + 30;
        }
        case 2:
        {
            return 65 * PUBLICSCALE;
        }
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *detailViewController = nil;
    switch (indexPath.section)
    {
        case 0:
        {
            
            break;
        }
        case 2:
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    detailViewController = [[MLDPromoterTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
                    
                    MLDPersonalModel *person = [[MLDPersonalModel alloc] init];
                    person.user = self.person.user;
                    person.earnings = self.person.earnings;
                    person.tasks = @[@"生成地推二维码"];
                    
                    ((MLDPromoterTableViewController *)detailViewController).person = person;
                    
                    break;
                }
                case 1:
                {
                    detailViewController = [[MLDSharePromoteViewController alloc] init];
                    break;
                }
                case 2:
                {
                    detailViewController = [[MLDFriendsListTableViewController alloc] init];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
    if (detailViewController)
    {
        detailViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
}

@end
