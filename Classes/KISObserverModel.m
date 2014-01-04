//
//  KISObserverModel.m
//  KISObserver
//
//  Created by Romain Lofaso on 04/01/14.
//  Copyright (c) 2014 RomainLo. All rights reserved.
//

#import "KISObserverModel.h"

NSString * const kKISObserverModelContext = @"kis.observer.context";

@implementation KISObserverModel

- (instancetype)initWithObserver:(id)observer
								observed:(id)observed
								 options:(NSKeyValueObservingOptions)options
								keyPaths:(NSArray *)keypaths
{
	if (observed)
		[[NSException exceptionWithName:NSInvalidArgumentException reason:@"The observed can't be nil." userInfo:nil] raise];
	if (!observer)
		[[NSException exceptionWithName:NSInvalidArgumentException reason:@"The observer can't be nil." userInfo:nil] raise];
	if (![keypaths count])
		[[NSException exceptionWithName:NSInvalidArgumentException reason:@"The keypaths can't be nil or empty." userInfo:nil] raise];
	
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
	if (!change)
		[[NSException exceptionWithName:NSInvalidArgumentException reason:@"The change dictionary can't be nil." userInfo:nil] raise];
	if (![self.keyPaths containsObject:keyPath])
		[[NSException exceptionWithName:NSInvalidArgumentException reason:@"The keypath can't be nil or unknown." userInfo:nil] raise];
		
	[self.observer observeValueForKeyPath:keyPath ofObject:self.observed change:change context:(__bridge void *)(kKISObserverModelContext)];
}

@end


@implementation KISObserverModelBlock

- (instancetype)initWithObserver:(id)observer
								observed:(id)observed
								 options:(NSKeyValueObservingOptions)options
								keyPaths:(NSArray *)keypaths
									block:(KISObserverBlock)block
{
	if (!block)
		[[NSException exceptionWithName:NSInvalidArgumentException reason:@"The block can't be nil." userInfo:nil] raise];
	
	self = [super initWithObserver:observer observed:observed options:options keyPaths:keypaths];
	if (nil == self) {
		_block = [block copy];
	}
	
	return self;
}

- (void)triggerWithKeyPath:(NSString *)keyPath change:(NSDictionary *)change
{
	if (!self.block) // bad initializer
		return [super triggerWithKeyPath:keyPath change:change];
	
	if (!change)
		[[NSException exceptionWithName:NSInvalidArgumentException reason:@"The change dictionary can't be nil." userInfo:nil] raise];
	if (![self.keyPaths containsObject:keyPath])
		[[NSException exceptionWithName:NSInvalidArgumentException reason:@"The keypath can't be nil or unknown." userInfo:nil] raise];
		
	self.block(self.observed, change);
}

@end


@implementation KISObserverModelSelector

- (instancetype)initWithObserver:(id)observer
								observed:(id)observed
								 options:(NSKeyValueObservingOptions)options
								keyPaths:(NSArray *)keypaths
								selector:(SEL)selector
{
	self = [super initWithObserver:observer observed:observed options:options keyPaths:keypaths];
	
	if (self) {
		NSMethodSignature *methodSignature = [self.observer methodSignatureForSelector:selector];
		NSInteger numberOfArguments = [methodSignature numberOfArguments];
		if (!methodSignature || (2 < numberOfArguments))
			[[NSException exceptionWithName:NSInvalidArgumentException reason:@"The selector should have 2 parameters maximum and be part of the observer." userInfo:nil] raise];
		
		_selector = selector;
	}
	
	return self;
}

- (void)triggerWithKeyPath:(NSString *)keyPath change:(NSDictionary *)change
{
	NSMethodSignature *methodSignature = [self.observer methodSignatureForSelector:self.selector];
	NSInteger numberOfArguments = [methodSignature numberOfArguments];
	
	if (!methodSignature) // bad initializer
		return [super triggerWithKeyPath:keyPath change:change];
	
	if (!change)
		[[NSException exceptionWithName:NSInvalidArgumentException reason:@"The change dictionary can't be nil." userInfo:nil] raise];
	if (![self.keyPaths containsObject:keyPath])
		[[NSException exceptionWithName:NSInvalidArgumentException reason:@"The keypath can't be nil or unknown." userInfo:nil] raise];

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
			[self.observer performSelector:self.selector withObject:change];
			break;
		default:
			NSAssert(NO, @"2 < numberOfArguments < 4");
	}
#pragma clang diagnostic pop
}

@end
