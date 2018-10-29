//
//  AppDelegate.m
//  MobLinkDemo
//
//  Created by youzu on 2017/1/11.
//  Copyright © 2017年 mob. All rights reserved.
//

#import "AppDelegate.h"

#import "MLDMainViewController.h"

#import "WeiboSDK.h"
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <ShareSDK/ShareSDK.h>
#import <MobLinkPro/MobLink.h>
#import <MobLinkPro/MLSDKScene.h>
#import <MobLinkPro/IMLSDKRestoreDelegate.h>

#import <MOBFoundation/MOBFoundation.h>

@interface AppDelegate () <IMLSDKRestoreDelegate>

@property (strong, nonatomic) UITabBarController *tabBarCtr;

@end


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[MLDMainViewController alloc] init];
    [self.window makeKeyAndVisible];
    
    // 设置MobLink代理
    [MobLink setDelegate:self];
    
    // 设置返回按钮样式
    [self setNavBackItem];
    
    // 初始化ShareSDK
    [self initShareSDK];
    
    
    return YES;
}


- (void)setNavBackItem
{
    UINavigationBar * navigationBar = [UINavigationBar appearance];
    //设置返回样式图片
    UIImage *image = [[UIImage imageNamed:@"return"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    navigationBar.backIndicatorImage = image;
    navigationBar.backIndicatorTransitionMaskImage = image;
}

/**
 初始化ShareSDK
 */
- (void)initShareSDK
{
    [ShareSDK registerActivePlatforms:@[@(SSDKPlatformTypeSinaWeibo),
                                        @(SSDKPlatformSubTypeWechatSession),
                                        @(SSDKPlatformSubTypeWechatTimeline),
                                        @(SSDKPlatformTypeQQ)]
                             onImport:^(SSDKPlatformType platformType) {
                                 
                                 switch (platformType)
                                 {
                                     case SSDKPlatformTypeWechat:
                                         [ShareSDKConnector connectWeChat:[WXApi class] delegate:self];
                                         break;
                                     case SSDKPlatformTypeQQ:
                                         [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                                         break;
                                     case SSDKPlatformTypeSinaWeibo:
                                         [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                                         break;
                                         
                                     default:
                                         break;
                                 }
                                 
                             } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
                                 
                                 switch (platformType)
                                 {
                                     case SSDKPlatformTypeWechat:
                                         [appInfo SSDKSetupWeChatByAppId:@"wx01634d672597c03c"
                                                               appSecret:@"64020361b8ec4c99936c0e3999a9f249"];
                                         break;
                                     case SSDKPlatformTypeQQ:
                                         [appInfo SSDKSetupQQByAppId:@"1105479028"
                                                              appKey:@"HxHozohsRAkSGREY"
                                                            authType:SSDKAuthTypeSSO];
                                         break;
                                     case SSDKPlatformTypeSinaWeibo:
                                         [appInfo SSDKSetupSinaWeiboByAppKey:@"474962333"
                                                                   appSecret:@"26522c6ed236057fd4ff5005449f98e9"
                                                                 redirectUri:@"http://www.sharesdk.cn"
                                                                    authType:SSDKAuthTypeBoth];
                                         break;
                                         
                                     default:
                                         break;
                                 }
                                 
                             }];
}

- (void) IMLSDKWillRestoreScene:(MLSDKScene *)scene Restore:(void (^)(BOOL, RestoreStyle))restoreHandler
{
    NSLog(@"Will Restore Scene - Class Name:%@",scene.className);

    if ([scene.className hasSuffix:@"MLDShopping"])
    {
        [[MLDTool shareInstance] showAlertWithTitle:nil
                                            message:@"是否进行场景恢复？"
                                        cancelTitle:@"否"
                                         otherTitle:@"是"
                                         clickBlock:^(MLDButtonType type) {
                                             type == MLDButtonTypeSure ? restoreHandler(YES, MLDefault) : restoreHandler (NO, MLDefault);
                                         }];
    }
    else
    {
        restoreHandler(YES, MLDefault);
    }

}

- (void)IMLSDKCompleteRestore:(MLSDKScene *)scene
{
    NSLog(@"Complete Restore -className:%@",scene.className);
}

- (void)IMLSDKNotFoundScene:(MLSDKScene *)scene
{
    NSLog(@"Not Found Scene - className :%@",scene.className);

    [[MLDTool shareInstance] showAlertWithTitle:@"没有找到该类"
                                        message:[NSString stringWithFormat:@"Path: %@",scene.className]
                                    cancelTitle:@"OK"
                                     otherTitle:nil
                                     clickBlock:nil];
}

@end
