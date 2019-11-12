//
//  AppDelegate.m
//  MobLinkProDemo
//
//  Created by lujh on 2018/12/10.
//  Copyright © 2018 mob. All rights reserved.
//

#import "AppDelegate.h"
#import "MOBApplication.h"
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
    self.guideSemaphore = dispatch_semaphore_create(0);
    self.guideQueue = dispatch_queue_create("MLDGuideQueue", DISPATCH_QUEUE_SERIAL);
    self.isAlreadyRun = NO;
    
    [[MLDUserManager sharedManager] loginUser];
    [MobLink setDelegate:self];
    
    MLSDKScene *scene = [MLSDKScene sceneForPath:@"/demo/test/123" params:@{@"key11": @"value11"}];
    [MobLink getMobId:scene result:^(NSString * _Nullable mobid, NSString * _Nullable domain, NSError * _Nullable error) {
        NSLog(@"------> mobid: %@  domain:%@", mobid, domain);
    }];
    if (![MOBApplication sharedApplication].isSceneApp) {
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.window.backgroundColor = [UIColor whiteColor];
        [self.window makeKeyAndVisible];
        if ([MLDGuideViewController isFirstRun])
        {
            self.window.rootViewController = [[MLDGuideViewController alloc] init];
        }
        else
        {
            self.window.rootViewController = [[MLDMainViewController alloc] init];
        }
        
    }

    [[MOBApplication sharedApplication] addBeforeWindowEvent:^(MOBApplication * _Nonnull application) {
        [self setupNavigationBar];
    }];
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
        if (scene.params && [scene.params isKindOfClass:[NSDictionary class]])
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

//- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler
//{
//    NSLog(@"title: %@", userActivity.title);
//    // NSUserActivityTypeBrowsingWeb
//    NSLog(@"activityType: %@", userActivity.activityType);
//    // The webpage URL property always contains an HTTP or HTTPS URL, and you can use NSURLComponents APIs to manipulate the components of the URL.
//    NSLog(@"webpageURL: %@", userActivity.webpageURL);
//    // 根据webpageURL的路径、参数等作出适当的处理
//    // <your code here ...>
//    return YES;
//}

@end
