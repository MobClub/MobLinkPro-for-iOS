//
//  MOBFComponentManager.h
//  MOBFoundation
//
//  Created by 冯鸿杰 on 17/2/14.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 组件管理器
 */
@interface MOBFComponentManager : NSObject

/**
 获取默认组件管理器
 
 @return 组件管理器
 */
+ (MOBFComponentManager *)defaultManager;

/**
 注册组件字符串
 建议在load中注册
 
 @param component 组件字符串类型
 */
+ (void)regComponentStr:(NSString *)componentStr;

/**
 注册组件
 
 @param component 组件类型
 */
- (void)regComponent:(Class)component;

/**
 反注册组件
 
 @param component 组件类型
 */
- (void)unregComponent:(Class)component;

/**
 获取注册组件
 
 @param protocol 组件协议
 @return 组件
 */
- (NSArray *)getComponents:(Protocol *)protocol;

/**
 获取组件名称

 @param component 组件
 @return 组件名称
 */
- (NSString *)getComponentName:(id)component;

/**
 获取组件版本

 @param component 组件
 @return 组件版本
 */
- (NSString *)getComponentVersion:(id)component;

/**
 获取解决方案名称
 
 @param component 组件
 @return 解决方案名称
 */
- (NSString *)getSolutionName:(id)component;

@end
