//
//  AppDelegate.h
//  BlusApp
//
//  Created by Usman Ghani on 16/06/2014.
//  Copyright (c) 2014 Gexton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "Post.h"
#import "HomeViewController.h"
#import "SideMenuVC.h"
#import "MFSideMenuContainerViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    
    POST *post;
}


@property (strong, nonatomic) HomeViewController *homeVC;

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSString *deviceToken;
@property (strong, nonatomic) UILabel *registerLabel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic)NSMutableArray *responseArray;
@property (strong, nonatomic)NSMutableDictionary *responseDict;

@property (strong, nonatomic)NSString *userFrom_id;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (void) copyDatabaseIfNeeded;

-(void)getNotification;

@property (strong, nonatomic)NSMutableArray *userArrays_id;

@end
