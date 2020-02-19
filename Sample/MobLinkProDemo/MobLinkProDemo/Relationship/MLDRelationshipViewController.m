//
//  MLDRelationshipViewController.m
//  MobLinkProDemo
//
//  Created by lujh on 2018/12/13.
//  Copyright © 2018 mob. All rights reserved.
//

#import "MLDRelationshipViewController.h"

#import "MLDRelationshipShareView.h"

#import "MLDUserManager.h"

#import "MLDTool.h"

@interface MLDRelationshipViewController ()

@property (strong, nonatomic) MLDRelationshipShareView *relationshipView;

@end

@implementation MLDRelationshipViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.layer.contents = (__bridge id)[UIImage imageNamed:@"gxpp_bg"].CGImage;
    self.view.layer.contentsGravity = kCAGravityResizeAspectFill;
    [self.view addSubview:self.relationshipView];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 30, 30);
    [rightBtn setImage:[UIImage imageNamed:@"fx"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(shareItemClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *shareItme = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = shareItme;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}


- (void)shareItemClick:(UIButton *)shareBtn
{
    NSString *path = [NSString stringWithFormat:@"/relationship?id=%@", [[MLDUserManager sharedManager] currentUserId]];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([MLDUserManager sharedManager].currentUserId)
    {
        [params addEntriesFromDictionary:@{@"id" : [MLDUserManager sharedManager].currentUserId}];
    }
    [params addEntriesFromDictionary:@{@"scene" : @(MLDSceneTypeRelationship)}];
    
    // 先读取缓存的mobid,缓存没有再进行网络请求
    NSString *cacheMobid = [[MLDTool shareInstance] mobidForKeyPath:path];
    NSString *title = @"MobLink 关系匹配";
    NSString *text = @"打开App，自动匹配该好友至好友列表";
    NSString *image = @"gxpp";
    
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
        [[MLDTool shareInstance] getMobidWithPath:@"/relationship"
                                           params:params
                                           result:^(NSString *mobid, NSString *domain, NSError *error) {
            if (error) {
                UIAlertControllerAlertCreate(@"错误", [NSString stringWithFormat:@"%@",error.userInfo])
                .addCancelAction(@"OK")
                .present();
                return;
            }
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

- (MLDRelationshipShareView *)relationshipView
{
    if (!_relationshipView)
    {
        CGRect frame = CGRectMake(0, MOBLINK_StatusBarSafeBottomMargin + 44, SCREEN_WIDTH, SCREEN_HEIGHT - MOBLINK_StatusBarSafeBottomMargin - 44);
        _relationshipView = [[MLDRelationshipShareView alloc] initWithFrame:frame];
    }
    return _relationshipView;
}

@end
