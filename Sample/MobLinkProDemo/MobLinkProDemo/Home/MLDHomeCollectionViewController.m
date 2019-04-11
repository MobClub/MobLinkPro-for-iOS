//
//  MLDHomeCollectionViewController.m
//  MobLinkProDemo
//
//  Created by lujh on 2018/12/10.
//  Copyright © 2018 mob. All rights reserved.
//

#import "MLDHomeCollectionViewController.h"

#import "MLDHomeCollectionViewCell.h"

#import "MLDSceneCollectionViewController.h"

#import "MLDInviteCollectionViewController.h"

#import "MLDAnalyCollectionViewController.h"

#import "MLDRelationshipViewController.h"

#import "MLDAwakenViewController.h"

#import <MobLinkPro/MobLink.h>

@interface MLDHomeCollectionViewController ()

@property (strong, nonatomic) NSArray *dataArray;

@end

@implementation MLDHomeCollectionViewController

static NSString * const homeReuseIdentifier = @"MLDHomeCollectionViewCell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"MLDHomeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:homeReuseIdentifier];
    
    self.collectionView.showsVerticalScrollIndicator = NO;
    
    [self createHeaderView];
    
    [self createVersionLabel];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    if (self = [super initWithCollectionViewLayout:layout])
    {
        UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)layout;
        
        flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH - 60) / 2.0, (SCREEN_WIDTH - 60) / 2.0);
        flowLayout.minimumLineSpacing = 20;
        flowLayout.minimumInteritemSpacing = 20;
        flowLayout.sectionInset = UIEdgeInsetsMake(84, 20, 60, 20);
    }
    return self;
}

- (void)createHeaderView
{
    CGRect origFrame = self.navigationController.navigationBar.frame;
    
    UILabel *headerView = [[UILabel alloc] init];
    headerView.frame = CGRectMake(origFrame.origin.x, origFrame.origin.y, origFrame.size.width, origFrame.size.height + 40.0);
    headerView.text = @"MobLink";
    headerView.textAlignment = NSTextAlignmentCenter;
    headerView.font = [UIFont fontWithName:@"AvenirNext-Bold" size:30];
    headerView.textColor = [UIColor colorWithRed:23/255.0 green:25/255.0 blue:34/255.0 alpha:1/1.0];
    
    [self.view addSubview:headerView];
}

- (void)createVersionLabel
{
    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, SCREEN_HEIGHT - MOBLINK_TabbarSafeBottomMargin - 90, SCREEN_WIDTH - 200, 20)];
    versionLabel.text = [NSString stringWithFormat:@"%@ 版本", [MobLink sdkVer]];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    versionLabel.textColor = [UIColor colorWithRed:157/255.0 green:164/255.0 blue:184/255.0 alpha:1/1.0];
    
    [self.view addSubview:versionLabel];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MLDHomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:homeReuseIdentifier forIndexPath:indexPath];
    
    if (indexPath.item < self.dataArray.count)
    {
        cell.dict = @{@"title" : self.dataArray[indexPath.item][@"title"],
                      @"image" : self.dataArray[indexPath.item][@"imageName"]};
    }
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *detailViewController = nil;
    
    switch (indexPath.item)
    {
        case 0:
        {
            // 一键拉起 打开分享页面
            detailViewController = [[MLDAwakenViewController alloc] init];
            break;
        }
        case 1:
        {
            // 场景还原
            UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
            detailViewController = [[MLDSceneCollectionViewController alloc] initWithCollectionViewLayout:flowLayout];
            break;
        }
        case 2:
        {
            // 无码邀请
            UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
            detailViewController = [[MLDInviteCollectionViewController alloc] initWithCollectionViewLayout:flowLayout];
            break;
        }
        case 3:
        {
            // 关系匹配
            detailViewController = [[MLDRelationshipViewController alloc] init];
            break;
        }
        case 4:
        {
            // 精准统计
            UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
            detailViewController = [[MLDAnalyCollectionViewController alloc] initWithCollectionViewLayout:flowLayout];
            break;
        }
        default:
            break;
    }
    if (detailViewController)
    {
        detailViewController.title = self.dataArray[indexPath.item][@"title"];
        detailViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
}

#pragma mark - 懒加载

- (NSArray *)dataArray
{
    if (!_dataArray)
    {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"HomeList" ofType:@"plist"];
        _dataArray = [NSArray arrayWithContentsOfFile:filePath];
    }
    return _dataArray;
}

@end
