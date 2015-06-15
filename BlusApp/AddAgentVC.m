//
//  AddAgentVC.m
//  BlusApp
//
//  Created by Zeeshan Anwar on 9/9/14.
//  Copyright (c) 2014 Gexton. All rights reserved.
//

#import "AddAgentVC.h"
#import "dbClass.h"

@interface AddAgentVC ()

@end

@implementation AddAgentVC

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
                                   selector:@selector(check_notification1)
                                   userInfo:nil
                                    repeats:YES];
    
     self.selected_Agents_Array = [[NSMutableArray alloc]init];
    
    post = [[POST alloc]init];
    post.delegate = self;

}

-(void)check_notification1{
    
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
    
    
    
    self.assign_agent_header_lbl.font = [UIFont fontWithName:@"Lato-Regular" size:20];
    self.doneBtn.titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:20];
    
    if ([self connectedToWiFi]) {
    
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            
            
            [post getAllAgents];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                
            });
        });
    }else{
        
        // IF not internet
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please check your internet connection" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    
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
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"Count %lu", (unsigned long)[self.conversationArray count]);
    
    return [self.agentsArray count];
    
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
    
    // SET AGENT NAME
    UILabel *agentName = [[UILabel alloc]initWithFrame:CGRectMake(70.0, 15.0, 200.0, 30.0)];
    
    agentName.font = [UIFont fontWithName:@"Lato-Regular" size:17];
    
    agentName.backgroundColor = [UIColor clearColor];
    
    [agentName setText:[NSString stringWithFormat:@"%@ %@", [[self.agentsArray objectAtIndex:indexPath.row]objectForKey:@"fname"],[[self.agentsArray objectAtIndex:indexPath.row]objectForKey:@"lname"]]];
    
    [cell.contentView addSubview:agentName];
    
    
    // SET MOOD
    UILabel *agentMood = [[UILabel alloc]initWithFrame:CGRectMake(70.0, 40.0, 200.0, 30.0)];
    
    agentMood.font = [UIFont fontWithName:@"Lato-Regular" size:13];
    
    agentMood.textColor = [UIColor darkGrayColor];
    
    agentMood.backgroundColor = [UIColor clearColor];
    
    [agentMood setText:[[self.agentsArray objectAtIndex:indexPath.row]objectForKey:@"mood"]];
    
    [cell.contentView addSubview:agentMood];
    
    
    
    // SET PROFILE PICTURE
    NSString *imgUrl =  [[self.agentsArray objectAtIndex:indexPath.row]objectForKey:@"img_link"];
    
    UIImageView *profileImgView = [[UIImageView alloc]initWithFrame:CGRectMake(12.0, 10.0, 50.0, 50.0)];
    
    if ([imgUrl isEqual:[NSNull null]] || [imgUrl isEqualToString:@""]) {
        
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

    
    return cell;
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if(cell.accessoryType == UITableViewCellAccessoryCheckmark){
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        [self.selected_Agents_Array removeObject:[[self.agentsArray objectAtIndex:indexPath.row]objectForKey:@"id"]];
        
        
    }else{
        
        if ([[self.agentsArray objectAtIndex:indexPath.row]objectForKey:@"fname"] == nil) {
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            
        }else{
            
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            
            [self.selected_Agents_Array addObject:[[self.agentsArray objectAtIndex:indexPath.row]objectForKey:@"id"]];
            
            //NSLog(@"selectedAgents--Array--> %@", self.selected_Agents_Array);
            
        }
    }
    
    
    
    //NSLog(@"selectedAgents--Array--> %@", self.selected_Agents_Array);
    Singleton *singleObj = [Singleton retrieveSingleton];
    singleObj.invitedUsersArray = self.selected_Agents_Array;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Connections
-(void)ConnectionDidFinishLoading:(NSString *)responseString :(NSString *)serviceName{
    
    NSLog(@"%@",serviceName);
    
    if([serviceName isEqualToString:@"getAllAgents"]){
        
        self.responseDict = [responseString objectFromJSONString];
        self.agentsArray = [self.responseDict objectForKey:@"agents"];
        
        [self.tableView reloadData];
        
    }
    
}

-(void)ConnectiondidFailWithError:(NSString *)responseString :(NSString *)serviceName{
}




- (IBAction)doneBtnPressed:(id)sender {
    
     [self dismissViewControllerAnimated:YES completion:nil];
}
@end
