//
//  KISBlockObservation.h
//  KISObserver
//
//  Created by Romain Lofaso on 12/01/14.
//  Copyright (c) 2014 RomainLo. All rights reserved.
//

#import "KISObservation.h"

/** The definition of the block that will be call for a notification. */
typedef void(^KISObserverBlock)(__weak id observed, NSDictionary *change);

/** Observation that notifies the observer via a block. */
@interface KISBlockObservation : KISObservationBase

@property (nonatomic, copy, readonly) KISObserverBlock block;

- (instancetype)initWithObserver:(id)observer
								observed:(id)observed
								 options:(NSKeyValueObservingOptions)options
								keyPaths:(NSString *)keyPaths
									block:(KISObserverBlock)block;

@end
