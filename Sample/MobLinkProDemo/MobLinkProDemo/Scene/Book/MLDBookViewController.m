//
//  MLDBookViewController.m
//  MobLinkProDemo
//
//  Created by lujh on 2018/12/11.
//  Copyright © 2018 mob. All rights reserved.
//

#import "MLDBookViewController.h"

// parser
#import "MLDBookParser.h"
#import "MLDReadOperation.h"

// content controller
#import "MLDBookPresentationTableViewController.h"

// model
#import "MLDBookModel.h"
#import "MLDMarkModel.h"
#import "MLDChapterModel.h"

// share
#import "MLDTool.h"
#import "MLDUserManager.h"

// MobLinkPro
#import <MobLinkPro/MLSDKScene.h>
#import <MobLinkPro/UIViewController+MLSDKRestore.h>

@interface MLDBookViewController ()

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) MLDBookModel *bookModel;

@property (nonatomic, strong) MLDMarkModel *markModel;

@property (nonatomic, strong) MLSDKScene *scene;

@end

@implementation MLDBookViewController

- (instancetype)initWithMobLinkScene:(MLSDKScene *)scene
{
    if (self = [super init])
    {
        self.scene = scene;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 拿到场景信息后，创建小说展示页面
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 30, 30);
    [rightBtn setImage:[UIImage imageNamed:@"fx"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(shareItemClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *shareItme = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = shareItme;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    [self setupUI];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.scene)
        {
//            [[MLDTool shareInstance] showAlertWithScene:self.scene];
        }
    });
}

- (void)setupUI
{
    if (self.scene)
    {
        if (self.scene.params[@"novel"])
        {
            NSDictionary *novelDict = self.dataArray[[self.scene.params[@"novel"] integerValue]];
            self.markModel = [[MLDMarkModel alloc] init];
            self.markModel.bookID = novelDict[@"title"];
            self.markModel.chapterID = self.scene.params[@"section"];
            if (!self.scene.params[@"section"])
            {
                self.markModel.chapterID = @"1";
            }
            else
            {
                self.markModel.chapterID = self.scene.params[@"section"];
            }
            self.markModel.readPercent = [self.scene.params[@"percent"] floatValue] * 0.01;
            // 读取资源
            self.novelDict = self.dataArray[[self.scene.params[@"novel"] integerValue]];
        }
    }
}

- (void)shareItemClick:(UIButton *)shareBtn
{
    NSString *bookID = self.novelDict[@"bookID"];
    
    if (!bookID)
    {
        bookID = @"0";
    }
    NSString *path = [NSString stringWithFormat:@"/scene/novel/%@?", bookID];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([MLDUserManager sharedManager].currentUserId)
    {
        [params addEntriesFromDictionary:@{@"id" : [MLDUserManager sharedManager].currentUserId}];
    }
    [params addEntriesFromDictionary:@{@"scene" : @(MLDSceneTypeNovel)}];
    [params addEntriesFromDictionary:@{@"novel" : bookID}];
    
    // 先读取缓存的mobid,缓存没有再进行网络请求
    NSString *cacheMobid = [[MLDTool shareInstance] mobidForKeyPath:path];
    NSString *title = self.novelDict[@"title"];
    NSString *text = self.novelDict[@"describe"];
    NSString *image = self.novelDict[@"imageName"];
    
    if (cacheMobid)
    {
        [[MLDTool shareInstance] shareWithMobId:cacheMobid
                                          title:title
                                           text:text
                                          image:image
                                           path:path
                                         onView:shareBtn];
    }
    else
    {
        [[MLDTool shareInstance] getMobidWithPath:path
                                           params:params
                                           result:^(NSString *mobid, NSString *domain, NSError *error) {
            if (error) {
                UIAlertControllerAlertCreate(@"错误", [NSString stringWithFormat:@"%@",error.userInfo])
                .addCancelAction(@"OK")
                .present();
                return;
            }
                                               // 先缓存mobid,如果有的话
                                               if (mobid)
                                               {
                                                   [[MLDTool shareInstance] cacheMobid:mobid forKeyPath:path];
                                               }
                                               
                                               [[MLDTool shareInstance] shareWithMobId:mobid
                                                                                 title:title
                                                                                  text:text
                                                                                 image:image
                                                                                  path:path
                                                                                onView:shareBtn];
                                           }];
    }
    
}

- (void)createPresentationController:(MLDMarkModel *)markModel
{
    MLDReadOperation *readOperation = [[MLDReadOperation alloc] initWithBookViewController:self];
    MLDBookPresentationTableViewController *presentationController = [readOperation presentationViewController:markModel];
    
    [self.view insertSubview:presentationController.view atIndex:0];
    [self addChildViewController:presentationController];
}

- (void)setNovelDict:(NSDictionary *)novelDict
{
    if (_novelDict != novelDict)
    {
        _novelDict = novelDict;
        
        self.title = novelDict[@"title"];
        // 读取资源
        [self readBookResourceWithBookName:novelDict[@"title"]];
    }
}

- (void)readBookResourceWithBookName:(NSString *)bookName
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:bookName withExtension:@"txt"];
    
    if (url)
    {
        self.bookModel = [MLDBookParser parserBookWithLocalPath:url];
        
        if (self.markModel)
        {
            NSInteger pageCount = self.bookModel.readMarkModel.chapterModel.pageCount;
            
            self.markModel.page = pageCount * self.markModel.readPercent;
            if (self.markModel.page == pageCount)
            {
                self.markModel.page--;
            }
             // 设置当前页面
            [self.markModel modifyWithChapterID:self.markModel.chapterID page:self.markModel.page];
            
            [self createPresentationController:self.markModel];
        }
        else
        {
            [self createPresentationController:self.bookModel.readMarkModel];
        }
    }
    else
    {
        //提示找不到书籍
    }
}

- (NSArray *)dataArray
{
    if (_dataArray == nil)
    {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"NovelList" ofType:@"plist"];
        _dataArray = [NSArray arrayWithContentsOfFile:filePath];
    }
    return _dataArray;
}

@end
