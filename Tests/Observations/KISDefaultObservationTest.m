//
//  KISObservation.m
//  KISObserver
//
//  Created by Romain Lofaso on 05/01/14.
//  Copyright (c) 2014 RomainLo. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "KISDefaultObservation.h"

NSString * const kDefaultKVOPropertyPath = @"kvoProperty";
NSString * const kDefault3KeyPaths = @"kvoProperty|kvoProperty1|kvoProperty2";

@interface KISDefaultObservationTest : XCTestCase

@property (nonatomic, assign) BOOL kvoProperty;

@property (nonatomic, assign) NSUInteger notificationCount;

@end

@implementation KISDefaultObservationTest

- (void)setUp
{
	[super setUp];
	self.notificationCount = 0;
}

- (void)testNotification
{
   KISDefaultObservation *observation __attribute__((unused)) = [[KISDefaultObservation alloc] initWithObserver:self observed:self options:0 keyPaths:kDefaultKVOPropertyPath];
	self.kvoProperty = YES;
	XCTAssertEqual(self.notificationCount, 1U, @"Should have received one notification");
}

- (void)testNotificationWithManyKeyPaths
{
   KISDefaultObservation *observation __attribute__((unused)) = [[KISDefaultObservation alloc] initWithObserver:self observed:self options:0 keyPaths:kDefault3KeyPaths];
	self.kvoProperty = YES;
	XCTAssertEqual(self.notificationCount, 1U, @"Should have received one notification");
}

- (void)testNotificationWithObservingOptionInitial
{
   KISDefaultObservation *observation __attribute__((unused)) = [[KISDefaultObservation alloc] initWithObserver:self observed:self options:NSKeyValueObservingOptionInitial keyPaths:kDefaultKVOPropertyPath];
	XCTAssertEqual(self.notificationCount, 1U, @"Should have received one notification");
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	self.notificationCount += 1;
}

@end
