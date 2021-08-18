//
//  IMOBFLinkComponent.h
//  MOBFoundation
//
//  Created by Sands_Lee on 2017/4/25.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MOBFoundation/IMOBFServiceComponent.h>

@protocol IMOBFScene;
@protocol IMOBFLinkController;

/**
 MobLink产品组件
 */
@protocol IMOBFLinkComponent <IMOBFServiceComponent>

/**
 获取MobId
 
 @param scene 当前场景信息(即传入您需要还原的场景)
 @param resultHandler 回调处理,返回mobid
 */
+ (void)getMobId:(MLSDKScene *)scene result:(void (^) (NSString *mobid, NSString *domain, NSError *error))resultHandler;

/**
 设置委托
 
 @param delegate 委托对象
 */
+ (void)setDelegate:(id)delegate;

@end

/**
 MobLink控制器
 */
@protocol IMOBFLinkController

@required

/**
 控制器初始化
 
 @param scene 场景参数
 @return 控制器对象
 */
- (instancetype)initWithMobLinkScene:(id<IMOBFScene>)scene;

@end

/**
 MobLink场景对象
 */
@protocol IMOBFScene

@required

/**
 获取路径

 @return 路径
 */
- (NSString *)getPath;

/**
 获取自定义参数

 @return 自定义参数
 */
- (NSDictionary *)getParams;

/**
 获取mobId

 @return MobId
 */
- (NSString *)getMobId;


/**
 获取类名

 @return ClassName
 */
- (NSString *)getClassName;

/**
 获取原始链接
 
 @return 原始链接
 */
- (NSString *)getRawURL;

@end

