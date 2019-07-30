//
//  MLDChapterModel.h
//  MobLinkProDemo
//
//  Created by lujh on 2018/12/14.
//  Copyright © 2018 mob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLDChapterModel : NSObject

@property (nonatomic, copy) NSString *bookID;

@property (nonatomic, copy) NSString *chapterID;

@property (nonatomic, copy) NSString *chapterName;

@property (nonatomic, copy) NSString *lastChapterID;

@property (nonatomic, copy) NSString *nextChapterID;

@property (nonatomic, copy) NSString *chapterNumString;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *fullChapterName;

@property (nonatomic, copy) NSString *fullContent;

@property (nonatomic, assign) NSInteger pageCount;

@property (nonatomic, strong) NSArray *rangeArray;

@property (nonatomic, assign) float lastPageHeight;

- (void)updateFont;

- (NSMutableAttributedString *)getContentWithPage:(NSInteger)page;

+ (MLDChapterModel *)chapterModelWithBookID:(NSString *)bookID chapterID:(NSString *)chapterID;

@end
