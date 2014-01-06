//
//  NSObject+KISObserver.m
//  KISObserver
//
//  Created by Romain Lofaso on 05/01/14.
//  Copyright (c) 2014 RomainLo. All rights reserved.
//

#import "NSObject+KISObserver.h"

#import "KISObserver.h"
#import "KISObservation.h"

@interface NSObject ()

@property (nonatomic, strong) KISObserver *_observer;

@end

@implementation NSObject (KISObserver)

- (KISObserver *)observer {
	if (!self._observer) {
		self._observer = [[KISObserver alloc] init];
	}
	
	return self._observer;
}

#ifdef NS_BLOCKS_AVAILABLE

- (void)observeObject:(NSObject *)object
			 forKeyPaths:(NSString *)keyPaths
				  options:(NSKeyValueObservingOptions)options
				withBlock:(void(^)(__weak id observed, NSDictionary *change))block
{
	for (NSString *keyPath in [self kis_keyPathsFromString:keyPaths]) {
		KISBlockObservation *observation = [[KISBlockObservation alloc] initWithObserver:self observed:object options:options keyPath:keyPath block:block];
		[self.observer addObservation:observation];
	}
}

- (void)observeObject:(NSObject *)object
			 forKeyPaths:(NSString *)keyPaths
				withBlock:(void(^)(__weak id observed, NSDictionary *change))block
{
	for (NSString *keyPath in [self kis_keyPathsFromString:keyPaths]) {
		KISBlockObservation *observation = [[KISBlockObservation alloc] initWithObserver:self observed:object options:0 keyPath:keyPath block:block];
		[self.observer addObservation:observation];
	}
}

#endif

- (void)observeObject:(NSObject *)object
			 forKeyPaths:(NSString *)keyPaths
				  options:(NSKeyValueObservingOptions)options
{
	for (NSString *keyPath in [self kis_keyPathsFromString:keyPaths]) {
		KISObservation *observation = [[KISObservation alloc] initWithObserver:self observed:object options:options keyPath:keyPath];
		[self.observer addObservation:observation];
	}
}

- (void)observeObject:(NSObject *)object
			 forKeyPaths:(NSString *)keyPaths
{
	for (NSString *keyPath in [self kis_keyPathsFromString:keyPaths]) {
		KISObservation *observation = [[KISObservation alloc] initWithObserver:self observed:object options:0 keyPath:keyPath];
		[self.observer addObservation:observation];
	}
}

- (void)observeObject:(NSObject *)object
			 forKeyPaths:(NSString *)keyPaths
				  options:(NSKeyValueObservingOptions)options
			withSelector:(SEL)selector
{
	for (NSString *keyPath in [self kis_keyPathsFromString:keyPaths]) {
		KISSelectorObservation *observation = [[KISSelectorObservation alloc] initWithObserver:self observed:object options:options keyPath:keyPath selector:selector];
		[self.observer addObservation:observation];
	}
}

- (void)observeObject:(NSObject *)object
			 forKeyPaths:(NSString *)keyPaths
			withSelector:(SEL)selector
{
	for (NSString *keyPath in [self kis_keyPathsFromString:keyPaths]) {
		KISSelectorObservation *observation = [[KISSelectorObservation alloc] initWithObserver:self observed:object options:0 keyPath:keyPath selector:selector];
		[self.observer addObservation:observation];
	}
}

- (void)stopObservingObject:(NSObject *)object forKeyPaths:(NSString *)keyPaths
{
	for (NSString *keyPath in [self kis_keyPathsFromString:keyPaths]) {
		[self.observer removeObservationOfObject:object forKeyPath:keyPath];
	}
}

- (void)stopObservingAllObjects
{
	[self.observer removeAllObservations];
}

- (BOOL)isObservingObject:(NSObject *)object forKeyPath:(NSString *)keyPath
{
	return [self.observer isObservingObject:object forKeyPath:keyPath];
}

- (NSArray *)kis_keyPathsFromString:(NSString *)keyPaths
{
	return [keyPaths componentsSeparatedByString:@"|"];
}

@end
