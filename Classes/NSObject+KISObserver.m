//
//  NSObject+KISObserver.m
//  KISObserver
//
//  Created by Romain Lofaso on 05/01/14.
//  Copyright (c) 2014 RomainLo. All rights reserved.
//

#import "NSObject+KISObserver.h"

#import <objc/runtime.h>

#import "KISObserver.h"

// Observations
#import "KISBlockObservation.h"
#import "KISSelectorObservation.h"
#import "KISDefaultObservation.h"


@implementation NSObject (KISObserver)

- (KISObserver *)kis_observer {
	static NSString *observerKey = @"kis_observer";
	
	KISObserver *ob = objc_getAssociatedObject(self, (__bridge const void *)(observerKey));
	
	if (nil == ob) {
		ob = [KISObserver new];
		objc_setAssociatedObject(self, (__bridge const void *)(observerKey), ob, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
	
	return ob;
}

#ifdef NS_BLOCKS_AVAILABLE

- (void)observeObject:(NSObject *)object
			 forKeyPaths:(NSString *)keyPaths
				  options:(NSKeyValueObservingOptions)options
				withBlock:(void(^)(__weak id observed, NSDictionary *change))block
{
	KISBlockObservation *observation = [[KISBlockObservation alloc] initWithObserver:self observed:object options:options keyPaths:keyPaths block:block];
	[[self kis_observer] addObservation:observation];
}

- (void)observeObject:(NSObject *)object
			 forKeyPaths:(NSString *)keyPaths
				withBlock:(void(^)(__weak id observed, NSDictionary *change))block
{
	KISBlockObservation *observation = [[KISBlockObservation alloc] initWithObserver:self observed:object options:0 keyPaths:keyPaths block:block];
	[[self kis_observer] addObservation:observation];
}

#endif

- (void)observeObject:(NSObject *)object
			 forKeyPaths:(NSString *)keyPaths
				  options:(NSKeyValueObservingOptions)options
{
	KISDefaultObservation *observation = [[KISDefaultObservation alloc] initWithObserver:self observed:object options:options keyPaths:keyPaths];
	[[self kis_observer] addObservation:observation];
}

- (void)observeObject:(NSObject *)object
			 forKeyPaths:(NSString *)keyPaths
{
	KISDefaultObservation *observation = [[KISDefaultObservation alloc] initWithObserver:self observed:object options:0 keyPaths:keyPaths];
	[[self kis_observer] addObservation:observation];
}

- (void)observeObject:(NSObject *)object
			 forKeyPaths:(NSString *)keyPaths
				  options:(NSKeyValueObservingOptions)options
			withSelector:(SEL)selector
{
	KISSelectorObservation *observation = [[KISSelectorObservation alloc] initWithObserver:self observed:object options:options keyPaths:keyPaths selector:selector];
	[[self kis_observer] addObservation:observation];
}

- (void)observeObject:(NSObject *)object
			 forKeyPaths:(NSString *)keyPaths
			withSelector:(SEL)selector
{
	KISSelectorObservation *observation = [[KISSelectorObservation alloc] initWithObserver:self observed:object options:0 keyPaths:keyPaths selector:selector];
	[[self kis_observer] addObservation:observation];
}

- (void)stopObservingObject:(NSObject *)object forKeyPaths:(NSString *)keyPaths
{
	[[self kis_observer] removeObservationOfObject:object forKeyPaths:keyPaths];
}

- (void)stopObservingAllObjects
{
	[[self kis_observer] removeAllObservations];
}

- (BOOL)isObservingObject:(NSObject *)object forKeyPath:(NSString *)keyPath
{
	return [[self kis_observer] isObservingObject:object forKeyPath:keyPath];
}

@end
