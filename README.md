### 一、申请APPKey

1.打开Mob官网，在官网首页选择登录或注册，新用户先注册，老用户直接登录。
![](http://wiki.mob.com/wp-content/uploads/2018/10/76B2999E-274D-4E03-8E64-5B1623879EDE.png)

 注册页面如下图：

![](http://onmw6wg88.bkt.clouddn.com/mob_reg.png)

2.注册或登录完成后，会返回至首页，点击右上角的“进入后台”，会跳转至管理后台，选择“添加应用”或选择已创建的应用。如下图：

![](http://wiki.mob.com/wp-content/uploads/2018/10/B8FB8AAC-A796-4339-8865-7B330FC8536C.png)

3.输入应用名称后点击“保存”，如下图：

![](http://onmw6wg88.bkt.clouddn.com/Snip20170525_11.png)


4.应用创建后在左边导航栏点击“+”，如下图：

![](http://wiki.mob.com/wp-content/uploads/2018/10/AEC8FCB3-1E39-4F4B-BA3C-31B94D0C9F6B.png)


5.在弹窗中点击“确定添加”，如下图：

![](http://wiki.mob.com/wp-content/uploads/2018/10/A9B291FD-C8B1-4571-B8E0-1B1D24DF16CD.png)

6.此时左边导航栏就能看到您添加的产品了，点击“概况”即可看到您接下来需要的AppKey和AppSecret了，如下图：

![](http://wiki.mob.com/wp-content/uploads/2018/10/8E79F125-4DA2-47E0-8304-616810E03F8C.png)

7. 后台基础配置。请务必根据自身客户端应用实际情况，进行相关项的配置。填写完毕后请点击“保存”以确保生效。

![](http://wiki.mob.com/wp-content/uploads/2018/10/17A80980-F349-41C2-A904-A95A4EDA1053.png)

下面仅对iOS各项基础配置进行说明，安卓部分请参考：安卓集成文档

<table class="mceItemTable">
<tbody>
<tr>
<th colspan="3" align="center">配置说明</th>
</tr>
<tr>
<td align="center">字段名称</td>
<td align="center">是否必填</td>
<td align="center">字段作用/说明</td>
</tr>
<tr>
<td>BundleID</td>
<td>是</td>
<td>项目唯一标识。请务必与项目中保持一致。可见于项目Info.plist文件的Bundle identifier</td>
</tr>
<tr>
<td>下载地址</td>
<td>是</td>
<td>应用在App Store的下载地址</td>
</tr>
<tr>
<td>URL Scheme</td>
<td>是</td>
<td>请务必与项目中的配置保持一致，否则可能会导致无法跳转应用（下文将介绍）</td>
</tr>
<tr>
<td>Team ID</td>
<td>是</td>
<td>开发团队的ID，可在苹果开发者后台查看</td>
</tr>
<tr>
<td>右上角跳转链接</td>
<td>否</td>
<td>通过Universal Link跳转到app后右上角会出现一个“mob.com”标志，点击后会通过Safari打开一个链接，可以在这里填写您想要打开的链接，如果不填，则默认打开之前的Web页面</td>
</tr>
<tr>
<td>Universal Link开关</td>
<td>是</td>
<td>强烈建议使用Mob生成的Universal Link。iOS 9.0及以上使用Universal Link能优化场景恢复过程，提供更好的用户体验。选择并使用我们帮您生成的Universal Link并正确配置到您的项目中(下文将介绍)，将为您节省大量工作和时间。</td>
</tr>
</tbody>
</table>

### 二、下载客户端SDK

请从官网下载客户端SDK，解压后可得到如下文件夹目录：
![](http://wiki.mob.com/wp-content/uploads/2018/10/6186AB57-5576-401F-BB0C-2A5D636C29CF.jpg)

说明:

- Sample文件夹里存放MobLinkDemo - MobLink的演示demo（供使用参考）
- SDK文件夹下的MobLinkPro文件夹里存放MobLinkPro.framework - 核心功能库（必要）
- SDK文件夹下的Required文件夹里存放MOBFoundation.framework = 基础功能框架（必要）

### 三、快速集成SDK

1、iOS 快速集成

1.1
（1）手动在项目中添加SDK
i. Xcode9以下可以将MobLinkPro.framework，MOBFoundation.framework添加到项目中，如下图：

![](http://onmw6wg88.bkt.clouddn.com/Snip20170525_3.png)

ii. 选择将文件夹复制到项目中，如下图：

![](http://onmw6wg88.bkt.clouddn.com/Snip20170525_4.png)

iii. 添加依赖库

![](http://onmw6wg88.bkt.clouddn.com/Snip20170525_7.png)

选择项目Target - Build Phases - Link Binary With Libraries，然后选择“+”进行添加系统库：

- libsqlite3
- libz1.2.5
- libc++

（2）CocoaPods添加SDK：

只需引入：
```
pod 'mob_linksdk_pro'
```
如果搜索不到我们这个mob_linksdk_pro时：

1、请先进行：pod setup

2、再清空一下搜索索引，让pod重建索引：

```
rm ~/Library/Caches/CocoaPods/search_index.json
```

1.2 配置URL Scheme及Universal Link

i. URL Scheme 项目中需要配置URL Scheme以用于场景恢复时跳转到应用中。请参考下图配置您自己的URL Scheme：

![](http://onmw6wg88.bkt.clouddn.com/mob_url.png)

这里所配置的务必与后台填写的一致，如下图：

![](http://wiki.mob.com/wp-content/uploads/2018/10/ul.png)

ii. Universal Link 后台已经为您生成好您的Universal Link，如上图：

然后在项目中配置Universal Link，请务必填写与后台生成的Universal Link地址(可以添加多个) 参考下图：

![universal link](http://onmw6wg88.bkt.clouddn.com/Snip20170526_11.png)

1.3 添加代码

i. 在Info.plist文件中右键空白处，选择“Add Row”，添加“MOBAppKey”和“MOBAppSecret”对应值为上述在管理后台中获得的AppKey和AppSecret（点击“显示”查看），如下图所示：

![](http://onmw6wg88.bkt.clouddn.com/Snip20170526_12.png)

无需代码即可完成MobLink的初始化工作。

ii. 在需要恢复的控制器中实现UIViewController+MLSDKRestore的两个方法，如下图所示：

```
#import <MobLinkPro/UIViewController+MLSDKRestore.h>
```

![](http://wiki.mob.com/wp-content/uploads/2018/10/7631AE5D-3485-444A-8314-BF214DEB123A.png)


在官网后台配置需要还原的类名，如下图，传入路径标识和对应控制器的类名

![](http://wiki.mob.com/wp-content/uploads/2018/10/8AC9FE4B-4197-48FE-87CF-210117AAA859.png)


并实现带有场景参数的初始化方法，并根据场景参数还原该控制器：

```
// 根据场景信息初始化方法
- (instancetype)initWithMobLinkScene:(MLSDKScene *)scene
{
    if (self = [super init])
    {
        self.scene = scene;
    }
    return self;
}
```

关于实现带有场景参数初始化方法的补充：

i.如果您的控制器采用xib的方式来初始化的，那么实现该初始化方法时请参考如下代码：

```
// 根据场景信息初始化方法
- (instancetype)initWithMobLinkScene:(MLSDKScene *)scene
{
    // 使用xib进行初始化
    if (self = [super initWithNibName:@"xib 名称" bundle:nil])
    {
        self.scene = scene;
    }
    return self;
}
```

ii. 获取MobId

```
- (void)getMobId
{
    // 构造自定义参数（可选）
    NSMutableDictionary *customParams = [NSMutableDictionary dictionary];
    customParams[@"key1"] = @"value1";
    customParams[@"key2"] = @"value2";
    // 根据路径、来源以及自定义参数构造scene(3.0.0以下版本)
    //MLSDKScene *scene = [[MLSDKScene alloc] initWithMLSDKPath:@"控制器对应的路径" source:nil params:customParams];
    // 根据路径、自定义参数构造scene （3.0.0以上版本，推荐）
    MLSDKScene *scene = [MLSDKScene sceneForPath:@"已在Mob后台配置的需要还原的控制器对应的路径" params:customParams];

    // 请求MobId
    __weak typeof(self) weakSelf = self;
    [MobLink getMobId:scene result:^(NSString *mobId, NSString *domain, NSError *error) {
        weakSelf.mobid = mobId;
        NSString *msg = mobId == nil ? @"获取Mobid失败" : @"获取Mobid成功";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }];
}
```

<table class="mceItemTable">
<tbody>
<tr>
<th colspan="2" align="center">参数说明</th>
</tr>
<tr>
<td>path</td>
<td>本次生成的mobid所对应的控制器唯一路径，即在Mob后台配置的需要还原的控制器对应的路径或上述第2点中所提及的+ MLSDKPath方法返回的路径。在场景还原时（即客户端还原网页内容）会返回path对应的类名或者根据path寻找匹配的控制器进行还原。</td>
</tr>
<tr>
<td>source</td>
<td>来源标识,可用于在场景还原时辨别来源，例如：传入一个当前控制器名称。（3.0.0版本后，废弃）</td>
</tr>
<tr>
<td>params</td>
<td>字段类型,此时传入的字典数据，在场景还原时能够重新得到，例如：传入一些回复控制器时需要的参数。</td>
</tr>
<tr>
<th colspan="2" align="center">回调值说明</th>
</tr>
<tr>
<td>mobid</td>
<td>生成的mobid可用于拼接到需要进行推广的链接后，例如：http://www.abc.com/?mobid=123456，<strong><span style="color: red;">注意：该网站页面必须集成了JS模块的代码（下文将说明），方可实现网页-应用无缝接合。</span></strong></td>
</tr>
<tr>
<td>domain</td>
<td>domain拼接mobid使用，无网页跳转方式。例如：https://7ne9.t4m.cn/NBjqIj</td>
</tr>
</tbody>
</table>

备注：如果您的页面参数固定，则可以将获取到的这个mobid缓存起来，不用每次都去获取新的mobid以节约时间成本。

到此，最简单的MobLink就集成好了，打开上述集成好JS模块(Web端集成请看下文)并带有mobid的链接即可跳转到您的APP并自动恢复到您实现了恢复方法的控制器中。 请注意：如果您的APP中带有导航控制器（UINavigationController），则恢复时MobLink会采用Push的方式，但是如果您的APP中没有导航控制器，则恢复时MobLink会采用Modal的方式，此时就需要您自行dismiss恢复出来的控制器了。

2、微信小程序分享

MobLink v2.2.0版本开始全平台支持微信小程序，支持一键唤起app，支持参数互传，使用方式如下：

1.获取微信小程序原始ID

在分享到微信小程序之前，我们需要先获取到微信小程序的原始ID，登录微信公众平台，在微信小程序的设置 - 基本设置 - 账号信息下面就可以找到微信小程序的原始ID了，如下图：
![](http://wiki.mob.com/wp-content/uploads/2017/07/Snip20180324_57.png)


提示：微信小程序要关联到微信公众号才能分享的哦！

2.分享到微信小程序

有了上面的微信小程序的原始ID就可以在客户端调用相关分享，将自己的小程序分享到微信里了，具体分享示例代码如下：

```
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDK/NSMutableDictionary+SSDKInit.h>
#import <ShareSDK/NSMutableDictionary+SSDKShare.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>

NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
// 平台参数定制
// webpageUrl: 6.5.6以下版本微信会自动转化为分享链接(必填)
// path: 点击分享卡片时打开微信小程序的页面路径,关于该字段的详细说明见下文
// thumbImage: 分享卡片展示的缩略图
// withShareTicket: 是否携带shareTicket
// miniProgramType: 分享的小程序版本（0-正式，1-开发，2-体验）
// forPlatformSubType: 分享自平台 微信小程序暂只支持 SSDKPlatformSubTypeWechatSession（微信好友分享)
[parameters SSDKSetupWeChatMiniProgramShareParamsByTitle:@"小程序卡片上的标题"
                                             description:@"对小程序的描述内容"
                                              webpageUrl:[NSURL URLWithString:@"http://www.mob.com"]
                                                    path:@"pages/index/index"
                                              thumbImage:[UIImage imageWithName:@"image.png"]
                                                userName:@"微信小程序的原始ID"
                                         withShareTicket:YES
                                         miniProgramType:2 
                                      forPlatformSubType:SSDKPlatformSubTypeWechatSession];
[ShareSDK share:SSDKPlatformSubTypeWechatSession parameters:parameters onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
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
```

关于path的补充：path是指分享到微信的小程序卡片点击后要打开微信小程序的哪个页面，但是这个path是可以像URL一样带参数的，格式：path?query，例如：page/index/index?name=sands，MobLink建议开发者将上述获取mobid部分获取到的mobid作为参数携带上，最后这个path字段传入一个形如：page/index/index?mobid=3Kx5 这样的字符串。

Tips：path参数除了上面说明的那样，还可以携带一些想让微信小程序使用的参数，例如：page/index/index?mobid=3Kx5&articleId=1121，但是值得注意的是不建议直接在path上携带有特殊字符(%,$,&,@...)的字符串！

3.从微信小程序打开app

完成上述步骤之后客户端就搞定了，下面在微信小程序里按照 MobLink 微信小程序集成文档 配置好微信小程序即可！！

### 四、高级功能

1、iOS 高级功能

MobLink在运行的时候会通过delegate将整个运作过程呈现出来，所有的delegate方法都不是必须实现的，但这些delegate能够帮助您实现更多自定义的操作。设定delegate对象的方法如下图：
delegate中各个方法的说明如下：

![](http://wiki.mob.com/wp-content/uploads/2017/06/13.png)

注意：其中将要进行场景恢复的代理方法的回调block有参数增加，需注意修改。

<table class="mceItemTable">
<thead>
<tr>
<th>方法名称</th>
<th>作用说明</th>
</tr>
</thead>
<tbody>
<tr>
<td>- (void)IMLSDKWillRestoreScene:(MLSDKScene *)scene Restore:(void (^)(BOOL isRestore, RestoreStyle style))restoreHandler</td>
<td>即将进行场景还原（注意：一旦实现该方法，请务必执行restoreHandler）<a href="file:///Users/shan/Desktop/MobLink%E9%9B%86%E6%88%90%E5%92%8C%E8%BF%81%E7%A7%BB%E6%96%87%E6%A1%A3-%E6%96%B0%E7%89%88%E6%9C%AC/MobLinkDocument-Swift(%E6%96%B0%E7%89%88%E6%9C%AC).html#will">查看示例</a></td>
</tr>
<tr>
<td>- (void)IMLSDKCompleteResotre:(MLSDKScene *)scene</td>
<td>完成场景恢复 <a href="file:///Users/shan/Desktop/MobLink%E9%9B%86%E6%88%90%E5%92%8C%E8%BF%81%E7%A7%BB%E6%96%87%E6%A1%A3-%E6%96%B0%E7%89%88%E6%9C%AC/MobLinkDocument-Swift(%E6%96%B0%E7%89%88%E6%9C%AC).html#complete">查看示例</a></td>
</tr>
<tr>
<td>- (void)IMLSDKNotFoundScene:(MLSDKScene *)scene</td>
<td>无法进行场景恢复(通常原因是在恢复时找不到对应的path,应检查需要恢复的控制器所实现的+ MLSDKPath中返回的路径是否与生成mobid时的传入的path参数一致) <a href="file:///Users/shan/Desktop/MobLink%E9%9B%86%E6%88%90%E5%92%8C%E8%BF%81%E7%A7%BB%E6%96%87%E6%A1%A3-%E6%96%B0%E7%89%88%E6%9C%AC/MobLinkDocument-Swift(%E6%96%B0%E7%89%88%E6%9C%AC).html#notfound">查看示例</a></td>
</tr>
</tbody>
</table>

开始检测是否需要场景还原示例代码

```
 - (void)IMLSDKStartCheckScene 
 {
     NSLog(@"Start Check Scene");
 }
```

结束检测是否需要场景还原示例代码

```
- (void)IMLSDKEndCheckScene 
{
    NSLog(@"End Check Scene");
}
```
即将进行场景还原示例代码

```
- (void)IMLSDKWillRestoreScene:(MLSDKScene *)scene Restore:(void (^) (BOOL, RestoreStyle))restoreHandler
{
    NSLog(@"Will Restore Scene - Path:%@",scene.path);

    [[MLDTool shareInstance] showAlertWithTitle:nil
                                        message:@"是否进行场景恢复？"
                                    cancelTitle:@"否"
                                     otherTitle:@"是"
                                     clickBlock:^(MLDButtonType type) {
                                         type == MLDButtonTypeSure ? restoreHandler(YES, Default) : restoreHandler(NO, Default);
                                     }];
}
```

场景恢复完成示例代码

```
- (void)IMLSDKCompleteRestore:(MLSDKScene *)scene
{
    NSLog(@"Complete Restore -Path:%@",scene.path);
}
```

找不到场景示例代码

```
- (void)IMLSDKNotFoundScene:(MLSDKScene *)scene
{
    NSLog(@"Not Found Scene - Path :%@",scene.path);

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"没有找到路径"
                                                       message:[NSString stringWithFormat:@"Path:%@",scene.path]
                                                      delegate:self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
    [alertView show];

}

```

### 五.Web集成请参考：[Web端文档](http://wiki.mob.com/moblink-web-doc/)
