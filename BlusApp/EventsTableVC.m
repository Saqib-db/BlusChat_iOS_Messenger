//
//  EventsTableVC.m
//  BlusApp
//
//  Created by Zeeshan Anwar on 8/24/14.
//  Copyright (c) 2014 Gexton. All rights reserved.
//

#import "EventsTableVC.h"
#import "MFSideMenu.h"
#import "MFSideMenuContainerViewController.h"
#import "MBProgressHUD.h"
#import "CreateEventVC.h"

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@interface EventsTableVC ()

@end

@implementation EventsTableVC

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

-(void)check_notification{
    
    dbClass *db = [[dbClass alloc]init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.msgsArray = [db get_conversation:[defaults stringForKey:@"user_from_id"]];
    
    if ([self.msgsArray count] != 0) {
        
        
        if ([[[self.msgsArray objectAtIndex:0]objectForKey:@"is_read"] isEqualToString:@"0"]) {
            
            
            self.notificationIconImg.hidden = NO;
            //  NSLog(@"one msg is unread");
        }else{
            self.notificationIconImg.hidden = YES;
        }
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    [NSTimer scheduledTimerWithTimeInterval:5.0
                                     target:self
                                   selector:@selector(check_notification9)
                                   userInfo:nil
                                    repeats:YES];
    
    self.responseArray = [[NSMutableArray alloc]init];
    
    if (!IS_IPHONE_5) {
        self.tableView.frame = CGRectMake(0.0, 60.0, 320.0, 420.0);
    }
    
    post = [[POST alloc]init];
    
    post.delegate = self;

    
}


-(void)check_notification9{
    
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
    
   
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    dbClass *db = [[dbClass alloc]init];
    
    self.events_header_lbl.font = [UIFont fontWithName:@"Lato-Regular" size:20];
    
    // If its client then hide the button of Create Event. Create event is only available for agent
    
    if ([[defaults stringForKey:@"status_user"] isEqualToString:@"1"]) {
  
      //  NSLog(@"Its Client");
        
        self.create_EventBtn.hidden = YES;
        
    }
    
    
    // IF Internet not available, then get the data from the database
    if (![self connectedToWiFi]) {
        
        self.responseArray = [db getAll_Events];
        
       // NSLog(@"ResponseArray---> %@", self.responseArray);
    
        [self.tableView reloadData];
        
    }else{
        
        
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        
//        hud.mode = MBProgressHUDModeIndeterminate;
//        
//        hud.labelText = @"Loading";
        
        if ([self connectedToWiFi]) {
            

            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                
                // MY CODE BEGIN //
                
                
                
                [post get_events:[defaults stringForKey:@"user_from_id"]];
                
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
    NSLog(@"count--> %lu", (unsigned long)[self.responseArray count]);
    return [self.responseArray count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 100;
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
    
    
     UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                              initWithTarget:self action:@selector(handleLongPress)];
    lpgr.minimumPressDuration = 2.0; //seconds
    lpgr.delegate = self;
    [self.tableView addGestureRecognizer:lpgr];

    
    UIImageView *eventImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10.0, 30.0, 30.0, 30.0)];
    UIImage *event_iconImg = [UIImage imageNamed:@"action_event_black.png"];
    [eventImgView setImage:event_iconImg];
    [cell.contentView addSubview:eventImgView];
    
    UILabel *event_titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(45.0, 30.0, 120.0, 30.0)];
    
    event_titleLbl.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:15];
    event_titleLbl.backgroundColor = [UIColor clearColor];
    
    [event_titleLbl setText:[[[self.responseArray objectAtIndex:indexPath.row]objectForKey:@"event_detail"]objectForKey:@"title"]];
    [cell.contentView addSubview:event_titleLbl];
    
    
    UILabel *eventDetail_titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(45.0, 55.0, 120.0, 40.0)];
    eventDetail_titleLbl.font = [UIFont fontWithName:@"Lato-Regular" size:13];
    eventDetail_titleLbl.backgroundColor = [UIColor clearColor];
    eventDetail_titleLbl.numberOfLines = 2;
    [eventDetail_titleLbl setText:[[[self.responseArray objectAtIndex:indexPath.row]objectForKey:@"event_detail"]objectForKey:@"detail"]];
    [cell.contentView addSubview:eventDetail_titleLbl];
    
    
    UIImageView *dateImgView = [[UIImageView alloc]initWithFrame:CGRectMake(220.0, 25.0, 25.0, 25.0)];
    UIImage *date_iconImg = [UIImage imageNamed:@"action_date.png"];
    [dateImgView setImage:date_iconImg];
    [cell.contentView addSubview:dateImgView];
    
    UIImageView *horizontalImgView = [[UIImageView alloc]initWithFrame:CGRectMake(235.0, 53.0, 80.0, 5.0)];
    UIImage *horizontal_iconImg = [UIImage imageNamed:@"horizontal.png"];
    [horizontalImgView setImage:horizontal_iconImg];
    [cell.contentView addSubview:horizontalImgView];
    
    UIImageView *verticalImgView = [[UIImageView alloc]initWithFrame:CGRectMake(210.0, 12.0, 5.0, 75.0)];
    UIImage *vertical_iconImg = [UIImage imageNamed:@"vertical.png"];
    [verticalImgView setImage:vertical_iconImg];
    [cell.contentView addSubview:verticalImgView];
    
    
    UILabel *start_dateLbl = [[UILabel alloc]initWithFrame:CGRectMake(250.0, 25.0, 100.0, 30.0)];
    start_dateLbl.font = [UIFont fontWithName:@"Lato-Regular" size:11];
    start_dateLbl.backgroundColor = [UIColor clearColor];
    
    NSString *dateStr = [[[self.responseArray objectAtIndex:indexPath.row]objectForKey:@"event_detail"]objectForKey:@"start"];

    
    // retrive date only from date and time string
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // this is imporant - we set our input date format to match our input string
    // if format doesn't match you'll get nil from your string, so be careful
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [dateFormatter dateFromString:dateStr];
    
    NSString *start_dateStr = [self stringDatePartOf:dateFromString];
    
    [start_dateLbl setText:start_dateStr];
    
    [cell.contentView addSubview:start_dateLbl];
    
    
    UIImageView *timeImgView = [[UIImageView alloc]initWithFrame:CGRectMake(220.0, 57.0, 25.0, 25.0)];
    UIImage *time_iconImg = [UIImage imageNamed:@"action_time.png"];
    [timeImgView setImage:time_iconImg];
    [cell.contentView addSubview:timeImgView];
    
    
    // retrive time from date and time
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
    timeFormatter.dateFormat = @"HH:mm:ss";
    NSString *timeStr = [timeFormatter stringFromDate: dateFromString];

    UILabel *start_timeLbl = [[UILabel alloc]initWithFrame:CGRectMake(250.0, 55.0, 100.0, 30.0)];
    start_timeLbl.font = [UIFont fontWithName:@"Lato-Regular" size:11];
    start_timeLbl.backgroundColor = [UIColor clearColor];
    [start_timeLbl setText:timeStr];// Start Time
    [cell.contentView addSubview:start_timeLbl];
    
    
    // Delete Button
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteBtn addTarget:self action:@selector(deleteEventBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    deleteBtn.frame = CGRectMake(250.0, 60.0, 28.0, 29.0);
    UIImage * buttonImage = [UIImage imageNamed:@"deleteBtn.png"];
    
    [deleteBtn setBackgroundImage:buttonImage forState:UIControlStateNormal];
    deleteBtn.tag = indexPath.row;
    //[cell.contentView addSubview:deleteBtn];
    
    
    return cell;
    
}


