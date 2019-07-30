//
//  MobLinkProDemoTests.m
//  MobLinkProDemoTests
//
//  Created by lujh on 2018/12/10.
//  Copyright © 2018 mob. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <MobLinkPro/MobLink.h>
#import <MobLinkPro/MLSDKScene.h>

@interface MobLinkProDemoTests : XCTestCase<IMLSDKRestoreDelegate>

@end

@implementation MobLinkProDemoTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}


#pragma mark - 获取mobid
//序号1
- (void)testGetMobID_StandardParams
{
    sleep(2);
    MLSDKScene *scene = [MLSDKScene sceneForPath:@"/abc/123" params:@{@"key":@"value"}];
    
    XCTestExpectation *exp = [self expectationWithDescription:@"testGetMobID_StandardParams"];
    
    [MobLink getMobId:scene result:^(NSString *mobid, NSString *domain, NSError *error) {
        XCTAssertNotNil(mobid,@"获取mobid失败");
        
        NSLog(@"mobid:%@",mobid);
        
        [exp fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
        NSLog(@"%@", error);
    }];
}

//序号2
- (void)testGetMobID_NilParams
{
    sleep(2);
    XCTestExpectation *exp = [self expectationWithDescription:@"testGetMobID_NilParams"];
    
    [MobLink getMobId:nil result:^(NSString *mobid, NSString *domain, NSError *error) {
        XCTAssertNil(mobid,@"不应该有mobid");
        [exp fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
        NSLog(@"%@", error);
    }];
    
}
//序号3
- (void)testGetMobID_UselessParams
{
    sleep(2);
    XCTestExpectation *exp = [self expectationWithDescription:@"testGetMobID_UselessParams"];
    
    [MobLink getMobId:[[MLSDKScene alloc] init] result:^(NSString *mobid, NSString *domain, NSError *error) {
        XCTAssertNil(mobid,@"不应该有mobid");
        [exp fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark - 设置委托
- (void)testSetDelegate
{
    [MobLink setDelegate:self];
}

- (void)testSetDelegate_nil
{
    [MobLink setDelegate:nil];
}



@end
