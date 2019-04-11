//
//  MLDEarnings.h
//  MobLinkProDemo
//
//  Created by lujh on 2018/12/11.
//  Copyright © 2018 mob. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MLDEarnings : NSObject

/**
 累计收益数
 */
@property (nonatomic, assign) NSInteger earningsCount;

/**
 累计推广数
 */
@property (nonatomic, assign) NSInteger promoteCount;

@end

NS_ASSUME_NONNULL_END
