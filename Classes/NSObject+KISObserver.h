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
 A category on NSObject that provides easy-to-use KVO handlings.
 
 You can add an observation of many keypaths at the same time by separating
 them with a '|' when you call an observeObject:forKeyPaths:[*] method.
 Exemple:
 [self observeObject:obj forKeyPaths:@"key1|key2|key3"];
 
 The observations are automatically removed when the observater is deallocated.
 */
@interface NSObject (KISObserver)

/// @name Adding basic KVO

/**
 Start to observe keypaths on an object with options.
 	
 The observer will be notified via the -observeValueForKeyPath:ofObject:change:context: method.
 
 @param object The targeted object of the observation.
 @param keyPaths A list of keypaths (separated by '|') to observe.
 @param options A combination of values that specifies what is included in observation notifications.
 
 @exception NSException Throw if one of the parameters is nil or empty string.
 */
- (void)observeObject:(NSObject *)object
			 forKeyPaths:(NSString *)keyPaths
				  options:(NSKeyValueObservingOptions)options;

/**
 Start to observe keypaths on an object without options.
 
 The observer will be notified via the -observeValueForKeyPath:ofObject:change:context: method.
 
 @param object The targeted object of the observation.
 @param keyPaths A list of keypaths (separated by '|') to observe.
 
 @exception NSException Throw if one of the parameters is nil or empty string.
 */
- (void)observeObject:(NSObject *)object
			 forKeyPaths:(NSString *)keyPaths;


/// @name Adding KVO with blocks

#ifdef NS_BLOCKS_AVAILABLE

/**
 Start to observe keypaths on an object with options and be notified via the given block.
 
 @param object The targeted object of the observation.
 @param keyPaths A list of keypaths (separated by '|') to observe.
 @param options A combination of values that specifies what is included in observation notifications.
 @param block The block that will be called when there is a notification.
 
 @exception NSException Throw if one of the parameters is nil or empty string.
 */
- (void)observeObject:(NSObject *)object
			 forKeyPaths:(NSString *)keyPaths
				  options:(NSKeyValueObservingOptions)options
				withBlock:(void(^)(__weak id observed, NSDictionary *change))block;

/**
 Start to observe keypaths on an object without options and be notified via the given block.
 
 @param object The targeted object of the observation.
 @param keyPaths A list of keypaths (separated by '|') to observe.
 @param block The block that will be called when there is a notification.
 
 @exception NSException Throw if one of the parameters is nil or empty string.
 */
- (void)observeObject:(NSObject *)object
			 forKeyPaths:(NSString *)keyPaths
				withBlock:(void(^)(__weak id observed, NSDictionary *change))block;
#endif

/// @name Adding KVO with selectors

/**
 Start to observe keypaths on an object with options and be notified via the given selector.
 
 The given selector can have between zero and two arguments:
 - (void)notify;
 - (void)notifyWithObserved:(NSObject *)observed;
 - (void)notifyWithObserved:(NSObject *)observed change:(NSDictionary *)change;
 
 @param object The targeted object of the observation.
 @param keyPaths A list of keypaths (separated by '|') to observe.
 @param options A combination of values that specifies what is included in observation notifications.
 @param selector The selector that will be called (on the observer) when there is a notification.
 
 @exception NSException Throw if one of the parameters is nil or empty string.
 @exception NSException Throw if doesn't exist on the observer or have more than two arguments.
 */
- (void)observeObject:(NSObject *)object
			 forKeyPaths:(NSString *)keyPaths
				  options:(NSKeyValueObservingOptions)options
			withSelector:(SEL)selector;

/**
 Start to observe keypaths on an object without options and be notified via the given selector.
 
 The given selector can have between zero and two arguments:
 - (void)notify;
 - (void)notifyWithObserved:(NSObject *)observed;
 - (void)notifyWithObserved:(NSObject *)observed change:(NSDictionary *)change;
 
 @param object The targeted object of the observation.
 @param keyPaths A list of keypaths (separated by '|') to observe.
 @param selector The selector that will be called (on the observer) when there is a notification.
 
 @exception NSException Throw if one of the parameters is nil or empty string.
 @exception NSException Throw if doesn't exist on the observer or have more than two arguments.
 */
- (void)observeObject:(NSObject *)object
			 forKeyPaths:(NSString *)keyPaths
			withSelector:(SEL)selector;

/// @name Removing KVO

/**
 Remove an observation on an object for given keypaths.
 
 @param object The targeted object of the observation to remove.
 @param keyPaths A list of keypaths (separated by '|').
 
 @warning Make sure that you provide the same keyPaths string that you used to add the observation.
 */
- (void)stopObservingObject:(NSObject *)object
					 forKeyPaths:(NSString *)keyPaths;

/** Remove all observations. */
- (void)stopObservingAllObjects;

/// @name Utils

/**
 Say if the current object has an observation on the given object for ONE keypath.
 
 @param object The targeted object of the observation.
 @param keyPath The keypath of the observation.
 @return YES if there is at least one observation on this object with this keypath else NO.
 */
- (BOOL)isObservingObject:(NSObject *)object forKeyPath:(NSString *)keyPath;

@end
