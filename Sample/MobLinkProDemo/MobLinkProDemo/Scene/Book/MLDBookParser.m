//
//  MLDBookParser.m
//  MobLinkProDemo
//
//  Created by lujh on 2018/12/14.
//  Copyright © 2018 mob. All rights reserved.
//

#import "MLDBookParser.h"

#import "MLDBookModel.h"

#import "MLDMarkModel.h"

#import "MLDChapterListModel.h"

#import "MLDChapterModel.h"

#import <UIKit/UIKit.h>

/// 段落头部双圆角空格
static NSString * MLDParagraphHeaderSpace = @"　　";

@implementation MLDBookParser

+ (MLDBookModel *)parserBookWithLocalPath:(NSString *)path
{
    //书籍id
    NSString *bookID = [path.lastPathComponent stringByDeletingPathExtension];
    
    //如果缓存中有bookid 则直接取用
    NSString *cachePath = [NSString stringWithFormat:@"%@/%@/%@",[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject], bookID, bookID];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:cachePath])
    {
        // 读取模型
        MLDBookModel *bookModel = [[MLDBookModel alloc] init];
        bookModel.bookID = bookID;
        
        MLDMarkModel *markModel = [[MLDMarkModel alloc] init];
        markModel.bookID = bookID;
        
        bookModel.readMarkModel = markModel;
        
        // 解析数据
        NSString *content = [self encodeContentWithFile:path];
        
        // 获取章节列表
        bookModel.chapterList = [self parserContentWithBookID:bookID content:content];
        
        //设置阅读记录
        // 检查是否有返回的记录，没有则第一章为记录
        [bookModel modifyMarkModelWithChapterID:bookModel.chapterList.firstObject.chapterID page:0];
        
        //保存
        [self saveBookModel:bookModel];
        
        return bookModel;
    }
    else
    {
        return [NSKeyedUnarchiver unarchiveObjectWithFile:cachePath];
    }
}

+ (NSString *)encodeContentWithFile:(NSString *)path
{
    NSString *content = nil;
    
    //检查是否有值
    
    content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    if (!content)
    {
        content = [NSString stringWithContentsOfFile:path encoding:0x80000632 error:nil];
    }
    
    if (!content)
    {
        content = [NSString stringWithContentsOfFile:path encoding:0x80000631 error:nil];
    }
    
    if (!content)
    {
        content = @"";
    }
    
    return content;
}

