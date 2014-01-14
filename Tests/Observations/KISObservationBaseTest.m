//
//  KISObservationBaseTest.m
//  KISObserver
//
//  Created by Romain Lofaso on 12/01/14.
//  Copyright (c) 2014 RomainLo. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "KISObservation.h"

#import "KISKvoObject.h"

@interface KISObservationBaseTest : XCTestCase

@property (nonatomic, strong) KISKvoObject *observer;

@property (nonatomic, strong) KISKvoObject *observed;

@end

@implementation KISObservationBaseTest

- (void)setUp
{
	self.observer = [KISKvoObject new];
	self.observed = [KISKvoObject new];
}

- (void)testInitializer
{
   XCTAssertNoThrow([[KISObservationBase alloc] initWithObserver:self.observed observed:self.observed options:0 keyPaths:kKvoPropertyKeyPath1]);
}

- (void)testInitializerWithNilObserver
{
   XCTAssertThrows([[KISObservationBase alloc] initWithObserver:nil observed:self.observed options:0 keyPaths:kKvoPropertyKeyPath1]);
}

- (void)testInitializerWithNilObserved
{
   XCTAssertThrows([[KISObservationBase alloc] initWithObserver:self.observer observed:nil options:0 keyPaths:kKvoPropertyKeyPath1]);
}

- (void)testInitializerWithEmptyKeyPath
{
   XCTAssertThrows([[KISObservationBase alloc] initWithObserver:self.observed observed:self.observed options:0 keyPaths:@""]);
}

- (void)testInitializerSetting
{
	KISObservationBase *observation = [[KISObservationBase alloc] initWithObserver:self.observer observed:self.observed options:NSKeyValueObservingOptionOld keyPaths:kKvoPropertyKeyPaths];
	XCTAssertEqual(self.observer, observation.observer, @"The observer should be self");
	XCTAssertEqual(self.observed, observation.observed, @"The observed should be self");
	XCTAssertEqual(NSKeyValueObservingOptionOld, observation.options, @"The options should be NSKeyValueObservingOptionOld");
	XCTAssertEqual(kKvoPropertyKeyPaths, observation.keyPaths, @"The keyPath isn't properly set.");
	XCTAssertEqual(2U, observation.keyPathArray.count, @"The keyPathArray isn't properly set.");
}

@end
