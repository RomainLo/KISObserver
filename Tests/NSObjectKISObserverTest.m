//
//  NSObjeckKISObserverTest.m
//  KISObserver
//
//  Created by Romain Lofaso on 12/01/14.
//  Copyright (c) 2014 RomainLo. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "KISKvoObject.h"

#import "NSObject+KISObserver.h"

@interface NSObjectKISObserverTest : XCTestCase

@property (nonatomic, strong) KISKvoObject *observed;

@end

@implementation NSObjectKISObserverTest

- (void)setUp
{
	[super setUp];
	self.observed = [KISKvoObject new];
}

- (void)testNotifySimpleBlock
{
	__block NSUInteger kvoCount = 0;
	KISKvoObject *ob = [KISKvoObject new];
	[ob observeObject:self.observed forKeyPaths:kKvoPropertyKeyPath1 withBlock:^(KISNotification *notification) {
		kvoCount += 1;
	}];
	self.observed.kvoProperty1 += 1;
	XCTAssertEqual(1U, kvoCount, @"Should be notified via the block.");
}

- (void)testRemoveAllObservationsWhenDealloc
{
	__block NSUInteger kvoCount = 0;
	@autoreleasepool {
		KISKvoObject *ob = [KISKvoObject new];
		[ob observeObject:self.observed forKeyPaths:kKvoPropertyKeyPath1 withBlock:^(KISNotification *notification) {
			kvoCount += 1;
		}];
	}
	self.observed.kvoProperty1 += 1;
	XCTAssertEqual(0U, kvoCount, @"Shouldn't be triggered because the observer is released.");
}

- (void)testForDocumentation
{
	KISKvoObject *ob = [KISKvoObject new];
	
	// Block
	[self observeObject:ob forKeyPaths:@"property" withBlock:^(KISNotification *notification) {
		NSLog(@"New value:\t%@", notification.newValue);
		NSLog(@"Old value:\t%@", notification.oldValue);
	}];
	
	// Selector for array
	NSKeyValueObservingOptions opt = NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
	[self observeObject:ob forKeyPaths:@"arr" options:opt withSelector:@selector(onChangeWithNotification:)];
	
	// ...
}

- (void)onChangeWithNotification:(KISNotification *)notification
{
	NSLog(@"isSetting :\t%hhd", notification.isSetting);
	NSLog(@"Insertions :\t%@", notification.insertionIndexSet);
	NSLog(@"Removals :\t%@", notification.removalIndexSet);
	NSLog(@"Replacements :\t%@", notification.replacementIndexSet);
}

@end
