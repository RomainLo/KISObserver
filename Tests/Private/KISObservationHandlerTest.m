//
//  KISObserverTest.m
//  KISObserver
//
//  Created by Romain Lofaso on 05/01/14.
//  Copyright (c) 2014 RomainLo. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <OCMock/OCMock.h>

#import "KISBlockObservation.h"
#import "KISObservationHandler.h"
#import "KISKvoObject.h"

@interface KISObservationHandlerTest : XCTestCase

@property (nonatomic, strong) KISKvoObject *observed;

@property (nonatomic, strong) KISObservationHandler *observer;

@property (nonatomic, strong) KISBlockObservation *observation;

@property (nonatomic, assign) NSUInteger notificationCount;

@end

@implementation KISObservationHandlerTest

- (void)setUp
{
	[super setUp];
	self.notificationCount = 0;
	self.observed = [KISKvoObject new];
	self.observer = [[KISObservationHandler alloc] init];
	self.observation = [[KISBlockObservation alloc] initWithObserver:self observable:self.observed options:0 keyPath:kKvoPropertyKeyPath1 block:^(KISNotification *notification) {
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
	
	self.observed.kvoProperty1 = YES;
	XCTAssertEqual(self.notificationCount, 1U, @"Should be notified twice since the observation is add twice.");
}

#pragma mark - Remove

- (void)testRemoveOnNil
{
	KISBlockObservation *obs1 = [[KISBlockObservation alloc] initWithObserver:self observable:self.observed options:0 keyPath:kKvoPropertyKeyPath1 block:^(KISNotification *notification) {}];
	[self.observer addObservation:obs1];
	XCTAssertNoThrow([self.observer removeObservationOfObject:nil]);
	XCTAssertEqual(self.observer.observations.count, 1U);
}

- (void)testRemoveOnNonObserved
{
	KISBlockObservation *obs1 = [[KISBlockObservation alloc] initWithObserver:self observable:self.observed options:0 keyPath:kKvoPropertyKeyPath1 block:^(KISNotification *notification) {}];
	[self.observer addObservation:obs1];
	[self.observer removeObservationOfObject:self];
	XCTAssertEqual(self.observer.observations.count, 1U);
}

- (void)testRemoveOnObservable
{
	KISBlockObservation *obs1 = [[KISBlockObservation alloc] initWithObserver:self observable:self.observed options:0 keyPath:kKvoPropertyKeyPath1 block:^(KISNotification *notification) {}];
	KISBlockObservation *obs2 = [[KISBlockObservation alloc] initWithObserver:self observable:self.observed options:0 keyPath:kKvoPropertyKeyPath1 block:^(KISNotification *notification) {}];
	KISBlockObservation *obs3 = [[KISBlockObservation alloc] initWithObserver:self observable:self options:0 keyPath:kKvoPropertyKeyPath1 block:^(KISNotification *notification) {}];
	[self.observer addObservation:obs1];
	[self.observer addObservation:obs2];
	[self.observer addObservation:obs3];
	[self.observer removeObservationOfObject:self.observed];
	XCTAssertEqual(self.observer.observations.count, 1U);
}

- (void)testRemove
{
	[self.observer addObservation:self.observation];
	[self.observer removeObservationOfObject:self.observation.observable forKeyPath:self.observation.keyPath];
	XCTAssertEqual(self.observer.observations.count, 0U, @"Should have only the element.");
}

- (void)testRemoveUnknownObservation
{
	XCTAssertNoThrow([self.observer removeObservationOfObject:self.observation.observable forKeyPath:self.observation.keyPath]);
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
	self.observed.kvoProperty1 = YES; // Try to trigger the KVO
	XCTAssertEqual(self.notificationCount, 0U, @"Shouldn't be notified by the notification because it is deallocated.");
}

#pragma mark - isObserving

- (void)testIsObserving
{
	[self.observer addObservation:self.observation];
	XCTAssertTrue([self.observer isObservingObject:self.observation.observable forKeyPath:kKvoPropertyKeyPath1], @"Should observe the given object.");
}

- (void)testIsNOTObservingKeyPath
{
	[self.observer addObservation:self.observation];
	XCTAssertFalse([self.observer isObservingObject:self.observation.observable forKeyPath:kKvoPropertyKeyPaths], @"Should NOT observe this path.");
}

- (void)testIsNOTObservingObject
{
	[self.observer addObservation:self.observation];
	XCTAssertFalse([self.observer isObservingObject:self forKeyPath:kKvoPropertyKeyPath1], @"Should NOT observe this object.");
}


@end
