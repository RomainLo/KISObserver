//
//  KISSelectorObservation.m
//  KISObserver
//
//  Created by Romain Lofaso on 12/01/14.
//  Copyright (c) 2014 RomainLo. All rights reserved.
//

#import "KISSelectorObservation.h"

@implementation KISSelectorObservation

- (instancetype)initWithObserver:(id)observer
								observed:(id)observed
								 options:(NSKeyValueObservingOptions)options
								keyPaths:(NSString *)keyPaths
								selector:(SEL)selector
{
	self = [super initWithObserver:observer observed:observed options:options keyPaths:keyPaths];
	
	if (self) {
		NSMethodSignature *methodSignature = [self.observer methodSignatureForSelector:selector];
		NSInteger numberOfArguments = [methodSignature numberOfArguments];
		if (!methodSignature || (4 < numberOfArguments))
			[[NSException exceptionWithName:NSInvalidArgumentException reason:@"The selector should have 2 parameters maximum and be part of the observer." userInfo:nil] raise];
		
		_selector = selector;
		[self startObservation];
	}
	
	return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
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
