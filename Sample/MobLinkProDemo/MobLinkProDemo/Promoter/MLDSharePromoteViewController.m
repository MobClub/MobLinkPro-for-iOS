//
//  MLDSharePromoteViewController.m
//  MobLinkProDemo
//
//  Created by lujh on 2018/12/11.
//  Copyright © 2018 mob. All rights reserved.
//

#import "MLDSharePromoteViewController.h"

#import "MLDShareQRCodeView.h"

#import "MLDUserManager.h"
#import "MLDNetworkManager.h"

#import "MLDTool.h"

// MobLinkPro
#import <MobLinkPro/MLSDKScene.h>
#import <MobLinkPro/UIViewController+MLSDKRestore.h>

@interface MLDSharePromoteViewController ()

@property (nonatomic, strong) MLSDKScene *scene;

@end

@implementation MLDSharePromoteViewController

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
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"我的推广";
    
    // 加载二维码视图
    [self loadUI];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 30, 30);
    [rightBtn setImage:[UIImage imageNamed:@"fx"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(shareItemClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *shareItme = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = shareItme;
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
        
        if (souceId
            && ![souceId isEqualToString:[MLDUserManager sharedManager].currentUserId]
            && [MLDTool isFirstPromote])
        {
            [[MLDNetworkManager sharedManager] addMoneyPushUserWithCurrentUserID:[MLDUserManager sharedManager].currentUserId sourceUserID:souceId channel:channelType type:MLDAnalyTypeShare completion:^(BOOL success) {
                if (success)
                {
                    NSLog(@"来源ID:%@ 添加收益用户成功", souceId);
                }
            }];
        }
    }
}

- (void)shareItemClick:(UIButton *)shareBtn
{    
    // 截图分享
    [[MLDTool shareInstance] shareQrcodeScreenCaptureOnView:shareBtn];
}

- (void)loadUI
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    
    MLDShareQRCodeView *qrCodeView = [[MLDShareQRCodeView alloc] initWithFrame:self.view.bounds];
    
    MLDUser *currentUser = [MLDUserManager sharedManager].currentUser;
    if (!currentUser)
    {
        currentUser = [[MLDUser alloc] init];
        currentUser.uid = @"12345";
        currentUser.nickName = @"默认用户";
    }
    
    qrCodeView.user = currentUser;
    
    [self.view addSubview:qrCodeView];
}


@end
