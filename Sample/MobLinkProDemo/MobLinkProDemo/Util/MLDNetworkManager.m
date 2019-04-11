//
//  MLDNetworkManager.m
//  MobLinkProDemo
//
//  Created by lujh on 2019/1/10.
//  Copyright © 2019 mob. All rights reserved.
//

#import "MLDNetworkManager.h"

#import "MLDUser.h"

@implementation MLDNetworkManager

+ (instancetype)sharedManager
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

#pragma mark - user

- (void)getMLDUserNeedRetry:(BOOL)retry
                 completion:(void (^)(MLDUser *user, NSError *error))completion
{
    NSString *urlString = [NSString stringWithFormat:@"%@:%@/user/login", MLD_Host, MLD_Port];
    
    __weak typeof(self) weakSelf = self;
    [MOBFHttpService sendHttpRequestByURLString:urlString
                                         method:@"POST"
                                     parameters:nil
                                        headers:nil
                                       onResult:^(NSHTTPURLResponse *response, NSData *responseData) {
                                           NSDictionary *responseDict = [MOBFJson objectFromJSONData:responseData];
                                           if (responseDict[@"success"])
                                           {
                                               NSDictionary *userDict = responseDict[@"res"];
                                               
                                               NSLog(@"%@",userDict);
                                               
                                               MLDUser *user = [[MLDUser alloc] init];
                                               user.uid = userDict[@"id"];
                                               user.avatar = userDict[@"avatar"];
                                               user.nickName = userDict[@"nickname"];
                                               
                                               if (completion)
                                               {
                                                   completion(user, nil);
                                               }
                                           }
                                           
                                       } onFault:^(NSError *error) {
                                           //再次获取
                                           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                               [weakSelf getMLDUserNeedRetry:NO completion:completion];
                                           });
                                       } onUploadProgress:nil];
}

#pragma mark - game

- (void)joinGameWithCurrentUserID:(NSString *)uid
                       roomNumber:(NSString *)roomNumber
                       completion:(void (^)(NSString *, NSArray *users))completion
{
    NSString *urlString = [NSString stringWithFormat:@"%@:%@/game/joinRoom", MLD_Host, MLD_Port];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (uid)
    {
        [params addEntriesFromDictionary:@{@"id" : uid}];
    }
    if (roomNumber)
    {
        [params addEntriesFromDictionary:@{@"roomId" : roomNumber}];
    }
    [MOBFHttpService sendHttpRequestByURLString:urlString
                                         method:@"POST"
                                     parameters:params
                                        headers:nil
                                       onResult:^(NSHTTPURLResponse *response, NSData *responseData) {
                                           NSDictionary *responseDict = [MOBFJson objectFromJSONData:responseData];
                                           if (responseDict[@"success"])
                                           {
                                               NSDictionary *resDict = responseDict[@"res"];
                                               NSLog(@"%@",resDict);
                                               
                                               NSArray *userArray = resDict[@"user"];
                                               
                                               NSMutableArray *users = [NSMutableArray array];
                                               
                                               for (NSDictionary *userDict in userArray)
                                               {
                                                   MLDUser *user = [[MLDUser alloc] init];
                                                   user.uid = userDict[@"id"];
                                                   user.avatar = userDict[@"avatar"];
                                                   user.nickName = userDict[@"nickname"];
                                                   
                                                   [users addObject:user];
                                               }
                                               
                                               NSString *roomId = resDict[@"roomId"];
                                               
                                               if (completion)
                                               {
                                                   completion(roomId, users);
                                               }
                                           }
                                           else
                                           {
                                               if (completion)
                                               {
                                                   completion(nil, nil);
                                               }
                                           }
                                           
                                       } onFault:^(NSError *error) {
                                           if (completion)
                                           {
                                               completion(nil, nil);
                                           }
                                       } onUploadProgress:nil];
}

- (void)exitGameWithCurrentUserID:(NSString *)uid completion:(void (^)(BOOL))completion
{
    NSString *urlString = [NSString stringWithFormat:@"%@:%@/game/exit", MLD_Host, MLD_Port];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (uid)
    {
        [params addEntriesFromDictionary:@{@"id" : uid}];
    }
    [MOBFHttpService sendHttpRequestByURLString:urlString
                                         method:@"POST"
                                     parameters:params
                                        headers:nil
                                       onResult:^(NSHTTPURLResponse *response, NSData *responseData) {
                                           NSDictionary *responseDict = [MOBFJson objectFromJSONData:responseData];
                                           if (responseDict[@"success"])
                                           {
                                               if (completion)
                                               {
                                                   completion(YES);
                                               }
                                           }
                                           else
                                           {
                                               if (completion)
                                               {
                                                   completion(NO);
                                               }
                                           }
                                           
                                       } onFault:^(NSError *error) {
                                           if (completion)
                                           {
                                               completion(NO);
                                           }
                                       } onUploadProgress:nil];
}

