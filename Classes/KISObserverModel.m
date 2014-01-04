//
//  KISObserverModel.m
//  KISObserver
//
//  Created by Romain Lofaso on 04/01/14.
//  Copyright (c) 2014 RomainLo. All rights reserved.
//

#import "KISObserverModel.h"

@implementation KISObserverModel

- (instancetype)initWithObserver:(id)observer
								observed:(id)observed
								 options:(NSKeyValueObservingOptions)options
								keyPaths:(NSArray *)keypaths
{
	self = [super init];
	if (self) {
		_observer = observer;
		_observed = observed;
		_options = options;
		_keyPaths = [keypaths copy];
	}
	return self;
}

- (void)triggerWithKeyPath:(NSString *)keyPath change:(NSDictionary *)change
{
	NSParameterAssert(keyPath);
	NSParameterAssert(change);
	NSAssert([self.keyPaths containsObject:keyPath], @"The given keypath isn't reconized");
	
	// Nothing to do; need to be overridden.
}

@end


@implementation KISObserverModelBlock

- (instancetype)initWithObserver:(id)observer
								observed:(id)observed
								 options:(NSKeyValueObservingOptions)options
								keyPaths:(NSArray *)keypaths
									block:(KISObserverBlock)block
{
	self = [super initWithObserver:observer observed:observed options:options keyPaths:keypaths];
	if (self) {
		_block = [block copy];
	}
	return self;
}

- (void)triggerWithKeyPath:(NSString *)keyPath change:(NSDictionary *)change
{
	[super triggerWithKeyPath:keyPath change:change];
	self.block(self.observed, change);
}

@end
