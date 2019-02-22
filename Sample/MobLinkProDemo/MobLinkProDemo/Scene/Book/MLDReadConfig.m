//
//  MLDReadConfig.m
//  MobLinkProDemo
//
//  Created by lujh on 2018/12/19.
//  Copyright © 2018 mob. All rights reserved.
//

#import "MLDReadConfig.h"

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@implementation MLDReadConfig

+ (instancetype)sharedInstance
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _fontSize = 18;
    }
    return self;
}

- (UIFont *)readFont:(BOOL)isTitle
{
    if (isTitle)
    {
        return [UIFont systemFontOfSize:25];
    }
    else
    {
        return [UIFont systemFontOfSize:18];
    }
}

- (NSDictionary *)readAttributeWithIsTitle:(BOOL)isTitle
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    paragraphStyle.lineHeightMultiple = 1.0;
    
    if (isTitle)
    {
        paragraphStyle.lineSpacing = 0;
        paragraphStyle.paragraphSpacing = 0;
        paragraphStyle.alignment = NSTextAlignmentCenter;
    }
    else
    {
        //TODO:改成宏
        paragraphStyle.lineSpacing = 10;
        paragraphStyle.paragraphSpacing = 50;
        paragraphStyle.alignment = NSTextAlignmentJustified;
    }
    
    return @{NSFontAttributeName : [self readFont:isTitle], NSParagraphStyleAttributeName : paragraphStyle};
}

@end
