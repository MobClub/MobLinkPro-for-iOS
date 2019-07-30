//
//  MLDFriendsListTableViewCell.m
//  MobLinkProDemo
//
//  Created by lujh on 2018/12/12.
//  Copyright © 2018 mob. All rights reserved.
//

#import "MLDFriendsListTableViewCell.h"

#import "MLDUser.h"

#import "UIImageView+WebCache.h"

#import "MLDNetworkManager.h"

#import "MLDUserManager.h"

@interface MLDFriendsListTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;

@property (weak, nonatomic) IBOutlet UIButton *focusButton;

@end

@implementation MLDFriendsListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUser:(MLDUser *)user
{
    _user = user;
    
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"hy_1"]];
    
    self.nickNameLabel.text = user.nickName;
    [self.nickNameLabel sizeToFit];
    
    self.focusButton.layer.masksToBounds = YES;
    self.focusButton.layer.cornerRadius = 12;
    self.focusButton.layer.borderWidth = 1;
    self.focusButton.layer.borderColor = [UIColor colorWithRed:157/255.0 green:164/255.0 blue:184/255.0 alpha:1/1.0].CGColor;
}

- (void)drawRect:(CGRect)rect
{
    self.imageV.layer.masksToBounds = YES;
    self.imageV.layer.cornerRadius = CGRectGetHeight(self.imageV.bounds) / 2;
    
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(ctx, 1);
    CGContextSetLineCap(ctx, kCGLineCapSquare);
    CGContextSetRGBStrokeColor(ctx, 245 / 255.0, 247 / 255.0, 248 / 255.0, 1.0);
    
    CGContextMoveToPoint(ctx, 15, CGRectGetHeight(rect) - 1);
    CGContextAddLineToPoint(ctx , CGRectGetWidth(rect), CGRectGetHeight(rect) - 1);
    
    CGContextStrokePath(ctx);
}
- (IBAction)deleteFriend:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(deleteFriendWithOtherUid:)])
    {
        [self.delegate deleteFriendWithOtherUid:self.user.uid];
    }
}

@end
