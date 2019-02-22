//
//  MLDNetworkManager.h
//  MobLinkProDemo
//
//  Created by lujh on 2019/1/10.
//  Copyright © 2019 mob. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MLDUser;
@class MLDEarnings;
NS_ASSUME_NONNULL_BEGIN

@interface MLDNetworkManager : NSObject

+ (instancetype)sharedManager;

#pragma mark - user

/**
 获取新用户

 @param retry 是否重新获取
 @param completion 回调用户信息
 */
- (void)getMLDUserNeedRetry:(BOOL)retry
                 completion:(void (^)(MLDUser *user, NSError *error))completion;


#pragma mark - game

/**
 加入游戏房间

 @param uid 用户id
 @param roomNumber 房间号，传0则创建房间
 @param completion 回调成功失败
 */
- (void)joinGameWithCurrentUserID:(NSString *)uid
                       roomNumber:(nullable NSString *)roomNumber
                       completion:(void (^)(NSString *, NSArray *users))completion;

/**
 退出房间

 @param uid 用户id
 @param completion 回调
 */
- (void)exitGameWithCurrentUserID:(NSString *)uid
                       completion:(void (^)(BOOL))completion;

/**
 游戏心跳

 @param uid 用户id
 @param roomNumber 房间号
 @param completion 回调，已加入房间的用户列表，房间号
 */
- (void)gameHeartbeatWithCurrentUserID:(NSString *)uid
                            roomNumber:(NSString *)roomNumber
                              complete:(void (^)(NSArray *users, NSString *roomNumber, NSError *error))completion;


#pragma mark - promote

/**
 添加收益用户

 @param uid 用户id
 @param sourceUid 对方用户id
 @param completion 回调
 */
- (void)addMoneyPushUserWithCurrentUserID:(NSString *)uid
                             sourceUserID:(NSString *)sourceUid
                                  channel:(MLDChannelType)channel
                                     type:(MLDAnalyType)type
                               completion:(void (^)(BOOL))completion;

/**
 根据用户id查询推广收益
 
 @param uid 用户id
 @param completion 推广收益
 */
- (void)queryEarningsWithCurrentUid:(NSString *)uid
                         completion:(void (^)(MLDEarnings *earnings, NSError * error))completion;


#pragma mark - friend

/**
 查询好友列表

 @param uid 用户id
 @param completion 好友列表
 */
- (void)queryFriendsWithCurrentUid:(NSString *)uid
                          complete:(void (^)(NSArray *friends, NSError *error))completion;


/**
 添加好友

 @param uid 用户id
 @param otherUid 对方用户id
 @param channel 渠道
 @param completion 用户
 */
- (void)addFriendWithCurrentUserID:(NSString *)uid
                       otherUserID:(NSString *)otherUid
                           channel:(MLDChannelType)channel
                        completion:(void (^)(MLDUser *user, NSError *error))completion;

/**
 删除好友

 @param uid 用户id
 @param otherUid 对方用户id
 @param completion 用户
 */
- (void)deleteFriendWithCurrentUserID:(NSString *)uid
                          otherUserID:(NSString *)otherUid
                           completion:(void (^)(MLDUser *user, NSError *error))completion;

/**
 根据id查询用户信息

 @param uid 用户id
 @param completion 用户信息
 */
- (void)queryUserInfoWithUserID:(NSString *)uid
                     completion:(void (^)(MLDUser *user, NSError *error))completion;


#pragma mark - record

/**
 获得推广记录

 @param uid 用户id
 @param promoteType 推广方式
 @param completion 推广记录
 */
- (void)getRecordWithCurrentUserID:(NSString *)uid
                       promoteType:(MLDAnalyType)promoteType
                        completion:(void (^)(NSArray *, NSError *))completion;

/**
 上传还原记录

 @param uid 用户id
 @param otherUid 来源用户id
 @param type 场景来源
 @param completion 成功失败
 */
- (void)sendSceneLogWithCurrentUserID:(NSString *)uid
                          otherUserID:(NSString *)otherUid
                           sourceType:(MLDSceneType)type
                           completion:(void (^)(BOOL))completion;

@end

NS_ASSUME_NONNULL_END
