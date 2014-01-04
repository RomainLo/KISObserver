//
//  KISObserver.h
//  KISObserver
//
//  Created by Romain Lofaso on 28/12/13.
//  Copyright (c) 2013 RomainLo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KISObserver : NSObject

#ifdef NS_BLOCKS_AVAILABLE

- (void)observeObject:(NSObject *)object
			 forKeyPaths:(NSString *)keyPath
				  options:(NSKeyValueObservingOptions)options
				withBlock:(void(^)(__weak id observed, NSDictionary *change))block;

- (void)observeObject:(NSObject *)object
			 forKeyPaths:(NSString *)keyPath
				withBlock:(void(^)(__weak id observed, NSDictionary *change))block;
#endif

- (void)observeObject:(NSObject *)object
			 forKeyPaths:(NSString *)keyPath
				  options:(NSKeyValueObservingOptions)options;

- (void)observeObject:(NSObject *)object
			 forKeyPaths:(NSString *)keyPath;

- (void)observeObject:(NSObject *)object
			 forKeyPaths:(NSString *)keyPath
				  options:(NSKeyValueObservingOptions)options
			withSelector:(SEL)selector;

- (void)observeObject:(NSObject *)object
			 forKeyPaths:(NSString *)keyPath
			withSelector:(SEL)selector;

- (void)stopObservingObject:(NSObject *)object
					 forKeyPaths:(NSString *)keyPath;

- (void)stopObservingAllObjects;

- (BOOL)isObservingObject:(NSObject *)object forKeyPath:(NSString *)keyPath;

@end
