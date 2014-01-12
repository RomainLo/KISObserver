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

#pragma mark - Interface

- (NSArray *)observations
{
	return [_observations copy];
}

- (void)addObservation:(id<KISObservation>)observation
{
	if (! [_observations containsObject:observation]) {
		[_observations addObject:observation];
	}
}

- (void)removeObservationOfObject:(NSObject *)object forKeyPaths:(NSString *)keyPaths
{
	NSUInteger index = [self _indexOfObservationWithObserved:object keyPaths:keyPaths];
	if (NSNotFound != index) {
		[_observations removeObjectAtIndex:index];
	}
}

- (void)removeAllObservations
{
	[_observations removeAllObjects];
}

- (BOOL)isObservingObject:(NSObject *)object forKeyPaths:(NSString *)keyPaths
{
	NSUInteger index = [self _indexOfObservationWithObserved:object keyPaths:keyPaths];
	return index != NSNotFound;
}

#pragma mark - Private method

- (NSUInteger)_indexOfObservationWithObserved:(id)object keyPaths:(NSString *)keyPaths
{
	NSUInteger index = [_observations indexOfObjectPassingTest:^BOOL(id<KISObservation> observation, NSUInteger idx, BOOL *stop) {
		return (observation.observed == object) && (0 == [observation.keyPaths compare:keyPaths]);
	}];
	return index;
}

@end
