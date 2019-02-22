//
//  MLDSceneCollectionViewController.m
//  MobLinkProDemo
//
//  Created by lujh on 2018/12/11.
//  Copyright © 2018 mob. All rights reserved.
//

#import "MLDSceneCollectionViewController.h"

#import "MLDNewsTableViewController.h"

#import "MLDBookshelfTableViewController.h"

#import "MLDGameViewController.h"

@interface MLDSceneCollectionViewController ()

@end

@implementation MLDSceneCollectionViewController

@synthesize dataArray = _dataArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.item)
    {
        case 0:
        {
            MLDNewsTableViewController *newsCtr = [[MLDNewsTableViewController alloc] initWithStyle:UITableViewStylePlain];
            newsCtr.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:newsCtr animated:YES];
            break;
        }
        case 1:
        {
            MLDBookshelfTableViewController *bookCtr = [[MLDBookshelfTableViewController alloc] init];
            bookCtr.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:bookCtr animated:YES];
            break;
        }
        case 2:
        {
            MLDGameViewController *gameCtr = [[MLDGameViewController alloc] init];
            gameCtr.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:gameCtr animated:YES];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - 懒加载

- (NSArray *)dataArray
{
    if (!_dataArray)
    {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"SceneList" ofType:@"plist"];
        _dataArray = [NSArray arrayWithContentsOfFile:filePath];
    }
    return _dataArray;
}

@end
