//
//  SettingsViewController.m
//  BlusApp
//
//  Created by Usman Ghani on 24/06/2014.
//  Copyright (c) 2014 Gexton. All rights reserved.
//

#import "SettingsViewController.h"
#import "SideMenuVC.h"
#import "MFSideMenuContainerViewController.h"
#import "ProfileViewController.h"
#import "ChangePasswordVC.h"
#import "MoodViewController.h"
#import "PaymentViewController.h"



@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    post = [[POST alloc]init];
    post.delegate = self;
  
    [NSTimer scheduledTimerWithTimeInterval:5.0
                                     target:self
                                   selector:@selector(check_notification2)
                                   userInfo:nil
                                    repeats:YES];
}


-(void)check_notification2{
        
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
    
    self.setting_header_lbl.font = [UIFont fontWithName:@"Lato-Regular" size:20];
   
    if([[defaults stringForKey:@"status_user"] isEqualToString:@"1"]){
        
        // GET PAYMENT INFO DETAIL
        [post get_payment_information:[defaults stringForKey:@"user_from_id"]];
        
        
        self.settingsArray = [[NSMutableArray alloc]initWithObjects:@"Edit Profile", @"Change Mood", @"Change Password", nil];
        
    }else{
        
        self.settingsArray = [[NSMutableArray alloc]initWithObjects:@"Edit Profile", @"Change Mood", @"Change Password", nil];
    }

    
}



#pragma mark - TOGGLE BUTTON
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
   
    else{

   
        [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
    }];
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
    return [self.settingsArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 70;
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
    
    UILabel *titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(20.0, 25.0, 320.0, 30.0)];
    titleLbl.backgroundColor = [UIColor clearColor];
    titleLbl.font = [UIFont fontWithName:@"Lato-Regular" size:15];
    [titleLbl setTextColor:[UIColor blackColor]];
    [titleLbl setText: [self.settingsArray objectAtIndex:indexPath.row]];
    
    [cell.contentView addSubview:titleLbl];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if (indexPath.row == 0) {
        
         ProfileViewController *profileVc = [[ProfileViewController alloc]initWithNibName:@"ProfileViewController" bundle:nil];
        [self.navigationController pushViewController:profileVc animated:YES];
    
          
    }else if (indexPath.row == 1){
        
        MoodViewController *moodVC = [[MoodViewController alloc]initWithNibName:@"MoodViewController" bundle:nil];
        [self.navigationController pushViewController:moodVC animated:YES];
        
    }else if (indexPath.row == 2){
        
        ChangePasswordVC *changePassVC = [[ChangePasswordVC alloc]initWithNibName:@"ChangePasswordVC" bundle:nil];
        [self.navigationController pushViewController:changePassVC animated:YES];
        
    }else{
        
        PaymentViewController *paymentVC = [[PaymentViewController alloc]initWithNibName:@"PaymentViewController" bundle:nil];
        
        paymentVC.payment_info_str = self.payment_infoStr;
        
        [self.navigationController pushViewController:paymentVC animated:YES];
    }
    
    
}

-(void)ConnectionDidFinishLoading:(NSString *)responseString :(NSString *)serviceName{
    NSLog(@"%@",serviceName);
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    
   if ([serviceName isEqualToString:@"get_payment_information"]){
        
        self.responseDict = [responseString objectFromJSONString];
       
       if ([[self.responseDict objectForKey:@"status"] isEqualToString:@"success"]) {
           
           self.payment_infoStr = [self.responseDict objectForKey:@"payment_info"];
       }else{
           NSLog(@"Error Please Check param or service");
       }
    }
    
    
}

-(void)ConnectiondidFailWithError:(NSString *)responseString :(NSString *)serviceName{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    NSLog(@"ConnectiondidFailWithError->>:%@",responseString);
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please Check Your Internet Connection" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
