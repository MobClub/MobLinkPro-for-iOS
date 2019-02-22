//
//  MLDSceneCollectionViewCell.m
//  MobLinkProDemo
//
//  Created by lujh on 2018/12/11.
//  Copyright © 2018 mob. All rights reserved.
//

#import "MLDSceneCollectionViewCell.h"

@interface MLDSceneCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end

@implementation MLDSceneCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setDict:(NSDictionary *)dict
{
    _dict = dict;
    
    self.titleLabel.text = dict[@"title"];
    
    self.detailLabel.text = dict[@"detail"];
    
    self.imageV.image = [UIImage imageNamed:dict[@"imageName"]];
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
