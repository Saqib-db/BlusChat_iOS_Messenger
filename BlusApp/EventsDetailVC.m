//
//  EventsDetailVC.m
//  BlusApp
//
//  Created by Zeeshan Anwar on 8/24/14.
//  Copyright (c) 2014 Gexton. All rights reserved.
//

#import "EventsDetailVC.h"
#import "dbClass.h"
#import "IphoneAsyncImageView.h"
#import "ContactsViewController.h"
#import "Singleton.h"


#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )


@interface EventsDetailVC ()

@end

@implementation EventsDetailVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(BOOL)connectedToWiFi
{
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    bool result = false;
    if (internetStatus == ReachableViaWiFi )
    {
        result = true;
    }
    else if(internetStatus == ReachableViaWWAN){
        result = true;
    }
    return result;
}

- (void)viewDidLoad
{
    
    post = [[POST alloc]init];
    post.delegate = self;
  
    self.dublicate_users_Array = [[NSMutableArray alloc]init];
    
    [super viewDidLoad];
    
    [NSTimer scheduledTimerWithTimeInterval:5.0
                                     target:self
                                   selector:@selector(check_notification10)
                                   userInfo:nil
                                    repeats:YES];

  
   // NSLog(@"index---> %ld", (long)self.index);
    
    // NSLog(@"usersArray--> %@", self.usersArray);
    
    self.event_id= [[self.usersArray objectAtIndex:0]objectForKey:@"event_id"];
    self.userFrom = [[self.usersArray objectAtIndex:0]objectForKey:@"user_from"];
    
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  
    if ([[defaults stringForKey:@"status_user"] isEqualToString:@"1"]) {
        
    //    NSLog(@"Its Client");
        
        self.tableView.frame = CGRectMake(0.0, 445.0, 320.0, 60.0);
        
        [self.scrollView setContentSize:CGSizeMake(320.0, 590.0)];
        
        self.eventCreated_Lbl.text = @"Event Created By";
        
        NSString *user_from = [[self.usersArray objectAtIndex:0]objectForKey:@"user_from"];
       
        dbClass *db = [[dbClass alloc]init];
        
       self.usersArray = [db get_user_detail:user_from];
        
       


    }else{
        
        
        for (int i=0; i < [self.usersArray count]; i++) {
            
            NSString *user_to = [[self.usersArray objectAtIndex:i]objectForKey:@"user_to"];
            dbClass *db = [[dbClass alloc]init];
            NSMutableArray *arr = [db get_user_detail:user_to];
            
            for (int x=0; x < [arr count]; x++) {
                
                [self.dublicate_users_Array addObject:[arr objectAtIndex:x]];
            }
        }
        
        self.usersArray = self.dublicate_users_Array;
        
        [self.scrollView setContentSize:CGSizeMake(320.0, 640.0)];
    }
    
    self.event_title_Lbl.text = self.event_title_str;
    self.eventDetailTextView.text = self.event_detail_str;
    
    //self.event_detail_Lbl.text = self.event_detail_str;
    
    self.startDate_Lbl.text = self.start_date_str;
    self.startTime_Lbl.text = self.start_time_str;
    
    self.endDate_Lbl.text = self.end_date_str;
    self.endTimeLbl.text = self.end_time_str;
    
    
}

