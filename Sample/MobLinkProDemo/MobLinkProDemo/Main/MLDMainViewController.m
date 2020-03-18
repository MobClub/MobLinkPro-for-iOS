//
//  MLDMainViewController.m
//  MobLinkProDemo
//
//  Created by lujh on 2018/12/10.
//  Copyright © 2018 mob. All rights reserved.
//

#import "MLDMainViewController.h"

#import "MLDHomeCollectionViewController.h"

#import "MLDPersonalTableViewController.h"

#import "AppDelegate.h"

@implementation MLDMainViewController

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        dispatch_semaphore_signal(((AppDelegate *)[UIApplication sharedApplication].delegate).guideSemaphore);
        ((AppDelegate *)[UIApplication sharedApplication].delegate).isAlreadyRun = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addChildViewControllers];
}

/**
 添加所有子控制器
 */
- (void)addChildViewControllers
{
    // 首页
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    MLDHomeCollectionViewController *homeCtr = [[MLDHomeCollectionViewController alloc] initWithCollectionViewLayout:flowLayout];
    
    [self addChildViewController:homeCtr navTitle:@"MobLink" tabTitle:@"首页" imageName:@"sy"];
    
    // 个人中心
    MLDPersonalTableViewController *personCtr = [[MLDPersonalTableViewController alloc] init];
    
    [self addChildViewController:personCtr navTitle:@"个人中心" tabTitle:@"我的" imageName:@"wd"];
}

/**
 添加一个子控制器
 
 @param childController 子控制器
 @param navTitle 导航栏标题
 @param tabTitle tabBar标题
 @param imageName tabBar图片名称
 */
- (void)addChildViewController:(UIViewController *)childController
                      navTitle:(NSString *)navTitle
                      tabTitle:(NSString *)tabTitle
                     imageName:(NSString *)imageName
{
    childController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    childController.navigationItem.title = navTitle;
    childController.tabBarItem.title = tabTitle;
    
    childController.tabBarItem.image = [[UIImage imageNamed:[imageName stringByAppendingString:@"_2"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    childController.tabBarItem.selectedImage = [[UIImage imageNamed:[imageName stringByAppendingString:@"_1"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [childController.tabBarItem setTitleTextAttributes:@{
                                                         NSForegroundColorAttributeName : [UIColor colorWithRed:157/255.0 green:164/255.0 blue:184/255.0 alpha:1.0],
                                                         NSFontAttributeName : Font(PingFangSemibold,11)
                                                         }
                                              forState:UIControlStateNormal];
    [childController.tabBarItem setTitleTextAttributes:@{
                                                         NSForegroundColorAttributeName : [UIColor colorWithRed:50/255.0 green:102/255.0 blue:255/255.0 alpha:1.0],
                                                         NSFontAttributeName : Font(PingFangSemibold, 11)
                                                         }
                                              forState:UIControlStateSelected];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:childController];
    
    [self addChildViewController:nav];
}

@end
