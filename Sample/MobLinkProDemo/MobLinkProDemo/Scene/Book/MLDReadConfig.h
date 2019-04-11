//
//  MLDReadConfig.h
//  MobLinkProDemo
//
//  Created by lujh on 2018/12/19.
//  Copyright © 2018 mob. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MLDReadConfig : NSObject

@property (nonatomic, assign) NSInteger fontSize;

+ (instancetype)sharedInstance;

- (NSDictionary *)readAttributeWithIsTitle:(BOOL)isTitle;

@end

NS_ASSUME_NONNULL_END
