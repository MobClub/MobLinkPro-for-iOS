//
//  MLDMarkModel.m
//  MobLinkProDemo
//
//  Created by lujh on 2018/12/14.
//  Copyright © 2018 mob. All rights reserved.
//

#import "MLDMarkModel.h"

#import "Archive.h"
#import "NSObject+Archive.h"

#import "MLDChapterModel.h"

@implementation MLDMarkModel

ArchiveImplementation

- (void)modifyWithChapterID:(NSString *)chapterID page:(NSInteger)page
{
    //检查是否有指定章节
    NSString *cachePath = [NSString stringWithFormat:@"%@/%@/%@",[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject], self.bookID, chapterID];
    
    self.chapterModel = [NSKeyedUnarchiver unarchiveObjectWithFile:cachePath];
    
    self.page = page;
    
    if (self.chapterModel)
    {
        self.chapterID = self.chapterModel.chapterID;
        self.chapterName = self.chapterModel.chapterName;
    }
    else
    {
        MLDChapterModel *chapterModel = [[MLDChapterModel alloc] init];
        chapterModel.chapterID = chapterID;
        chapterModel.bookID = self.bookID;
        
        self.chapterModel = chapterModel;
        self.chapterID = chapterID;
    }
}

@end
