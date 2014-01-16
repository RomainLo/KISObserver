//
//  KISObserver.h
//  KISObserver
//
//  Created by Romain Lofaso on 28/12/13.
//  Copyright (c) 2013 RomainLo. All rights reserved.
//

@protocol KISObservation;

@interface KISObserver : NSObject

@property (nonatomic, readonly, copy) NSArray *observations;

- (void)addObservation:(id<KISObservation>)observation;

- (void)removeObservationOfObject:(NSObject *)object forKeyPaths:(NSString *)keyPaths;

- (void)removeAllObservations;

- (BOOL)isObservingObject:(NSObject *)object forKeyPaths:(NSString *)keyPaths;

@end
