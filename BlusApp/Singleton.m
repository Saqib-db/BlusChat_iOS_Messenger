//
//  Singleton.m
//
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Singleton.h"
#import "Reachability.h"


@implementation Singleton

@synthesize	templateId;
@synthesize selectedTheme;
@synthesize userLocation;
@synthesize preventRespondToShakeEvent;
@synthesize shoppingCartItems;

static Singleton *sharedSingleton = nil;

+ (Singleton*) retrieveSingleton {
	@synchronized(self) {
		if (sharedSingleton == nil) {
			sharedSingleton = [[Singleton alloc] init];
            sharedSingleton.shoppingCartItems = [[NSMutableArray alloc] init];
		}
	}
	return sharedSingleton;
}

+ (id) allocWithZone:(NSZone *) zone {
	@synchronized(self) {
		if (sharedSingleton == nil) {
			sharedSingleton = [super allocWithZone:zone];
			return sharedSingleton;
		}
	}
	return nil;
}

@end
