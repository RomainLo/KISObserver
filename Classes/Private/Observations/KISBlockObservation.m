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

#import "KISBlockObservation.h"

#ifdef NS_BLOCKS_AVAILABLE

@implementation KISBlockObservation

- (instancetype)initWithObserver:(id)observer
								observed:(id)observed
								 options:(NSKeyValueObservingOptions)options
								keyPaths:(NSString *)keyPaths
									block:(KISObserverBlock)block
{
	if (!block)
		[[NSException exceptionWithName:NSInvalidArgumentException reason:@"The block can't be nil." userInfo:nil] raise];
	
	self = [super initWithObserver:observer observed:observed options:options keyPaths:keyPaths];
	if (self) {
		_block = [block copy];
		[self startObservation];
	}
	
	return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	KISNotification *notif = [[KISNotification alloc] initWithObservable:object keyPath:keyPath change:change];
	self.block(notif);
}

@end

#endif