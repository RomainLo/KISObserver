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

- (void)addObservation:(KISObservation *)observation;

- (void)removeObservationOfObject:(NSObject *)object
							 forKeyPaths:(NSString *)keyPaths;

- (void)removeAllObservations;

- (BOOL)isObservingObject:(NSObject *)object forKeyPath:(NSString *)keyPath;

@end
