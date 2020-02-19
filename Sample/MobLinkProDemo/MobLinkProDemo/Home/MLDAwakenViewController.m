//
//  MLDAwakenViewController.m
//  MobLinkProDemo
//
//  Created by lujh on 2018/12/22.
//  Copyright © 2018年 mob. All rights reserved.
//

#import "MLDAwakenViewController.h"

#import "MLDTool.h"

#import "MLDUserManager.h"

@interface MLDAwakenViewController ()

@end

@implementation MLDAwakenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addSubViews];
}

- (void)share:(UIButton *)shareBtn
{
    NSString *path = [NSString stringWithFormat:@"/wakeup?id=%@",[MLDUserManager sharedManager].currentUserId];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([MLDUserManager sharedManager].currentUserId)
    {
        [params addEntriesFromDictionary:@{@"id" : [MLDUserManager sharedManager].currentUserId}];
    }
    [params addEntriesFromDictionary:@{@"scene" : @(MLDSceneTypeOthers)}];

    // 先读取缓存的mobid,缓存没有再进行网络请求
    NSString *cacheMobid = [[MLDTool shareInstance] mobidForKeyPath:path];
    NSString *title = @"MobLink 一键唤醒";
    NSString *text = @"移动端场景还原解决方案";
    NSString *image = @"xzy_icon";

    if (cacheMobid)
    {
        [[MLDTool shareInstance] shareWithMobId:cacheMobid
                                          title:title
                                           text:text
                                          image:image
                                           path:path
                                         onView:shareBtn];
    }
    else
    {
        [[MLDTool shareInstance] getMobidWithPath:@"/wakeup"
                                           params:params
                                           result:^(NSString *mobid, NSString *domain, NSError *error) {
                                               // 先缓存mobid,如果有的话
                                               if (mobid)
                                               {
                                                   [[MLDTool shareInstance] cacheMobid:mobid forKeyPath:path];
                                               }

                                               [[MLDTool shareInstance] shareWithMobId:mobid
                                                                                 title:title
                                                                                  text:text
                                                                                 image:image
                                                                                  path:path
                                                                                onView:shareBtn];
                                           }];
    }
}


- (void)addSubViews
{
    CALayer *topLayer = [CALayer layer];
    
    topLayer.frame = CGRectMake(0, MOBLINK_StatusBarSafeBottomMargin + 44, SCREEN_WIDTH, SCREEN_WIDTH * 1.37);
    topLayer.contents = (__bridge id)[UIImage imageNamed:@"xzy_bg"].CGImage;
    topLayer.contentsGravity = kCAGravityResizeAspect;
    topLayer.contentsScale = [UIScreen mainScreen].scale;
    
    CGFloat centerW = SCREEN_WIDTH / 2.0;
    
    UIView *centerView = [[UIView alloc] init];
    
    centerView.bounds = CGRectMake(0, 0, centerW, centerW);
    centerView.center = CGPointMake(centerW, (SCREEN_HEIGHT - MOBLINK_StatusBarSafeBottomMargin - 44) / 2);
    
    CALayer *centerLayer = [CALayer layer];
    centerLayer.frame = CGRectMake(0, 0, centerW, SCREEN_WIDTH * 0.3);
    centerLayer.contents = (__bridge id)[UIImage imageNamed:@"xzy_icon"].CGImage;
    centerLayer.contentsGravity = kCAGravityResizeAspect;
    centerLayer.contentsScale = [UIScreen mainScreen].scale;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(0, SCREEN_WIDTH * 0.3 + 10, centerW, 40);
    titleLabel.text = @"MobLink";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = Font(PingFangSemibold,   30);
    titleLabel.textColor = [UIColor colorWithRed:23/255.0 green:25/255.0 blue:34/255.0 alpha:1/1.0];
    
    UILabel *subTitleLabel = [[UILabel alloc] init];
    subTitleLabel.frame = CGRectMake(0, SCREEN_WIDTH * 0.3 + 60, centerW, 40);
    subTitleLabel.text = @"移动端场景还原解决方案";
    subTitleLabel.textAlignment = NSTextAlignmentCenter;
    subTitleLabel.font = Font(PingFangReguler,   17);
    subTitleLabel.textColor = [UIColor colorWithRed:23/255.0 green:25/255.0 blue:34/255.0 alpha:1/1.0];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    shareBtn.frame = CGRectMake(SCREEN_WIDTH / 6, (SCREEN_HEIGHT - MOBLINK_StatusBarSafeBottomMargin - 44) / 2 + SCREEN_WIDTH * 0.3 / 2 + 100, SCREEN_WIDTH / 3 * 2, 50);
    
    shareBtn.backgroundColor = [UIColor colorWithRed:50/255.0 green:102/255.0 blue:255/255.0 alpha:1/1.0];

    NSDictionary *attributes = @{
                                 NSFontAttributeName : Font(PingFangSemibold,   17),
                                 NSForegroundColorAttributeName : [UIColor whiteColor]
                                 };
    NSAttributedString *attrTitle = [[NSAttributedString alloc] initWithString:@"立即使用" attributes:attributes];
    [shareBtn setAttributedTitle:attrTitle forState:UIControlStateNormal];

    shareBtn.clipsToBounds = NO;
    shareBtn.layer.cornerRadius = 25;
    shareBtn.layer.borderWidth = 1.0;
    shareBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [shareBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    
    [centerView.layer addSublayer:centerLayer];
    [centerView addSubview:titleLabel];
    [centerView addSubview:subTitleLabel];
    
    [self.view.layer addSublayer:topLayer];
    [self.view addSubview:centerView];
    [self.view addSubview:shareBtn];
}

@end
