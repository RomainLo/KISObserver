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

#import "KISObservation.h"

NSString * const kKISObservationContext = @"com.observation.context";

@implementation KISObservationBase {
	BOOL _isObserving;
}

- (id)initWithObserver:(id)observer
				observable:(id)observable
					options:(NSKeyValueObservingOptions)options
					keyPath:(NSString *)keyPath
{
	if (!observable)
		[[NSException exceptionWithName:NSInvalidArgumentException reason:@"The observed can't be nil." userInfo:nil] raise];
	if (!observer)
		[[NSException exceptionWithName:NSInvalidArgumentException reason:@"The observer can't be nil." userInfo:nil] raise];
	if (![keyPath length])
		[[NSException exceptionWithName:NSInvalidArgumentException reason:@"The keypath can't be nil or empty." userInfo:nil] raise];
	
	self = [super init];
	if (self) {
		_observer = observer;
		_observable = observable;
		_options = options;
		_keyPath = keyPath;
		_isObserving = NO;
	}
	
	return self;
}

- (void)dealloc
{
	if (_isObserving) {
		[self.observable removeObserver:self forKeyPath:self.keyPath context:(__bridge void *)(kKISObservationContext)];
	}
}

- (void)startObservation
{
	if (_isObserving) return;
	[self.observable addObserver:self forKeyPath:self.keyPath options:self.options context:(__bridge void *)(kKISObservationContext)];
	_isObserving = true;
}

@end
