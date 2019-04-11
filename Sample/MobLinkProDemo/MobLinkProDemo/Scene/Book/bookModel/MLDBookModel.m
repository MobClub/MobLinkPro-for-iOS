//
//  MLDBookModel.m
//  MobLinkProDemo
//
//  Created by lujh on 2018/12/14.
//  Copyright © 2018 mob. All rights reserved.
//

#import "MLDBookModel.h"

#import "Archive.h"
#import "NSObject+Archive.h"

#import "MLDMarkModel.h"

@implementation MLDBookModel

ArchiveImplementation


- (void)modifyMarkModelWithChapterID:(NSString *)chapterID page:(NSInteger)page
{
    [self.readMarkModel modifyWithChapterID:chapterID page:0];
}

@end
