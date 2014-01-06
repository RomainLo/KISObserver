//
//  KISObserverModel.m
//  KISObserver
//
//  Created by Romain Lofaso on 04/01/14.
//  Copyright (c) 2014 RomainLo. All rights reserved.
//

#import "KISObservation.h"

NSString * const kKISObservationContext = @"kis.observer.model.context";

@implementation KISObservation

- (instancetype)initWithObserver:(id)observer
								observed:(id)observed
								 options:(NSKeyValueObservingOptions)options
								keyPath:(NSString *)keyPath
{
	if (!observed)
		[[NSException exceptionWithName:NSInvalidArgumentException reason:@"The observed can't be nil." userInfo:nil] raise];
	if (!observer)
		[[NSException exceptionWithName:NSInvalidArgumentException reason:@"The observer can't be nil." userInfo:nil] raise];
	if (![keyPath length])
		[[NSException exceptionWithName:NSInvalidArgumentException reason:@"The keypaths can't be nil or empty." userInfo:nil] raise];
	
	self = [super init];
	if (self) {
		_observer = observer;
		_observed = observed;
		_options = options;
		_keyPath = keyPath;
	}
	
	return self;
}

- (void)notifyForChange:(NSDictionary *)change
{
	if (!change)
		[[NSException exceptionWithName:NSInvalidArgumentException reason:@"The change dictionary can't be nil." userInfo:nil] raise];
		
	[self.observer observeValueForKeyPath:self.keyPath ofObject:self.observed change:change context:(__bridge void *)(kKISObservationContext)];
}


+ (NSArray *)keyPathsWithString:(NSString *)string
{
	return [string componentsSeparatedByString:@"|"];
}

@end


@implementation KISBlockObservation

- (instancetype)initWithObserver:(id)observer
								observed:(id)observed
								 options:(NSKeyValueObservingOptions)options
								keyPath:(NSString *)keyPath
									block:(KISObserverBlock)block
{
	if (!block)
		[[NSException exceptionWithName:NSInvalidArgumentException reason:@"The block can't be nil." userInfo:nil] raise];
	
	self = [super initWithObserver:observer observed:observed options:options keyPath:keyPath];
	if (self) {
		_block = [block copy];
	}
	
	return self;
}

- (void)notifyForChange:(NSDictionary *)change
{
	if (!change)
		[[NSException exceptionWithName:NSInvalidArgumentException reason:@"The change dictionary can't be nil." userInfo:nil] raise];
		
	self.block(self.observed, change);
}

@end


@implementation KISSelectorObservation

- (instancetype)initWithObserver:(id)observer
								observed:(id)observed
								 options:(NSKeyValueObservingOptions)options
								keyPath:(NSString *)keyPath
								selector:(SEL)selector
{
	self = [super initWithObserver:observer observed:observed options:options keyPath:keyPath];
	
	if (self) {
		NSMethodSignature *methodSignature = [self.observer methodSignatureForSelector:selector];
		NSInteger numberOfArguments = [methodSignature numberOfArguments];
		if (!methodSignature || (4 < numberOfArguments))
			[[NSException exceptionWithName:NSInvalidArgumentException reason:@"The selector should have 2 parameters maximum and be part of the observer." userInfo:nil] raise];
		
		_selector = selector;
	}
	
	return self;
}

- (void)notifyForChange:(NSDictionary *)change
{
	if (!change)
		[[NSException exceptionWithName:NSInvalidArgumentException reason:@"The change dictionary can't be nil." userInfo:nil] raise];
	
	NSMethodSignature *methodSignature = [self.observer methodSignatureForSelector:self.selector];
	NSInteger numberOfArguments = [methodSignature numberOfArguments];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
	switch (numberOfArguments) {
		case 2: // No argument
			[self.observer performSelector:self.selector];
			break;
		case 3: // 1 argument: the observed object
			[self.observer performSelector:self.selector withObject:self.observed];
			break;
		case 4: // 2 argument: the observed object & the change dics
			[self.observer performSelector:self.selector withObject:self.observed withObject:change];
			break;
		default:
			NSAssert(NO, @"2 < numberOfArguments < 4");
	}
#pragma clang diagnostic pop
}

@end
