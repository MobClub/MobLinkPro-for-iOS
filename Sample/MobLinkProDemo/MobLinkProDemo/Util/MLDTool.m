//
//  MLDTool.m
//  MobLinkProDemo
//
//  Created by lujh on 2019/1/10.
//  Copyright © 2019 mob. All rights reserved.
//

#import "MLDTool.h"

// ShareSDK
#import <ShareSDK/ShareSDK.h>
#import <ShareSDK/ShareSDK+Base.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/ShareSDKUI.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>
#import <ShareSDKUI/SSUIShareSheetConfiguration.h>
#import <ShareSDKExtension/SSEShareHelper.h>

// MobLinkPro
#import <MobLinkPro/MobLink.h>
#import <MobLinkPro/MLSDKScene.h>

@interface MLDTool()

@property (weak, nonatomic) MLDAlertView *msgAlert;
@property (weak, nonatomic) MLDAlertView *sceneAlert;
@property (nonatomic, strong) NSDictionary *paramsCache;

@end

@implementation MLDTool

/**
 获取单例对象
 
 @return 单例对象
 */
+ (MLDTool *)shareInstance
{
    static MLDTool *_instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _instance = [[MLDTool alloc] init];
    });
    
    return _instance;
}

/**
 获取Mobid
 
 @param path 恢复路径
 @param params 参数
 @param result 结果回调
 */
- (void)getMobidWithPath:(NSString *)path
                  params:(NSDictionary *)params
                  result:(void (^)(NSString *mobid, NSString *domain, NSError *error))result
{
    
    MLSDKScene *scene = [MLSDKScene sceneForPath:path params:params];
    
    [MobLink getMobId:scene result:^(NSString *mobid, NSString *domain, NSError *error) {
        if (result)
        {
            result(mobid, domain, error);
        }
    }];
}


/**
 使用用户偏好缓存mobid
 
 @param mobid mobid
 @param keyPath 对应key
 */
- (void)cacheMobid:(NSString *)mobid forKeyPath:(NSString *)keyPath
{
    [[NSUserDefaults standardUserDefaults] setObject:mobid forKey:keyPath];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 从缓存读取mobid
 
 @param keyPath 对应key
 @return mobid
 */
- (NSString *)mobidForKeyPath:(NSString *)keyPath
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:keyPath];
}

- (void)shareWithMobId:(NSString *)mobid
                 title:(NSString *)title
                  text:(NSString *)text
                 image:(NSString *)imageName
                  path:(NSString *)path
                onView:(UIView *)onView
{
    [self shareWithMobId:mobid title:title text:text image:imageName path:path domain:ULDomain onView:onView];
}

/**
 分享mobid
 
 @param mobid mobid
 @param title 标题
 @param text 内容
 @param imageName 完整图片名称须带后缀
 @param path 相应的路径
 @param onView iPhone可以传nil,但是iPad就必须要传一个分享弹窗的依赖视图,相当于一个锚点
 */
- (void)shareWithMobId:(NSString *)mobid
                 title:(NSString *)title
                  text:(NSString *)text
                 image:(NSString *)imageName
                  path:(NSString *)path
                domain:(NSString *)domain
                onView:(UIView *)onView
{

    NSURL *domainUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",domain,mobid]];
    NSURL *pageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@&mobid=%@",baseShareUrl, path, mobid]];

    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];

    [shareParams SSDKSetupShareParamsByText:text
                                     images:[UIImage imageNamed:imageName]
                                        url:pageUrl
                                      title:title
                                       type:SSDKContentTypeWebPage];

    [shareParams SSDKSetupFacebookParamsByText:text
                                         image:@"http://www.mob.com/assets/images/pro_pic_MobLink-9615ec41.png"
                                           url:pageUrl
                                      urlTitle:@"MobLink"
                                       urlName:nil
                                attachementUrl:nil
                                       hashtag:@"#MobLink"
                                         quote:@"Mob官网 - 全球领先的移动开发者服务平台"
                                          type:SSDKContentTypeWebPage];
    // 短信内容
    [shareParams SSDKSetupSMSParamsByText:[NSString stringWithFormat:@"%@ %@ %@", title, domainUrl.absoluteString, text]
                                    title:title
                                   images:nil
                              attachments:nil
                               recipients:@[@"15757870542"]
                                     type:SSDKContentTypeText];

    self.paramsCache = [shareParams copy];

    [self shareWithParams:shareParams onView:onView];
}

