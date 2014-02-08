//
//  KISNotificationTest.m
//  KISObserver
//
//  Created by Romain Lofaso on 20/01/14.
//  Copyright (c) 2014 RomainLo. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "KISNotification.h"

#import "KISKvoObject.h"

static NSString * const kKvoObjectKey = @"kvoObject";

static NSString * const kKvoArrayKey = @"kvoArray";

@interface KISNotificationTest : XCTestCase

@end

@implementation KISNotificationTest

- (void)testInitializer
{
	NSMutableDictionary *changes = [[NSMutableDictionary alloc] initWithCapacity:0];
	NSDictionary *copiedChanges = [changes copy];
	NSMutableString *keyPath = [[NSMutableString alloc] initWithString:@"keypath"];
	NSString *copiedKeypath = [keyPath copy];
	
	KISNotification *notif = [[KISNotification alloc] initWithObservable:self keyPath:keyPath change:changes];
	XCTAssertEqual(self, notif.observable, @"The observable should be set into the initilizer.");
	XCTAssertEqualObjects(keyPath, notif.keyPath, @"The keyPath should be set into the initilizer.");
	XCTAssertEqualObjects(changes, notif.change, @"The change should be set into the initilizer.");
	
	[changes setObject:@"AA" forKey:@"BB"];
	[keyPath appendString:@"aa"];
	XCTAssertEqualObjects(copiedKeypath, notif.keyPath, @"The keyPath should be copied into the initilizer.");
	XCTAssertEqualObjects(copiedChanges, notif.change, @"The change should be copied into the initilizer.");
}

- (void)testWrongInitializerWithNilArguments
{
	XCTAssertThrows([[KISNotification alloc] initWithObservable:nil keyPath:@"keypath" change:@{}], @"The first parameter should not be accepted.");
	XCTAssertThrows([[KISNotification alloc] initWithObservable:self keyPath:@"" change:@{}], @"The second parameter should not be accepted.");
	XCTAssertThrows([[KISNotification alloc] initWithObservable:self keyPath:@"keypath" change:nil], @"The third parameter should not be accepted.");
}

- (void)testNotificationForSettingKind
{
	KISKvoObject *newValue = [KISKvoObject new];
	NSDictionary *change = @{
		NSKeyValueChangeKindKey: @(NSKeyValueChangeSetting),
		NSKeyValueChangeNewKey: newValue
	};
	KISNotification *notif = [[KISNotification alloc] initWithObservable:self keyPath:kKvoObjectKey change:change];
	XCTAssertTrue(notif.isSetting, @"Should be a setting notification.");
	XCTAssertFalse(notif.isPrior, @"Should not be a prior notification.");
	XCTAssertEqual(notif.newValue, newValue, @"Should be the newValue object.");
	XCTAssertNil(notif.oldValue, @"Should be nil because there is no oldvalue.");
	XCTAssert(notif.insertionIndexSet.count == 0, @"Should haven't got something to insert.");
	XCTAssert(notif.removalIndexSet.count == 0, @"Should haven't got something to remove.");
	XCTAssert(notif.replacementIndexSet.count == 0, @"Should haven't got something to replace.");
}


- (void)testNotificationForPriorKind
{
	KISKvoObject *oldValue = [KISKvoObject new];
	NSDictionary *change = @{
									 NSKeyValueChangeKindKey: @(NSKeyValueChangeSetting),
									 NSKeyValueChangeOldKey: oldValue,
									 NSKeyValueChangeNotificationIsPriorKey: @YES
									 };
	KISNotification *notif = [[KISNotification alloc] initWithObservable:self keyPath:kKvoObjectKey change:change];
	XCTAssertTrue(notif.isSetting, @"Should be a setting notification.");
	XCTAssertTrue(notif.isPrior, @"Should not be a prior notification.");
	XCTAssertEqual(notif.oldValue, oldValue, @"Should be the oldValue object.");
	XCTAssert(notif.insertionIndexSet.count == 0, @"Should haven't got something to insert.");
	XCTAssert(notif.removalIndexSet.count == 0, @"Should haven't got something to remove.");
	XCTAssert(notif.replacementIndexSet.count == 0, @"Should haven't got something to replace.");
}