-(void)handleLongPress{
    
    
    [self.tableView setEditing:TRUE];
    
//    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Do You Want To Delete Event ?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
//    
//    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    if (buttonIndex == 0) {
        // Do Nothing
    }else{
        
        
    }
}



-(void)deleteEventBtnPressed:(id)sender{
    
   // UIButton *btn = (UIButton *)sender;
    
    
}


-(NSString*) stringDatePartOf:(NSDate*)date
{
   // NSLog(@"Date--> %@", date);
    NSDateFormatter *formatter = [NSDateFormatter new];
                                 
                                  [formatter setDateFormat:@"yyyy-MM-dd"];
    
                                  return [formatter stringFromDate:date];
                                  
    
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
     if ([[defaults stringForKey:@"status_user"] isEqualToString:@"1"]) {
         
         UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Only agent can delete event" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
         [alert show];
         
     }else{
         

        if (editingStyle == UITableViewCellEditingStyleDelete)
        {
           
            NSLog(@"index--> %lu", (long)indexPath.row);
          
            NSLog(@"responseArray--> %@", [[self.responseArray objectAtIndex:indexPath.row]objectForKey:@"event_detail"]);
            
            NSLog(@"event_id--> %@", [[[[self.responseArray objectAtIndex:indexPath.row]objectForKey:@"users"]objectAtIndex:0]objectForKey:@"event_id"]);
            
            
            [[self.responseArray mutableCopy] removeObjectAtIndex:indexPath.row];
           
            //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
         
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeIndeterminate;
            hud.labelText = @"Deleting..";
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{

                [post delEvents:[[[[self.responseArray objectAtIndex:indexPath.row]objectForKey:@"users"]objectAtIndex:0]objectForKey:@"event_id"]];

                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                    
                });
            });

            
            
           
        }
     
     }
    
}


//- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
//forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete)
//    {
//        [self.responseArray removeObjectAtIndex:indexPath.row];
//        
////        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
//    }
//}

