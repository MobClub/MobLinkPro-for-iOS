//
//  MOBPolicyManager.m
//  ShareSDKDemo
//
//  Created by maxl on 2020/1/14.
//  Copyright © 2020 mob. All rights reserved.
//

#import "MOBPolicyManager.h"
#import "MOBPolicyViewController.h"
#import <MOBFoundation/MOBFoundation.h>
#import <MOBFoundation/MobSDK+Privacy.h>
#import <objc/message.h>
static NSString * kMOBPolicyManagerSaveKey =  @"kMOBPolicyManagerSaveKey";

@interface MOBPolicyManager ()

@property (nonatomic, strong) NSNumber * isAllowPolicy;

@end

@implementation MOBPolicyManager

static dispatch_once_t onceToken;
static MOBPolicyManager * manager = nil;
+ (MOBPolicyManager *)defaultManager{
    dispatch_once(&onceToken, ^{
        manager = [MOBPolicyManager new];
    });
    return manager;
}

- (void)show{
    
    id cacheKey = [[NSUserDefaults standardUserDefaults] objectForKey:kMOBPolicyManagerSaveKey];
    if (cacheKey) {
        self.isAllowPolicy = cacheKey;
        return;
    }
    MOBPolicyViewController *vc = [MOBPolicyViewController new];
    vc.policyStaus = ^(BOOL status) {
        self.isAllowPolicy = @(status);
        [MobSDK uploadPrivacyPermissionStatus:status onResult:nil];
        [[NSUserDefaults standardUserDefaults] setObject:@(status) forKey:kMOBPolicyManagerSaveKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self clear];
    };
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    vc.present();
    
}

- (void)clear{
    onceToken = 0;
    manager = nil;
}

- (void)clearCache{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kMOBPolicyManagerSaveKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
