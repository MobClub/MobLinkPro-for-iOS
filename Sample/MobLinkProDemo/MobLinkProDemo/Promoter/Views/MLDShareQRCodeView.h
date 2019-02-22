//
//  MLDShareQRCodeView.h
//  MobLinkProDemo
//
//  Created by lujh on 2018/12/12.
//  Copyright © 2018 mob. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MLDUser;
NS_ASSUME_NONNULL_BEGIN

@interface MLDShareQRCodeView : UIScrollView

@property (strong, nonatomic) MLDUser *user;

@end

NS_ASSUME_NONNULL_END
