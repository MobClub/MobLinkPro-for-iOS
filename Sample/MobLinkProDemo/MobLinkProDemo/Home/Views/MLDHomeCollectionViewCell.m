//
//  MLDHomeCollectionViewCell.m
//  MobLinkProDemo
//
//  Created by lujh on 2018/12/10.
//  Copyright © 2018 mob. All rights reserved.
//

#import "MLDHomeCollectionViewCell.h"

@interface MLDHomeCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIView *imageV;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation MLDHomeCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setDict:(NSDictionary *)dict
{
    _dict = dict;
    
    self.titleLabel.text = dict[@"title"];
    self.titleLabel.textColor = [UIColor colorWithRed:23/255.0 green:25/255.0 blue:34/255.0 alpha:1.0];
    self.titleLabel.font = Font(PingFangSemibold, 18);
    
    self.imageV.layer.contents = (__bridge id)[UIImage imageNamed:dict[@"image"]].CGImage;
    self.imageV.layer.contentsGravity = kCAGravityResizeAspect;
}

- (void)drawRect:(CGRect)rect
{
    self.layer.masksToBounds = NO;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowColor = [UIColor colorWithRed:194/255.0 green:194/255.0 blue:196/255.0 alpha:1.0].CGColor;
    self.layer.shadowRadius = 5;
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:rect].CGPath;
}

@end
