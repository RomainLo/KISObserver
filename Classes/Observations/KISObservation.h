//
//  KISObservation.h
//  KISObserver
//
//  Created by Romain Lofaso on 12/01/14.
//  Copyright (c) 2014 RomainLo. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kKISObservationContext;

@protocol KISObservation <NSObject>

/** The object which observes. */
@property (nonatomic, weak, readonly) id observer;

/** The object which is observed. */
@property (nonatomic, weak, readonly) id observed;

/** The option of the observation. */
@property (nonatomic, assign, readonly) NSKeyValueObservingOptions options;

/** The list of observed key paths. */
@property (nonatomic, copy, readonly) NSString *keyPaths;

/** The list of observed key paths. */
@property (nonatomic, copy, readonly) NSArray *keyPathArray;

@end


@interface KISObservationBase : NSObject <KISObservation>

@property (nonatomic, weak, readonly) id observer;
@property (nonatomic, weak, readonly) id observed;
@property (nonatomic, assign, readonly) NSKeyValueObservingOptions options;
@property (nonatomic, copy, readonly) NSString *keyPaths;
@property (nonatomic, copy, readonly) NSArray *keyPathArray;

- (instancetype)initWithObserver:(id)observer
								observed:(id)observed
								 options:(NSKeyValueObservingOptions)options
								keyPaths:(NSString *)keyPaths;

- (void)startObservation;

@end
