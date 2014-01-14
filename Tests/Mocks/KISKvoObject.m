//
//  KISKvoObjectMock.m
//  KISObserver
//
//  Created by Romain Lofaso on 13/01/14.
//  Copyright (c) 2014 RomainLo. All rights reserved.
//

#import "KISKvoObject.h"

NSString *kKvoPropertyKeyPath1 = @"kvoProperty1";
NSString *kKvoPropertyKeyPath2 = @"kvoProperty2";
NSString *kKvoPropertyKeyPaths = @"kvoProperty1|kvoProperty2";

@implementation KISKvoObject

- (void)notify
{
	
}

- (void)notifyWithObserved:(NSObject *)observed
{

}

- (void)notifyWithObserved:(NSObject *)observed change:(NSDictionary *)change
{

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{

}

@end
