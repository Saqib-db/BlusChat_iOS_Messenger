//
//  AppDelegate.m
//  BlusApp
//
//  Created by Usman Ghani on 16/06/2014.
//  Copyright (c) 2014 Gexton. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"




@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    [defaults setObject:@"1" forKey:@"first_login"];
    
    [defaults synchronize];
    
    // Adding custom font
    NSArray *fontFamilies = [UIFont familyNames];
    for (int i = 0; i < [fontFamilies count]; i++)
    {
        NSString *fontFamily = [fontFamilies objectAtIndex:i];
        NSArray *fontNames = [UIFont fontNamesForFamilyName:[fontFamilies objectAtIndex:i]];
        NSLog (@"%@: %@", fontFamily, fontNames);
    }
    
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    post = [[POST alloc]init];
    
    post.delegate = self;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Override point for customization after application launch.
    
    [self copyDatabaseIfNeeded];
    
    LoginViewController *loginVC = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    
    UINavigationController *navCont = [[UINavigationController alloc]initWithRootViewController:loginVC];
    
    self.window.rootViewController = navCont;
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self.window makeKeyAndVisible];
    
   // application.applicationIconBadgeNumber = 0;
    
    
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    
    // Handle launching from a notification
    UILocalNotification *localNotif =
    [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    
    if (localNotif) {
        NSLog(@"Recieved Notification %@",localNotif);
        
        application.applicationIconBadgeNumber = 0;
    }
    
    return YES;

}



#pragma mark - COPY DATABASE

- (void) copyDatabaseIfNeeded
{
	BOOL success;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"blusApp.sqlite"];
	//printf(writableDBPath);
	success = [fileManager fileExistsAtPath:writableDBPath];
	if (success) return;
	// The writable database does not exist, so copy the default to the appropriate location.
	NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"blusApp.sqlite"];
	success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    
	if (!success)
	{
		NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
	}
}


-(void)getNotification{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [post getNotification:[defaults stringForKey:@"user_from_id"]];
    
}



