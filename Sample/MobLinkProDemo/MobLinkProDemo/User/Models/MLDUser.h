//
//  MLDUser.h
//  MobLinkProDemo
//
//  Created by lujh on 2018/12/11.
//  Copyright © 2018 mob. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MLDEarnings.h"

NS_ASSUME_NONNULL_BEGIN

@interface MLDUser : NSObject

/**
 用户id
 */
@property (nonatomic, copy) NSString *uid;

/**
 用户头像
 */
@property (nonatomic, copy) NSString *avatar;

/**
 昵称
 */
@property (nonatomic, copy) NSString *nickName;

/**
 座位
 */
@property (nonatomic, assign) NSInteger seat;

/**
 用户推广收益
 */
@property (nonatomic, strong) MLDEarnings *earnings;

@end

NS_ASSUME_NONNULL_END
