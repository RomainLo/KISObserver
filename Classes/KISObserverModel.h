//
//  KISObserverModel.h
//  KISObserver
//
//  Created by Romain Lofaso on 04/01/14.
//  Copyright (c) 2014 RomainLo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KISObserverModel : NSObject

@property (nonatomic, weak, readonly) id observer;

@property (nonatomic, weak, readonly) id observed;

@property (nonatomic, assign, readonly) NSKeyValueObservingOptions options;

@property (nonatomic, copy, readonly) NSArray *keyPaths;

- (instancetype)initWithObserver:(id)observer
								observed:(id)observed
								 options:(NSKeyValueObservingOptions)options
								keyPaths:(NSArray *)keypaths;

- (void)triggerWithKeyPath:(NSString *)keyPath change:(NSDictionary *)change;

@end


typedef void(^KISObserverBlock)(__weak id observed, NSDictionary *change);

@interface KISObserverModelBlock : KISObserverModel

@property (nonatomic, copy, readonly) KISObserverBlock block;

- (instancetype)initWithObserver:(id)observer
								observed:(id)observed
								 options:(NSKeyValueObservingOptions)options
								keyPaths:(NSArray *)keypaths
									block:(KISObserverBlock)block;

@end