//
//  MLDBookTableViewCell.m
//  MobLinkProDemo
//
//  Created by lujh on 2019/1/9.
//  Copyright © 2019 mob. All rights reserved.
//

#import "MLDBookTableViewCell.h"

@interface MLDBookTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *bookImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *describeLabel;

@end

@implementation MLDBookTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDict:(NSDictionary *)dict
{
    _dict = dict;
    
    self.bookImageView.layer.contents = (__bridge id)[UIImage imageNamed:dict[@"imageName"]].CGImage;
    self.titleLabel.text = dict[@"title"];
    self.authorLabel.text = [NSString stringWithFormat:@"作者: %@", dict[@"author"]];
    
    self.describeLabel.text = dict[@"describe"];
}

@end
