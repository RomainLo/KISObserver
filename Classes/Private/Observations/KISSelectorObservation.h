//
//  KISSelectorObservation.h
//  KISObserver
//
//  Created by Romain Lofaso on 12/01/14.
//  Copyright (c) 2014 RomainLo. All rights reserved.
//

#import "KISObservation.h"

/** Observation that notifies the observer via a selector. */
@interface KISSelectorObservation : KISObservationBase

@property (nonatomic, assign, readonly) SEL selector;

- (instancetype)initWithObserver:(id)observer
								observed:(id)observed
								 options:(NSKeyValueObservingOptions)options
								keyPaths:(NSString *)keyPaths
								selector:(SEL)selector;

@end
