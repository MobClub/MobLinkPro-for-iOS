//
//  MLDShareQRCodeView.m
//  MobLinkProDemo
//
//  Created by lujh on 2018/12/12.
//  Copyright © 2018 mob. All rights reserved.
//

#import "MLDShareQRCodeView.h"

#import "MLDUserTableViewCell.h"

#import "MLDUserManager.h"

#import "MLDTool.h"

#import "UIImage+MLDQRCode.h"

@interface MLDShareQRCodeView ()

@property (strong, nonatomic) MLDUserTableViewCell *userView;
@property (strong, nonatomic) UIImageView *qrImageView;

@end

@implementation MLDShareQRCodeView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        [self loadSubViewsWithFrame:frame];
    }
    return self;
}

- (void)setUser:(MLDUser *)user
{
    if (_user != user)
    {
        _user = user;
    }
    
    self.userView.user = user;
    
    if (user.uid)
    {
        CGFloat qrWidth = self.qrImageView.bounds.size.width - 30 * PUBLICSCALE;
        CALayer *qrLayer = [CALayer layer];
        qrLayer.position = CGPointMake(_qrImageView.bounds.size.width / 2,_qrImageView.bounds.size.width / 2);
        qrLayer.bounds = CGRectMake(0, 0, qrWidth, qrWidth);
        
        NSString *path = [NSString stringWithFormat:@"/invite/share?id=%@", user.uid];
      
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        if (user.uid)
        {
            [params addEntriesFromDictionary:@{@"id" : user.uid}];
        }
        [params addEntriesFromDictionary:@{@"scene" : @(MLDSceneTypeShare)}];
        
        // 先读取缓存的mobid,缓存没有再进行网络请求
        NSString *cacheMobid = [[MLDTool shareInstance] mobidForKeyPath:path];
        
        if (cacheMobid)
        {
            self.mobid = cacheMobid;
            qrLayer.contents = (__bridge id)[UIImage mldCreateQRCodeImageFormString:[NSString stringWithFormat:@"%@/invite/share?id=%@&mobid=%@", baseShareUrl, user.uid, cacheMobid] withSize:qrWidth].CGImage;
        }
        else
        {
            __weak typeof(self) weakSelf = self;
            [[MLDTool shareInstance] getMobidWithPath:@"/invite/local"
                                               params:params
                                               result:^(NSString *mobid, NSString *domain, NSError *error) {
                                                   // 先缓存mobid,如果有的话
                                                   weakSelf.mobid = mobid;
                                                   if (mobid)
                                                   {
                                                       [[MLDTool shareInstance] cacheMobid:mobid forKeyPath:path];
                                                   }
                                                   qrLayer.contents = (__bridge id)[UIImage mldCreateQRCodeImageFormString:[NSString stringWithFormat:@"%@/invite/share?id=%@&mobid=%@", baseShareUrl, user.uid, mobid] withSize:qrWidth].CGImage;
                                                   [weakSelf.qrImageView setNeedsDisplay];
                                               }];
        }
        
        qrLayer.contentsGravity = kCAGravityResizeAspect;
        qrLayer.contentsScale = [UIScreen mainScreen].scale;
        
        [_qrImageView.layer addSublayer:qrLayer];
    }
}

- (void)loadSubViewsWithFrame:(CGRect)frame
{
    _userView = [[NSBundle mainBundle] loadNibNamed:@"MLDUserTableViewCell" owner:nil options:nil][0];
    _userView.frame = CGRectMake(20, 30, frame.size.width - 40, 100 * PUBLICSCALE);
    
    CGFloat imageW = SCREEN_WIDTH - 80 * PUBLICSCALE;
    
    _qrImageView = [[UIImageView alloc] init];
    _qrImageView.frame = CGRectMake(40 * PUBLICSCALE, 60 * PUBLICSCALE + 100, imageW, imageW);
    
    _qrImageView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:_userView];
    [self addSubview:_qrImageView];
}

- (void)drawRect:(CGRect)rect
{
    _qrImageView.layer.masksToBounds = NO;
    _qrImageView.layer.shadowOffset = CGSizeMake(0, 0);
    _qrImageView.layer.shadowColor = [UIColor colorWithRed:194/255.0 green:194/255.0 blue:196/255.0 alpha:1.0].CGColor;
    _qrImageView.layer.shadowRadius = 10;
    _qrImageView.layer.shadowOpacity = 0.5;
    _qrImageView.layer.shadowPath = [UIBezierPath bezierPathWithRect:_qrImageView.bounds].CGPath;
}


@end
