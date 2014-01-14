//
//  KISObservation.m
//  KISObserver
//
//  Created by Romain Lofaso on 05/01/14.
//  Copyright (c) 2014 RomainLo. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <OCMock/OCMock.h>

#import "KISDefaultObservation.h"

#import "KISKvoObject.h"

@interface KISDefaultObservationTest : XCTestCase

@property (nonatomic, strong) KISKvoObject *observed;

@property (nonatomic, strong) id observer;

@end

@implementation KISDefaultObservationTest

- (void)setUp
{
	[super setUp];
	self.observer = [OCMockObject mockForClass:[KISKvoObject class]];
	self.observed = [KISKvoObject new];
}

- (void)testNotification
{
   KISDefaultObservation *observation __attribute__((unused)) = [[KISDefaultObservation alloc] initWithObserver:self.observer observed:self.observed options:0 keyPaths:kKvoPropertyKeyPath1];
	[[self.observer expect] observeValueForKeyPath:kKvoPropertyKeyPath1 ofObject:self.observed change:[OCMArg any] context:(__bridge void *)(kKISObservationContext)];
	self.observed.kvoProperty1 += 1;
	[self.observer verify];
}

- (void)testNotificationWithManyKeyPaths
{
   KISDefaultObservation *observation __attribute__((unused)) = [[KISDefaultObservation alloc] initWithObserver:self.observer observed:self.observed options:0 keyPaths:kKvoPropertyKeyPaths];
	[[self.observer expect] observeValueForKeyPath:kKvoPropertyKeyPath1 ofObject:self.observed change:[OCMArg any] context:(__bridge void *)(kKISObservationContext)];
	self.observed.kvoProperty1 += 1;
	[self.observer verify];
}

- (void)testNotificationWithObservingOptionInitial
{
	[[self.observer expect] observeValueForKeyPath:kKvoPropertyKeyPaths ofObject:self.observed change:[OCMArg any] context:(__bridge void *)(kKISObservationContext)];
   KISDefaultObservation *observation __attribute__((unused)) = [[KISDefaultObservation alloc] initWithObserver:self.observer observed:self.observed options:NSKeyValueObservingOptionInitial keyPaths:kKvoPropertyKeyPaths];
	[self.observer verify];
}

@end
