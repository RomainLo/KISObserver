//
//  KISObserverModel.h
//  KISObserver
//
//  Created by Romain Lofaso on 04/01/14.
//  Copyright (c) 2014 RomainLo. All rights reserved.
//

#import <Foundation/Foundation.h>

/** The context when the KISObserverModel call observeValueForKeyPath:... */
extern NSString * const kKISObserverModelContext;

/** The definition of the block that will be call when KISObserverModelBlock is triggered */
typedef void(^KISObserverBlock)(__weak id observed, NSDictionary *change);


/** Immutable model that notifies the observer via observeValueForKeyPath: when it is triggered. */
@interface KISObserverModel : NSObject

/** The object which observes. */
@property (nonatomic, weak, readonly) id observer;

/** The object which is observed. */
@property (nonatomic, weak, readonly) id observed;

/** The option of the observation. */
@property (nonatomic, assign, readonly) NSKeyValueObservingOptions options;

/** The list of observed key paths. */
@property (nonatomic, copy, readonly) NSArray *keyPaths;

- (instancetype)initWithObserver:(id)observer
								observed:(id)observed
								 options:(NSKeyValueObservingOptions)options
								keyPaths:(NSArray *)keypaths;

/**
 Notify the observer that changes has happen for the given key path.
 Subclasses override this method for implementing its own notification style.
 @param keyPath The key path of the notification.
					 It can't be nil and it should be contained in the keyPaths property.
 @param change The change dictionnary of the notification. It can't be nil.
 */
- (void)triggerWithKeyPath:(NSString *)keyPath change:(NSDictionary *)change;

@end


/** Model that notifies the observer via a block when it is triggered. */
@interface KISObserverModelBlock : KISObserverModel

@property (nonatomic, copy, readonly) KISObserverBlock block;

- (instancetype)initWithObserver:(id)observer
								observed:(id)observed
								 options:(NSKeyValueObservingOptions)options
								keyPaths:(NSArray *)keypaths
									block:(KISObserverBlock)block;

@end


/** Model that notifies the observer via a selector when it is triggered. */
@interface KISObserverModelSelector : KISObserverModel

@property (nonatomic, assign, readonly) SEL selector;

- (instancetype)initWithObserver:(id)observer
								observed:(id)observed
								 options:(NSKeyValueObservingOptions)options
								keyPaths:(NSArray *)keypaths
								selector:(SEL)selector;

@end