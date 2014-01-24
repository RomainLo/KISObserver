// Copyright (c) 2013 RomainLo <romain.lofaso@gmail.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "KISObservationHandler.h"

#import "KISObservation.h"
#import "KISNotification.h"

NSString * const kKISObserverContext = @"kis.observer.context";

@implementation KISObservationHandler {
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
	if (nil == observation)
		[[NSException exceptionWithName:NSInvalidArgumentException reason:@"The observation can't be nil." userInfo:nil] raise];
	
	if ((! [_observations containsObject:observation])) {
		[_observations addObject:observation];
	}
}

- (void)removeObservationOfObject:(NSObject *)object forKeyPaths:(NSString *)keyPaths
{
	if ((nil == object) || (0 == keyPaths.length))
		[[NSException exceptionWithName:NSInvalidArgumentException reason:@"The parameters can't be nil." userInfo:nil] raise];
	
	const NSUInteger index = [self _indexOfObservationWithObserved:object keyPaths:keyPaths];
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
	const NSUInteger index = [self _indexOfObservationWithObserved:object keyPaths:keyPaths];
	return index != NSNotFound;
}

#pragma mark - Private method

- (NSUInteger)_indexOfObservationWithObserved:(id)object keyPaths:(NSString *)keyPaths
{
	const NSUInteger index = [_observations indexOfObjectPassingTest:^BOOL(id<KISObservation> observation, NSUInteger idx, BOOL *stop) {
		return (observation.observable == object) && (0 == [observation.keyPaths compare:keyPaths]);
	}];
	return index;
}

@end
