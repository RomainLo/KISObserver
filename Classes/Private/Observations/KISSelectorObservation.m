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

#import "KISSelectorObservation.h"

#import "KISNotification.h"

@implementation KISSelectorObservation

- (instancetype)initWithObserver:(id)observer
								observed:(id)observed
								 options:(NSKeyValueObservingOptions)options
								keyPaths:(NSString *)keyPaths
								selector:(SEL)selector
{
	self = [super initWithObserver:observer observed:observed options:options keyPaths:keyPaths];
	
	if (self) {
		NSMethodSignature *methodSignature = [self.observer methodSignatureForSelector:selector];
		NSInteger numberOfArguments = [methodSignature numberOfArguments];
		if (!methodSignature || (3 < numberOfArguments))
			[[NSException exceptionWithName:NSInvalidArgumentException reason:@"The selector should have 1 parameters maximum and be part of the observer." userInfo:nil] raise];
		
		_selector = selector;
		[self startObservation];
	}
	
	return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	NSMethodSignature *methodSignature = [self.observer methodSignatureForSelector:self.selector];
	NSInteger numberOfArguments = [methodSignature numberOfArguments];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
	switch (numberOfArguments) {
		case 2: // No argument
			[self.observer performSelector:self.selector];
			break;
		case 3: { // 1 argument: the observed object
			KISNotification *notif = [[KISNotification alloc] initWithObservable:object keyPath:keyPath change:change];
			[self.observer performSelector:self.selector withObject:notif];
			break;
		}
		default:
			NSAssert(NO, @"2 < numberOfArguments < 4");
	}
#pragma clang diagnostic pop
}

@end
