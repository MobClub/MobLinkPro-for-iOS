//
//  MLDStaticTableViewCell.m
//  MobLinkProDemo
//
//  Created by lujh on 2018/12/11.
//  Copyright © 2018 mob. All rights reserved.
//

#import "MLDStaticTableViewCell.h"

@interface MLDStaticTableViewCell ()

@end

@implementation MLDStaticTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect
{
    //绘制分割线
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//
//    CGContextSetLineWidth(ctx, 1.0);
//    CGContextSetLineCap(ctx, kCGLineCapSquare);
//    CGContextSetRGBStrokeColor(ctx, 0.314, 0.486, 0.859, 1.0);
//
//    CGContextMoveToPoint(ctx, 0, rect.size.height - 1);
//    CGContextAddLineToPoint(ctx, rect.size.width, rect.size.height - 1);
//
//    CGContextStrokePath(ctx);
}

@end
