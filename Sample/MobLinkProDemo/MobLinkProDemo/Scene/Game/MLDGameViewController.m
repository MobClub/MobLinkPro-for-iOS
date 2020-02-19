//
//  MLDGameViewController.m
//  MobLinkProDemo
//
//  Created by lujh on 2018/12/11.
//  Copyright © 2018 mob. All rights reserved.
//

#import "MLDGameViewController.h"

#import "MLDTool.h"

#import "MLDNetworkManager.h"
#import "MLDUserManager.h"

#import "UIViewController+MLDBackItemHandler.h"
#import "UIImageView+WebCache.h"

// MobLinkPro
#import <MobLinkPro/MLSDKScene.h>
#import <MobLinkPro/UIViewController+MLSDKRestore.h>

@interface MLDGameViewController () <UIAlertViewDelegate>

@property (copy, nonatomic)   NSString *roomId;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) UIImageView *homeownerView;
@property (strong, nonatomic) UIImageView *userSView;
@property (strong, nonatomic) UIButton *nickNameF;
@property (strong, nonatomic) UIButton *nickNameS;
@property (strong, nonatomic) MLDUser *homeownerUser;

@property (strong, nonatomic) MLDUser *otherUser;

@property (nonatomic, strong) MLSDKScene *scene;

@end

@implementation MLDGameViewController

