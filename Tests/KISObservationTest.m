//
//  KISObservation.m
//  KISObserver
//
//  Created by Romain Lofaso on 05/01/14.
//  Copyright (c) 2014 RomainLo. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "KISObservation.h"

NSString * const kKVOPropertyPath = @"kvoProperty";
NSString * const k3KeyPaths = @"kvoProperty|kvoProperty1|kvoProperty2";

@interface KISObservationTest : XCTestCase

@property (nonatomic, assign) BOOL kvoProperty;

@property (nonatomic, assign) NSUInteger notificationCount;

@end

@implementation KISObservationTest

- (void)setUp
{
	[super setUp];
	self.notificationCount = 0;
}

- (void)testInitializer
{
   XCTAssertNoThrow([[KISObservation alloc] initWithObserver:self observed:self options:0 keyPaths:kKVOPropertyPath]);
}

- (void)testInitializerWithNilObserver
{
   XCTAssertThrows([[KISObservation alloc] initWithObserver:nil observed:self options:0 keyPaths:kKVOPropertyPath]);
}

- (void)testInitializerWithNilObserved
{
   XCTAssertThrows([[KISObservation alloc] initWithObserver:self observed:nil options:0 keyPaths:kKVOPropertyPath]);
}

- (void)testInitializerWithEmptyKeyPath
{
   XCTAssertThrows([[KISObservation alloc] initWithObserver:self observed:nil options:0 keyPaths:@""]);
}

- (void)testInitializerWithOneKeyPath
{
	KISObservation *observation = [[KISObservation alloc] initWithObserver:self observed:self options:0 keyPaths:kKVOPropertyPath];
	XCTAssertEqual(observation.keyPaths.count, 1U, @"Should found 1 keypath within the keypath string.");
}

- (void)testInitializerWithManyKeyPaths
{
	KISObservation *observation = [[KISObservation alloc] initWithObserver:self observed:self options:0 keyPaths:k3KeyPaths];
	XCTAssertEqual(observation.keyPaths.count, 3U, @"Should found 3 keypaths within the keypath string.");
}

- (void)testNotification
{
   KISObservation *observation = [[KISObservation alloc] initWithObserver:self observed:self options:0 keyPaths:kKVOPropertyPath];
	[observation notifyForKeyPath:kKVOPropertyPath change:@{}];
	XCTAssertEqual(self.notificationCount, 1U, @"Should have received one notification");
}

- (void)testNotificationWithWrongKeyPath
{
   KISObservation *observation = [[KISObservation alloc] initWithObserver:self observed:self options:0 keyPaths:kKVOPropertyPath];
	XCTAssertThrows([observation notifyForKeyPath:@"whatEver" change:@{}], @"Should send an exception due to the unknown key path.");
}

- (void)testNotificationWithNilChange
{
   KISObservation *observation = [[KISObservation alloc] initWithObserver:self observed:self options:0 keyPaths:kKVOPropertyPath];
	XCTAssertThrows([observation notifyForKeyPath:kKVOPropertyPath change:nil], @"Should send an exception due to the nil change dir.");
}

- (void)testRemoveOneKeyPath
{
	KISObservation *observation = [[KISObservation alloc] initWithObserver:self observed:self options:0 keyPaths:k3KeyPaths];
	[observation removeKeyPaths:kKVOPropertyPath];
	XCTAssertEqual(observation.keyPaths.count, 2U, @"Should found 2 keypaths after removing one.");
}

- (void)testRemoveUniqueKeyPath
{
	KISObservation *observation = [[KISObservation alloc] initWithObserver:self observed:self options:0 keyPaths:kKVOPropertyPath];
	[observation removeKeyPaths:kKVOPropertyPath];
	XCTAssertEqual(observation.keyPaths.count, 0U, @"Should found 2 keypaths after removing one.");
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	XCTAssertEqualObjects(keyPath, @"kvoProperty", @"Should received notifications only for the \"kvoProperty\"");
	XCTAssertEqual(object, self, @"Should received notifications only of itself.");
	self.notificationCount += 1;
}

@end
