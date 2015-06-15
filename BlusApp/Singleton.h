//
//  Singleton.h
//
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface Singleton : NSObject {

	int templateId;
    CLLocationCoordinate2D userLocation;
    BOOL preventRespondToShakeEvent;
    NSMutableArray* shoppingCartItems;
}

@property (strong, nonatomic)NSString *mood;
@property (strong, nonatomic)NSMutableArray *invitedUsersArray;
@property (nonatomic,readwrite) int templateId;
@property (nonatomic,readwrite) int selectedTheme;
@property (nonatomic,readwrite) CLLocationCoordinate2D userLocation;
@property (nonatomic,readwrite) BOOL preventRespondToShakeEvent;
@property (nonatomic,readwrite) NSMutableArray* shoppingCartItems;

+ (Singleton*) retrieveSingleton;

@end
