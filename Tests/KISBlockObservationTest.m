//
//  KISBlockObservationTest.m
//  KISObserver
//
//  Created by Romain Lofaso on 05/01/14.
//  Copyright (c) 2014 RomainLo. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "KISObservation.h"

NSString * const kBlockKVOPropertyPath = @"kvoProperty";

@interface KISBlockObservationTest : XCTestCase

@property (nonatomic, assign) NSUInteger notificationCount;

@end

@implementation KISBlockObservationTest

- (void)setUp
{
	[super setUp];
	self.notificationCount = 0;
}

- (void)testInitializer
{
	XCTAssertNoThrow([[KISBlockObservation alloc] initWithObserver:self observed:self options:NSKeyValueObservingOptionInitial keyPath:kBlockKVOPropertyPath block:^(__weak id observed, NSDictionary *change) {}], @"Should not throw exception.");
}

- (void)testInitializerWithNilBlock
{
	XCTAssertThrows([[KISBlockObservation alloc] initWithObserver:self observed:self options:NSKeyValueObservingOptionInitial keyPath:kBlockKVOPropertyPath block:nil], @"Should throw an exception because the block is nil.");
}

- (void)testNotification
{
	KISBlockObservation *observation = [[KISBlockObservation alloc] initWithObserver:self observed:self options:NSKeyValueObservingOptionInitial keyPath:kBlockKVOPropertyPath block:^(__weak id observed, NSDictionary *change) {
		self.notificationCount += 1;
	}];
	[observation notifyForChange:@{}];
	XCTAssertEqual(self.notificationCount, 1U, @"The observation should have call the block once.");
}


@end
