//
//  MLDReadOperation.m
//  MobLinkProDemo
//
//  Created by lujh on 2018/12/19.
//  Copyright © 2018 mob. All rights reserved.
//

#import "MLDReadOperation.h"

#import "MLDBookPresentationTableViewController.h"
#import "MLDBookViewController.h"

#import "MLDBookModel.h"

#import "MLDMarkModel.h"

@interface MLDReadOperation ()

@property (nonatomic, strong) MLDBookViewController *bookVC;

@end


@implementation MLDReadOperation

- (instancetype)initWithBookViewController:(MLDBookViewController *)bookVC
{
    self = [super init];
    if (self) {
        self.bookVC = bookVC;
    }
    return self;
}

- (MLDBookPresentationTableViewController *)presentationViewController:(MLDMarkModel *)markModel
{
    if (markModel)
    {
        MLDBookPresentationTableViewController *presentationController = [[MLDBookPresentationTableViewController alloc] init];
        presentationController.markModel = markModel;
        presentationController.readController = self.bookVC;
        return presentationController;
    }
    return nil;
}

@end
