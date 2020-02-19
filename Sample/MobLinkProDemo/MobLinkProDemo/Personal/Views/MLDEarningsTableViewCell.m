//
//  MLDEarningsTableViewCell.m
//  MobLinkProDemo
//
//  Created by lujh on 2018/12/11.
//  Copyright © 2018 mob. All rights reserved.
//

#import "MLDEarningsTableViewCell.h"

#import "MLDEarnings.h"

@interface MLDEarningsTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *rightView;

@property (weak, nonatomic) IBOutlet UILabel *promoteLabel;
@property (weak, nonatomic) IBOutlet UILabel *promoteTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *earningsTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *earningsLabel;

@end

@implementation MLDEarningsTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setupTitle];
}

- (void)setupTitle
{
    NSMutableAttributedString *promoteTitle = [[NSMutableAttributedString alloc] initWithString:@" 累计推广"];
    
    NSTextAttachment *attachtg = [[NSTextAttachment alloc] init];
    attachtg.image = [UIImage imageNamed:@"ljtg"];
    attachtg.bounds = CGRectMake(0, 0, 22, 14.5);
    
    NSAttributedString *picStrTg = [NSAttributedString attributedStringWithAttachment:attachtg];
    
    [promoteTitle insertAttributedString:picStrTg atIndex:0];
    
    [promoteTitle addAttributes:@{
                                   NSForegroundColorAttributeName : [UIColor colorWithRed:157/255.0 green:164/255.0 blue:184/255.0 alpha:1/1.0],
                                   NSFontAttributeName : Font(PingFangSemibold,   16),
                                   }
                           range:NSMakeRange(0, [promoteTitle length])];
    
    
    self.promoteTitleLabel.attributedText = promoteTitle;
    
    NSMutableAttributedString *earningsTitle = [[NSMutableAttributedString alloc] initWithString:@" 累计收益"];
    
    NSTextAttachment *attachsy = [[NSTextAttachment alloc] init];
    attachsy.image = [UIImage imageNamed:@"ljsy"];
    attachsy.bounds = CGRectMake(0, 0, 19, 14.5);
    
    NSAttributedString *picStrSy = [NSAttributedString attributedStringWithAttachment:attachsy];
    
    [earningsTitle insertAttributedString:picStrSy atIndex:0];
    
    [earningsTitle addAttributes:@{
                                   NSForegroundColorAttributeName : [UIColor colorWithRed:157/255.0 green:164/255.0 blue:184/255.0 alpha:1/1.0],
                                   NSFontAttributeName : Font(PingFangSemibold,   12),
                                   }
                           range:NSMakeRange(0, [earningsTitle length])];
    
    
    self.earningsTitleLabel.attributedText = earningsTitle;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setEarnings:(MLDEarnings *)earnings
{
    _earnings = earnings;
    
    self.promoteLabel.text = [NSString stringWithFormat:@"%ld", (long)earnings.promoteCount];
    self.earningsLabel.text = [NSString stringWithFormat:@"%ld", (long)earnings.earningsCount];
}

- (void)drawRect:(CGRect)rect
{
    self.leftView.layer.masksToBounds = NO;
    
    self.leftView.layer.shadowOffset = CGSizeMake(0, 0);
    self.leftView.layer.shadowColor = [UIColor colorWithRed:194/255.0 green:194/255.0 blue:196/255.0 alpha:1.0].CGColor;
    self.leftView.layer.shadowRadius = 5;
    self.leftView.layer.shadowOpacity = 0.3;
    
    self.leftView.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.leftView.bounds].CGPath;
    
    self.rightView.layer.masksToBounds = NO;
    
    self.rightView.layer.shadowOffset = CGSizeMake(0, 0);
    self.rightView.layer.shadowColor = [UIColor colorWithRed:194/255.0 green:194/255.0 blue:196/255.0 alpha:1.0].CGColor;
    self.rightView.layer.shadowRadius = 5;
    self.rightView.layer.shadowOpacity = 0.3;
    
    self.rightView.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.rightView.bounds].CGPath;
}

@end
