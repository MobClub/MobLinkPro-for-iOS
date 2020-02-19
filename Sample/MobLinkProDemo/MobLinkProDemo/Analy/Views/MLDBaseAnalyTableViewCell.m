//
//  MLDBaseAnalyTableViewCell.m
//  MobLinkProDemo
//
//  Created by lujh on 2019/1/16.
//  Copyright © 2019 mob. All rights reserved.
//

#import "MLDBaseAnalyTableViewCell.h"

@implementation MLDBaseAnalyTableViewCell

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
    NSInteger row = [dict[@"row"] integerValue];
    
    if (row % 2)
    {
        self.backgroundColor = [UIColor whiteColor];
    }
    else
    {
        self.backgroundColor = [UIColor colorWithRed:245/255.0 green:246/255.0 blue:248/255.0 alpha:1/1.0];
    }
    
    NSArray *dictKey = dict[@"dictKey"];
    NSMutableDictionary *dataDict = [dict[@"dataDict"] mutableCopy];
    [dataDict setObject:@(row + 1) forKey:@"row"];
    
    NSInteger count = dictKey.count;
    
    CGFloat labelW = SCREEN_WIDTH / count;
    CGFloat labelH = 40.0;
    
    for (UIView *view in self.subviews)
    {
        [view removeFromSuperview];
    }

    [dictKey enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(labelW * idx, 0, labelW, labelH)];
        label.text = [NSString stringWithFormat:@"%@", dataDict[obj]];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = Font(PingFangReguler,   15);
        
        if (idx == count - 1)
        {
            label.textColor = [UIColor colorWithRed:50/255.0 green:102/255.0 blue:255/255.0 alpha:1/1.0];
        }
        else
        {
            label.textColor = [UIColor colorWithRed:23/255.0 green:25/255.0 blue:34/255.0 alpha:1/1.0];
        }
        
        if ([obj isEqualToString:@"channel"])
        {
            switch ([dataDict[obj] integerValue])
            {
                case MLDChannelTypeQQ:
                {
                    label.text = @"QQ";
                    break;
                }
                case MLDChannelTypeWechat:
                {
                    label.text = @"微信";
                    break;
                }
                case MLDChannelTypeWeibo:
                {
                    label.text = @"微博";
                    break;
                }
                case MLDChannelTypeFacebook:
                {
                    label.text = @"Facebook";
                    break;
                }
                case MLDChannelTypeTwitter:
                {
                    label.text = @"Twitter";
                    break;
                }
                case MLDChannelTypeSMS:
                {
                    label.text = @"短信";
                    break;
                }
                default:
                {
                    label.text = @"其他";
                    break;
                }
            }
        }
        if ([obj isEqualToString:@"scene"])
        {
            switch ([dataDict[obj] integerValue])
            {
                case MLDSceneTypeNews:
                {
                    label.text = @"资讯";
                    break;
                }
                case MLDSceneTypeNovel:
                {
                    label.text = @"小说";
                    break;
                }
                case MLDSceneTypeGame:
                {
                    label.text = @"游戏";
                    break;
                }
                case MLDSceneTypePromote:
                {
                    label.text = @"地推";
                    break;
                }
                case MLDSceneTypeShare:
                {
                    label.text = @"社交分享";
                    break;
                }
                case MLDSceneTypeRelationship:
                {
                    label.text = @"关系匹配";
                    break;
                }
                default:
                {
                    label.text = @"其他";
                    break;
                }
            }
        }
        
        [self addSubview:label];
    }];
}

@end
