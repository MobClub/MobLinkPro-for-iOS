//
//  MLDPromoterTableViewController.m
//  MobLinkProDemo
//
//  Created by lujh on 2018/12/12.
//  Copyright © 2018 mob. All rights reserved.
//

#import "MLDPromoterTableViewController.h"

#import "MLDPersonalModel.h"

#import "MLDPromoterFooterView.h"

#import "MLDUserManager.h"
#import "MLDNetworkManager.h"

#import "MLDTool.h"

// MobLinkPro
#import <MobLinkPro/MLSDKScene.h>
#import <MobLinkPro/UIViewController+MLSDKRestore.h>

@interface MLDPromoterTableViewController ()

@property (copy, nonatomic) NSString *qrcodeString;

@property (nonatomic, strong) MLSDKScene *scene;

@end

@implementation MLDPromoterTableViewController

static NSString * const promoteReuseIdentifier = @"MLDPromoteFooterCell";

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
    
    self.title = @"地推";
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    NSString *path = [NSString stringWithFormat:@"/invite/local?id=%@", [[MLDUserManager sharedManager] currentUserId]];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([MLDUserManager sharedManager].currentUserId)
    {
        [params addEntriesFromDictionary:@{@"id" : [MLDUserManager sharedManager].currentUserId}];
    }
    [params addEntriesFromDictionary:@{@"scene" : @(MLDSceneTypePromote)}];

    // 先读取缓存的mobid,缓存没有再进行网络请求
    NSString *cacheMobid = [[MLDTool shareInstance] mobidForKeyPath:path];
    
    if (cacheMobid)
    {
        self.qrcodeString = [NSString stringWithFormat:@"%@/invite/local?id=%@&mobid=%@", baseShareUrl, [[MLDUserManager sharedManager] currentUserId], cacheMobid];
    }
    else
    {
        __weak typeof(self) weakSelf = self;
        [[MLDTool shareInstance] getMobidWithPath:@"/invite/local"
                                           params:params
                                           result:^(NSString *mobid, NSString *domain, NSError *error) {
                                               // 先缓存mobid,如果有的话
                                               if (mobid)
                                               {
                                                   [[MLDTool shareInstance] cacheMobid:mobid forKeyPath:path];
                                               }
                                               weakSelf.qrcodeString = [NSString stringWithFormat:@"%@/invite/local?id=%@&mobid=%@", baseShareUrl, [[MLDUserManager sharedManager] currentUserId], mobid];
                                               [weakSelf.tableView reloadData];
                                           }];
    }

    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    [self addPromoter];
}

- (void)addPromoter
{
    if (self.scene)
    {
        NSString *souceId = self.scene.params[@"id"];
        MLDChannelType channelType = MLDChannelTypeOthers;
        if (self.scene.params[@"channel"])
        {
            channelType = [self.scene.params[@"channel"] integerValue];
        }
        // 只增加首次还原的
        if (souceId
            && ![souceId isEqualToString:[MLDUserManager sharedManager].currentUserId]
            && [MLDTool isFirstPromote])
        {
            [[MLDNetworkManager sharedManager] addMoneyPushUserWithCurrentUserID:[MLDUserManager sharedManager].currentUserId sourceUserID:souceId channel:channelType type:MLDAnalyTypePromoter completion:^(BOOL success) {
                if (success)
                {
                    NSLog(@"来源ID:%@ 添加收益用户成功", souceId);
                }
            }];
        }
    }
}

- (MLDPersonalModel *)person
{
    MLDPersonalModel *person = [super person];
    person.tasks = @[];
    return person;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2)
    {
        return SCREEN_WIDTH * 0.65 + 135;
    }
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 2)
    {
        MLDPromoterFooterView *footerView = (MLDPromoterFooterView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:promoteReuseIdentifier];
        
        if (!footerView)
        {
            footerView = [[MLDPromoterFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 0.65 + 135)];
        }

        footerView.qrString = self.qrcodeString;
        
        return footerView;
    }
    else
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
        view.backgroundColor = [UIColor clearColor];
        return view;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

@end
