//
//  KISObserverTest.m
//  KISObserver
//
//  Created by Romain Lofaso on 05/01/14.
//  Copyright (c) 2014 RomainLo. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "KISBlockObservation.h"
#import "KISObserver.h"

NSString * const kObserverKVOProperty = @"kvoProperty";

@interface KISObserverTest : XCTestCase

@property (nonatomic, strong) KISObserver *observer;

@property (nonatomic, strong) KISBlockObservation *observation;

@property (nonatomic, assign) NSUInteger notificationCount;

@property (nonatomic, assign) BOOL kvoProperty;

@end

@implementation KISObserverTest

- (void)setUp
{
	[super setUp];
	self.notificationCount = 0;
	self.kvoProperty = NO;
	self.observer = [[KISObserver alloc] init];
	self.observation = [[KISBlockObservation alloc] initWithObserver:self observed:self options:0 keyPaths:kObserverKVOProperty block:^(__weak id observed, NSDictionary *change) {
		self.notificationCount += 1;
	}];
}

- (void)testAddObservations
{
	[self.observer addObservation:self.observation];
	XCTAssertEqual(self.observer.observations.count, 1U, @"Should have two elements that we have just added.");
}

- (void)testNotification
{
	[self.observer addObservation:self.observation];
	self.observation = nil; // the observer should retain the observation.
	
	self.kvoProperty = YES;
	XCTAssertEqual(self.notificationCount, 1U, @"Should be notified twice since the observation is add twice.");
}

- (void)testRemove
{
	[self.observer addObservation:self.observation];
	[self.observer removeObservationOfObject:self.observation.observed forKeyPaths:self.observation.keyPaths];
	XCTAssertEqual(self.observer.observations.count, 0U, @"Should have only the element.");
}

- (void)testRemoveUnknownObservation
{
	XCTAssertNoThrow([self.observer removeObservationOfObject:self.observation.observed forKeyPaths:self.observation.keyPaths]);
}

- (void)testRemoveAll
{
	[self.observer addObservation:self.observation];
	[self.observer removeAllObservations];
	XCTAssertEqual(self.observer.observations.count, 0U, @"Should have only the element.");
}

- (void)testDeallocShouldRemoveAll
{
	[self.observer addObservation:self.observation];
	self.observation = nil; // the observer should retain the observation.
	self.observer = nil; // Anything should retain the observation.
	self.kvoProperty = YES; // Try to trigger the KVO
	XCTAssertEqual(self.notificationCount, 0U, @"Shouldn't be notified by the notification because it is deallocated.");
}


@end
