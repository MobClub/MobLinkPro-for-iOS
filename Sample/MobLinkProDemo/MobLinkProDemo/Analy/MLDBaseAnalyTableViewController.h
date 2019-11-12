//
//  MLDBaseAnalyTableViewController.h
//  MobLinkProDemo
//
//  Created by lujh on 2019/1/16.
//  Copyright © 2019 mob. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MLDNetworkManager.h"
#import "MLDUserManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface MLDBaseAnalyTableViewController : UITableViewController

@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) NSArray *dictKey;
@property (strong, nonatomic) NSArray *headerArray;

@end

NS_ASSUME_NONNULL_END