- (void)shareWithParams:(NSMutableDictionary *)params onView:(UIView *)onView
{
    SSUIShareSheetConfiguration *config = [[SSUIShareSheetConfiguration alloc] init];

    //设置分享菜单为简洁样式
    config.style = SSUIActionSheetStyleSimple;

    //设置直接分享的平台（不弹编辑界面）
    config.directSharePlatforms = [ShareSDK activePlatforms];

    SSUIPlatformItem *itemFacebook = [[SSUIPlatformItem alloc] init];
    itemFacebook.iconNormal = [UIImage imageNamed:@"fb_icon"];//默认版显示的图标
    itemFacebook.iconSimple = [UIImage imageNamed:@"fb_s_icon"];//简洁版显示的图标
    itemFacebook.platformName = @"Facebook";
    //添加点击事件
    [itemFacebook addTarget:self action:@selector(costomPlatFormClick:)];

    //QQ、新浪微博、微信好友、微信朋友圈、Twitter、Facebook、短信、复制链接 顺序
    NSArray *platforms = @[
                           @(SSDKPlatformSubTypeQQFriend),
                           @(SSDKPlatformTypeSinaWeibo),
                           @(SSDKPlatformSubTypeWechatSession),
                           @(SSDKPlatformSubTypeWechatTimeline),
                           @(SSDKPlatformTypeTwitter),
                           itemFacebook,
                           @(SSDKPlatformTypeSMS),
                           @(SSDKPlatformTypeCopy)
                           ];

    [ShareSDK showShareActionSheet:[MOBFDevice isPad] ? onView : nil
                       customItems:platforms
                       shareParams:params
                sheetConfiguration:config
                    onStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                        switch (state)
                        {
                            case SSDKResponseStateSuccess:
                                [self showAlertWithMessage:@"分享成功！"];
                                break;
                            case SSDKResponseStateFail:
                                [self showAlertWithMessage:@"分享失败！"];
                                break;

                            default:
                                break;
                        }
                    }];
}

- (void)costomPlatFormClick:(SSUIPlatformItem *)item
{
    if ([item.platformName isEqualToString:@"Facebook"])
    {
        [ShareSDK getUserInfo:SSDKPlatformTypeFacebook onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
            switch (state) {
                case SSDKResponseStateSuccess:
                {
                    [ShareSDK share:SSDKPlatformTypeFacebook parameters:[self.paramsCache mutableCopy] onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                        switch (state)
                        {
                            case SSDKResponseStateSuccess:
                                [self showAlertWithMessage:@"分享成功！"];
                                break;
                            case SSDKResponseStateFail:
                                [self showAlertWithMessage:@"分享失败！"];
                                break;

                            default:
                                break;
                        }
                    }];
                    break;
                }
                default:
                    break;
            }
        }];
    }

    // 以下固定注释
//    else if ([item.platformName isEqualToString:@"Twitter"])
//    {
//        [shareParams SSDKSetupShareParamsByText:self.paramsCache[@"text"]
//                                         images:nil
//                                            url:self.paramsCache[@"url"]
//                                          title:self.paramsCache[@"title"]
//                                           type:SSDKContentTypeWebPage];
//
//        [ShareSDK share:SSDKPlatformTypeTwitter parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
//            switch (state)
//            {
//                case SSDKResponseStateSuccess:
//                    [self showAlertWithMessage:@"分享成功！"];
//                    break;
//                case SSDKResponseStateFail:
//                    [self showAlertWithMessage:@"分享失败！"];
//                    break;
//
//                default:
//                    break;
//            }
//        }];
//    }
}

