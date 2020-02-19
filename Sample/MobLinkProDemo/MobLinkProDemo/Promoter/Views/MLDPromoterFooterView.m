//
//  MLDPromoterFooterView.m
//  MobLinkProDemo
//
//  Created by lujh on 2018/12/12.
//  Copyright © 2018 mob. All rights reserved.
//

#import "MLDPromoterFooterView.h"

#import "UIImage+MLDQRCode.h"

@interface MLDPromoterFooterView ()

@property (strong, nonatomic) UIImageView *qrImageView;

@end

@implementation MLDPromoterFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self loadSubViewsWithFrame:frame];
    }
    return self;
}

- (void)setQrString:(NSString *)qrString
{
    _qrString = qrString;
    if (qrString)
    {
        self.qrImageView.image = [UIImage mldCreateQRCodeImageFormString:_qrString withSize:self.qrImageView.bounds.size.width];
    }
}

- (void)loadSubViewsWithFrame:(CGRect)frame
{
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    view.backgroundColor = [UIColor whiteColor];
    
    CGFloat frameW = frame.size.width;
    CGFloat imageW = frameW * 0.65;
    
    UILabel *topLabel = [[UILabel alloc] init];
    topLabel.frame = CGRectMake(0, 10, frameW, 18);
    topLabel.text = @"地推二维码";
    topLabel.font = Font(PingFangReguler,   16);
    topLabel.textColor = [UIColor colorWithRed:157/255.0 green:164/255.0 blue:184/255.0 alpha:1/1.0];
    topLabel.textAlignment = NSTextAlignmentCenter;
    
    self.qrImageView = [[UIImageView alloc] init];
    self.qrImageView.frame = CGRectMake((frameW - imageW) / 2.0, 45, imageW, imageW);
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(0, 60 + imageW, frameW, 25);
    titleLabel.text = @"扫码下载应用";
    titleLabel.font = Font(PingFangSemibold,   20);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor colorWithRed:23/255.0 green:25/255.0 blue:34/255.0 alpha:1/1.0];
    
    UILabel *subTitleLabel = [[UILabel alloc] init];
    subTitleLabel.frame = CGRectMake(0, 100 + imageW, frameW, 35);
    subTitleLabel.text = @"无需填写邀请码，扫码后自动绑定地推人员账户";
    subTitleLabel.font = Font(PingFangReguler,   15);
    subTitleLabel.numberOfLines = 0;
    subTitleLabel.textAlignment = NSTextAlignmentCenter;
    subTitleLabel.textColor = [UIColor colorWithRed:23/255.0 green:25/255.0 blue:34/255.0 alpha:1/1.0];
    
    [self addSubview:view];
    [self addSubview:topLabel];
    [self addSubview:self.qrImageView];
    [self addSubview:titleLabel];
    [self addSubview:subTitleLabel];
}

@end
