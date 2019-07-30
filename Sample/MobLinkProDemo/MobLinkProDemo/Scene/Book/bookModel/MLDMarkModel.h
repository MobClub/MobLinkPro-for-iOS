//
//  MLDMarkModel.h
//  MobLinkProDemo
//
//  Created by lujh on 2018/12/14.
//  Copyright © 2018 mob. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MLDChapterModel;
NS_ASSUME_NONNULL_BEGIN

@interface MLDMarkModel : NSObject

@property (nonatomic, copy) NSString *bookID;

@property (nonatomic, copy) NSString *chapterID;

@property (nonatomic, copy) NSString *chapterName;

@property (nonatomic, strong) MLDChapterModel *chapterModel;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, assign) float readPercent;

- (void)modifyWithChapterID:(NSString *)chapterID page:(NSInteger)page;

@end

NS_ASSUME_NONNULL_END
