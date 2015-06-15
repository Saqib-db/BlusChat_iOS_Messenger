//
//  DashBoardVC.m
//  BlusApp
//
//  Created by Usman Ghani on 16/06/2014.
//  Copyright (c) 2014 Gexton. All rights reserved.
//

#import "ContactsViewController.h"
#import "MBProgressHUD.h"
#import "SideMenuVC.h"
#import "MFSideMenuContainerViewController.h"
#import "dbClass.h"
#import "Reachability.h"
#import "CreateEventVC.h"
#import "Singleton.h"
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#define defaults [NSUserDefaults standardUserDefaults]

@interface ContactsViewController ()

@end

@implementation ContactsViewController

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
    
    [NSTimer scheduledTimerWithTimeInterval:5.0
                                     target:self
                                   selector:@selector(check_notification)
                                   userInfo:nil
                                    repeats:YES];
    
    
    if (!IS_IPHONE_5) {
        
        self.tableView.frame = CGRectMake(0.0, 60.0, 320.0, 420.0);
    }
    
    self.okBtn.hidden = YES;
    
    self.dublicate_AgentArray = [[NSMutableArray alloc]init];
    self.selectedUsersArray = [[NSMutableArray alloc]init];
    self.navigationController.navigationBarHidden = YES;
   
    
        post = [[POST alloc]init];
            
        post.delegate = self;
        
        if ([self connectedToWiFi]) {
            

            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
            // MY CODE BEGIN //
            
            
            [post getAllContacts:[defaults stringForKey:@"user_from_id"]];
           
            // MY CODE ENDS //
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
            });
        });
        
        }else{
            // IF not internet
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please check your internet connection" delegate:nil cancelButtonTitle:@"Try Again" otherButtonTitles:nil, nil];
            [alert show];
        }
    

}

-(void)check_notification{
    
    dbClass *db = [[dbClass alloc]init];
    
    self.msgsArray = [db get_conversation:[defaults stringForKey:@"user_from_id"]];
    
    if ([self.msgsArray count] != 0) {
        
        
        if ([self.msgsArray count] == 0 || [[[self.msgsArray objectAtIndex:0]objectForKey:@"is_read"] isEqualToString:@"0"]) {
            
            
            self.notificationIconImg.hidden = NO;
            //  NSLog(@"one msg is unread");
        }else{
             self.notificationIconImg.hidden = YES;
        }
    }

}

