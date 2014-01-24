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

#import "NSObject+KISObserver.h"

#import <objc/runtime.h>

#import "KISObservationHandler.h"
#import "KISNotification.h"

// Observations
#import "KISBlockObservation.h"
#import "KISSelectorObservation.h"
#import "KISDefaultObservation.h"

#define OBSERVER_DEFAULT_OPTIONS NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld


@implementation NSObject (KISObserver)

- (KISObservationHandler *)kis_observer {
	static NSString * const observerKey = @"kis_observer";
	KISObservationHandler *ob = objc_getAssociatedObject(self, (__bridge const void *)(observerKey));
	
	if (nil == ob) {
		ob = [KISObservationHandler new];
		objc_setAssociatedObject(self, (__bridge const void *)(observerKey), ob, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
	
	return ob;
}

#ifdef NS_BLOCKS_AVAILABLE

- (void)observeObject:(NSObject *)object
			 forKeyPaths:(NSString *)keyPaths
				  options:(NSKeyValueObservingOptions)options
				withBlock:(void(^)(KISNotification *notification))block
{
	KISBlockObservation * const observation = [[KISBlockObservation alloc] initWithObserver:self observable:object options:options keyPaths:keyPaths block:block];
	[[self kis_observer] addObservation:observation];
}

- (void)observeObject:(NSObject *)object
			 forKeyPaths:(NSString *)keyPaths
				withBlock:(void(^)(KISNotification *notification))block
{
	KISBlockObservation * const observation = [[KISBlockObservation alloc] initWithObserver:self observable:object options:OBSERVER_DEFAULT_OPTIONS keyPaths:keyPaths block:block];
	[[self kis_observer] addObservation:observation];
}

#endif

- (void)observeObject:(NSObject *)object
			 forKeyPaths:(NSString *)keyPaths
				  options:(NSKeyValueObservingOptions)options
{
	KISDefaultObservation * const observation = [[KISDefaultObservation alloc] initWithObserver:self observable:object options:options keyPaths:keyPaths];
	[[self kis_observer] addObservation:observation];
}

- (void)observeObject:(NSObject *)object
			 forKeyPaths:(NSString *)keyPaths
{
	KISDefaultObservation * const observation = [[KISDefaultObservation alloc] initWithObserver:self observable:object options:OBSERVER_DEFAULT_OPTIONS keyPaths:keyPaths];
	[[self kis_observer] addObservation:observation];
}

- (void)observeObject:(NSObject *)object
			 forKeyPaths:(NSString *)keyPaths
				  options:(NSKeyValueObservingOptions)options
			withSelector:(SEL)selector
{
	KISSelectorObservation * const observation = [[KISSelectorObservation alloc] initWithObserver:self observable:object options:options keyPaths:keyPaths selector:selector];
	[[self kis_observer] addObservation:observation];
}

- (void)observeObject:(NSObject *)object
			 forKeyPaths:(NSString *)keyPaths
			withSelector:(SEL)selector
{
	KISSelectorObservation * const observation = [[KISSelectorObservation alloc] initWithObserver:self observable:object options:OBSERVER_DEFAULT_OPTIONS keyPaths:keyPaths selector:selector];
	[[self kis_observer] addObservation:observation];
}

- (void)stopObservingObject:(NSObject *)object forKeyPaths:(NSString *)keyPaths
{
	[[self kis_observer] removeObservationOfObject:object forKeyPaths:keyPaths];
}

- (void)stopObservingAllObjects
{
	[[self kis_observer] removeAllObservations];
}

- (BOOL)isObservingObject:(NSObject *)object forKeyPath:(NSString *)keyPath
{
	return [[self kis_observer] isObservingObject:object forKeyPath:keyPath];
}

@end
