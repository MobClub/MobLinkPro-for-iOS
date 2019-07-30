//
//  MLDBookViewController.h
//  MobLinkProDemo
//
//  Created by lujh on 2018/12/11.
//  Copyright © 2018 mob. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MobLinkPro/MLSDKScene.h>

NS_ASSUME_NONNULL_BEGIN

@interface MLDBookViewController : UIViewController

@property (nonatomic, strong) NSDictionary *novelDict;

- (instancetype)initWithMobLinkScene:(MLSDKScene *)scene;

@end

NS_ASSUME_NONNULL_END
