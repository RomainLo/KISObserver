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


@implementation NSObject (KISObserver)

- (KISObservationHandler *)kis_observer {
	static NSString *observerKey = @"kis_observer";
	
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
	KISBlockObservation *observation = [[KISBlockObservation alloc] initWithObserver:self observed:object options:options keyPaths:keyPaths block:block];
	[[self kis_observer] addObservation:observation];
}

- (void)observeObject:(NSObject *)object
			 forKeyPaths:(NSString *)keyPaths
				withBlock:(void(^)(KISNotification *notification))block
{
	KISBlockObservation *observation = [[KISBlockObservation alloc] initWithObserver:self observed:object options:0 keyPaths:keyPaths block:block];
	[[self kis_observer] addObservation:observation];
}

#endif

- (void)observeObject:(NSObject *)object
			 forKeyPaths:(NSString *)keyPaths
				  options:(NSKeyValueObservingOptions)options
{
	KISDefaultObservation *observation = [[KISDefaultObservation alloc] initWithObserver:self observed:object options:options keyPaths:keyPaths];
	[[self kis_observer] addObservation:observation];
}

- (void)observeObject:(NSObject *)object
			 forKeyPaths:(NSString *)keyPaths
{
	KISDefaultObservation *observation = [[KISDefaultObservation alloc] initWithObserver:self observed:object options:0 keyPaths:keyPaths];
	[[self kis_observer] addObservation:observation];
}

- (void)observeObject:(NSObject *)object
			 forKeyPaths:(NSString *)keyPaths
				  options:(NSKeyValueObservingOptions)options
			withSelector:(SEL)selector
{
	KISSelectorObservation *observation = [[KISSelectorObservation alloc] initWithObserver:self observed:object options:options keyPaths:keyPaths selector:selector];
	[[self kis_observer] addObservation:observation];
}

- (void)observeObject:(NSObject *)object
			 forKeyPaths:(NSString *)keyPaths
			withSelector:(SEL)selector
{
	KISSelectorObservation *observation = [[KISSelectorObservation alloc] initWithObserver:self observed:object options:0 keyPaths:keyPaths selector:selector];
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
