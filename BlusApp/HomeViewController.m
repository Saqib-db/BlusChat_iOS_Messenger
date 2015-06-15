//
//  HomeViewController.m
//  BlusApp
//
//  Created by Usman Ghani on 21/07/2014.
//  Copyright (c) 2014 Gexton. All rights reserved.
//

#import "HomeViewController.h"
#import "SideMenuVC.h"
#import "MFSideMenuContainerViewController.h"
#import "Reachability.h"
#import "dbClass.h"
#import "ChatVC.h"
#import "AppDelegate.h"
#import "ProfileViewController.h"

#define defaults [NSUserDefaults standardUserDefaults]

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@interface HomeViewController ()

@end

@implementation HomeViewController

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
    [super viewDidLoad];
    
   // NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
 //   if(self.isFirstLogin){

    if ([defaults boolForKey:@"isFirstLogin"] == YES) {
        
    
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Welcome To Blus" message:@"Do you want to edit your profile ?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"Yes", nil];
        
        [alertView show];
        
        [defaults setBool:NO forKey:@"isFirstLogin"];
        
      // self.isFirstLogin = NO;
    }
    
    if (!IS_IPHONE_5) {
        self.tableView.frame = CGRectMake(0.0, 60.0, 320.0, 420.0);
    }
    
    post = [[POST alloc]init];
    post.delegate = self;
    
  
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];

    
  // Run an NSTimer in the Background
   
    UIBackgroundTaskIdentifier bgTask;
    UIApplication  *app = [UIApplication sharedApplication];
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:bgTask];
    }];
    
    self.silenceTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self
                                                       selector:@selector(get_Notification) userInfo:nil repeats:YES];
   
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (buttonIndex == 1) {
        
        ProfileViewController *profileVc = [[ProfileViewController alloc]initWithNibName:@"ProfileViewController" bundle:nil];
        
        [self.navigationController pushViewController:profileVc animated:YES];
        
    }else{
        //Do nothing
    }
}


-(void)get_Notification{
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [appDelegate getNotification ];
    
    [self getLast_conversation_from_database];
    
    [self.tableView reloadData];
    
}


-(void)viewWillAppear:(BOOL)animated{
    
    self.contactLabel.font = [UIFont fontWithName:@"Lato-Regular" size:20];
  
    [self getLast_conversation_from_database];
    
}



