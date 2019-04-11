//
//  AppDelegate.h
//  MobLinkProDemo
//
//  Created by lujh on 2018/12/10.
//  Copyright © 2018 mob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) dispatch_queue_t guideQueue;
@property (nonatomic) dispatch_semaphore_t guideSemaphore;
@property (nonatomic) BOOL isAlreadyRun;

@end

