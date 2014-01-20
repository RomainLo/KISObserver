//
//  KISNotificationTest.m
//  KISObserver
//
//  Created by Romain Lofaso on 20/01/14.
//  Copyright (c) 2014 RomainLo. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "KISNotification.h"

@interface KISNotificationTest : XCTestCase

@end

@implementation KISNotificationTest

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

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

- (void)testWrongInitializer
{
	XCTAssertThrows([[KISNotification alloc] initWithObservable:nil keyPath:@"keypath" change:@{}], @"The first parameter should not be accepted.");
	XCTAssertThrows([[KISNotification alloc] initWithObservable:self keyPath:@"" change:@{}], @"The second parameter should not be accepted.");
	XCTAssertThrows([[KISNotification alloc] initWithObservable:self keyPath:@"keypath" change:nil], @"The third parameter should not be accepted.");
}


@end
