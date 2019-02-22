//
//  MLDBookModel.h
//  MobLinkProDemo
//
//  Created by lujh on 2018/12/14.
//  Copyright © 2018 mob. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MLDChapterListModel;
@class MLDMarkModel;

NS_ASSUME_NONNULL_BEGIN

@interface MLDBookModel : NSObject

/**
 书籍id
 */
@property (nonatomic, copy) NSString *bookID;

/**
 书名
 */
@property (nonatomic, copy) NSString *bookName;

/**
 章节列表
 */
@property (nonatomic, strong) NSArray<MLDChapterListModel *> *chapterList;

/**
 书签或阅读记录列表
 */
@property (nonatomic, strong) NSArray<MLDMarkModel *> *readMarkList;

/**
 阅读记录模型
 */
@property (nonatomic, strong) MLDMarkModel *readMarkModel;

- (void)modifyMarkModelWithChapterID:(NSString *)chapterID page:(NSInteger)page;

@end

NS_ASSUME_NONNULL_END