- (void)shareQrcodeScreenCaptureOnView:(UIView *)onView mobid:(NSString *)mobid
{
    [SSEShareHelper screenCaptureShare:^(SSDKImage *sImage, SSEShareHandler shareHandler) {
        if(sImage != nil)
        {
            //设置分享数据
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params SSDKSetupShareParamsByText:@"MobLink"
                                        images:sImage
                                           url:nil
                                         title:nil
                                          type:SSDKContentTypeImage];
            // 短信内容
            NSString *domainUrlStr = [NSString stringWithFormat:@"%@/%@", ULDomain, mobid];
            [params SSDKSetupSMSParamsByText:[NSString stringWithFormat:@"MobLink 一键唤醒 %@ 移动端场景还原解决方案", domainUrlStr]
                                            title:@"MobLink 一键唤醒"
                                           images:nil
                                      attachments:nil
                                       recipients:@[@"15757870542"]
                                             type:SSDKContentTypeText];
            [params SSDKSetupFacebookParamsByText:[NSString stringWithFormat:@"MobLink 一键唤醒 %@ 移动端场景还原解决方案", domainUrlStr] image:sImage url:nil urlTitle:@"MobLink 一键唤醒" urlName:nil attachementUrl:nil hashtag:nil quote:nil type:SSDKContentTypeImage];
            self.paramsCache = params.copy;
            [self shareWithParams:params onView:onView];
        }
    } onStateChanged:nil];
}

/**
 显示弹窗信息,默认无标题,无点击回调
 
 @param message 信息内容
 */
- (void)showAlertWithMessage:(NSString *)message
{
    [self showAlertWithTitle:nil
                     message:message
                 cancelTitle:@"关闭"
                  otherTitle:nil
                  clickBlock:nil];
}

/**
 显示弹窗
 
 @param title 标题
 @param message 信息
 @param cancel 取消按钮标题
 @param other 其他按钮标题
 @param block 点击按钮回调block
 */
- (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
               cancelTitle:(NSString *)cancel
                otherTitle:(NSString *)other
                clickBlock:(MLDAlertClickButtonBlock)block
{
    MLDAlertView *msgAlertView = [[MLDAlertView alloc] initWithTitle:title
                                                             message:message
                                                      cancelBtnTitle:cancel
                                                       otherBtnTitle:other
                                                          clickBlock:block
                                                                type:MLDShowContentTypeLabel];
    self.msgAlert = msgAlertView;
    
    [msgAlertView show];
}

/**
 显示场景信息专用的弹窗
 
 @param scene 场景信息
 */
- (void)showAlertWithScene:(MLSDKScene *)scene
{
    NSString *path = scene.path == nil ? @"" : scene.path;
    NSString *className = scene.className == nil ? @"" : scene.className;
    
    __block NSMutableString *msg = [NSMutableString stringWithFormat:@"路径path\n%@ \n\n类名\n%@ \n\n参数", path, className];
    [scene.params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [msg appendFormat:@"\n%@ : %@;", key, obj];
    }];
    
    MLDAlertView *sceneAlertView = [[MLDAlertView alloc] initWithTitle:@"参数"
                                                               message:msg.copy
                                                        cancelBtnTitle:@"关闭"
                                                         otherBtnTitle:nil
                                                            clickBlock:nil
                                                                  type:MLDShowContentTypeTextView];
    self.sceneAlert = sceneAlertView;
    
    [sceneAlertView show];
}

/**
 关闭所有弹窗
 */
- (void)dismissAlert
{
    [self.msgAlert dismiss];
    [self.sceneAlert dismiss];
}

+ (BOOL)isFirstPromote
{
    static NSString *const MLDAlreadyPromote = @"MLDAlreadyPromote";
    
    BOOL res = [[[NSUserDefaults standardUserDefaults] objectForKey:MLDAlreadyPromote] boolValue];
    if (!res)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:MLDAlreadyPromote];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return !res;
}

@end
