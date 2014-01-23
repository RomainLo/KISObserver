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

/**
 Immutable object that represents a KVO notification.
 */
@interface KISNotification : NSObject

/** Initializer with the usefull parameters of -observeValueForKeyPath:ofObject:change:context: */
- (id)initWithObservable:(id)observable keyPath:(NSString *)keyPath change:(NSDictionary *)change;

/** The observed object that has triggered the notification. */
@property (nonatomic, weak, readonly) id observable;

/** The key path that has change on the observed object. */
@property (nonatomic, strong, readonly) NSString *keyPath;

/** The related dictionnary of the KVO notification. */
@property (nonatomic, strong, readonly) NSDictionary *change;

@end

/**
 Category that provides wrappers on the change dictionnary of a notification.
 */
@interface KISNotification (KeyValueChange)

/** The new value of the attribute related to the key path. */
@property (nonatomic, strong, readonly) id newValue;

/** The old value of the attribute related to the key path. */
@property (nonatomic, strong, readonly) id oldValue;

/** The inserted indexes into the to-many relationship that is being observed. */
@property (nonatomic, strong, readonly) NSIndexSet *insertIndexSet;

/** The removed indexes from the to-many relationship that is being observed. */
@property (nonatomic, strong, readonly) NSIndexSet *removeIndexSet;

/** The replace indexes into the to-many relationship that is being observed. */
@property (nonatomic, strong, readonly) NSIndexSet *replaceIndexSet;

/** Say if the notification is for setting. */
@property (nonatomic, assign, readonly, getter = isSetting) BOOL setting;

/** Say if the notification is prior. */
@property (nonatomic, assign, readonly, getter = isPrior) BOOL prior;

@end
