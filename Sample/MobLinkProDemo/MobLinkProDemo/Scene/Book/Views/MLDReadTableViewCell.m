//
//  MLDReadTableViewCell.m
//  MobLinkProDemo
//
//  Created by lujh on 2018/12/19.
//  Copyright © 2018 mob. All rights reserved.
//

#import "MLDReadTableViewCell.h"

#import "MLDReadView.h"

@interface MLDReadTableViewCell ()

@property (nonatomic, strong) MLDReadView *readView;

@end

@implementation MLDReadTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self addSubViews];
    }
    return self;
}

- (void)setContent:(NSMutableAttributedString *)content
{
    _content = content;
    self.readView.content = content;
}

- (void)addSubViews
{
    self.readView = [[MLDReadView alloc] init];
    
    self.readView.backgroundColor = [UIColor clearColor];
    
    [self.contentView addSubview:self.readView];
}

- (CGRect)readViewFrame
{
    return CGRectMake(15, 0, SCREEN_WIDTH - 30, SCREEN_HEIGHT - MOBLINK_StatusBarSafeBottomMargin - MOBLINK_TabbarSafeBottomMargin);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.readView.frame = [self readViewFrame];
}

@end
