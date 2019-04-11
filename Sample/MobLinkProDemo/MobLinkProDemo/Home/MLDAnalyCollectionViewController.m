//
//  MLDAnalyCollectionViewController.m
//  MobLinkProDemo
//
//  Created by lujh on 2018/12/11.
//  Copyright © 2018 mob. All rights reserved.
//

#import "MLDAnalyCollectionViewController.h"

#import "MLDPromoterAnalyTableViewController.h"
#import "MLDSceneAnalyTableViewController.h"
#import "MLDShareAnalyTableViewController.h"

@interface MLDAnalyCollectionViewController ()

@end

@implementation MLDAnalyCollectionViewController

@synthesize dataArray = _dataArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (NSArray *)dataArray
{
    if (!_dataArray)
    {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"AnalyList" ofType:@"plist"];
        _dataArray = [NSArray arrayWithContentsOfFile:filePath];
    }
    return _dataArray;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MLDBaseAnalyTableViewController *analyTableViewController = nil;
    switch (indexPath.item)
    {
        case 0:
        {
            // 地推效果统计
            analyTableViewController = [[MLDPromoterAnalyTableViewController alloc] init];
            break;
        }
        case 1:
        {
            // 社交分享效果统计
            analyTableViewController = [[MLDShareAnalyTableViewController alloc] init];
            
            break;
        }
        case 2:
        {
            // 场景还原统计
            analyTableViewController = [[MLDSceneAnalyTableViewController alloc] init];
            break;
        }
            
        default:
            break;
    }
    if (analyTableViewController)
    {
        [self.navigationController pushViewController:analyTableViewController animated:YES];
    }
}

@end
