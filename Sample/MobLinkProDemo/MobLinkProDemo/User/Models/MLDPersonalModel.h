//
//  MLDPersonalModel.h
//  MobLinkProDemo
//
//  Created by lujh on 2018/12/12.
//  Copyright © 2018 mob. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MLDUser;
@class MLDEarnings;

NS_ASSUME_NONNULL_BEGIN

@interface MLDPersonalModel : NSObject

@property (strong, nonatomic) NSArray<MLDUser *> *user;

@property (strong, nonatomic) NSArray<MLDEarnings *> *earnings;

@property (strong, nonatomic) NSArray<NSString *> *tasks;

@end

NS_ASSUME_NONNULL_END