- (instancetype)initWithMobLinkScene:(MLSDKScene *)scene
{
    if (self = [super init])
    {
        self.scene = scene;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"游戏场景还原";
    
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    [self setupDefaultUI];
    
    [self setupUIWithScene];
    
    if (!self.roomId)
    {
        if ([[MLDUserManager sharedManager] currentUserId])
        {
            self.roomId = [[NSUserDefaults standardUserDefaults] objectForKey:[[MLDUserManager sharedManager] currentUserId]];
        }
        // 如果是创建的房间，则开启定时器
        if (self.roomId)
        {
            [self startHeartbeat];
        }
    }
    
    if (!self.roomId)
    {
        //创建房间
        __weak typeof(self) weakSelf = self;
        
        [[MLDNetworkManager sharedManager] joinGameWithCurrentUserID:[[MLDUserManager sharedManager] currentUserId] roomNumber:nil completion:^(NSString * _Nonnull roomId, NSArray *users) {
            if (roomId)
            {
                // 缓存roomId
                weakSelf.roomId = roomId;
                [[NSUserDefaults standardUserDefaults] setObject:roomId forKey:[[MLDUserManager sharedManager] currentUserId]];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                // 如果是创建的房间，则开启定时器
                [weakSelf startHeartbeat];
            }
        }];
    }
    else
    {
        //加入房间
        __weak typeof(self) weakSelf = self;
        [[MLDNetworkManager sharedManager] joinGameWithCurrentUserID:[[MLDUserManager sharedManager] currentUserId] roomNumber:self.roomId completion:^(NSString * _Nonnull roomId, NSArray * _Nonnull users) {
            if (roomId)
            {
                if (weakSelf.scene)
                {
                    //提示加入房间成功
                    [[[MLDAlertView alloc] initWithTitle:nil
                                                 message:@"成功加入游戏房间"
                                          cancelBtnTitle:@"OK"
                                           otherBtnTitle:nil
                                              clickBlock:nil
                                                    type:MLDShowContentTypeLabel] show];
                }
            }
        }];
    }
    
    
}

- (void)setupDefaultUI
{
    self.view.layer.contents = (__bridge id)[UIImage imageNamed:@"yxfj"].CGImage;
    self.view.layer.contentsGravity = kCAGravityResize;
    self.view.layer.contentsScale = [UIScreen mainScreen].scale;
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 30, 30);
    [rightBtn setImage:[UIImage imageNamed:@"fx"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(shareItemClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *shareItme = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = shareItme;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    shareBtn.layer.contents = (__bridge id)[UIImage imageNamed:@"yqan"].CGImage;
    shareBtn.layer.contentsGravity = kCAGravityResizeAspect;
    CGFloat frameW = self.view.frame.size.width / 2.0;
    shareBtn.frame = CGRectMake(frameW, self.view.frame.size.height - 70 - MOBLINK_StatusBarSafeBottomMargin - 44, 60, 60);
    
    [shareBtn addTarget:self action:@selector(shareItemClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareBtn];
    
    // 添加用户
    self.homeownerView = [[UIImageView alloc] init];
    self.homeownerView.frame = CGRectMake(25, CGRectGetHeight([UIScreen mainScreen].bounds) / 2 - 100, 60, 60);
    
    self.homeownerView.layer.cornerRadius = 10;
    self.homeownerView.layer.masksToBounds = YES;
    
    UIView *viewF = [[UIView alloc] initWithFrame:CGRectMake(17, CGRectGetHeight([UIScreen mainScreen].bounds) / 2 - 105, 70, 70)];
    viewF.layer.contents = (__bridge id)[UIImage imageNamed:@"txk_1"].CGImage;
    
    self.nickNameF = [[UIButton alloc] initWithFrame:CGRectMake(17, CGRectGetHeight([UIScreen mainScreen].bounds) / 2 - 34, 73, 20)];
    self.nickNameF.layer.contents = (__bridge id)[UIImage imageNamed:@"xmp"].CGImage;
    self.nickNameF.titleLabel.font = Font(PingFangReguler,   13);
    
    [self.view addSubview:self.homeownerView];
    [self.view addSubview:viewF];
    [self.view addSubview:self.nickNameF];
    
    // 添加空白用户
    self.userSView = [[UIImageView alloc] init];
    self.userSView.frame = CGRectMake(25, CGRectGetHeight([UIScreen mainScreen].bounds) / 2, 60, 60);
    
    self.userSView.layer.cornerRadius = 10;
    self.userSView.layer.masksToBounds = YES;
    
    UIView *viewS = [[UIView alloc] initWithFrame:CGRectMake(17, CGRectGetHeight([UIScreen mainScreen].bounds) / 2 - 5, 70, 70)];
    viewS.layer.contents = (__bridge id)[UIImage imageNamed:@"txk_2"].CGImage;
    
    self.nickNameS = [[UIButton alloc] initWithFrame:CGRectMake(17, CGRectGetHeight([UIScreen mainScreen].bounds) / 2 + 66, 73, 20)];
    self.nickNameS.layer.contents = (__bridge id)[UIImage imageNamed:@"xmp"].CGImage;
    self.nickNameS.titleLabel.font = Font(PingFangReguler,   13);
    
    [self.view addSubview:self.userSView];
    [self.view addSubview:viewS];
    [self.view addSubview:self.nickNameS];
}

- (void)setupUIWithScene
{
    if (self.scene && self.scene.params[@"id"] && ![self.scene.params[@"id"] isEqualToString:[MLDUserManager sharedManager].currentUserId])
    {
        NSString *sourceId = self.scene.params[@"id"];
        
        // 根据id查询对方用户信息
        __weak typeof(self) weakSelf = self;
        [[MLDNetworkManager sharedManager] queryUserInfoWithUserID:sourceId completion:^(MLDUser * _Nonnull user, NSError * _Nonnull error) {
            if (user)
            {
                weakSelf.homeownerUser = user;
                weakSelf.otherUser = [MLDUserManager sharedManager].currentUser;
                [weakSelf setupRoomUsers];
            }
        }];
        
        self.roomId = self.scene.params[@"roomId"];
        
        [self.timer invalidate];
    }
    else
    {
        self.homeownerUser = [MLDUserManager sharedManager].currentUser;
    }
    [self setupRoomUsers];
}

// 设置房间用户信息
- (void)setupRoomUsers
{
    //更新imageView
    [self.homeownerView sd_setImageWithURL:[NSURL URLWithString:self.homeownerUser.avatar] placeholderImage:[UIImage imageNamed:@"txzp"]];
    
    [self.userSView sd_setImageWithURL:[NSURL URLWithString:self.otherUser.avatar] placeholderImage:[UIImage imageNamed:@"txzp"]];
    
    [self.nickNameF setTitle:self.homeownerUser.nickName forState:UIControlStateNormal];
    [self.nickNameS setTitle:self.otherUser.nickName forState:UIControlStateNormal];
}

//分享
- (void)shareItemClick:(UIButton *)shareBtn
{
    NSString *path = [NSString stringWithFormat:@"/scene/game?id=%@&room=%@", [[MLDUserManager sharedManager] currentUserId], self.roomId];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([MLDUserManager sharedManager].currentUserId)
    {
        [params addEntriesFromDictionary:@{@"id" : [MLDUserManager sharedManager].currentUserId}];
    }
    [params addEntriesFromDictionary:@{@"scene" : @(MLDSceneTypeGame)}];
    
    // 先读取缓存的mobid,缓存没有再进行网络请求
    NSString *cacheMobid = [[MLDTool shareInstance] mobidForKeyPath:path];
    NSString *title = @"MobLink 邀请你一起来玩";
    NSString *text = @"聚会一起玩，大家一起找卧底";
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSArray *iconsArr = infoDict[@"CFBundleIcons"][@"CFBundlePrimaryIcon"][@"CFBundleIconFiles"];
    NSString *image = [iconsArr lastObject];
    
    if (cacheMobid)
    {
        [[MLDTool shareInstance] shareWithMobId:cacheMobid
                                          title:title
                                           text:text
                                          image:image
                                           path:path
                                         onView:shareBtn];
    }
    else
    {
        [[MLDTool shareInstance] getMobidWithPath:@"/scene/game"
                                           params:params
                                           result:^(NSString *mobid, NSString *domain, NSError *error) {
            if (error) {
                UIAlertControllerAlertCreate(@"错误", [NSString stringWithFormat:@"%@",error.userInfo])
                .addCancelAction(@"OK")
                .present();
                return;
            }
                                               // 先缓存mobid,如果有的话
                                               if (mobid)
                                               {
                                                   [[MLDTool shareInstance] cacheMobid:mobid forKeyPath:path];
                                               }
                                               
                                               [[MLDTool shareInstance] shareWithMobId:mobid
                                                                                 title:title
                                                                                  text:text
                                                                                 image:image
                                                                                  path:path
                                                                                onView:shareBtn];
                                           }];
    }
}


// 轮询是否有新用户加入
- (void)startHeartbeat
{
    self.timer = [NSTimer timerWithTimeInterval:60 target:self selector:@selector(pollForNewUsers) userInfo:nil repeats:YES];
    // 加入RunLoop中
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)pollForNewUsers
{
    __weak typeof(self) weakSelf = self;
    [[MLDNetworkManager sharedManager] gameHeartbeatWithCurrentUserID:[[MLDUserManager sharedManager] currentUserId] roomNumber:self.roomId complete:^(NSArray * _Nonnull users, NSString * _Nonnull roomNumber, NSError * _Nonnull error) {
        if (users)
        {
            for (MLDUser *user in users)
            {
                if (user.seat == 1)
                {
                    weakSelf.homeownerUser = user;
                }
                else
                {
                    weakSelf.otherUser = user;
                }
            }
            [weakSelf setupRoomUsers];
        }
    }];
}

- (BOOL)navigationShouldPopOnBackButtonClick
{
    [[[MLDAlertView alloc] initWithTitle:nil
                                 message:@"确定退出房间？"
                          cancelBtnTitle:@"还待着"
                           otherBtnTitle:@"狠心离开"
                              clickBlock:^(MLDButtonType type) {
                                  switch (type) {
                                      case MLDButtonTypeSure:
                                      {
                                          // 离开房间
                                          // 如果是加入的房间，则退出房间
                                          if ([self.otherUser.uid isEqualToString:[MLDUserManager sharedManager].currentUserId])
                                          {
                                              NSLog(@"正在退出房间");
                                              [[MLDNetworkManager sharedManager] exitGameWithCurrentUserID:[MLDUserManager sharedManager].currentUserId completion:^(BOOL success) {
                                                  //退出成功
                                                  if (success)
                                                  {
                                                      NSLog(@"退出房间成功，房间id:%@",self.roomId);
                                                  }
                                              }];
                                          }
                                          
                                          [self.timer invalidate];
                                          
                                          [self.navigationController popViewControllerAnimated:YES];
                                          break;
                                      }
                                      default:
                                          break;
                                  }
                                  
                              }
                                    type:MLDShowContentTypeLabel] show];
    return NO;
}

@end
