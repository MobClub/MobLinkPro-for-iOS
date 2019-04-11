//
//  AppDelegate.m
//  MobLinkProDemo
//
//  Created by lujh on 2018/12/10.
//  Copyright © 2018 mob. All rights reserved.
//

#import "AppDelegate.h"

#import "MLDMainViewController.h"
#import "MLDGuideViewController.h"

#import "MLDUserManager.h"
#import "MLDNetworkManager.h"

#import "MLDTool.h"

// MobLinkPro
#import <MobLinkPro/MLSDKScene.h>
#import <MobLinkPro/MobLink.h>
#import <MobLinkPro/IMLSDKRestoreDelegate.h>

@interface AppDelegate ()<IMLSDKRestoreDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    self.guideSemaphore = dispatch_semaphore_create(0);
    self.guideQueue = dispatch_queue_create("MLDGuideQueue", DISPATCH_QUEUE_SERIAL);
    self.isAlreadyRun = NO;
    
    [[MLDUserManager sharedManager] loginUser];
    
    if ([MLDGuideViewController isFirstRun])
    {
        self.window.rootViewController = [[MLDGuideViewController alloc] init];
    }
    else
    {
        self.window.rootViewController = [[MLDMainViewController alloc] init];
    }
    
    // 配置 navigation bar
    [self setupNavigationBar];
    
    [MobLink setDelegate:self];
    
    return YES;
}

- (void)IMLSDKWillRestoreScene:(MLSDKScene *)scene Restore:(void (^)(BOOL, RestoreStyle))restoreHandler
{
    dispatch_async(self.guideQueue, ^{
        if (!self.isAlreadyRun)
        {
            dispatch_semaphore_wait(self.guideSemaphore, DISPATCH_TIME_FOREVER);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            restoreHandler(YES, MLPush);
        });
    });
    // 发送场景还原记录
    if (scene.params)
    {
        NSString *otherId = scene.params[@"id"];
        if (otherId)
        {
            MLDSceneType sourceType = MLDSceneTypeOthers;
            if (scene.params[@"scene"])
            {
                sourceType = [scene.params[@"scene"] integerValue];
            }
            [[MLDNetworkManager sharedManager] sendSceneLogWithCurrentUserID:[MLDUserManager sharedManager].currentUserId otherUserID:otherId sourceType:sourceType completion:^(BOOL success) {
                if (success)
                {
                    NSLog(@"上传场景记录成功");
                }
            }];
        }
    }
}

- (void)setupNavigationBar
{
    UINavigationBar * navigationBar = [UINavigationBar appearance];
    // 设置返回样式图片
    UIImage *image = [[UIImage imageNamed:@"fh"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    navigationBar.backIndicatorImage = image;
    navigationBar.backIndicatorTransitionMaskImage = image;
    
    // 设置标题属性
    [navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0], NSFontAttributeName : [UIFont fontWithName:@"PingFangSC-Semibold" size:18]}];
    // 设置bar颜色
    [navigationBar setBarTintColor:[UIColor colorWithRed:50/255.0 green:102/255.0 blue:255/255.0 alpha:1.0]];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
