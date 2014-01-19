//
//  KISBlockObservationTest.m
//  KISObserver
//
//  Created by Romain Lofaso on 05/01/14.
//  Copyright (c) 2014 RomainLo. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "KISBlockObservation.h"

#import "KISKvoObject.h"

@interface KISBlockObservationTest : XCTestCase

@property (nonatomic, strong) KISKvoObject *observed;

@end

@implementation KISBlockObservationTest

- (void)setUp
{
	[super setUp];
	self.observed = [KISKvoObject new];
}

- (void)testInitializer
{
	XCTAssertNoThrow([[KISBlockObservation alloc] initWithObserver:self observed:self.observed options:NSKeyValueObservingOptionInitial keyPaths:kKvoPropertyKeyPath1 block:^(KISNotification *notification) {}], @"Should not throw exception.");
}

- (void)testInitializerWithNilBlock
{
	XCTAssertThrows([[KISBlockObservation alloc] initWithObserver:self observed:self.observed options:NSKeyValueObservingOptionInitial keyPaths:kKvoPropertyKeyPath1 block:nil], @"Should throw an exception because the block is nil.");
}

- (void)testNotification
{
	__block NSUInteger kvoTriggeredCount = 0;
	KISBlockObservation *observation __attribute__((unused)) = [[KISBlockObservation alloc] initWithObserver:self observed:self.observed options:0 keyPaths:kKvoPropertyKeyPath1 block:^(KISNotification *notification) {
		kvoTriggeredCount += 1;
	}];
	self.observed.kvoProperty1 = 42;
	XCTAssertEqual(kvoTriggeredCount, 1U, @"The observation should have call the block once.");
}


@end
