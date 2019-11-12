//
//  MLDInviteCollectionViewController.m
//  MobLinkProDemo
//
//  Created by lujh on 2018/12/11.
//  Copyright © 2018 mob. All rights reserved.
//

#import "MLDInviteCollectionViewController.h"

#import "MLDPromoterTableViewController.h"

#import "MLDSharePromoteViewController.h"

@interface MLDInviteCollectionViewController ()

@end

@implementation MLDInviteCollectionViewController

@synthesize dataArray = _dataArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (NSArray *)dataArray
{
    if (!_dataArray)
    {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"InviteList" ofType:@"plist"];
        _dataArray = [NSArray arrayWithContentsOfFile:filePath];
    }
    return _dataArray;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.item)
    {
        case 0:
        {
            // 地推
            MLDPromoterTableViewController *proCtr = [[MLDPromoterTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            proCtr.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:proCtr animated:YES];
            break;
        }
        case 1:
        {
            // 社交分享推广
            MLDSharePromoteViewController *shareCtr = [[MLDSharePromoteViewController alloc] init];
            shareCtr.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:shareCtr animated:YES];
            break;
        }
            
        default:
            break;
    }
}


@end
