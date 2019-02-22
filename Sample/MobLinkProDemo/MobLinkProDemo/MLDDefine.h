//
//  MLDDefine.h
//  MobLinkProDemo
//
//  Created by lujh on 2019/1/16.
//  Copyright © 2019 mob. All rights reserved.
//

#ifndef MLDDefine_h
#define MLDDefine_h

/**
 推广方式

 - MLDAnalyTypePromoter: 地推推广
 - MLDAnalyTypeShare: 社交分享
 - MLDAnalyTypeScene: 场景还原
 */
typedef NS_ENUM(NSUInteger, MLDAnalyType) {
    MLDAnalyTypePromoter = 1,
    MLDAnalyTypeShare,
    MLDAnalyTypeScene,
};

/**
 社交分享渠道类型

 - MLDChannelTypeQQ: QQ
 - MLDChannelTypeWechat: 微信
 - MLDChannelTypeWeibo: 微博
 - MLDChannelTypeFacebook: Facebook
 - MLDChannelTypeTwitter: Twitter
 - MLDChannelTypeSMS: 短信
 - MLDChannelTypeOther: 其他
 */
typedef NS_ENUM(NSUInteger, MLDChannelType) {
    MLDChannelTypeQQ = 1001,
    MLDChannelTypeWechat,
    MLDChannelTypeWeibo,
    MLDChannelTypeFacebook,
    MLDChannelTypeTwitter,
    MLDChannelTypeSMS,
    MLDChannelTypeOthers,
};

/**
 场景还原渠道类型

 - MLDSceneTypeNews: 资讯
 - MLDSceneTypeNovel: 小说
 - MLDSceneTypeGame: 游戏
 - MLDSceneTypePromote: 地推
 - MLDSceneTypeShare: 社交分享
 - MLDSceneTypeRelationship: 关系匹配
 - MLDSceneTypeOther: 其他
 */
typedef NS_ENUM(NSUInteger, MLDSceneType) {
    MLDSceneTypeNews = 2001,
    MLDSceneTypeNovel,
    MLDSceneTypeGame,
    MLDSceneTypePromote,
    MLDSceneTypeShare,
    MLDSceneTypeRelationship,
    MLDSceneTypeOthers,
};

#endif /* MLDDefine_h */