+ (NSArray<MLDChapterListModel *> *)parserContentWithBookID:(NSString *)bookID content:(NSString *)content
{
    
    NSMutableArray *readChapterListModels = [NSMutableArray array];
    NSString *pattern = @"第[0-9一二三四五六七八九十百千]*[章回].*";
    content = [self convertContent:content];
    
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *results = [regularExpression matchesInString:content options:NSMatchingReportCompletion range:NSMakeRange(0, content.length)];
    
    if (results && results.count > 0)
    {
        NSRange lastRange = NSMakeRange(0, 0);
        
        NSUInteger count = results.count;
        
        MLDChapterModel *lastChapterModel = nil;
        
        BOOL isPreface = YES;
        
        for (int i = 0; i <= count; i++)
        {
            NSRange range = NSMakeRange(0, 0);
            
            NSInteger location = 0;
            
            if (i < count)
            {
                range = [results[i] range];
                
                location = range.location;
            }
            
            MLDChapterModel *readChapterModel = [[MLDChapterModel alloc] init];
            
            readChapterModel.bookID = bookID;
            
            readChapterModel.chapterID = [NSString stringWithFormat:@"%d",i];
            
            if (i == 0)
            {
                // 开头
                readChapterModel.chapterName = @"前言";

                readChapterModel.content = [content substringWithRange:NSMakeRange(0, location)];

                lastRange = range;

                if (!(readChapterModel.content && readChapterModel.content.length > 0))
                {
                    isPreface = NO;
                    continue;
                }
            }
            else if (i == count)
            {
                // 结尾
                readChapterModel.chapterName = [content substringWithRange:lastRange];

                readChapterModel.content = [content substringWithRange:NSMakeRange(lastRange.location, content.length - lastRange.location)];
                
            }
            else
            {
                // 中间章节
                readChapterModel.chapterName = [content substringWithRange:lastRange];
                
                // 内容
                readChapterModel.content = [content substringWithRange:NSMakeRange(lastRange.location, location - lastRange.location)];
                
            }
            
            // 清空章节名，保留纯内容
            readChapterModel.content = [NSString stringWithFormat:@"%@%@", MLDParagraphHeaderSpace, [[readChapterModel.content stringByReplacingOccurrencesOfString:readChapterModel.chapterName withString:@""] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
            
            [readChapterModel updateFont];
            
            // 添加章节列表模型
            MLDChapterListModel *chapterListModel = [self getReadChapterListModel:readChapterModel];
            [readChapterListModels addObject:chapterListModel];
            
            //设置上下章ID
            readChapterModel.lastChapterID = lastChapterModel.chapterID;
            lastChapterModel.nextChapterID = readChapterModel.chapterID;
            
            //保存
            [self saveChapterModel:readChapterModel];
            [self saveChapterModel:lastChapterModel];
            
            //记录
            lastRange = range;
            lastChapterModel = readChapterModel;
        }
        
    }
    
    return readChapterListModels;
}

+ (void)saveBookModel:(MLDBookModel *)bookModel
{
    NSString *cachePath = [NSString stringWithFormat:@"%@/%@",[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject], bookModel.bookID];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:cachePath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    [NSKeyedArchiver archiveRootObject:bookModel toFile:[cachePath stringByAppendingPathComponent:bookModel.bookID]];
}

+ (void)saveChapterModel:(MLDChapterModel *)capterModel
{
    
    NSString *cachePath = [NSString stringWithFormat:@"%@/%@",[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject], capterModel.bookID];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:cachePath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    [NSKeyedArchiver archiveRootObject:capterModel toFile:[cachePath stringByAppendingPathComponent:capterModel.chapterID]];
}

+ (MLDChapterListModel *)getReadChapterListModel:(MLDChapterModel *)chapterModel
{
    MLDChapterListModel *chapterListModel = [[MLDChapterListModel alloc] init];
    
    chapterListModel.bookID = chapterModel.bookID;
    chapterListModel.chapterID = chapterModel.chapterID;
    chapterListModel.chapterName = chapterModel.chapterName;
    
    return chapterListModel;
}

+ (NSString *)convertContent:(NSString *)content
{
    
    content = [content stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    
    content = [self contentReplacingCharactersWithPattern:@"\\s*\\n+\\s*" template:[NSString stringWithFormat:@"\n%@", MLDParagraphHeaderSpace] content:content];
    
    return content;
}

+ (NSString *)contentReplacingCharactersWithPattern:(NSString *)pattern template:(NSString *)template content:(NSString *)content
{
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    
    return [regularExpression stringByReplacingMatchesInString:content options:NSMatchingReportProgress range:NSMakeRange(0, content.length) withTemplate:template];
}

+ (CTFrameRef)readFrameRef:(NSMutableAttributedString *)string rect:(CGRect)rect
{
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)string);
    
    CGPathRef path = CGPathCreateWithRect(rect, NULL);
    
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, nil);
    
    CFRelease(path);
    CFRelease(framesetter);
    
    return frameRef;
}

+ (NSDictionary *)parserPageRangeWithAttributeString:(NSAttributedString *)attrString rect:(CGRect)rect
{
    NSMutableArray *rangeArray = [NSMutableArray array];
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attrString);
    
    CGPathRef path = CGPathCreateWithRect(rect, NULL);
    
    CFRange range = CFRangeMake(0, 0);
    
    NSInteger rangeOffset = 0;
    
    do
    {
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(rangeOffset, 0), path, nil);
        
        range = CTFrameGetVisibleStringRange(frame);
        
        [rangeArray addObject:[NSValue valueWithRange:NSMakeRange(rangeOffset, range.length)]];
        
        rangeOffset += range.length;
        
        CFRelease(frame);
        
    } while (range.location + range.length < attrString.length);
    
    CGSize size = CGSizeMake(rect.size.width, 1000);
    
    CGSize lastPageSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, range, NULL, size, NULL);
    
    CFRelease(framesetter);
    CFRelease(path);
        
    return @{@"rangeArray" : rangeArray,
             @"lastPageSize" : [NSValue valueWithCGSize:lastPageSize]};
}



@end