// For example, if you pass a date with the value 2013-08-03 12:26:33 +0000, this method will return 2013-08-03 , like you wanted.

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    EventsDetailVC *eventsDetail = [[EventsDetailVC alloc]initWithNibName:@"EventsDetailVC" bundle:nil];
    
    NSString *titleStr = [[[self.responseArray objectAtIndex:indexPath.row]objectForKey:@"event_detail"]objectForKey:@"title"];
    NSString *detailStr = [[[self.responseArray objectAtIndex:indexPath.row]objectForKey:@"event_detail"]objectForKey:@"detail"];
    
    eventsDetail.event_title_str = titleStr;
    eventsDetail.event_detail_str = detailStr;
    
    
    NSString *dateStr = [[[self.responseArray objectAtIndex:indexPath.row]objectForKey:@"event_detail"]objectForKey:@"start"];
    
    // retrive date only from date and time string
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // this is imporant - we set our input date format to match our input string
    // if format doesn't match you'll get nil from your string, so be careful
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [dateFormatter dateFromString:dateStr];
    
    NSString *start_dateStr = [self stringDatePartOf:dateFromString];
    
    eventsDetail.start_date_str = start_dateStr;
    
    
    
    // retrive time from date and time
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
    timeFormatter.dateFormat = @"HH:mm:ss";
    NSString *timeStr = [timeFormatter stringFromDate: dateFromString];
    
    eventsDetail.start_time_str = timeStr;
    
    NSString *endDateStr = [[[self.responseArray objectAtIndex:indexPath.row]objectForKey:@"event_detail"]objectForKey:@"end"];
    // retrive date only from date and time string
    dateFromString = [dateFormatter dateFromString:endDateStr];
    NSString *end_dateStr = [self stringDatePartOf:dateFromString];
    
    eventsDetail.end_date_str = end_dateStr;
    
    
    
    // retrive time from date and time
//    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
//    timeFormatter.dateFormat = @"HH:mm:ss";
    NSString *endtimeStr = [timeFormatter stringFromDate: dateFromString];
  
    eventsDetail.end_time_str = endtimeStr;
    
    
    eventsDetail.index = indexPath.row;
    
    NSLog(@"usersss---> %@", [[self.responseArray objectAtIndex:indexPath.row]objectForKey:@"users"]);
    
    if ([[[self.responseArray objectAtIndex:indexPath.row]objectForKey:@"users"]count] !=0) {
        
        eventsDetail.usersArray = [[self.responseArray objectAtIndex:indexPath.row]objectForKey:@"users"];
    
    }
    
    [self.navigationController pushViewController:eventsDetail animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)createEventBtnPressed:(id)sender {
    
    CreateEventVC *createEventVc = [[CreateEventVC alloc]initWithNibName:@"CreateEventVC" bundle:nil];
    [self.navigationController pushViewController:createEventVc animated:YES];
}

- (IBAction)toggleBtnPressed:(id)sender {
    
    if ([[[self.msgsArray objectAtIndex:0]objectForKey:@"is_read"] isEqualToString:@"0"] || [[self.msgsArray objectAtIndex:0]objectForKey:@"is_read"] == nil) {
        
        
        HomeViewController *dashBoardVC = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
        
        self.homeVC = dashBoardVC;
        
        
        SideMenuVC *leftMenuViewController = [[SideMenuVC alloc]init];
        
        MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController
                                                        containerWithCenterViewController:self.homeVC
                                                        leftMenuViewController:leftMenuViewController
                                                        rightMenuViewController:nil];
        
        [self.navigationController pushViewController:container animated:NO];
        
        
    }else{

    
        [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
        
    }];
   
    }
}

#pragma mark - Connections
-(void)ConnectionDidFinishLoading:(NSString *)responseString :(NSString *)serviceName{
    
    NSLog(@"%@",serviceName);
    
    if([serviceName isEqualToString:@"get_events"]){
        
        self.responseDict = [responseString objectFromJSONString];
        
        if ([[self.responseDict objectForKey:@"status"] isEqualToString:@"success"]) {
            
          // NSLog(@"events--detail--> %@", [[self.responseDict objectForKey:@"events"]objectForKey:@"event_detail"]);
            
            self.responseArray = [self.responseDict objectForKey:@"events"];
            
            
            
            //dbClass *db = [[dbClass alloc]init];
            
            //[db insertEvents:self.responseArray];
            
            //[db insertEvents_users:self.responseArray];
            
            
             [self.tableView reloadData];
            
        }else{
            
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Alert!" message:@"No Event Created" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertView show];
        }
        
    
        
    }
    else if([serviceName isEqualToString:@"delEvents"]){
     
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        self.responseDict = [responseString objectFromJSONString];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        [post get_events:[defaults stringForKey:@"user_from_id"]];
        
        
        [self.tableView reloadData];
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
