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

@implementation KISObserver {
	NSMutableArray *_observations;
}

@dynamic observations;

#pragma mark - NSObject

- (instancetype)init
{
	self = [super init];
	if (self) {
		_observations = [NSMutableArray new];
	}
	
	return self;
}

- (void)dealloc
{
	[self removeAllObservations];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	NSIndexSet *indexSet = [self _indexesOfModelsWithObserved:object keyPath:keyPath];
	[_observations enumerateObjectsAtIndexes:indexSet options:0 usingBlock:^(KISObservation *observation, NSUInteger idx, BOOL *stop) {
		[observation notifyForChange:change];
	}];
}

#pragma mark - Interface

- (NSArray *)observations
{
	return [_observations copy];
}

- (void)addObservation:(KISObservation *)observation
{
	[observation.observed addObserver:self forKeyPath:observation.keyPath options:observation.options context:(__bridge void *)(kKISObserverContext)];
	[_observations addObject:observation];
}

- (void)removeObservationOfObject:(NSObject *)object forKeyPath:(NSString *)keyPath
{
	NSUInteger index = [self _indexOfModelWithObserved:object keyPath:keyPath];
	if (NSNotFound != index) {
		KISObservation *observation = _observations[index];
		[observation.observed removeObserver:self forKeyPath:observation.keyPath context:(__bridge void *)(kKISObserverContext)];
		[_observations removeObjectAtIndex:index];
	}
}

- (void)removeAllObservations
{
	for (KISObservation *observation in self.observations) {
		[observation.observed removeObserver:self forKeyPath:observation.keyPath context:(__bridge void *)(kKISObserverContext)];
	}
	[_observations removeAllObjects];
}

- (BOOL)isObservingObject:(NSObject *)object forKeyPath:(NSString *)keyPath
{
	NSUInteger index = [self _indexOfModelWithObserved:object keyPath:keyPath];
	return index != NSNotFound;
}

#pragma mark - Private method

- (NSUInteger)_indexOfModelWithObserved:(id)object keyPath:(NSString *)keyPath
{
	NSUInteger index = [_observations indexOfObjectPassingTest:^BOOL(KISObservation *observation, NSUInteger idx, BOOL *stop) {
		return (observation.observed == object) && (0 == [observation.keyPath compare:keyPath]);
	}];
	return index;
}

- (NSIndexSet *)_indexesOfModelsWithObserved:(id)object keyPath:(NSString *)keyPath
{
	NSIndexSet *indexSet = [_observations indexesOfObjectsPassingTest:^BOOL(KISObservation *observation, NSUInteger idx, BOOL *stop) {
		return (observation.observed == object) && (0 == [observation.keyPath compare:keyPath]);
	}];
	return indexSet;
}

@end
