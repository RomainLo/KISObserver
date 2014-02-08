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

- (NSString *)description
{
	NSMutableString * const result = [NSMutableString stringWithFormat:@"<%@ %p> observable: %@; keypath: %@", [self class], self, self.observable, self.keyPath];
	if (self.newValue) [result appendFormat:@"; newValue: %@", self.newValue];
	if (self.oldValue) [result appendFormat:@"; oldValue: %@", self.oldValue];
	if (self.insertionIndexSet) [result appendFormat:@"; insertionIndexSet: %@", self.insertionIndexSet];
	if (self.removalIndexSet) [result appendFormat:@"; removalIndexSet: %@", self.removalIndexSet];
	if (self.replacementIndexSet) [result appendFormat:@"; removalIndexSet: %@", self.replacementIndexSet];
	if (self.isPrior) [result appendString:@"; isPrior"];
	if (self.isSetting) [result appendString:@"; isSetting"];
	return result;
}

@end

@implementation KISNotification (KeyValueChange)

- (id)newValue
{
	const id value = self.change[NSKeyValueChangeNewKey];
	return (value != [NSNull null]) ? value : nil;
}

- (id)oldValue
{
	const id value = self.change[NSKeyValueChangeOldKey];
	return (value != [NSNull null]) ? value : nil;
}

- (NSIndexSet *)insertionIndexSet
{
	return [self kvc_indexSetByKeyValueChange:NSKeyValueChangeInsertion];
}

- (NSIndexSet *)removalIndexSet
{
	return [self kvc_indexSetByKeyValueChange:NSKeyValueChangeRemoval];
}

- (NSIndexSet *)replacementIndexSet
{
	return [self kvc_indexSetByKeyValueChange:NSKeyValueChangeReplacement];
}

- (BOOL)isPrior
{
	NSNumber * const value = self.change[NSKeyValueChangeNotificationIsPriorKey];
	return [value boolValue];
}

- (BOOL)isSetting
{
	NSNumber * const value = self.change[NSKeyValueChangeKindKey];
	return [value unsignedIntegerValue] == NSKeyValueChangeSetting;
}

#pragma mark - Private methods

- (NSIndexSet *)kvc_indexSetByKeyValueChange:(NSKeyValueChange)kvc
{
	const BOOL isGoodKvc = [self.change[NSKeyValueChangeKindKey] intValue] == kvc;
	NSIndexSet * const kvcIndexSet = self.change[NSKeyValueChangeIndexesKey];
	return (isGoodKvc && kvcIndexSet.count) ? kvcIndexSet : [NSIndexSet indexSet];
}

@end
