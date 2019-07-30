//
//  MLDPersonalTableViewController.h
//  MobLinkProDemo
//
//  Created by lujh on 2018/12/11.
//  Copyright © 2018 mob. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MLDPersonalModel;

NS_ASSUME_NONNULL_BEGIN

@interface MLDPersonalTableViewController : UITableViewController

@property (strong, nonatomic) MLDPersonalModel *person;

@end

NS_ASSUME_NONNULL_END
