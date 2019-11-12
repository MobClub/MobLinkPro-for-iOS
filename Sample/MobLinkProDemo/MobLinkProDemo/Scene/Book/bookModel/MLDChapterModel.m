//
//  MLDChapterModel.m
//  MobLinkProDemo
//
//  Created by lujh on 2018/12/14.
//  Copyright © 2018 mob. All rights reserved.
//

#import "MLDChapterModel.h"

#import "Archive.h"
#import "NSObject+Archive.h"

#import "MLDReadConfig.h"

#import "MLDBookParser.h"

#import <UIKit/UIKit.h>

@interface MLDChapterModel ()

@property (nonatomic, strong) NSDictionary *titleAttributes;

@property (nonatomic, strong) NSDictionary *publicAttributes;

@end

@implementation MLDChapterModel

ArchiveImplementation

- (void)updateFont
{
    self.titleAttributes = [[MLDReadConfig sharedInstance] readAttributeWithIsTitle:YES];
    
    self.publicAttributes = [[MLDReadConfig sharedInstance] readAttributeWithIsTitle:NO];
    
    NSDictionary *parserDict = [MLDBookParser parserPageRangeWithAttributeString:[self fullContentAttrString] rect:CGRectMake(0, 0, SCREEN_WIDTH - 30, SCREEN_HEIGHT - MOBLINK_StatusBarSafeBottomMargin - MOBLINK_TabbarSafeBottomMargin)];
    
    self.rangeArray = parserDict[@"rangeArray"];
    
    self.lastPageHeight = [parserDict[@"lastPageSize"] CGSizeValue].height + 50.f;
    
    self.pageCount = self.rangeArray.count;
}

- (NSMutableAttributedString *)fullContentAttrString
{
    self.titleAttributes = [[MLDReadConfig sharedInstance] readAttributeWithIsTitle:YES];
    
    self.publicAttributes = [[MLDReadConfig sharedInstance] readAttributeWithIsTitle:NO];
    
    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:self.fullChapterName attributes:self.titleAttributes];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:self.content attributes:self.publicAttributes];
    
    [titleString appendAttributedString:attrString];
    
    return titleString;
}

- (NSString *)fullChapterName
{
    return [NSString stringWithFormat:@"\n\%@\n\n", self.chapterName];
}

- (NSString *)fullContent
{
    return [NSString stringWithFormat:@"%@%@", self.fullChapterName, self.content];
}

- (NSMutableAttributedString *)getContentWithPage:(NSInteger)page
{
    NSString *content = [self.fullContent substringWithRange:[self.rangeArray[page] rangeValue]];
    
    NSMutableAttributedString * contentAttr = [[NSMutableAttributedString alloc] init];
    
    if (page == 0)
    {
        content = [content stringByReplacingOccurrencesOfString:self.fullChapterName withString:@""];
        
        NSDictionary *titleAttributes = [[MLDReadConfig sharedInstance] readAttributeWithIsTitle:YES];
        
        NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:self.fullChapterName attributes:titleAttributes];
        
        contentAttr = titleString;
    }
    
    NSDictionary *publicAttributes = [[MLDReadConfig sharedInstance] readAttributeWithIsTitle:NO];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:content attributes:publicAttributes];
    
    [contentAttr appendAttributedString:attrString];
    
    return contentAttr;
    
}

+ (MLDChapterModel *)chapterModelWithBookID:(NSString *)bookID chapterID:(NSString *)chapterID
{
    //检查是否有指定章节
    NSString *cachePath = [NSString stringWithFormat:@"%@/%@/%@",[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject], bookID, chapterID];
    
    MLDChapterModel *chapterModel = [NSKeyedUnarchiver unarchiveObjectWithFile:cachePath];
    
    return chapterModel;
}

@end
