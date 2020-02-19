//
//  MLDRelationshipShareView.m
//  MobLinkProDemo
//
//  Created by lujh on 2018/12/13.
//  Copyright © 2018 mob. All rights reserved.
//

#import "MLDRelationshipShareView.h"

@implementation MLDRelationshipShareView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {        
        [self addTipView:frame];
    }
    return self;
}

- (void)addTipView:(CGRect)frame
{
    // 行间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5.0;
    
    // 第一步
    NSMutableAttributedString *stepFString = [[NSMutableAttributedString alloc] initWithString:@"点击上方\"  \"图标，向好友分享邀请链接"];
    
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.image = [UIImage imageNamed:@"gxpp_fx_icon"];
    attach.bounds = CGRectMake(0, -10, 35, 35);
    
    NSAttributedString *sharePicStr = [NSAttributedString attributedStringWithAttachment:attach];

    [stepFString insertAttributedString:sharePicStr atIndex:6];
    
    // 第二步
    NSMutableAttributedString *stepSString = [[NSMutableAttributedString alloc] initWithString:@"好友通过该链接下载App，系统自动匹配该好友至好友列表。"];

    // 第三步
    NSMutableAttributedString *stepTString = [[NSMutableAttributedString alloc] initWithString:@"点击\"个人中心\"-\"好友列表\"查看"];
    
    NSArray *tipArray = @[
                          stepFString,
                          stepSString,
                          stepTString
                          ];
    
    UIView *tipView = [[UIView alloc] initWithFrame:CGRectMake(0, (frame.size.height + MOBLINK_StatusBarSafeBottomMargin + 44) / 2.0 - 240 , frame.size.width / 3 * 2, 300)];
    tipView.backgroundColor = [UIColor whiteColor];
    
    for (int i = 0; i < 3; i++)
    {
        // 添加文字描述
        UILabel *stepLabel = [[UILabel alloc] init];
        
        stepLabel.frame = CGRectMake(frame.size.width / 4 + 30, 120 * i, frame.size.width / 3 * 2 - 20, 80);
        
        stepLabel.numberOfLines = 0;
        
        [tipArray[i] addAttributes:@{
                                     NSForegroundColorAttributeName : [UIColor colorWithRed:23/255.0 green:25/255.0 blue:34/255.0 alpha:1/1.0],
                                     NSFontAttributeName :Font(PingFangReguler,   16),
                                     NSParagraphStyleAttributeName : paragraphStyle
                                     }
                             range:NSMakeRange(0, [tipArray[i] length])];
        if (i == 2)
        {
            [stepTString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(2, 13)];
        }
        
        stepLabel.attributedText = tipArray[i];
        
        // 添加步数图片
        CALayer *stepLayer = [CALayer layer];
        stepLayer.frame = CGRectMake(20, 125 * i + 10, frame.size.width / 4, 32);
        stepLayer.contents = (__bridge id)[UIImage imageNamed:[NSString stringWithFormat:@"STEP%d", i + 1]].CGImage;
        stepLayer.contentsGravity = kCAGravityResizeAspect;
        
        [tipView addSubview:stepLabel];
        [tipView.layer addSublayer:stepLayer];
        
        // 添加虚线
        if (i < 2)
        {
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            shapeLayer.frame = CGRectMake(19 + frame.size.width / 8, 125 * i + 50, 1, 80);
            [shapeLayer setFillColor:[UIColor clearColor].CGColor];
            
            [shapeLayer setStrokeColor:[UIColor colorWithRed:224/255.0 green:227/255.0 blue:253/255.0 alpha:1/1.0].CGColor];
            
            [shapeLayer setLineWidth:1.0];
            [shapeLayer setLineJoin:kCALineJoinRound];
            
            [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:5], [NSNumber numberWithInt:2], nil]];
            
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathMoveToPoint(path, NULL, 0, 0);
            CGPathAddLineToPoint(path, NULL, 0, 80);
            
            [shapeLayer setPath:path];
            CGPathRelease(path);
            
            [tipView.layer addSublayer:shapeLayer];
        }
    }
    
    [self addSubview:tipView];
}


@end
