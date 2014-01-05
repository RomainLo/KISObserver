//
//  KISObservation.m
//  KISObserver
//
//  Created by Romain Lofaso on 05/01/14.
//  Copyright (c) 2014 RomainLo. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "KISObservation.h"

NSString * const kKVOPropertyPath = @"kvoProperty";

@interface KISObservationTest : XCTestCase

@property (nonatomic, assign) BOOL kvoProperty;

@property (nonatomic, assign) NSUInteger notificationCount;

@end

@implementation KISObservationTest

- (void)setUp
{
	[super setUp];
	self.notificationCount = 0;
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testInitializer
{
   XCTAssertNoThrow([[KISObservation alloc] initWithObserver:self observed:self options:0 keyPaths:kKVOPropertyPath]);
}

- (void)testInitializerWithNilObserver
{
   XCTAssertThrows([[KISObservation alloc] initWithObserver:nil observed:self options:0 keyPaths:kKVOPropertyPath]);
}

- (void)testInitializerWithNilObserved
{
   XCTAssertThrows([[KISObservation alloc] initWithObserver:self observed:nil options:0 keyPaths:kKVOPropertyPath]);
}

- (void)testInitializerWithEmptyKeyPath
{
   XCTAssertThrows([[KISObservation alloc] initWithObserver:self observed:nil options:0 keyPaths:@""]);
}

- (void)testNotification
{
   KISObservation *observation = [[KISObservation alloc] initWithObserver:self observed:self options:0 keyPaths:kKVOPropertyPath];
	[observation notifyForKeyPath:kKVOPropertyPath change:@{}];
	XCTAssertEqual(self.notificationCount, (NSUInteger)1, @"Should have received one notification");
}

- (void)testNotificationWithWrongKeyPath
{
   KISObservation *observation = [[KISObservation alloc] initWithObserver:self observed:self options:0 keyPaths:kKVOPropertyPath];
	XCTAssertThrows([observation notifyForKeyPath:@"whatEver" change:@{}], @"Should send an exception due to the unknown key path.");
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	XCTAssertEqualObjects(keyPath, @"kvoProperty", @"Should received notifications only for the \"kvoProperty\"");
	XCTAssertEqual(object, self, @"Should received notifications only of itself.");
	self.notificationCount += 1;
}

@end
