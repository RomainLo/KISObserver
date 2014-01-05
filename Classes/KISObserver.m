//
//  KISObserver.m
//  KISObserver
//
//  Created by Romain Lofaso on 28/12/13.
//  Copyright (c) 2013 RomainLo. All rights reserved.
//

#import "KISObserver.h"

#import "KISObservation.h"

NSString * const kKISObserverContext = @"kis.observer.context";

@interface KISObserver ()

@property (nonatomic, strong) NSMutableArray *observations;

@end

@implementation KISObserver

- (instancetype)init
{
	self = [super init];
	if (self) {
		self.observations = [NSMutableArray new];
	}
	
	return self;
}

- (void)dealloc
{
	[self removeAllObservations];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	NSIndexSet *indexSet = [self _indexesOfModelWithObserved:object keyPath:keyPath];
	[self.observations enumerateObjectsAtIndexes:indexSet options:0 usingBlock:^(KISObservation *observation, NSUInteger idx, BOOL *stop) {
		[observation notifyForKeyPath:keyPath change:change];
	}];
}

- (void)addObservation:(KISObservation *)observation
{
	for (NSString *keyPath in observation.keyPaths) {
		[observation.observed addObserver:self forKeyPath:keyPath options:observation.options context:(__bridge void *)(kKISObserverContext)];
	}
	[self.observations addObject:observation];
}

- (void)removeObservationOfObject:(NSObject *)object
							 forKeyPaths:(NSString *)keyPaths
{
	// Firt we remove the keypath within the observations.
	NSArray *keyPathArray = [KISObservation keyPathsWithString:keyPaths];
	for (NSString *keyPath in keyPathArray) {
		NSIndexSet *indexSet = [self _indexesOfModelWithObserved:object keyPath:keyPath];
		[self.observations enumerateObjectsAtIndexes:indexSet options:0 usingBlock:^(KISObservation *observation, NSUInteger idx, BOOL *stop) {
			[observation.observed removeObserver:self forKeyPath:keyPath context:(__bridge void *)(kKISObserverContext)];
			[observation removeKeyPaths:keyPath];
		}];
	}
	
	// Then we remove the useless observations of the observer.
	NSIndexSet *indexesToRemove = [self.observations indexesOfObjectsPassingTest:^BOOL(KISObservation *observation, NSUInteger idx, BOOL *stop) {
		return !observation.keyPaths.count;
	}];
	[self.observations removeObjectsAtIndexes:indexesToRemove];
}

- (void)removeAllObservations
{
	for (KISObservation *observation in self.observations) {
		for (NSString *keyPath in observation.keyPaths) {
			[observation.observed removeObserver:self forKeyPath:keyPath context:(__bridge void *)(kKISObserverContext)];
		}
	}
	[self.observations removeAllObjects];
}

- (BOOL)isObservingObject:(NSObject *)object forKeyPath:(NSString *)keyPath
{
	NSIndexSet *indexSet = [self _indexesOfModelWithObserved:object keyPath:keyPath];
	return [indexSet count];
}

#pragma mark - Private method
- (NSIndexSet *)_indexesOfModelWithObserved:(id)object keyPath:(NSString *)keyPath
{
	NSIndexSet *indexSet = [self.observations indexesOfObjectsPassingTest:^BOOL(KISObservation *observation, NSUInteger idx, BOOL *stop) {
		return (observation.observed == object) && [observation.keyPaths containsObject:keyPath];
	}];
	
	return indexSet;
}

@end