- (void)gameHeartbeatWithCurrentUserID:(NSString *)uid
                            roomNumber:(NSString *)roomNumber
                              complete:(void (^)(NSArray *users, NSString *roomNumber, NSError *error))completion
{
    if (!roomNumber)
    {
        if (completion)
        {
            NSError *error = [NSError errorWithDomain:@"MLDError" code:0 userInfo:@{@"error" : @"roomId 不能为空"}];
            completion(nil, nil, error);
        }
        return;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@:%@/game/read", MLD_Host, MLD_Port];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (uid)
    {
        [params addEntriesFromDictionary:@{@"id" : uid}];
    }
    if (roomNumber)
    {
        [params addEntriesFromDictionary:@{@"roomId" : roomNumber}];
    }
    [MOBFHttpService sendHttpRequestByURLString:urlString
                                         method:@"POST"
                                     parameters:params
                                        headers:nil
                                       onResult:^(NSHTTPURLResponse *response, NSData *responseData) {
                                           NSDictionary *responseDict = [MOBFJson objectFromJSONData:responseData];
                                           if (responseDict[@"success"])
                                           {
                                               NSArray *friendsArray = responseDict[@"res"][@"user"];
                                               
                                               NSLog(@"%@",friendsArray);
                                               
                                               NSMutableArray *users = [NSMutableArray array];
                                               for (NSDictionary *userDict in friendsArray)
                                               {
                                                   MLDUser *user = [[MLDUser alloc] init];
                                                   user.uid = userDict[@"id"];
                                                   user.avatar = userDict[@"avatar"];
                                                   user.nickName = userDict[@"nickname"];
                                                   user.seat = [userDict[@"seat"] integerValue];
                                                   [users addObject:user];
                                               }
                                               
                                               if (completion)
                                               {
                                                   completion(users, responseDict[@"res"][@"roomId"], nil);
                                               }
                                           }
                                           
                                       } onFault:^(NSError *error) {
                                           if (completion)
                                           {
                                               completion(nil, roomNumber, error);
                                           }
                                       } onUploadProgress:nil];
}

#pragma mark - promote

- (void)addMoneyPushUserWithCurrentUserID:(NSString *)uid
                             sourceUserID:(NSString *)sourceUid
                                  channel:(MLDChannelType)channel
                                     type:(MLDAnalyType)type
                               completion:(void (^)(BOOL))completion
{
    NSString *urlString = [NSString stringWithFormat:@"%@:%@/push/addMoneyPush", MLD_Host, MLD_Port];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (uid)
    {
        [params addEntriesFromDictionary:@{@"id" : uid}];
    }
    if (sourceUid)
    {
        [params addEntriesFromDictionary:@{@"sourceId" : sourceUid}];
    }
    [params addEntriesFromDictionary:@{@"channel" : @(channel)}];
    [params addEntriesFromDictionary:@{@"type" : @(type)}];
    
    [MOBFHttpService sendHttpRequestByURLString:urlString
                                         method:@"POST"
                                     parameters:params
                                        headers:nil
                                       onResult:^(NSHTTPURLResponse *response, NSData *responseData) {
                                           NSDictionary *responseDict = [MOBFJson objectFromJSONData:responseData];
                                           if (responseDict[@"success"])
                                           {
                                               if (completion)
                                               {
                                                   completion(YES);
                                               }
                                           }
                                           else
                                           {
                                               if (completion)
                                               {
                                                   completion(NO);
                                               }
                                           }
                                           
                                       } onFault:^(NSError *error) {
                                           if (completion)
                                           {
                                               completion(NO);
                                           }
                                       } onUploadProgress:nil];
}

- (void)queryEarningsWithCurrentUid:(NSString *)uid completion:(void (^)(MLDEarnings *, NSError *))completion
{
    NSString *urlString = [NSString stringWithFormat:@"%@:%@/push/query", MLD_Host, MLD_Port];
    NSDictionary *params = nil;
    if (uid)
    {
        params = @{@"id" : uid};
    }
    [MOBFHttpService sendHttpRequestByURLString:urlString
                                         method:@"POST"
                                     parameters:params
                                        headers:nil
                                       onResult:^(NSHTTPURLResponse *response, NSData *responseData) {
                                           NSDictionary *responseDict = [MOBFJson objectFromJSONData:responseData];
                                           if (responseDict[@"success"])
                                           {
                                               NSDictionary *earningsDict = responseDict[@"res"];
                                               
                                               NSLog(@"%@",earningsDict);
                                               
                                               MLDEarnings *earnings = [[MLDEarnings alloc] init];
                                               
                                               earnings.earningsCount = [earningsDict[@"getMoney"] integerValue];
                                               earnings.promoteCount = [earningsDict[@"num"] integerValue];
                                               
                                               if (completion)
                                               {
                                                   completion(earnings, nil);
                                               }
                                           }
                                           
                                       } onFault:^(NSError *error) {
                                           if (completion)
                                           {
                                               completion(nil, error);
                                           }
                                       } onUploadProgress:nil];
}

#pragma mark - friend

- (void)queryFriendsWithCurrentUid:(NSString *)uid
                          complete:(void (^)(NSArray *friends, NSError *error))completion
{
    NSString *urlString = [NSString stringWithFormat:@"%@:%@/friend/query", MLD_Host, MLD_Port];
    NSDictionary *params = nil;
    if (uid)
    {
        params = @{@"id" : uid};
    }
    [MOBFHttpService sendHttpRequestByURLString:urlString
                                         method:@"POST"
                                     parameters:params
                                        headers:nil
                                       onResult:^(NSHTTPURLResponse *response, NSData *responseData) {
                                           NSDictionary *responseDict = [MOBFJson objectFromJSONData:responseData];
                                           if (responseDict[@"success"])
                                           {
                                               NSArray *friendsArray = responseDict[@"res"][@"user"];
                                               
                                               NSLog(@"%@",friendsArray);
                                               
                                               NSMutableArray *users = [NSMutableArray array];
                                               for (NSDictionary *userDict in friendsArray)
                                               {
                                                   MLDUser *user = [[MLDUser alloc] init];
                                                   user.uid = userDict[@"id"];
                                                   user.avatar = userDict[@"avatar"];
                                                   user.nickName = userDict[@"nickname"];
                                                   [users addObject:user];
                                               }
                                               
                                               if (completion)
                                               {
                                                   completion(users, nil);
                                               }
                                           }
                                           
                                       } onFault:^(NSError *error) {
                                           if (completion)
                                           {
                                               completion(nil, error);
                                           }
                                       } onUploadProgress:nil];
}

- (void)addFriendWithCurrentUserID:(NSString *)uid
                       otherUserID:(NSString *)otherUid
                           channel:(MLDChannelType)channel
                        completion:(void (^)(MLDUser *user, NSError *error))completion
{
    NSString *urlString = [NSString stringWithFormat:@"%@:%@/friend/add", MLD_Host, MLD_Port];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (uid)
    {
        [params addEntriesFromDictionary:@{@"id" : uid}];
    }
    if (otherUid)
    {
        [params addEntriesFromDictionary:@{@"addId" : otherUid}];
    }
    [params addEntriesFromDictionary:@{@"channel" : @(channel)}];
    
    [MOBFHttpService sendHttpRequestByURLString:urlString
                                         method:@"POST"
                                     parameters:params
                                        headers:nil
                                       onResult:^(NSHTTPURLResponse *response, NSData *responseData) {
                                           NSDictionary *responseDict = [MOBFJson objectFromJSONData:responseData];
                                           if (responseDict[@"success"])
                                           {
                                               NSDictionary *userDict = responseDict[@"res"];
                                               
                                               NSLog(@"%@",userDict);
                                               
                                               MLDUser *user = [[MLDUser alloc] init];
                                               user.uid = userDict[@"id"];
                                               user.avatar = userDict[@"avatar"];
                                               user.nickName = userDict[@"nickname"];
                                               
                                               if (completion)
                                               {
                                                   completion(user, nil);
                                               }
                                           }
                                           
                                       } onFault:^(NSError *error) {
                                           if (completion)
                                           {
                                               completion(nil, error);
                                           }
                                       } onUploadProgress:nil];
}

- (void)deleteFriendWithCurrentUserID:(NSString *)uid
                          otherUserID:(NSString *)otherUid
                           completion:(void (^)(MLDUser *user, NSError *error))completion
{
    NSString *urlString = [NSString stringWithFormat:@"%@:%@/friend/del", MLD_Host, MLD_Port];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (uid)
    {
        [params addEntriesFromDictionary:@{@"id" : uid}];
    }
    if (otherUid)
    {
        [params addEntriesFromDictionary:@{@"addId" : otherUid}];
    }
    [MOBFHttpService sendHttpRequestByURLString:urlString
                                         method:@"POST"
                                     parameters:params
                                        headers:nil
                                       onResult:^(NSHTTPURLResponse *response, NSData *responseData) {
                                           NSDictionary *responseDict = [MOBFJson objectFromJSONData:responseData];
                                           if (responseDict[@"success"])
                                           {
                                               NSDictionary *userDict = responseDict[@"res"];
                                               
                                               NSLog(@"%@",userDict);
                                               
                                               MLDUser *user = [[MLDUser alloc] init];
                                               user.uid = userDict[@"id"];
                                               user.avatar = userDict[@"avatar"];
                                               user.nickName = userDict[@"nickname"];
                                               
                                               if (completion)
                                               {
                                                   completion(user, nil);
                                               }
                                           }
                                           
                                       } onFault:^(NSError *error) {
                                           if (completion)
                                           {
                                               completion(nil, error);
                                           }
                                       } onUploadProgress:nil];
}

- (void)queryUserInfoWithUserID:(NSString *)uid completion:(void (^)(MLDUser *user, NSError *error))completion
{
    NSString *urlString = [NSString stringWithFormat:@"%@:%@/user/info", MLD_Host, MLD_Port];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (uid)
    {
        [params addEntriesFromDictionary:@{@"id" : uid}];
    }
    [MOBFHttpService sendHttpRequestByURLString:urlString
                                         method:@"POST"
                                     parameters:params
                                        headers:nil
                                       onResult:^(NSHTTPURLResponse *response, NSData *responseData) {
                                           NSDictionary *responseDict = [MOBFJson objectFromJSONData:responseData];
                                           if (responseDict[@"success"])
                                           {
                                               NSDictionary *userDict = responseDict[@"res"];
                                               
                                               NSLog(@"%@",userDict);
                                               
                                               MLDUser *user = [[MLDUser alloc] init];
                                               user.uid = userDict[@"id"];
                                               user.avatar = userDict[@"avatar"];
                                               user.nickName = userDict[@"nickname"];
                                               
                                               if (completion)
                                               {
                                                   completion(user, nil);
                                               }
                                           }
                                           
                                       } onFault:^(NSError *error) {
                                           if (completion)
                                           {
                                               completion(nil, error);
                                           }
                                       } onUploadProgress:nil];
}

#pragma mark - record

- (void)getRecordWithCurrentUserID:(NSString *)uid
                       promoteType:(MLDAnalyType)promoteType
                        completion:(void (^)(NSArray *, NSError *))completion
{
    NSString *urlString = [NSString stringWithFormat:@"%@:%@/record", MLD_Host, MLD_Port];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (uid)
    {
        [params addEntriesFromDictionary:@{@"id" : uid}];
    }
    [params addEntriesFromDictionary:@{@"type" : @(promoteType)}];
    [MOBFHttpService sendHttpRequestByURLString:urlString
                                         method:@"POST"
                                     parameters:params
                                        headers:nil
                                       onResult:^(NSHTTPURLResponse *response, NSData *responseData) {
                                           NSDictionary *responseDict = [MOBFJson objectFromJSONData:responseData];
                                           if (responseDict[@"success"])
                                           {
                                               NSArray *recordsArray = responseDict[@"res"][@"data"];
                                               
                                               NSLog(@"%@",recordsArray);
                                               
                                               if (completion)
                                               {
                                                   completion(recordsArray, nil);
                                               }
                                           }
                                           
                                       } onFault:^(NSError *error) {
                                           if (completion)
                                           {
                                               completion(nil, error);
                                           }
                                       } onUploadProgress:nil];
}

- (void)sendSceneLogWithCurrentUserID:(NSString *)uid
                          otherUserID:(NSString *)otherUid
                           sourceType:(MLDSceneType)type
                           completion:(void (^)(BOOL))completion
{
    NSString *urlString = [NSString stringWithFormat:@"%@:%@/scene/log", MLD_Host, MLD_Port];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (uid)
    {
        [params addEntriesFromDictionary:@{@"id" : uid}];
    }
    if (otherUid)
    {
        [params addEntriesFromDictionary:@{@"sourceId" : otherUid}];
    }
    [params addEntriesFromDictionary:@{@"scene" : @(type)}];
    [MOBFHttpService sendHttpRequestByURLString:urlString
                                         method:@"POST"
                                     parameters:params
                                        headers:nil
                                       onResult:^(NSHTTPURLResponse *response, NSData *responseData) {
                                           NSDictionary *responseDict = [MOBFJson objectFromJSONData:responseData];
                                           if (responseDict[@"success"])
                                           {
                                               if (completion)
                                               {
                                                   completion(YES);
                                               }
                                           }
                                           else
                                           {
                                               if (completion)
                                               {
                                                   completion(NO);
                                               }
                                           }
                                           
                                       } onFault:^(NSError *error) {
                                           if (completion)
                                           {
                                               completion(NO);
                                           }
                                       } onUploadProgress:nil];
}

@end
