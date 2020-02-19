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

#import "MOBPolicyManager.h"
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
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    
    
    
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
        flowLayout.sectionInset = UIEdgeInsetsMake(30, 15, 0, 15);
        flowLayout.headerReferenceSize = CGSizeMake(0, kNavigationBarHeight);
        flowLayout.footerReferenceSize = CGSizeMake(0, 80);
    }
    return self;
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

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
        if ([headerView viewWithTag:100]) {
            return headerView;
        }
        UILabel *headerLabel = [[UILabel alloc] init];
        headerLabel.frame = CGRectMake(0,10 , SSDK_WIDTH, 30);
        headerLabel.text = @"MobLink";
        headerLabel.tag = 100;
        headerLabel.textAlignment = NSTextAlignmentCenter;
        headerLabel.font = [UIFont fontWithName:@"AvenirNext-Bold" size:30];
        headerLabel.textColor = [UIColor colorWithRed:23/255.0 green:25/255.0 blue:34/255.0 alpha:1/1.0];
        
        [headerView addSubview:headerLabel];
        return headerView;
    }else{
        UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"footer" forIndexPath:indexPath];
        if ([footer viewWithTag:100]) {
            return footer;
        }
        UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 20)];
        versionLabel.text = [NSString stringWithFormat:@"%@ 版本", [MobLink sdkVer]];
        versionLabel.textAlignment = NSTextAlignmentCenter;
        
        versionLabel.font = Font(PingFangReguler,   14);
        versionLabel.textColor = [UIColor colorWithRed:157/255.0 green:164/255.0 blue:184/255.0 alpha:1/1.0];
        versionLabel.tag = 100;
        [footer addSubview:versionLabel];
        return footer;
    }
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
