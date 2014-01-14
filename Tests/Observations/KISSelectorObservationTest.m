//
//  KISSelectorObservationTest.m
//  KISObserver
//
//  Created by Romain Lofaso on 05/01/14.
//  Copyright (c) 2014 RomainLo. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <OCMock/OCMock.h>

#import "KISSelectorObservation.h"

#import "KISKvoObject.h"

@interface KISSelectorObservationTest : XCTestCase

@property (nonatomic, strong) KISKvoObject *observed;

@property (nonatomic, strong) id observer;

@end

@implementation KISSelectorObservationTest

- (void)setUp
{
	[super setUp];
	self.observer = [OCMockObject mockForClass:[KISKvoObject class]];
	self.observed = [KISKvoObject new];
}

- (void)testInitializer
{
   XCTAssertNoThrow([[KISSelectorObservation alloc] initWithObserver:self.observer observed:self.observed options:NSKeyValueObservingOptionNew keyPaths:kKvoPropertyKeyPath1 selector:@selector(notify)]);
}

- (void)testInitializerWithUnknownSelector
{
   XCTAssertThrows([[KISSelectorObservation alloc] initWithObserver:self.observer observed:self.observed options:NSKeyValueObservingOptionNew keyPaths:kKvoPropertyKeyPath1 selector:@selector(addObjectsFromArray:)], @"Should send an exception because the selector is unknown on the object.");
}

- (void)testInitializerWithTooManyArgumentSelector
{
	XCTAssertThrows([[KISSelectorObservation alloc] initWithObserver:self.observer observed:self.observed options:NSKeyValueObservingOptionNew keyPaths:kKvoPropertyKeyPath1 selector:@selector(_selectorWithObject:change:whatever:)], @"Should send an exception because the selector has more than two parameters.");
}

- (void)testNotificationWithoutArgument
{
	[[self.observer expect] notify];
	KISSelectorObservation *obs __attribute__((unused)) = [[KISSelectorObservation alloc] initWithObserver:self.observer observed:self.observed options:NSKeyValueObservingOptionNew keyPaths:kKvoPropertyKeyPath1 selector:@selector(notify)];
	self.observed.kvoProperty1 = 42;
	[self.observer verify];
}

- (void)testNotificationWithOneArgument
{
	[[self.observer expect] notifyWithObserved:self.observed];
	KISSelectorObservation *obs __attribute__((unused)) = [[KISSelectorObservation alloc] initWithObserver:self.observer observed:self.observed options:NSKeyValueObservingOptionNew keyPaths:kKvoPropertyKeyPath1 selector:@selector(notifyWithObserved:)];
	self.observed.kvoProperty1 = 42;
	[self.observer verify];
}

- (void)testNotificationWithTwoArguments
{
	[[self.observer expect] notifyWithObserved:self.observed change:[OCMArg any]];
	KISSelectorObservation *obs __attribute__((unused)) = [[KISSelectorObservation alloc] initWithObserver:self.observer observed:self.observed options:NSKeyValueObservingOptionNew keyPaths:kKvoPropertyKeyPath1 selector:@selector(notifyWithObserved:change:)];
	self.observed.kvoProperty1 = 42;
	[self.observer verify];
}

- (void)_selectorWithObject:(id)object change:(NSDictionary *)change whatever:(id)whatever
{
	// Should never be called
}

@end
