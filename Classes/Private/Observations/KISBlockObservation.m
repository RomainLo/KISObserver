//
//  KISBlockObservation.m
//  KISObserver
//
//  Created by Romain Lofaso on 12/01/14.
//  Copyright (c) 2014 RomainLo. All rights reserved.
//

#import "KISBlockObservation.h"

#ifdef NS_BLOCKS_AVAILABLE

@implementation KISBlockObservation

- (instancetype)initWithObserver:(id)observer
								observed:(id)observed
								 options:(NSKeyValueObservingOptions)options
								keyPaths:(NSString *)keyPaths
									block:(KISObserverBlock)block
{
	if (!block)
		[[NSException exceptionWithName:NSInvalidArgumentException reason:@"The block can't be nil." userInfo:nil] raise];
	
	self = [super initWithObserver:observer observed:observed options:options keyPaths:keyPaths];
	if (self) {
		_block = [block copy];
		[self startObservation];
	}
	
	return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	self.block(self.observed, change);
}

@end

#endif