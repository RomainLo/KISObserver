//
//  KISKvoObjectMock.h
//  KISObserver
//
//  Created by Romain Lofaso on 13/01/14.
//  Copyright (c) 2014 RomainLo. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *kKvoPropertyKeyPath1;
extern NSString *kKvoPropertyKeyPath2;
extern NSString *kKvoPropertyKeyPaths;

@interface KISKvoObject : NSObject

@property (nonatomic, assign) NSUInteger kvoProperty1;

@property (nonatomic, assign) NSUInteger kvoProperty2;

// Selectors
- (void)notify;
- (void)notifyWithObserved:(NSObject *)observed;
- (void)notifyWithObserved:(NSObject *)observed change:(NSDictionary *)change;

@end
