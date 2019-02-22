//
//  MLDUserManager.m
//  MobLinkProDemo
//
//  Created by lujh on 2018/12/12.
//  Copyright © 2018 mob. All rights reserved.
//

#import "MLDUserManager.h"

#import "MLDNetworkManager.h"

static NSString *const CacheDataDomain = @"MLDCacheDataDomain";

static NSString *const kMLDCurrentUser = @"kMLDCurrentUser";

@implementation MLDUserManager

+ (instancetype)sharedManager
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)loginUser
{
    if (![MLDUserManager sharedManager].currentUser)
    {
        __weak typeof(self) weakSelf = self;
        [[MLDNetworkManager sharedManager] getMLDUserNeedRetry:YES completion:^(MLDUser * _Nonnull user, NSError * _Nonnull error) {
            
            if (user.uid)
            {
                [NSKeyedArchiver archiveRootObject:user toFile:[NSString stringWithFormat:@"%@/Library/Caches/%@", NSHomeDirectory(), CacheDataDomain]];
                
                [[MLDNetworkManager sharedManager] queryEarningsWithCurrentUid:user.uid completion:^(MLDEarnings * _Nonnull earnings, NSError * _Nonnull error) {
                    
                    user.earnings = earnings;
                    weakSelf.currentUser = user;
                }];
            }
        }];
    }
    else
    {
        // 查询当前id的推广数和收益数
        [[MLDNetworkManager sharedManager] queryEarningsWithCurrentUid:self.currentUserId completion:^(MLDEarnings * _Nonnull earnings, NSError * _Nonnull error) {
            
            [MLDUserManager sharedManager].currentUser.earnings = earnings;
        }];
    }
}

- (MLDUser *)currentUser
{
    if (!_currentUser)
    {
        MLDUser *user = [NSKeyedUnarchiver unarchiveObjectWithFile:[NSString stringWithFormat:@"%@/Library/Caches/%@", NSHomeDirectory(), CacheDataDomain]];
        _currentUser = user;
    }
    return _currentUser;
}

- (NSString *)currentUserId
{
    return [MLDUserManager sharedManager].currentUser.uid;
}

@end
