//
//  KISObservationBaseTest.m
//  KISObserver
//
//  Created by Romain Lofaso on 12/01/14.
//  Copyright (c) 2014 RomainLo. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "KISObservation.h"

NSString * const kKVOPropertyPath = @"kvoProperty";
NSString * const k3KeyPaths = @"kvoProperty|kvoProperty1|kvoProperty2";

@interface KISObservationBaseTest : XCTestCase

@end

@implementation KISObservationBaseTest

- (void)testInitializer
{
   XCTAssertNoThrow([[KISObservationBase alloc] initWithObserver:self observed:self options:0 keyPaths:kKVOPropertyPath]);
}

- (void)testInitializerWithNilObserver
{
   XCTAssertThrows([[KISObservationBase alloc] initWithObserver:nil observed:self options:0 keyPaths:kKVOPropertyPath]);
}

- (void)testInitializerWithNilObserved
{
   XCTAssertThrows([[KISObservationBase alloc] initWithObserver:self observed:nil options:0 keyPaths:kKVOPropertyPath]);
}

- (void)testInitializerWithEmptyKeyPath
{
   XCTAssertThrows([[KISObservationBase alloc] initWithObserver:self observed:nil options:0 keyPaths:@""]);
}

- (void)testInitializerSetting
{
	KISObservationBase *observation = [[KISObservationBase alloc] initWithObserver:self observed:self options:NSKeyValueObservingOptionOld keyPaths:kKVOPropertyPath];
	XCTAssertEqual(self, observation.observer, @"The observer should be self");
	XCTAssertEqual(self, observation.observed, @"The observed should be self");
	XCTAssertEqual(NSKeyValueObservingOptionOld, observation.options, @"The options should be NSKeyValueObservingOptionOld");
	XCTAssertEqual(kKVOPropertyPath, observation.keyPaths, @"The keyPath should be kKVOPropertyPath");
}

- (void)testInitializerManyKeyPaths
{
	KISObservationBase *observation = [[KISObservationBase alloc] initWithObserver:self observed:self options:NSKeyValueObservingOptionOld keyPaths:k3KeyPaths];
	XCTAssertEqual(3U, observation.keyPathArray.count, @"The keyPath should be kKVOPropertyPath");
}


@end
