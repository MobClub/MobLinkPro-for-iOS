//
//  MLDBookParser.h
//  MobLinkProDemo
//
//  Created by lujh on 2018/12/14.
//  Copyright © 2018 mob. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreText/CoreText.h>

@class MLDBookModel;

NS_ASSUME_NONNULL_BEGIN

@interface MLDBookParser : NSObject

/**
 解析本地书籍

 @param url 本地url
 @return 书籍模型
 */
+ (MLDBookModel *)parserBookWithLocalPath:(NSURL *)url;

+ (CTFrameRef)readFrameRef:(NSMutableAttributedString *)string rect:(CGRect)rect;

+ (NSDictionary *)parserPageRangeWithAttributeString:(NSAttributedString *)attrString rect:(CGRect)rect;

@end

NS_ASSUME_NONNULL_END
