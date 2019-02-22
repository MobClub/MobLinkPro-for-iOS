//
//  MLDFriendsListTableViewCell.h
//  MobLinkProDemo
//
//  Created by lujh on 2018/12/12.
//  Copyright © 2018 mob. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IMLDDeleteFriendDelegate <NSObject>

- (void)deleteFriendWithOtherUid:(NSString *)uid;

@end

@class MLDUser;
NS_ASSUME_NONNULL_BEGIN

@interface MLDFriendsListTableViewCell : UITableViewCell

@property (nonatomic, weak) id <IMLDDeleteFriendDelegate>delegate;
@property (strong, nonatomic) MLDUser *user;

@end

NS_ASSUME_NONNULL_END
