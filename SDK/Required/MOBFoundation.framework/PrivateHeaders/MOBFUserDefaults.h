//
//  MOBFUserDefaults.h
//  MOBFoundation
//
//  Created by hower on 2020/5/20.
//  Copyright © 2020 MOB. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MOBFDataService;

@interface MOBFUserDefaults : NSObject

/**
*  获取当前授权状态
**  @param dataService 数据管理服务
*  @param key  标识
*  @return 当前授权状态
*/
+ (NSNumber *)curAuthNum:(MOBFDataService *)dataService key:(NSString *)key;


/**
*  设置当前授权状态
**  @param authStatus 授权状态
*  @param key  标识
*/
+ (void)setCurAuthNum:(NSNumber *)authStatus key:(NSString *)key dataService:(MOBFDataService *)dataService;

@end

NS_ASSUME_NONNULL_END