-(void)check_notification10{
    
    dbClass *db = [[dbClass alloc]init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.msgsArray = [db get_conversation:[defaults stringForKey:@"user_from_id"]];
    
    if ([self.msgsArray count] != 0) {
        
        
        if ([[[self.msgsArray objectAtIndex:0]objectForKey:@"is_read"] isEqualToString:@"0"]) {
            
            
            self.notificationIconImg.hidden = NO;
            //  NSLog(@"one msg is unread");
        }
    }
    
}


-(void)viewWillAppear:(BOOL)animated{
    
    
    self.notificationIconImg.hidden = YES;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    dbClass *db = [[dbClass alloc]init];
    
    // Checking if there is any unread msg, if it is then show the number icon on header
    
    self.msgsArray = [db get_conversation:[defaults stringForKey:@"user_from_id"]];
    
    if ([self.msgsArray count] !=0) {
        
        if ([[[self.msgsArray objectAtIndex:0]objectForKey:@"is_read"] isEqualToString:@"0"]) {
            
            self.notificationIconImg.hidden = NO;
            
        }
        
    }
    
    self.eventDetail_headerLbl.font = [UIFont fontWithName:@"Lato-Regular" size:20];
    self.inviteClient_Lbl.titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:15];
    self.backBtn_lbl.titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:15];
    
    
    self.event_title_Lbl.font = [UIFont fontWithName:@"Lato-Regular" size:20];
    //self.event_detail_Lbl.font = [UIFont fontWithName:@"Lato-Regular" size:16];
    self.eventDetailTextView.font = [UIFont fontWithName:@"Lato-Regular" size:14];
    self.startEvent_Lbl.font = [UIFont fontWithName:@"Lato-Regular" size:18];
    self.endEvent_Lbl.font = [UIFont fontWithName:@"Lato-Regular" size:18];
    self.eventCreated_Lbl.font = [UIFont fontWithName:@"Lato-Regular" size:20];
    
    // If its coming from the contactsVC for client invited by agent for event that is created by admin
    
    if ([defaults stringForKey:@"isClientPushed"]) {
        
        
        Singleton *single = [Singleton retrieveSingleton];
        self.selected_usersArray_clients = single.invitedUsersArray;
        
       // self.usersCount.text = [NSString stringWithFormat:@"%lu", (unsigned long)[self.selected_usersArray count]];
        
        self.user_to_id_comma_seperated = [self.selected_usersArray_clients componentsJoinedByString:@"_"];
         NSLog(@"Result--> %@", self.user_to_id_comma_seperated);
        
        
        [defaults removeObjectForKey:@"isClientPushed"];
        
        // Call the webservice here
        
         MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        hud.mode = MBProgressHUDModeIndeterminate;
        
        hud.labelText = @"Inviting Client";
        
        
        if ([self connectedToWiFi]) {
            
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                
                // MY CODE BEGIN //

                if ([self.userFrom isEqualToString:@"0"]) {
                    
                    [post inviteClientsForEvent:[defaults stringForKey:@"user_from_id"] :self.user_to_id_comma_seperated :self.event_id:@"admin"];
                    
                }else{
        
                    [post inviteClientsForEvent:[defaults stringForKey:@"user_from_id"] :self.user_to_id_comma_seperated :self.event_id :@"agent"];
                }
               
                // MY CODE ENDS //
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                    
                });
            });
        }else{
            // IF not internet
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please check your internet connection" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }
    
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
       return [self.usersArray count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // For CellStyleDefault
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
  
    
  
    NSString *imgUrl = [[self.usersArray objectAtIndex:indexPath.row]objectForKey:@"img_link"];
  
     UIImageView *profileImgView = [[UIImageView alloc]initWithFrame:CGRectMake(12.0, 12.0, 30.0, 30.0)];
    
    if ([imgUrl isEqual:[NSNull null]] || [imgUrl isEqualToString:@""]) {
        
        UIImage *profileImg = [UIImage imageNamed:@"test_dp.png"];
        
        [profileImgView setImage:profileImg];
        
        [cell.contentView addSubview:profileImgView];
    }
    
    else{
        
        IphoneAsyncImageView *participantImg = [[IphoneAsyncImageView alloc] initWithFrame:CGRectMake(12.0f, 12.0f, 30.0f, 30.0f)];
        participantImg.cv_width = 100.0f;
        participantImg.cv_height = 100.0f;
        participantImg.backgroundColor = [UIColor clearColor];
        [participantImg loadImageFromURL:[NSURL URLWithString:imgUrl]];
        [cell.contentView addSubview:participantImg];
        
        }
    
    
    UILabel *nameLbl = [[UILabel alloc]initWithFrame:CGRectMake(50.0, 10.0, 250.0, 30.0)];
    
    nameLbl.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:17];
    nameLbl.backgroundColor = [UIColor clearColor];
    
    [nameLbl setText: [NSString stringWithFormat:@"%@ %@",[[self.usersArray objectAtIndex:indexPath.row]objectForKey:@"fname"],[[self.usersArray objectAtIndex:indexPath.row]objectForKey:@"lname"]]];
    
    [cell.contentView addSubview:nameLbl];
    
   
    return cell;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)backBtnPressed:(id)sender {
//    
//    if ([[[self.msgsArray objectAtIndex:0]objectForKey:@"is_read"] isEqualToString:@"0"] || [[self.msgsArray objectAtIndex:0]objectForKey:@"is_read"] == nil) {
//        
//        
//        HomeViewController *dashBoardVC = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
//        
//        self.homeVC = dashBoardVC;
//        
//        
//        SideMenuVC *leftMenuViewController = [[SideMenuVC alloc]init];
//        
//        MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController
//                                                        containerWithCenterViewController:self.homeVC
//                                                        leftMenuViewController:leftMenuViewController
//                                                        rightMenuViewController:nil];
//        
//        [self.navigationController pushViewController:container animated:NO];
//        
//        
//    }else{
//
    
        [self.navigationController popToRootViewControllerAnimated:YES];
  //  }
}

- (IBAction)inviteClientBtnPressed:(id)sender {
    
    ContactsViewController *contactsVc = [[ContactsViewController alloc]initWithNibName:@"ContactsViewController" bundle:nil];
    contactsVc.isPushed = @"eventPushed";
    contactsVc.isPushed_client = @"clientPushed";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.usersArray forKey:@"usersArrayInvited"];
    [defaults synchronize];
    
    [self presentViewController:contactsVc animated:YES completion:nil];
}



#pragma mark - Connections
-(void)ConnectionDidFinishLoading:(NSString *)responseString :(NSString *)serviceName{
    
    NSLog(@"%@",serviceName);
    
    //  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if([serviceName isEqualToString:@"inviteClientsForEvent"]){
        
        self.responseDict = [responseString objectFromJSONString];
        
        if ([[self.responseDict objectForKey:@"status"] isEqualToString:@"success"]) {
            
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            
            NSLog(@"If response is not successful");
        }
    }
    
}


-(void)ConnectiondidFailWithError:(NSString *)responseString :(NSString *)serviceName{
    /*
     [MBProgressHUD hideHUDForView:self.view animated:YES];
     
     UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please Check Your Internet Connection" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
     [alertView show];
     */
    
}


@end
