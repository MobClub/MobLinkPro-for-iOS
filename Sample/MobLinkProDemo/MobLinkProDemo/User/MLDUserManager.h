//
//  MLDUserManager.h
//  MobLinkProDemo
//
//  Created by lujh on 2018/12/12.
//  Copyright © 2018 mob. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MLDUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface MLDUserManager : NSObject

+ (instancetype)sharedManager;

- (void)loginUser;

//当前登录用户
@property (nonatomic, strong) MLDUser *currentUser;

- (NSString *)currentUserId;

@end

NS_ASSUME_NONNULL_END
