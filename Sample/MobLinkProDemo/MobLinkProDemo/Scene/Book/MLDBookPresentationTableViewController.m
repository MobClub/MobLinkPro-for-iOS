//
//  MLDBookPresentationTableViewController.m
//  MobLinkProDemo
//
//  Created by lujh on 2018/12/19.
//  Copyright © 2018 mob. All rights reserved.
//

#import "MLDBookPresentationTableViewController.h"

#import "MLDReadTableViewCell.h"

#import "MLDMarkModel.h"

#import "MLDChapterModel.h"

@interface MLDBookPresentationTableViewController ()

@property (nonatomic, strong) NSMutableArray *chapterArray;
@property (nonatomic, strong) NSMutableArray *willLoadArray;

@property (nonatomic, strong) NSMutableArray *chapterModelArray;

@property (nonatomic, assign) CGFloat cellHeight;

@end

@implementation MLDBookPresentationTableViewController

static NSString * const readTableCellReuseIdentifier = @"MLDReadTableViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cellHeight = SCREEN_HEIGHT - MOBLINK_StatusBarSafeBottomMargin - MOBLINK_TabbarSafeBottomMargin;
    
    self.willLoadArray = [[NSMutableArray alloc] init];
    
    [self.tableView registerClass:[MLDReadTableViewCell class] forCellReuseIdentifier:readTableCellReuseIdentifier];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    
    NSIndexPath *selectIndexPath = [NSIndexPath indexPathForRow:self.markModel.page inSection:0];
    
    if (self.chapterArray.count > 0)
    {
        [self.tableView scrollToRowAtIndexPath:selectIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

- (void)setMarkModel:(MLDMarkModel *)markModel
{
    _markModel = markModel;
    if (_markModel.chapterModel.chapterID)
    {
        [self.chapterArray addObject:_markModel.chapterModel.chapterID];
    }
    if (_markModel.chapterModel)
    {
        [self.chapterModelArray addObject:_markModel.chapterModel];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.chapterArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MLDChapterModel *chapterModel = self.chapterModelArray[indexPath.section];
    
    if (indexPath.row == chapterModel.pageCount - 1)
    {
        return chapterModel.lastPageHeight;
    }
    return self.cellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    MLDChapterModel *chapterModel = self.chapterModelArray[section];
    
    if (chapterModel.pageCount > 0)
    {
        return chapterModel.pageCount;
    }
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MLDReadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:readTableCellReuseIdentifier forIndexPath:indexPath];
    
    MLDChapterModel *chapterModel = self.chapterModelArray[indexPath.section];
    
    cell.content = [chapterModel getContentWithPage:indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(nonnull UIView *)view forSection:(NSInteger)section
{
    //预加载上下章节
    MLDChapterModel *currentChapterModel = [MLDChapterModel chapterModelWithBookID:self.markModel.bookID chapterID:self.chapterArray[section]];
    NSString *lastChapterId = currentChapterModel.lastChapterID;
    NSString *nextChapterId = currentChapterModel.nextChapterID;
    
    if (lastChapterId&& ![self.willLoadArray containsObject:lastChapterId])
    {
        
        [self.willLoadArray addObject:lastChapterId];
        
        if (![self.chapterArray containsObject:lastChapterId])
        {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                MLDChapterModel *lastChapterModel = [MLDChapterModel chapterModelWithBookID:self.markModel.bookID chapterID:lastChapterId];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (lastChapterModel)
                    {
                        [self.chapterArray insertObject:lastChapterId atIndex:0];
                        [self.chapterModelArray insertObject:lastChapterModel atIndex:0];
                        
                        [self.tableView reloadData];
                        
                        CGFloat cellHeight = self.cellHeight * lastChapterModel.pageCount;
                        
                        [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y + cellHeight)];
                    }
                });
            });
        }
    }
    
    if (nextChapterId && ![self.willLoadArray containsObject:nextChapterId])
    {
        [self.willLoadArray addObject:nextChapterId];
        
        if (![self.chapterArray containsObject:nextChapterId])
        {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                MLDChapterModel *nextChapterModel = [MLDChapterModel chapterModelWithBookID:self.markModel.bookID chapterID:nextChapterId];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (nextChapterModel.chapterID)
                    {
                        [self.chapterArray addObject:nextChapterModel.chapterID];
                        
                        [self.chapterModelArray addObject:nextChapterModel];
                        
                        [self.tableView reloadData];
                    }
                });
            });
        }
    }
}

- (NSMutableArray *)chapterArray
{
    if (!_chapterArray)
    {
        _chapterArray = [[NSMutableArray alloc] init];
    }
    return _chapterArray;
}

- (NSMutableArray *)chapterModelArray
{
    if (!_chapterModelArray)
    {
        _chapterModelArray = [[NSMutableArray alloc] init];
    }
    return _chapterModelArray;
}

- (void)dealloc
{
    self.chapterModelArray = nil;
    self.chapterArray = nil;
    self.willLoadArray = nil;
}

@end