- (void)testNotificationWithNewOldValue
{
	KISKvoObject *newValue = [KISKvoObject new];
	KISKvoObject *oldValue = [KISKvoObject new];
	NSDictionary *change = @{
									 NSKeyValueChangeKindKey: @(NSKeyValueChangeSetting),
									 NSKeyValueChangeOldKey: oldValue,
									 NSKeyValueChangeNewKey: newValue
									 };
	KISNotification *notif = [[KISNotification alloc] initWithObservable:self keyPath:kKvoObjectKey change:change];
	XCTAssertTrue(notif.isSetting, @"Should be a setting notification.");
	XCTAssertFalse(notif.isPrior, @"Should not be a prior notification.");
	XCTAssertEqual(notif.oldValue, oldValue, @"Should be the oldValue object.");
	XCTAssertEqual(notif.newValue, newValue, @"Should be the newValue object.");
	XCTAssert(notif.insertionIndexSet.count == 0, @"Should haven't got something to insert.");
	XCTAssert(notif.removalIndexSet.count == 0, @"Should haven't got something to remove.");
	XCTAssert(notif.replacementIndexSet.count == 0, @"Should haven't got something to replace.");
}

- (void)testNotificationForInsertion
{
	NSIndexSet *indexes = [[NSIndexSet alloc] initWithIndex:1];
	NSDictionary *change = @{
									 NSKeyValueChangeKindKey: @(NSKeyValueChangeInsertion),
									 NSKeyValueChangeIndexesKey: indexes
									 };
	KISNotification *notif = [[KISNotification alloc] initWithObservable:self keyPath:kKvoObjectKey change:change];
	XCTAssertFalse(notif.isSetting, @"Should be a setting notification.");
	XCTAssertFalse(notif.isPrior, @"Should not be a prior notification.");
	XCTAssertNil(notif.oldValue, @"Should NOT be set.");
	XCTAssertNil(notif.newValue, @"Should NOT be set.");
	XCTAssertEqual(notif.insertionIndexSet, indexes, @"Shoud be equal to indexes since we insert something in an array.");
	XCTAssert(notif.removalIndexSet.count == 0, @"Should haven't got something to remove.");
	XCTAssert(notif.replacementIndexSet.count == 0, @"Should haven't got something to replace.");
}

- (void)testNotificationForRemoval
{
	NSIndexSet *indexes = [[NSIndexSet alloc] initWithIndex:1];
	NSDictionary *change = @{
									 NSKeyValueChangeKindKey: @(NSKeyValueChangeRemoval),
									 NSKeyValueChangeIndexesKey: indexes
									 };
	KISNotification *notif = [[KISNotification alloc] initWithObservable:self keyPath:kKvoObjectKey change:change];
	XCTAssertFalse(notif.isSetting, @"Should be a setting notification.");
	XCTAssertFalse(notif.isPrior, @"Should not be a prior notification.");
	XCTAssertNil(notif.oldValue, @"Should NOT be set.");
	XCTAssertNil(notif.newValue, @"Should NOT be set.");
	XCTAssertEqual(notif.removalIndexSet, indexes, @"Shoud be equal to indexes since we remove something in an array.");
	XCTAssert(notif.insertionIndexSet.count == 0, @"Should haven't got something to insert.");
	XCTAssert(notif.replacementIndexSet.count == 0, @"Should haven't got something to replace.");
}

- (void)testNotificationForReplacement
{
	NSIndexSet *indexes = [[NSIndexSet alloc] initWithIndex:1];
	NSDictionary *change = @{
									 NSKeyValueChangeKindKey: @(NSKeyValueChangeReplacement),
									 NSKeyValueChangeIndexesKey: indexes
									 };
	KISNotification *notif = [[KISNotification alloc] initWithObservable:self keyPath:kKvoObjectKey change:change];
	XCTAssertFalse(notif.isSetting, @"Should be a setting notification.");
	XCTAssertFalse(notif.isPrior, @"Should not be a prior notification.");
	XCTAssertNil(notif.oldValue, @"Should NOT be set.");
	XCTAssertNil(notif.newValue, @"Should NOT be set.");
	XCTAssert(notif.insertionIndexSet.count == 0, @"Should haven't got something to insert.");
	XCTAssert(notif.removalIndexSet.count == 0, @"Should haven't got something to remove.");
	XCTAssertEqual(notif.replacementIndexSet, indexes, @"Shoud be equal to indexes since we replace something in an array.");
}

@end
