//
//  MLDBaseCollectionViewController.m
//  MobLinkProDemo
//
//  Created by lujh on 2018/12/11.
//  Copyright © 2018 mob. All rights reserved.
//

#import "MLDBaseCollectionViewController.h"

#import "MLDSceneCollectionViewCell.h"

@interface MLDBaseCollectionViewController ()

@end

@implementation MLDBaseCollectionViewController

static NSString * const sceneReuseIdentifier = @"MLDSceneCollectionViewCellId";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];

    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    // Register cell classes
    [self.collectionView registerNib:[UINib nibWithNibName:@"MLDSceneCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:sceneReuseIdentifier];
}

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    if (self = [super initWithCollectionViewLayout:layout])
    {
        UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)layout;
        
        flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH - 40, 80 * PUBLICSCALE);
        flowLayout.minimumLineSpacing = 20;
        flowLayout.minimumInteritemSpacing = 20;
        flowLayout.sectionInset = UIEdgeInsetsMake(30, 20, 20, 20);
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
    MLDSceneCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:sceneReuseIdentifier forIndexPath:indexPath];
    
    if (indexPath.item < self.dataArray.count)
    {
        cell.dict = self.dataArray[indexPath.item];
    }
    
    return cell;
}

@end
