//
//  MLDUserTableViewCell.m
//  MobLinkProDemo
//
//  Created by lujh on 2018/12/11.
//  Copyright © 2018 mob. All rights reserved.
//

#import "MLDUserTableViewCell.h"

#import "MLDUser.h"
#import "UIImageView+WebCache.h"

@interface MLDUserTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userStatus;

@end

@implementation MLDUserTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setUser:(MLDUser *)user
{
    _user = user;
    
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"tx"]];
    
    self.userName.text = user.nickName;
    [self.userName sizeToFit];
    self.userStatus.text = [NSString stringWithFormat:@"UID:%@", user.uid];
    [self.userStatus sizeToFit];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    self.imageV.layer.cornerRadius = CGRectGetHeight(self.imageV.bounds) / 2;
    self.imageV.layer.masksToBounds = YES;
    self.imageV.layer.borderWidth = 1.0;
    self.imageV.layer.borderColor = [UIColor colorWithRed:194/255.0 green:194/255.0 blue:196/255.0 alpha:1.0].CGColor;
}

@end
