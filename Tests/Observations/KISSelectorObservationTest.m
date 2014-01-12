//
//  KISSelectorObservationTest.m
//  KISObserver
//
//  Created by Romain Lofaso on 05/01/14.
//  Copyright (c) 2014 RomainLo. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "KISSelectorObservation.h"

NSString * const kSelectorKVOPropertyPath = @"kvoProperty";

@interface KISSelectorObservationTest : XCTestCase

@property (nonatomic, assign) BOOL kvoProperty;

@property (nonatomic, assign) NSUInteger selectorMark;

@end

@implementation KISSelectorObservationTest

- (void)setUp
{
	[super setUp];
	self.selectorMark = 0;
}

- (void)testInitializer
{
   XCTAssertNoThrow([[KISSelectorObservation alloc] initWithObserver:self observed:self options:NSKeyValueObservingOptionNew keyPaths:kSelectorKVOPropertyPath selector:@selector(_selector)]);
}

- (void)testInitializerWithUnknownSelector
{
   XCTAssertThrows([[KISSelectorObservation alloc] initWithObserver:self observed:self options:NSKeyValueObservingOptionNew keyPaths:kSelectorKVOPropertyPath selector:@selector(addObjectsFromArray:)], @"Should send an exception because the selector is unknown on the object.");
}

- (void)testInitializerWithTooManyArgumentSelector
{
   XCTAssertThrows([[KISSelectorObservation alloc] initWithObserver:self observed:self options:NSKeyValueObservingOptionNew keyPaths:kSelectorKVOPropertyPath selector:@selector(_selectorWithObject:change:whatever:)], @"Should send an exception because the selector has more than two parameters.");
}

- (void)testNotificationWithoutArgument
{
	KISSelectorObservation *obs __attribute__((unused)) = [[KISSelectorObservation alloc] initWithObserver:self observed:self options:NSKeyValueObservingOptionNew keyPaths:kSelectorKVOPropertyPath selector:@selector(_selector)];
	self.kvoProperty = YES;
	XCTAssertTrue(self.selectorMark & 1, @"Should have call the selector without parameter.");
}

- (void)testNotificationWithOneArgument
{
	KISSelectorObservation *obs __attribute__((unused)) = [[KISSelectorObservation alloc] initWithObserver:self observed:self options:NSKeyValueObservingOptionNew keyPaths:kSelectorKVOPropertyPath selector:@selector(_selectorWithObject:)];
	self.kvoProperty = YES;
	XCTAssertTrue(self.selectorMark & (1 << 1), @"Should have call the selector with one parameter.");
}

- (void)testNotificationWithTwoArguments
{
	KISSelectorObservation *obs __attribute__((unused)) = [[KISSelectorObservation alloc] initWithObserver:self observed:self options:NSKeyValueObservingOptionNew keyPaths:kSelectorKVOPropertyPath selector:@selector(_selectorWithObject:change:)];
	self.kvoProperty = YES;
	XCTAssertTrue(self.selectorMark & (1 << 2), @"Should have call the selector with two parameters.");
}

- (void)_selector
{
	self.selectorMark = self.selectorMark | 1;
}

- (void)_selectorWithObject:(id)object
{
	XCTAssertEqual(self, object, @"Should give self in parameter.");
	self.selectorMark = self.selectorMark | (1 << 1);
}

- (void)_selectorWithObject:(id)object change:(NSDictionary *)change
{
	XCTAssertEqual(self, object, @"Should give self in parameter.");
	self.selectorMark = self.selectorMark | (1 << 2);
}

- (void)_selectorWithObject:(id)object change:(NSDictionary *)change whatever:(id)whatever
{
	// Should never be called
}

@end
