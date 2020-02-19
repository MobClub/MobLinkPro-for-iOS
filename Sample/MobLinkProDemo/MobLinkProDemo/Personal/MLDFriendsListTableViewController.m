//
//  MLDFriendsListTableViewController.m
//  MobLinkProDemo
//
//  Created by lujh on 2018/12/12.
//  Copyright © 2018 mob. All rights reserved.
//

#import "MLDFriendsListTableViewController.h"

#import "MLDUser.h"

#import "MLDFriendsListTableViewCell.h"

#import "MLDNetworkManager.h"

#import "MLDUserManager.h"

// MobLinkPro
#import <MobLinkPro/MLSDKScene.h>
#import <MobLinkPro/UIViewController+MLSDKRestore.h>

@interface MLDFriendsListTableViewController () <IMLDDeleteFriendDelegate>

@property (strong, nonatomic) NSMutableArray *dataArray;

@property (nonatomic, strong) MLSDKScene *scene;

@end

@implementation MLDFriendsListTableViewController

static NSString * const friendsReuseIdentifier = @"MLDFriendsListTableViewCell";

- (instancetype)initWithMobLinkScene:(MLSDKScene *)scene
{
    if (self = [super init])
    {
        self.scene = scene;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataArray = [[NSMutableArray alloc] init];

    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MLDFriendsListTableViewCell" bundle:nil] forCellReuseIdentifier:friendsReuseIdentifier];
    
    [self loadFriendsData];
    
    if (self.scene)
    {
        NSString *sourceId = self.scene.params[@"id"];
        if (![[MLDUserManager sharedManager].currentUserId isEqualToString:sourceId])
        {
            //查询好友信息
            __weak typeof(self) weakSelf = self;
            [[MLDNetworkManager sharedManager] queryUserInfoWithUserID:sourceId completion:^(MLDUser * _Nonnull user, NSError * _Nonnull error) {
                if (user)
                {
                    //加入好友列表
                    [weakSelf.dataArray addObject:user];
                    
                    [weakSelf.tableView reloadData];
                }
            }];
            
            // 向服务器发送添加好友
            [[MLDNetworkManager sharedManager] addFriendWithCurrentUserID:[MLDUserManager sharedManager].currentUserId otherUserID:sourceId channel:1001 completion:^(MLDUser * _Nonnull user, NSError * _Nonnull error) {
                if (!error)
                {
                    NSLog(@"添加好友成功");
                }
            }];
        }
    }
}

- (void)loadFriendsData
{
    __weak typeof(self) weakSelf = self;
    [[MLDNetworkManager sharedManager] queryFriendsWithCurrentUid:[MLDUserManager sharedManager].currentUserId complete:^(NSArray * _Nonnull friends, NSError * _Nonnull error) {
        
        if (weakSelf.scene)
        {
            NSPredicate *predicateForUid = [NSPredicate predicateWithFormat:@"uid == %@", weakSelf.scene.params[@"id"]];
            NSArray *resultForUid = [friends filteredArrayUsingPredicate:predicateForUid];
            if (resultForUid && resultForUid.count > 0)
            {
                weakSelf.dataArray = [NSMutableArray array];
            }
        }
        [weakSelf.dataArray addObjectsFromArray:friends];
        
        [weakSelf.tableView reloadData];
    }];
}

- (void)deleteFriendWithOtherUid:(NSString *)uid
{
    NSPredicate *predicateForUid = [NSPredicate predicateWithFormat:@"uid != %@", uid];
    NSArray *resultForUid = [self.dataArray filteredArrayUsingPredicate:predicateForUid];
    
    self.dataArray = [resultForUid mutableCopy];
    
    [self.tableView reloadData];
    
    [[MLDNetworkManager sharedManager] deleteFriendWithCurrentUserID:[MLDUserManager sharedManager].currentUserId otherUserID:uid completion:^(MLDUser * _Nonnull user, NSError * _Nonnull error) {
        if (!error)
        {
            //删除成功
            NSLog(@"删除用户成功：%@", user.uid);
        }
    }];
}

#pragma mark - Table view data source

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    view.backgroundColor = [UIColor colorWithRed:245/255.0 green:246/255.0 blue:248/255.0 alpha:1/1.0];
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(15, 0, 96, 40);
    label.text = @"全部粉丝";
    label.textAlignment = NSTextAlignmentLeft;
    label.font = Font(PingFangReguler,  14);
    label.textColor = [UIColor colorWithRed:157/255.0 green:164/255.0 blue:184/255.0 alpha:1/1.0];
    [view addSubview:label];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MLDFriendsListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:friendsReuseIdentifier forIndexPath:indexPath];
    
    cell.user = self.dataArray[indexPath.row];
    
    cell.delegate = self;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

@end
