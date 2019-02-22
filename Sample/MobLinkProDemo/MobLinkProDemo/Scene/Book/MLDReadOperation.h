//
//  MLDReadOperation.h
//  MobLinkProDemo
//
//  Created by lujh on 2018/12/19.
//  Copyright © 2018 mob. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MLDBookPresentationTableViewController;
@class MLDMarkModel;
@class MLDBookViewController;

NS_ASSUME_NONNULL_BEGIN

@interface MLDReadOperation : NSObject

- (instancetype)initWithBookViewController:(MLDBookViewController *)bookVC;

- (MLDBookPresentationTableViewController *)presentationViewController:(MLDMarkModel *)markModel;

@end

NS_ASSUME_NONNULL_END
