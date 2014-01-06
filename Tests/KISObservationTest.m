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
NSString * const k3KeyPaths = @"kvoProperty|kvoProperty1|kvoProperty2";

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

- (void)testInitializer
{
   XCTAssertNoThrow([[KISObservation alloc] initWithObserver:self observed:self options:0 keyPath:kKVOPropertyPath]);
}

- (void)testInitializerWithNilObserver
{
   XCTAssertThrows([[KISObservation alloc] initWithObserver:nil observed:self options:0 keyPath:kKVOPropertyPath]);
}

- (void)testInitializerWithNilObserved
{
   XCTAssertThrows([[KISObservation alloc] initWithObserver:self observed:nil options:0 keyPath:kKVOPropertyPath]);
}

- (void)testInitializerWithEmptyKeyPath
{
   XCTAssertThrows([[KISObservation alloc] initWithObserver:self observed:nil options:0 keyPath:@""]);
}

- (void)testInitializerSetting
{
	KISObservation *observation = [[KISObservation alloc] initWithObserver:self observed:self options:NSKeyValueObservingOptionOld keyPath:kKVOPropertyPath];
	XCTAssertEqual(self, observation.observer, @"The observer should be self");
	XCTAssertEqual(self, observation.observed, @"The observed should be self");
	XCTAssertEqual(NSKeyValueObservingOptionOld, observation.options, @"The options should be NSKeyValueObservingOptionOld");
	XCTAssertEqual(kKVOPropertyPath, observation.keyPath, @"The keyPath should be kKVOPropertyPath");
}

- (void)testNotification
{
   KISObservation *observation = [[KISObservation alloc] initWithObserver:self observed:self options:0 keyPath:kKVOPropertyPath];
	[observation notifyForChange:@{}];
	XCTAssertEqual(self.notificationCount, 1U, @"Should have received one notification");
}

- (void)testNotificationWithNilChange
{
   KISObservation *observation = [[KISObservation alloc] initWithObserver:self observed:self options:0 keyPath:kKVOPropertyPath];
	XCTAssertThrows([observation notifyForChange:nil], @"Should send an exception due to the nil change dir.");
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	XCTAssertEqualObjects(keyPath, @"kvoProperty", @"Should received notifications only for the \"kvoProperty\"");
	XCTAssertEqual(object, self, @"Should received notifications only of itself.");
	self.notificationCount += 1;
}

@end
