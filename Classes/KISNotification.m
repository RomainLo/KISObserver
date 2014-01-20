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

#import "KISNotification.h"

@implementation KISNotification

- (id)initWithObservable:(id)observable keyPath:(NSString *)keyPath change:(NSDictionary *)change
{
	self = [super init];
	if (self) {
		
		if (!observable || !keyPath.length || !change)
			[[NSException exceptionWithName:NSInvalidArgumentException reason:@"One of the parameters is nil or empty" userInfo:nil] raise];
		
		_observable = observable;
		_keyPath = [keyPath copy];
		_change = [change copy];
	}
	
	return self;
}

@end

@implementation KISNotification (KeyValueChange)

- (id)newValue
{
	id value = self.change[NSKeyValueChangeNewKey];
	return (value != [NSNull null]) ? value : nil;
}

- (id)oldValue
{
	id value = self.change[NSKeyValueChangeOldKey];
	return (value != [NSNull null]) ? value : nil;
}

- (NSIndexSet *)insertIndexSet
{
	return [self kvc_indexSetByKeyValueChange:NSKeyValueChangeInsertion];
}

- (NSIndexSet *)removeIndexSet
{
	return [self kvc_indexSetByKeyValueChange:NSKeyValueChangeRemoval];
}

- (NSIndexSet *)replaceIndexSet
{
	return [self kvc_indexSetByKeyValueChange:NSKeyValueChangeReplacement];
}

- (BOOL)isPrior
{
	NSNumber *value = self.change[NSKeyValueChangeOldKey];
	return [value boolValue];
}

#pragma mark - Private methods

- (NSIndexSet *)kvc_indexSetByKeyValueChange:(NSKeyValueChange)kvc
{
	BOOL isGoodKvc = [self.change[NSKeyValueChangeKindKey] intValue] == kvc;
	NSIndexSet *kvcIndexSet = self.change[NSKeyValueChangeIndexesKey];
	return (isGoodKvc && kvcIndexSet.count) ? kvcIndexSet : nil;
}

@end
