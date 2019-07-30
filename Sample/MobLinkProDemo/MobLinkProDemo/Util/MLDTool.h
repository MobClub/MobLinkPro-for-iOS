//
//  MLDTool.h
//  MobLinkProDemo
//
//  Created by lujh on 2019/1/10.
//  Copyright © 2019 mob. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MLDAlertView.h"

@class MLSDKScene;

@interface MLDTool : NSObject

/**
 获取单例对象
 
 @return 单例对象
 */
+ (MLDTool *)shareInstance;

/**
 获取Mobid
 
 @param path 恢复路径
 @param params 参数
 @param result 结果回调
 */
- (void)getMobidWithPath:(NSString *)path
                  params:(NSDictionary *)params
                  result:(void (^)(NSString *mobid, NSString *domain, NSError *error))result;

/**
 使用用户偏好缓存mobid
 
 @param mobid mobid
 @param keyPath 对应key
 */
- (void)cacheMobid:(NSString *)mobid forKeyPath:(NSString *)keyPath;

/**
 从缓存读取mobid
 
 @param keyPath 对应key
 @return mobid
 */
- (NSString *)mobidForKeyPath:(NSString *)keyPath;

/**
 普通分享mobid
 
 @param mobid mobid
 @param title 标题
 @param text 内容
 @param imageName 完整图片名称须带后缀
 @param path 相应的路径
 @param onView iPhone可以传nil,但是iPad就必须要传一个分享弹窗的依赖视图,相当于一个锚点
 */
- (void)shareWithMobId:(NSString *)mobid
                 title:(NSString *)title
                  text:(NSString *)text
                 image:(NSString *)imageName
                  path:(NSString *)path
                onView:(UIView *)onView;

/**
 短链分享mobid
 
 @param mobid mobid
 @param title 标题
 @param text 内容
 @param imageName 完整图片名称须带后缀
 @param path 相应的路径
 @param domain 分享短链
 @param onView iPhone可以传nil,但是iPad就必须要传一个分享弹窗的依赖视图,相当于一个锚点
 */
- (void)shareWithMobId:(NSString *)mobid
                 title:(NSString *)title
                  text:(NSString *)text
                 image:(NSString *)imageName
                  path:(NSString *)path
                domain:(NSString *)domain
                onView:(UIView *)onView;

/**
 截图分享

 @param onView iPhone可以传nil,但是iPad就必须要传一个分享弹窗的依赖视图,相当于一个锚点
 */
- (void)shareQrcodeScreenCaptureOnView:(UIView *)onView mobid:(NSString *)mobid;

/**
 显示场景信息
 
 @param scene 场景信息
 */
- (void)showAlertWithScene:(MLSDKScene *)scene;

/**
 显示弹窗信息,默认无标题,无点击回调
 
 @param message 信息内容
 */
- (void)showAlertWithMessage:(NSString *)message;

/**
 显示弹窗
 
 @param title 标题
 @param message 信息
 @param cancel 取消按钮标题
 @param other 其他按钮标题
 @param block 点击按钮回调block
 */
- (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
               cancelTitle:(NSString *)cancel
                otherTitle:(NSString *)other
                clickBlock:(MLDAlertClickButtonBlock)block;

/**
 关闭所有弹窗
 */
- (void)dismissAlert;


/**
 是第一次被推广的用户

 @return bool
 */
+ (BOOL)isFirstPromote;

@end
