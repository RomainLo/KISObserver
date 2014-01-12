//
//  NSObjeckKISObserverTest.m
//  KISObserver
//
//  Created by Romain Lofaso on 12/01/14.
//  Copyright (c) 2014 RomainLo. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface NSObjeckKISObserverTest : XCTestCase

@property (nonatomic, assign) NSUInteger countSelector;

@end

@implementation NSObjeckKISObserverTest

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

- (void)testRemoveAllObservationsWhenDealloc
{
	@autoreleasepool {
		
	}
}

@end
