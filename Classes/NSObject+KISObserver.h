//
//  NSObject+KISObserver.h
//  KISObserver
//
//  Created by Romain Lofaso on 05/01/14.
//  Copyright (c) 2014 RomainLo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (KISObserver)

- (void)observeObject:(NSObject *)object
			 forKeyPaths:(NSString *)keyPaths
				  options:(NSKeyValueObservingOptions)options;

- (void)observeObject:(NSObject *)object
			 forKeyPaths:(NSString *)keyPaths;

#ifdef NS_BLOCKS_AVAILABLE

- (void)observeObject:(NSObject *)object
			 forKeyPaths:(NSString *)keyPaths
				  options:(NSKeyValueObservingOptions)options
				withBlock:(void(^)(__weak id observed, NSDictionary *change))block;

- (void)observeObject:(NSObject *)object
			 forKeyPaths:(NSString *)keyPaths
				withBlock:(void(^)(__weak id observed, NSDictionary *change))block;
#endif

- (void)observeObject:(NSObject *)object
			 forKeyPaths:(NSString *)keyPaths
				  options:(NSKeyValueObservingOptions)options
			withSelector:(SEL)selector;

- (void)observeObject:(NSObject *)object
			 forKeyPaths:(NSString *)keyPaths
			withSelector:(SEL)selector;

- (void)stopObservingObject:(NSObject *)object
					 forKeyPaths:(NSString *)keyPaths;

- (void)stopObservingAllObjects;

- (BOOL)isObservingObject:(NSObject *)object forKeyPath:(NSString *)keyPath;

@end