-(void)getLast_conversation_from_database{
    
    dbClass *db = [[dbClass alloc]init];
    
    self.conversationArray = [db get_conversation:[defaults stringForKey:@"user_from_id"]]; // user_from is current userid;
    
    //NSLog(@"Get Last Conversation---> %@", self.conversationArray);
  
       [self.tableView reloadData];

}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  //  NSLog(@"Count %lu", (unsigned long)[self.conversationArray count]);
    
    return [self.conversationArray count];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 70;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"Cell";
  //  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // For CellStyleDefault
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    
    UILabel *contactName = [[UILabel alloc]initWithFrame:CGRectMake(70.0, 15.0, 200.0, 30.0)];
    
    contactName.font = [UIFont fontWithName:@"Lato-Regular" size:17];

    contactName.backgroundColor = [UIColor clearColor];
    
    [contactName setText:[NSString stringWithFormat:@"%@ %@", [[self.conversationArray objectAtIndex:indexPath.row]objectForKey:@"fname"],[[self.conversationArray objectAtIndex:indexPath.row]objectForKey:@"lname"]]];
    
    [cell.contentView addSubview:contactName];
    
    UILabel *lastMsgLbl = [[UILabel alloc]initWithFrame:CGRectMake(70.0, 40.0, 120.0, 30.0)];
    
    lastMsgLbl.font = [UIFont fontWithName:@"Lato-Regular" size:13];
    
    if ([[[self.conversationArray objectAtIndex:indexPath.row]objectForKey:@"is_read"] isEqualToString:@"0"]) {
        lastMsgLbl.textColor = [UIColor redColor];
    }else{
        lastMsgLbl.textColor = [UIColor darkGrayColor];
    }
    
    lastMsgLbl.backgroundColor = [UIColor clearColor];
    
    if ([[[self.conversationArray objectAtIndex:indexPath.row]objectForKey:@"is_image"] isEqualToString:@"1"]) {
        [lastMsgLbl setText:@"image"];
    }else{
        [lastMsgLbl setText:[[self.conversationArray objectAtIndex:indexPath.row]objectForKey:@"msg"]];
    }
    [cell.contentView addSubview:lastMsgLbl];
    
    
    UILabel *dateTimeLbl = [[UILabel alloc]initWithFrame:CGRectMake(200.0, 40.0,120.0, 30.0)];
    dateTimeLbl.font = [UIFont fontWithName:@"Lato-Regular" size:11];
    dateTimeLbl.textColor = [UIColor darkGrayColor];
    dateTimeLbl.backgroundColor = [UIColor clearColor];
    [dateTimeLbl setText:[[self.conversationArray objectAtIndex:indexPath.row]objectForKey:@"date_time"]];
    [cell.contentView addSubview:dateTimeLbl];
    
    
    
    NSString *imgUrl =  [[self.conversationArray objectAtIndex:indexPath.row]objectForKey:@"img_link"];
    
   // NSLog(@"img_url--> %@", imgUrl);
    
    
   // UIImageView *profileImgView = [[UIImageView alloc]initWithFrame:CGRectMake(12.0, 10.0, 50.0, 50.0)];
    
    if ([imgUrl isEqual:[NSNull null]] || [imgUrl isEqualToString:@""]) {
        
        
        IphoneAsyncImageView *participantImg = [[IphoneAsyncImageView alloc] initWithFrame:CGRectMake(12.0f, 15.0f, 50.0f, 50.0f)];
        participantImg.cv_width = 100.0f;
        participantImg.cv_height = 100.0f;
        participantImg.backgroundColor = [UIColor clearColor];
        [participantImg loadImageFromURL:[NSURL URLWithString:[defaults stringForKey:@"adminImg"]]];
        [cell.contentView addSubview:participantImg];
        
//        UIImage *profileImg = [UIImage imageNamed:@"test_dp.png"];
//        
//        [profileImgView setImage:profileImg];
//        [cell.contentView addSubview:profileImgView];
        
    }else{
        
        IphoneAsyncImageView *participantImg = [[IphoneAsyncImageView alloc] initWithFrame:CGRectMake(12.0f, 15.0f, 50.0f, 50.0f)];
        participantImg.cv_width = 100.0f;
        participantImg.cv_height = 100.0f;
        participantImg.backgroundColor = [UIColor clearColor];
        [participantImg loadImageFromURL:[NSURL URLWithString:imgUrl]];
        [cell.contentView addSubview:participantImg];
        
    }
    

    return cell;
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatVC *controller = [[ChatVC alloc] initWithNibName:@"ChatVC" bundle:nil];
    
   // NSLog(@"Conversation--> %@", self.conversationArray);
    
    controller.user_to_string = [NSString stringWithFormat:@"%@ %@", [[self.conversationArray objectAtIndex:indexPath.row]objectForKey:@"fname"],[[self.conversationArray objectAtIndex:indexPath.row]objectForKey:@"lname"]];
    
 
    
    if ([self connectedToWiFi]) {
        
        
            self.user_to_id = [[self.conversationArray objectAtIndex:indexPath.row]objectForKey:@"user_from_id"];
            
            if ([self.user_to_id isEqualToString:[defaults stringForKey:@"user_from_id"]]) {
            
                self.user_to_id = [[self.conversationArray objectAtIndex:indexPath.row]objectForKey:@"user_to_id"];
              
           }
    }
    
    else
    {
        
            self.user_to_id = [[self.conversationArray objectAtIndex:indexPath.row]objectForKey:@"user_id"];
           // NSLog(@"user_to_id---> %@", self.user_to_id);
     }
    
    controller.user_to_id =  self.user_to_id;
    
    // on click the row set the is_read = 0
    
    dbClass *db = [[dbClass alloc]init];
    
    [db update_isRead:self.user_to_id];
    
    //[self getLast_conversation_from_database];
    
    [self.navigationController pushViewController:controller animated:YES];
    
    
}


#pragma mark - Connections
-(void)ConnectionDidFinishLoading:(NSString *)responseString :(NSString *)serviceName{
    
    NSLog(@"%@",serviceName);
    
   
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if([serviceName isEqualToString:@"getNotification"]){
        
        self.responseDict = [responseString objectFromJSONString];
        self.responseArray = [self.responseDict objectForKey:@"recived_messages"];
     
        //NSLog(@"Response Arr--> %@",self.responseArray);
        
         dbClass *db = [[dbClass alloc]init];
        
        
        if ([self.responseArray count] !=0) {
            
           // NSLog(@"from_id-->user_to %@", [[self.responseArray objectAtIndex:0]objectForKey:@"from_id"]);
          
            
            for (int x=0; x < [self.responseArray count]; x++) {
                
            //  NSLog(@"message %@",[[self.responseArray objectAtIndex:x]objectForKey:@"msg"]);
                
        [db insertMessages:[defaults stringForKey:@"user_from_id"]:[[self.responseArray objectAtIndex:0]objectForKey:@"from_id"] :[[self.responseArray objectAtIndex:x]objectForKey:@"msg"] :[[self.responseArray objectAtIndex:0]objectForKey:@"date_time"] :@"0" :@"0" :@"0" :@"0"];
                
            }
            
           //  [self getLast_conversation_from_database];
            
            [self.tableView reloadData];


        }
        
    }

}


-(void)ConnectiondidFailWithError:(NSString *)responseString :(NSString *)serviceName{
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)toggleBtnPressed:(id)sender {
    
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
        
    }];
}

@end
