//
//  KISObservation.m
//  KISObserver
//
//  Created by Romain Lofaso on 12/01/14.
//  Copyright (c) 2014 RomainLo. All rights reserved.
//

#import "KISObservation.h"

NSString * const kKISObservationContext = @"com.observation.context";

@implementation KISObservationBase {
	BOOL _isObserving;
}

- (instancetype)initWithObserver:(id)observer
								observed:(id)observed
								 options:(NSKeyValueObservingOptions)options
								keyPaths:(NSString *)keyPaths
{
	if (!observed)
		[[NSException exceptionWithName:NSInvalidArgumentException reason:@"The observed can't be nil." userInfo:nil] raise];
	if (!observer)
		[[NSException exceptionWithName:NSInvalidArgumentException reason:@"The observer can't be nil." userInfo:nil] raise];
	if (![keyPaths length])
		[[NSException exceptionWithName:NSInvalidArgumentException reason:@"The keypaths can't be nil or empty." userInfo:nil] raise];
	
	self = [super init];
	if (self) {
		_observer = observer;
		_observed = observed;
		_options = options;
		_keyPaths = keyPaths;
		_isObserving = NO;
	}
	
	return self;
}

- (void)dealloc
{
	if (_isObserving) {
		for (NSString *key in self.keyPathArray) {
			[self.observed removeObserver:self forKeyPath:key context:(__bridge void *)(kKISObservationContext)];
		}
	}
}

- (void)startObservation
{
	if (_isObserving) return;
	
	NSKeyValueObservingOptions optionsWithoutInit = self.options & (NSKeyValueObservingOptionInitial ^ NSIntegerMax);
	for (NSString *key in self.keyPathArray) {
		[self.observed addObserver:self forKeyPath:key options:optionsWithoutInit context:(__bridge void *)(kKISObservationContext)];
	}
	
	BOOL needToInitialized = self.options & NSKeyValueObservingOptionInitial;
	if (needToInitialized) {
		[self observeValueForKeyPath:self.keyPaths ofObject:self.observed change:@{} context:(__bridge void *)(kKISObservationContext)];
	}
	_isObserving = true;
}

- (NSArray *)keyPathArray
{
	return [self.keyPaths componentsSeparatedByString:@"|"];
}

@end
