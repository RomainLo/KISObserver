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
	KISBlockObservation *observation = [[KISBlockObservation alloc] initWithObserver:self observed:object options:options keyPaths:keyPaths block:block];
	[self.observer addObservation:observation];
}

- (void)observeObject:(NSObject *)object
			 forKeyPaths:(NSString *)keyPaths
				withBlock:(void(^)(__weak id observed, NSDictionary *change))block
{
	KISBlockObservation *observation = [[KISBlockObservation alloc] initWithObserver:self observed:object options:0 keyPaths:keyPaths block:block];
	[self.observer addObservation:observation];
}

#endif

- (void)observeObject:(NSObject *)object
			 forKeyPaths:(NSString *)keyPaths
				  options:(NSKeyValueObservingOptions)options
{
	KISObservation *observation = [[KISObservation alloc] initWithObserver:self observed:object options:options keyPaths:keyPaths];
	[self.observer addObservation:observation];
}

- (void)observeObject:(NSObject *)object
			 forKeyPaths:(NSString *)keyPaths
{
	KISObservation *observation = [[KISObservation alloc] initWithObserver:self observed:object options:0 keyPaths:keyPaths];
	[self.observer addObservation:observation];
}

- (void)observeObject:(NSObject *)object
			 forKeyPaths:(NSString *)keyPaths
				  options:(NSKeyValueObservingOptions)options
			withSelector:(SEL)selector
{
	KISSelectorObservation *observation = [[KISSelectorObservation alloc] initWithObserver:self observed:object options:options keyPaths:keyPaths selector:selector];
	[self.observer addObservation:observation];
}

- (void)observeObject:(NSObject *)object
			 forKeyPaths:(NSString *)keyPaths
			withSelector:(SEL)selector
{
	KISSelectorObservation *observation = [[KISSelectorObservation alloc] initWithObserver:self observed:object options:0 keyPaths:keyPaths selector:selector];
	[self.observer addObservation:observation];
}

- (void)stopObservingObject:(NSObject *)object forKeyPaths:(NSString *)keyPaths
{
	[self.observer removeObservationOfObject:object forKeyPaths:keyPaths];
}

- (void)stopObservingAllObjects
{
	[self.observer removeAllObservations];
}

- (BOOL)isObservingObject:(NSObject *)object forKeyPath:(NSString *)keyPath
{
	return [self.observer isObservingObject:object forKeyPath:keyPath];
}

@end
