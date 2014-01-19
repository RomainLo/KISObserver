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

- (void)notifyWithNotification:(KISNotification *)notification
{

}

- (void)notifyWithNotification:(KISNotification *)notification whatever:(id)whatever
{

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{

}

@end
