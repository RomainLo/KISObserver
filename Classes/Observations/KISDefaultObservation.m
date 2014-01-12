//
//  KISDefaultObservation.m
//  KISObserver
//
//  Created by Romain Lofaso on 12/01/14.
//  Copyright (c) 2014 RomainLo. All rights reserved.
//

#import "KISDefaultObservation.h"

@implementation KISDefaultObservation

- (instancetype)initWithObserver:(id)observer
								observed:(id)observed
								 options:(NSKeyValueObservingOptions)options
								keyPaths:(NSString *)keyPaths
{
	self = [super initWithObserver:observer observed:observed options:options keyPaths:keyPaths];
	if (self) {
		[self startObservation];
	}
	
	return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	[self.observer observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

@end
