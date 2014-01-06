//
//  KISObserverModel.h
//  KISObserver
//
//  Created by Romain Lofaso on 04/01/14.
//  Copyright (c) 2014 RomainLo. All rights reserved.
//

// TODO : Delete option
// TODO : Find a better design
// TODO : Test unit


#import <Foundation/Foundation.h>

/** The context when the KISObservation call observeValueForKeyPath:... */
extern NSString * const kKISObservationContext;

/** The definition of the block that will be call when KISObserverModelBlock is triggered */
typedef void(^KISObserverBlock)(__weak id observed, NSDictionary *change);


/** Immutable model that notifies the observer via observeValueForKeyPath: when it is triggered. */
@interface KISObservation : NSObject

/** The object which observes. */
@property (nonatomic, weak, readonly) id observer;

/** The object which is observed. */
@property (nonatomic, weak, readonly) id observed;

/** The option of the observation. */
@property (nonatomic, assign, readonly) NSKeyValueObservingOptions options;

/** The list of observed key paths. */
@property (nonatomic, copy, readonly) NSString *keyPath;

- (instancetype)initWithObserver:(id)observer
								observed:(id)observed
								 options:(NSKeyValueObservingOptions)options
								keyPath:(NSString *)keyPath;

/**
 Notify the observer that changes has happen for the given key path.
 Subclasses override this method for implementing its own notification style.
 @param change The change dictionnary of the notification. It can't be nil.
 */
- (void)notifyForChange:(NSDictionary *)change;

@end


/** Model that notifies the observer via a block when it is triggered. */
@interface KISBlockObservation : KISObservation

@property (nonatomic, copy, readonly) KISObserverBlock block;

- (instancetype)initWithObserver:(id)observer
								observed:(id)observed
								 options:(NSKeyValueObservingOptions)options
								keyPath:(NSString *)keyPath
									block:(KISObserverBlock)block;

@end


/** Model that notifies the observer via a selector when it is triggered. */
@interface KISSelectorObservation : KISObservation

@property (nonatomic, assign, readonly) SEL selector;

- (instancetype)initWithObserver:(id)observer
								observed:(id)observed
								 options:(NSKeyValueObservingOptions)options
								 keyPath:(NSString *)keyPath
								selector:(SEL)selector;

@end