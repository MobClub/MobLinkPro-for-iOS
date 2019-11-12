//
//  MLDBookPresentationTableViewController.h
//  MobLinkProDemo
//
//  Created by lujh on 2018/12/19.
//  Copyright © 2018 mob. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MLDMarkModel;
@class MLDBookViewController;
NS_ASSUME_NONNULL_BEGIN

@interface MLDBookPresentationTableViewController : UITableViewController

@property (nonatomic, strong) MLDMarkModel *markModel;

@property (nonatomic, strong) MLDBookViewController *readController;

@end

NS_ASSUME_NONNULL_END