- (IBAction)createClientBtnPressed:(id)sender {
    
    CreateClientVC *clinetVc = [[CreateClientVC alloc]initWithNibName:@"CreateClientVC" bundle:nil];
    [self.navigationController pushViewController:clinetVc animated:YES];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
   dbClass *db = [[dbClass alloc]init];
    
    self.msgsArray = [db get_conversation:[defaults stringForKey:@"user_from_id"]];
    
    if ([self.msgsArray count] != 0) {
        
        // First Check if the msg has read then hide the notify icon
        if ([[[self.msgsArray objectAtIndex:0]objectForKey:@"is_read"] isEqualToString:@"1"]) {
             self.notificationIconImg.hidden = YES;
        }
    }
    
    self.createClient_Btn.titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:15];
    
    //NSLog(@"status-->%@", [defaults stringForKey:@"status_user"]);
    
    // if not agent
    if ([defaults stringForKey:@"status_user"] != 0) {
        
        self.createClient_Btn.hidden = YES;
        
    }
   
    
    self.contacts_header_lbl.font = [UIFont fontWithName:@"Lato-Regular" size:20];
    
    self.okBtn.titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:18];
    
    if ([self.isPushed isEqualToString:@"eventPushed"]) {
       
        self.createClient_Btn.hidden = YES;
        
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
  //  NSLog(@"Count %lu", (unsigned long)[self.dublicate_AgentArray count]);
    
    return [self.dublicate_AgentArray count];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    return 70;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // For CellStyleDefault
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    
    UILabel *contactName = [[UILabel alloc]initWithFrame:CGRectMake(70.0, 15.0, 250.0, 30.0)];
    contactName.font = [UIFont fontWithName:@"Lato-Regular" size:17];
    contactName.backgroundColor = [UIColor clearColor];
    
    //if ([[self.dublicate_AgentArray objectAtIndex:indexPath.row]objectForKey:@"fname"] == nil) {
    if (indexPath.row == 0) {
        
        [contactName setText:@"Admin"];
        
    }else{
        
        [contactName setText:[NSString stringWithFormat:@"%@ %@", [[self.dublicate_AgentArray objectAtIndex:indexPath.row-1]objectForKey:@"fname"],[[self.dublicate_AgentArray objectAtIndex:indexPath.row-1]objectForKey:@"lname"]]];
        
        if ([self.selectedUsersArray count] !=0) {
            
        
            if ([self.selectedUsersArray containsObject: [[self.dublicate_AgentArray objectAtIndex:indexPath.row-1]objectForKey:@"id"]]) {
            
         
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
        }
       
}
    
     [cell.contentView addSubview:contactName];
    
    
    
    if ([self.isPushed isEqualToString:@"eventPushed"]) {
        
        self.okBtn.hidden = NO;
        

    }else{
    
        UIImageView *online_indicatorView = [[UIImageView alloc]initWithFrame:CGRectMake(290.0, 25.0, 12.0, 12.0)];
        
     
        if (indexPath.row == 0) {
            
            online_indicatorView.image = nil;
            
        }else{
     
            
            if ([[[self.dublicate_AgentArray objectAtIndex:indexPath.row-1]objectForKey:@"is_logged_in"] isEqualToString:@"0"])
               
                online_indicatorView.image = [UIImage imageNamed:@"icon_offline.png"];
            else{
            
                online_indicatorView.image = [UIImage imageNamed:@"icon_online.png"];
            }
            
        }
        
        [cell.contentView addSubview:online_indicatorView];
        
    }
    
    
    UILabel *moodLbl = [[UILabel alloc]initWithFrame:CGRectMake(70.0, 40.0, 250.0, 30.0)];
    moodLbl.font = [UIFont fontWithName:@"Lato-Regular" size:13];
    moodLbl.textColor = [UIColor darkGrayColor];
    moodLbl.backgroundColor = [UIColor clearColor];
    
   // if ([[self.dublicate_AgentArray objectAtIndex:indexPath.row]objectForKey:@"mood"] == nil) {
    if (indexPath.row == 0) {
        
        [moodLbl setText:@"Blus"];
    
    }else{
    
        [moodLbl setText:[[self.dublicate_AgentArray objectAtIndex:indexPath.row-1]objectForKey:@"mood"]];
    }
    
   
    [cell.contentView addSubview:moodLbl];
    
     UIImageView *profileImgView = [[UIImageView alloc]initWithFrame:CGRectMake(12.0, 10.0, 50.0, 50.0)];
    
    
    if (indexPath.row == 0) {
        
        
        IphoneAsyncImageView *participantImg = [[IphoneAsyncImageView alloc] initWithFrame:CGRectMake(12.0f, 15.0f, 50.0f, 50.0f)];
        participantImg.cv_width = 100.0f;
        participantImg.cv_height = 100.0f;
        participantImg.backgroundColor = [UIColor clearColor];
        [participantImg loadImageFromURL:[NSURL URLWithString:[defaults stringForKey:@"adminImg"]]];
        [cell.contentView addSubview:participantImg];
        
        /*// load the image
        UIImage *profileImg = [UIImage imageNamed:@"test_dp.png"];
        
        [profileImgView setImage:profileImg];
        
        [cell.contentView addSubview:profileImgView];*/
        
    }else{
        

        NSString *imgUrl =  [[self.dublicate_AgentArray objectAtIndex:indexPath.row-1]objectForKey:@"img_link"];
        
        if ([imgUrl isEqual:[NSNull null]] || imgUrl == nil || [imgUrl isEqualToString:@""]) {
            
            UIImage *profileImg = [UIImage imageNamed:@"test_dp.png"];
            
            [profileImgView setImage:profileImg];
            
            [cell.contentView addSubview:profileImgView];
            
        }else{
            
            IphoneAsyncImageView *participantImg = [[IphoneAsyncImageView alloc] initWithFrame:CGRectMake(12.0f, 15.0f, 50.0f, 50.0f)];
            participantImg.cv_width = 100.0f;
            participantImg.cv_height = 100.0f;
            participantImg.backgroundColor = [UIColor clearColor];
            [participantImg loadImageFromURL:[NSURL URLWithString:imgUrl]];
            [cell.contentView addSubview:participantImg];
            
        }
    }
    
        return cell;

}



#pragma mark - Connections
-(void)ConnectionDidFinishLoading:(NSString *)responseString :(NSString *)serviceName{
    
    NSLog(@"%@",serviceName);
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
   
    if([serviceName isEqualToString:@"getAllContacts"]){
       self.responseDict = [responseString objectFromJSONString];
        if ([[self.responseDict objectForKey:@"msg"] isEqualToString:@"no contacts yet"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert!" message:@"No contacts yet" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            [self.dublicate_AgentArray addObject:[self.responseDict objectForKey:@"admin"]];
            [self.tableView reloadData];
        }
        dbClass *db = [[dbClass alloc]init];
        [db insertAdminContacts:[[self.responseDict objectForKey:@"admin"]objectForKey:@"email"]:[[self.responseDict objectForKey:@"admin"]objectForKey:@"username"]];
        if ([[self.responseDict objectForKey:@"status"] isEqualToString:@"success"]) {
        // If Agent
            if ([[defaults stringForKey:@"status_user"] isEqualToString:@"1"]) {
                self.agentArray =  [self.responseDict objectForKey:@"agent"];
                [db insertContacts:self.agentArray];
                for (int x = 0; x < [self.agentArray count]; x++) {
                    [self.dublicate_AgentArray addObject:[[self.responseDict objectForKey:@"agent"]objectAtIndex:x]];
                }
                [self.dublicate_AgentArray mutableCopy];
                [self.dublicate_AgentArray addObject:[self.responseDict objectForKey:@"admin"]];
                [self.tableView reloadData];
                }else{
                // If Client
                self.clientArray = [self.responseDict objectForKey:@"client"];
                if ([self.isPushed_client isEqualToString:@"clientPushed"]){
                    NSMutableArray *alreadyInvitedUsers = [defaults objectForKey:@"usersArrayInvited"];//
                  NSMutableArray *tempArray = [[NSMutableArray alloc] init];
                   for (int x = 0; x < [self.clientArray count]; x++) {
                       BOOL isPresent = NO;
                        NSString *user_id = [[self.clientArray objectAtIndex:x] objectForKey:@"id"];
                        //loop on alreadyInvitedUsers to check if it is invited
                        for (int y = 0; y < [alreadyInvitedUsers count]; y++) {
                            if([[[alreadyInvitedUsers objectAtIndex:y] objectForKey:@"user_id"] isEqualToString:user_id]){
                                isPresent = YES;
                            }}
                        if(!isPresent){
                            [tempArray addObject:[self.clientArray objectAtIndex:x]];
                        }}
                   self.clientArray = tempArray;
                    self.dublicate_AgentArray = self.clientArray;
                    [self.tableView reloadData];
                }else{
                    [db insertContacts:self.clientArray];
                    for (int x = 0; x < [self.clientArray count]; x++) {
                    
                        [self.dublicate_AgentArray addObject:[[self.responseDict objectForKey:@"client"]objectAtIndex:x]];
                    }
                    [self.dublicate_AgentArray mutableCopy];
                    [self.dublicate_AgentArray addObject:[self.responseDict objectForKey:@"admin"]];
                    [self.tableView reloadData];
                }}}
            }else{
            
            self.dublicate_AgentArray = [self.responseDict objectForKey:@"agent"];
            
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

- (IBAction)okBtnPressed:(id)sender {
    
    if ([self.isPushed_client isEqualToString:@"clientPushed"]) {
        
       // NSLog(@"selectedUsersArray--> %@", self.selectedUsersArray);
        
        if (self.selectedUsersArray == nil) {
            
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Alert!" message:@"You did not select client" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertView show];
            
            
        }else{
        

            [defaults setObject:@"isClientPushed" forKey:@"isClientPushed"];
            [defaults synchronize];
        
            [self dismissViewControllerAnimated:YES completion:nil];
     
        }
    
    }else{
    
    
        [self dismissViewControllerAnimated:YES completion:nil];
    
    }
}

- (IBAction)toggleBtnPressed:(id)sender {
    
    
    NSLog(@"isREa--> %@", [[self.msgsArray objectAtIndex:0]objectForKey:@"is_read"]);
    
    if ([[[self.msgsArray objectAtIndex:0]objectForKey:@"is_read"] isEqualToString:@"0"] || [[self.msgsArray objectAtIndex:0]objectForKey:@"is_read"] == nil) {
        
        
        HomeViewController *dashBoardVC = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
        
        self.homeVC = dashBoardVC;
        
        
        SideMenuVC *leftMenuViewController = [[SideMenuVC alloc]init];
        
        MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController
                                                        containerWithCenterViewController:self.homeVC
                                                        leftMenuViewController:leftMenuViewController
                                                        rightMenuViewController:nil];
        
        [self.navigationController pushViewController:container animated:NO];
        
    }
    
   else if ([self.isPushed isEqualToString:@"eventPushed"]) {
    
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    else if ([self.isPushed isEqualToString:@"yes"]) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        
        [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
         
        }];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self.isPushed isEqualToString:@"eventPushed"]) {
        

        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if(cell.accessoryType == UITableViewCellAccessoryCheckmark){

            cell.accessoryType = UITableViewCellAccessoryNone;
            
            [self.selectedUsersArray removeObject:[[self.dublicate_AgentArray objectAtIndex:indexPath.row-1]objectForKey:@"id"]];
            
            
        }else{
            
            // on index 0, its admin then dont check mark
            if (indexPath.row == 0) {
                
             cell.accessoryType = UITableViewCellAccessoryNone;

            }else{

                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                //self.selectedRow = indexPath.row;
                
               [self.selectedUsersArray addObject:[[self.dublicate_AgentArray objectAtIndex:indexPath.row-1]objectForKey:@"id"]];
            }
        }
        
        Singleton *singleObj = [Singleton retrieveSingleton];
        singleObj.invitedUsersArray = self.selectedUsersArray;
    
        
        
// If its coming from the side menu contact tab
        
    }else{
        
        ChatVC *controller = [[ChatVC alloc] initWithNibName:@"ChatVC" bundle:nil];
             
        // is_galleryImg is YES if its coming from the iPhoneImageDetailVC or if contactsVc is coming from side menu so is_galler will be null
        
        controller.DocDir_galleryImg = self.gallery_image;
        controller.is_galleryImg = self.is_galleryImg;
        
      // If its admin
        if (indexPath.row == 0) {
        
            controller.user_to_string = @"Admin";
            self.user_to_id = @"0";
        
        }else{
            
            // If its any contact
            controller.user_to_string = [NSString stringWithFormat:@"%@ %@", [[self.dublicate_AgentArray objectAtIndex:indexPath.row-1]objectForKey:@"fname"],[[self.dublicate_AgentArray objectAtIndex:indexPath.row-1]objectForKey:@"lname"]];
           
            self.user_to_id = [[self.dublicate_AgentArray objectAtIndex:indexPath.row-1]objectForKey:@"id"];
            
        }
        
        controller.user_to_id =  self.user_to_id;
        [self.navigationController pushViewController:controller animated:YES];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
