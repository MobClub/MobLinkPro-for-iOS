//
//  SceneDelegate.m
//  MobLinkProDemo
//
//  Created by maxl on 2019/9/17.
//  Copyright © 2019 mob. All rights reserved.
//

#import <objc/message.h>
#import "SceneDelegate.h"
#import "MLDMainViewController.h"
#import "MLDGuideViewController.h"
#ifndef __IPHONE_13_0

@protocol UIWindowSceneDelegate <NSObject>

@end

#endif

@protocol UIWindowSceneDelegate;
@class UIScene,UISceneSession,UISceneConnectionOptions, UIOpenURLContext;

@interface SceneDelegate ()<UIWindowSceneDelegate>

@end
@implementation SceneDelegate

- (void)scene:(id)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions API_AVAILABLE(ios(13.0)){
   self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
   self.window.backgroundColor = [UIColor whiteColor];
   [self.window makeKeyAndVisible];
    ((void (*)(id, SEL, id))objc_msgSend)(self.window,sel_registerName("setWindowScene:"),scene);
    if ([MLDGuideViewController isFirstRun])
    {
        self.window.rootViewController = [[MLDGuideViewController alloc] init];
    }
    else
    {
        self.window.rootViewController = [[MLDMainViewController alloc] init];
    }
}
- (void)sceneDidDisconnect:(UIScene *)scene API_AVAILABLE(ios(13.0)){
    
}
- (void)scene:(UIScene *)scene openURLContexts:(NSSet<UIOpenURLContext *> *)URLContexts API_AVAILABLE(ios(13.0)){

}
- (void)sceneDidBecomeActive:(UIScene *)scene API_AVAILABLE(ios(13.0)){
    
}
- (void)sceneWillResignActive:(UIScene *)scene API_AVAILABLE(ios(13.0)){
    
}

- (void)sceneWillEnterForeground:(UIScene *)scene API_AVAILABLE(ios(13.0)){
    
}
- (void)sceneDidEnterBackground:(UIScene *)scene API_AVAILABLE(ios(13.0)){
    
}
@end
