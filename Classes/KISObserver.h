//
//  KISObserver.h
//  KISObserver
//
//  Created by Romain Lofaso on 28/12/13.
//  Copyright (c) 2013 RomainLo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KISObservation;

@interface KISObserver : NSObject

@property (nonatomic, readonly, copy) NSArray *observations;

- (void)addObservation:(KISObservation *)observation;

- (void)removeObservationOfObject:(NSObject *)object forKeyPath:(NSString *)keyPath;

- (void)removeAllObservations;

- (BOOL)isObservingObject:(NSObject *)object forKeyPath:(NSString *)keyPath;

@end
