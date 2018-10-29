//
//  MLSDKScene.h
//  MobLink
//
//  Created by lujh on 2018/7/13.
//  Copyright © 2018年 Mob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLSDKScene : NSObject

/**
 路径，自定义的路径
 */
@property (nonatomic, copy) NSString *path;

/**
 自定义参数
 */
@property (nonatomic, strong)  NSDictionary *params;

/**
 类名，即需要恢复的控制器名称
 */
@property (nonatomic, copy, readonly) NSString *className;

/**
 MobId
 */
@property (nonatomic, copy, readonly) NSString *mobid;

/**
 打开的原始链接
 */
@property (nonatomic, copy, readonly) NSString *rawURL;

/**
 初始化场景 @form v3.0.0
 
 @param params 参数
 @param path 路径
 @return 场景对象
 */
+ (instancetype)sceneForPath:(NSString *)path
                      params:(NSDictionary *)params;

/**
 初始化场景
 
 @param path 路径,应传入需要恢复的控制器所设定的路径,即控制器在实现UIViewController+MLSDKRestore里面的+[MLSDKPath]时所返回的值。
 @param source 来源标识
 @param params 自定义参数,可传入自定义键值对
 @return 场景对象
 */
- (instancetype)initWithMLSDKPath:(NSString *)path
                           source:(NSString *)source
                           params:(NSDictionary *)params __deprecated_msg("deprecated from v3.0.0. Use 'sceneForPath:params:'.");

@end