#pragma mark - Connections
-(void)ConnectionDidFinishLoading:(NSString *)responseString :(NSString *)serviceName{
    
    NSLog(@"%@",serviceName);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    if([serviceName isEqualToString:@"getNotification"]){
        
        self.responseDict = [responseString objectFromJSONString];
        
        if ([[self.responseDict objectForKey:@"recived_messages"]count] !=0) {
            
            self.responseArray = [self.responseDict objectForKey:@"recived_messages"];
            self.userFrom_id = [[self.responseArray objectAtIndex:0]objectForKey:@"from_id"];
           
           // NSLog(@"response--> %@",self.responseArray);
            
            [self localNotificaiton];
            
        }else{
            self.responseArray = [self.responseDict objectForKey:@"web_messages"];
            self.userFrom_id = @"0";
            
            [self localNotificaiton];
           
        }
       
        dbClass *db = [[dbClass alloc]init];
        
        if ([self.responseArray count] !=0) {
            
            for (int x=0; x < [self.responseArray count]; x++) {
                
              //  NSLog(@"message %@",[[self.responseArray objectAtIndex:x]objectForKey:@"msg"]);
               
                // if its coming from admin panel
                
                    if ([[self.responseDict objectForKey:@"recived_messages"]count] == 0) {
                        
                        if ([[[[self.responseArray objectAtIndex:x]objectForKey:@"msg"]pathExtension] isEqualToString:@"jpg"] ||[[[[self.responseArray objectAtIndex:x]objectForKey:@"msg"]pathExtension] isEqualToString:@"png"]) {
                           
                            NSLog(@".jpg exist");

                            
                             NSString *urlPathStr = [NSString stringWithFormat:@"http://www.blusserver.com/bluschat/assets/gallery/%@", [[self.responseArray objectAtIndex:x]objectForKey:@"msg"]];
                            
                            urlPathStr = [urlPathStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                            
                            NSLog(@"urlPathStr---------------------------------> %@", urlPathStr);
                            
                            [db insertMessages:[defaults stringForKey:@"user_from_id"]:self.userFrom_id :urlPathStr :[[self.responseArray objectAtIndex:0]objectForKey:@"date_time"] :@"0" :@"0" :@"1" :@"0"];
                        
                        }else{
   
                            [db insertMessages:[defaults stringForKey:@"user_from_id"]:self.userFrom_id :[[self.responseArray objectAtIndex:x]objectForKey:@"msg"] :[[self.responseArray objectAtIndex:0]objectForKey:@"date_time"] :@"0" :@"0" :@"0" :@"0"];
                            
                        }
                    }else{
                        
                        // If its coming from App
                        
                         NSLog(@"response msg--> %@",[[self.responseArray objectAtIndex:x]objectForKey:@"msg"]);
                        
                        if ([[[[self.responseArray objectAtIndex:x]objectForKey:@"msg"]pathExtension] isEqualToString:@"jpg"] ||[[[[self.responseArray objectAtIndex:x]objectForKey:@"msg"]pathExtension] isEqualToString:@"png"]) {
                          
                            NSLog(@".jpg/png exist");
                            
                            
                            NSString *urlPathStr = [NSString stringWithFormat:@"http://www.blusserver.com/bluschat/assets/msg-img/%@", [[self.responseArray objectAtIndex:x]objectForKey:@"msg"]];
                            
                            urlPathStr = [urlPathStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                            
                            NSLog(@"urlPathStr---------------------------------> %@", urlPathStr);
                            
                            // If its image
                            [db insertMessages:[defaults stringForKey:@"user_from_id"]:self.userFrom_id :urlPathStr :[[self.responseArray objectAtIndex:0]objectForKey:@"date_time"] :@"0" :@"0" :@"1" :@"0"];
                            
                            
                            
                        }else{
                            
                             // if its a msg
                            [db insertMessages:[defaults stringForKey:@"user_from_id"]:self.userFrom_id :[[self.responseArray objectAtIndex:x]objectForKey:@"msg"] :[[self.responseArray objectAtIndex:0]objectForKey:@"date_time"] :@"0" :@"0" :@"0" :@"0"];
                            
                        }

                    }
            
        }
        
        }else{
            // If responseArray count = 0;
        }
    }
}


-(void)localNotificaiton{

    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    //localNotif.fireDate = date;  // date after 10 sec from now
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    
    // Notification details
   // localNotif.fireDate =  [NSDate dateWithTimeIntervalSinceNow:5];
    
     if ([self.responseArray count] !=0) {
         
         // if its coming from admin panel
         if ([[[[self.responseArray objectAtIndex:0]objectForKey:@"msg"]pathExtension] isEqualToString:@"jpg"] ||[[[[self.responseArray objectAtIndex:0]objectForKey:@"msg"]pathExtension] isEqualToString:@"png"]) {
             NSLog(@".jpg exist");
             
             localNotif.alertBody = @"Image";
             
         }else{
             if ([self.userFrom_id isEqualToString:@"0"]) {
                
                 localNotif.alertBody =  [NSString stringWithFormat:@"Admin Says: %@",[[self.responseArray objectAtIndex:0]objectForKey:@"msg"]]; // text of you that you have fetched
             }else{
             
            
                 localNotif.alertBody =  [NSString stringWithFormat:@"%@ %@ Says: %@",[[self.responseArray objectAtIndex:0]objectForKey:@"fname"], [[self.responseArray objectAtIndex:0]objectForKey:@"lname"], [[self.responseArray objectAtIndex:0]objectForKey:@"msg"]];
                 // text of you that you have fetched
             }
         }
        // Set the action button
        localNotif.alertAction = @"View";
         
         if ([self.userFrom_id isEqualToString:@"0"]) {
         
        //     localNotif.alertAction = @"Admin";
         }else{
             //localNotif.alertTitle = [NSString stringWithFormat:@"%@ %@", [[self.responseArray objectAtIndex:0]objectForKey:@"fname"], [[self.responseArray objectAtIndex:0]objectForKey:@"lname"]];
         }
        
         localNotif.soundName = UILocalNotificationDefaultSoundName;
//         localNotif.soundName = @"Bell.wav";
//       localNotif.soundName =  [[NSBundle mainBundle] pathForResource:@"Bell" ofType:@"wav"];
         
        localNotif.applicationIconBadgeNumber = 1;
        
        // Specify custom data for the notification
        //NSDictionary *infoDict = [NSDictionary dictionaryWithObject:@"someValue" forKey:@"someKey"];
        
        NSMutableDictionary *infoDict = [[NSMutableDictionary alloc]init];
        
       
            
         [infoDict setObject: [[self.responseArray objectAtIndex:0]objectForKey:@"msg"] forKey:@"msg"];
        localNotif.userInfo = infoDict;
    
    // Schedule the notification
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
         
     }
}



-(void)ConnectiondidFailWithError:(NSString *)responseString :(NSString *)serviceName{
  //  [MBProgressHUD hideHUDForView:self.view animated:YES];
    
//    NSLog(@"ConnectiondidFailWithError->>:%@",responseString);
//    
//    alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please Check Your Internet Connection" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//    [alertView show];
}



    
// We are registered, so now store the device token (as a string) on the AppDelegate instance
// taking care to remove the angle brackets first.

 /*
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSCharacterSet *angleBrackets = [NSCharacterSet characterSetWithCharactersInString:@"<>"];
    self.deviceToken = [[deviceToken description] stringByTrimmingCharactersInSet:angleBrackets];
    self.deviceToken = [self.deviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"Device Token %@", self.deviceToken);
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.deviceToken forKey:@"deviceToken"];
    [defaults synchronize];
    
    
}
*/
- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}


// For Local Notification

- (void)application:(UIApplication *)app didReceiveLocalNotification:(UILocalNotification  *)notif {

    
    UIApplicationState state = [app applicationState];
    
    app.applicationIconBadgeNumber = 1;
    
    if (state == UIApplicationStateActive) {
   
        // Do nothing
    }
   
    else{
        
       // NSString *nameStr = [NSString stringWithFormat:@"%@ %@", [[self.responseArray objectAtIndex:0]objectForKey:@"fname"], [[self.responseArray objectAtIndex:0]objectForKey:@"lname"]];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Blu'sChat"
                                                        message:[NSString stringWithFormat:@"%@ " , notif.alertBody]
                                                       delegate:self cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        //[alert show];
    }
    
    // saru  raat ki jaagi ankhain college me kia parhti hongi

    
    // Set icon badge number to zero
   // app.applicationIconBadgeNumber = 0;
    
   
}


// Because toast alerts don't work when the app is running, the app handles them.
// This uses the userInfo in the payload to display a UIAlertView.

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    
    UIApplicationState state = [application applicationState];
    
    
    if (state == UIApplicationStateActive) {
    
//     if (application.applicationState == UIApplicationStateActive) {
         
         // If the app is active don't show any alert.
     
     }else{
         
         //inAppMessage
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"BlusApp" message:
                               [[userInfo objectForKey:@"aps"]objectForKey:@"alert"] delegate:nil cancelButtonTitle:
                               @"OK" otherButtonTitles:nil, nil];
         [alert show];
         

     }
    
    
    /////////////////////////////////////////////
    
    /*
    NSLog(@"%@", userInfo);
    
    
    if ([[userInfo objectForKey:@"recived_messages"]count] !=0) {
        
        self.responseArray = [self.responseDict objectForKey:@"recived_messages"];
        self.userFrom_id = [[self.responseArray objectAtIndex:0]objectForKey:@"from_id"];

        
    }else{
        
        self.responseArray = [userInfo objectForKey:@"web_messages"];
        self.userFrom_id = @"0";
        // [self localNotificaiton];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSLog(@"Response Arr--> %@",self.responseArray);
    dbClass *db = [[dbClass alloc]init];
    
    if ([self.responseArray count] !=0) {
        
        for (int x=0; x < [self.responseArray count]; x++) {
            
            NSLog(@"message %@",[[self.responseArray objectAtIndex:x]objectForKey:@"msg"]);
            
            if ([[[[self.responseArray objectAtIndex:x]objectForKey:@"msg"]pathExtension] isEqualToString:@"jpg"]) {
                NSLog(@".jpg exist");
                
                NSString *urlPathStr = [NSString stringWithFormat:@"http://www.demii.com/demo/blus-app/assets/msg-img/%@", [[self.responseArray objectAtIndex:x]objectForKey:@"msg"]];
                
                // inserting with image
                [db insertMessages:[defaults stringForKey:@"user_from_id"]:self.userFrom_id :urlPathStr :[[self.responseArray objectAtIndex:0]objectForKey:@"date_time"] :@"0" :@"0" :@"1" :@"0"];
                
            }else{
                
                // inserting simple text msg
                [db insertMessages:[defaults stringForKey:@"user_from_id"]:self.userFrom_id :[[self.responseArray objectAtIndex:x]objectForKey:@"msg"] :[[self.responseArray objectAtIndex:0]objectForKey:@"date_time"] :@"0" :@"0" :@"0" :@"0"];
                
            }
        }

    
}

*/

   // }
 
}




/*
- (void)application:(UIApplication *)app didReceiveLocalNotification:(UILocalNotification  *)notif {

    // Handle the notificaton when the app is running
    
    
    UIApplicationState state = [app applicationState];
    

      if (state != UIApplicationStateActive) {
          
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Blus"
                                                        message:[NSString stringWithFormat:@"%@" ,notif.alertBody]
                                                       delegate:self cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    
    // Set icon badge number to zero
    app.applicationIconBadgeNumber = 0;
    
}
*/
    
    

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
   
    // If notification is 1 then launch the app from the homeVC
    if (application.applicationIconBadgeNumber == 1) {
        
        UINavigationController *navController = (UINavigationController *)self.window.rootViewController;
        
        HomeViewController *dashBoardVC = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
        
        self.homeVC = dashBoardVC;
        
        
        SideMenuVC *leftMenuViewController = [[SideMenuVC alloc]init];
        
        MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController
                                                        containerWithCenterViewController:self.homeVC
                                                        leftMenuViewController:leftMenuViewController
                                                        rightMenuViewController:nil];
        
        
        [navController.visibleViewController.navigationController pushViewController:container animated:YES];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}



#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"BlusApp" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"BlusApp.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
