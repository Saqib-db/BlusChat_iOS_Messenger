//
//  MoodViewController.m
//  BlusApp
//
//  Created by Usman Ghani on 24/06/2014.
//  Copyright (c) 2014 Gexton. All rights reserved.
//

#import "MoodViewController.h"
#import "SideMenuVC.h"
#import "Singleton.h"

@interface MoodViewController ()

@end

@implementation MoodViewController

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
    
    [NSTimer scheduledTimerWithTimeInterval:5.0
                                     target:self
                                   selector:@selector(check_notification4)
                                   userInfo:nil
                                    repeats:YES];
    
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
    
    self.setMood_header_lbl.font = [UIFont fontWithName:@"Lato-Regular" size:20];
    self.back_btn.titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:20];
    self.setMood_btn.titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:16];
    self.moodTextField.font = [UIFont fontWithName:@"Lato-Regular" size:15];
    
    post = [[POST alloc]init];
    post.delegate = self;
    
    
    Singleton *single = [Singleton retrieveSingleton];
    self.moodTextField.text = single.mood;
    

    self.moodTextField.text = [defaults stringForKey:@"mood"];
    [defaults synchronize];
    
}

-(void)check_notification4{
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backBtnPressed:(id)sender {
    
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
        
        
    }else{
    

        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)setMoodBtnPressed:(id)sender {
    
    
    [self.moodTextField resignFirstResponder];
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading";
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        // MY CODE BEGIN //
        
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        [post setMood:self.moodTextField.text:[defaults stringForKey:@"user_from_id"]];
        
        
        
        // MY CODE ENDS //
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            
        });
    });

    
}


-(BOOL) textFieldShouldReturn:(UITextField *)textField{

    [self.moodTextField resignFirstResponder];
    
    return YES;
}


#pragma mark - Connections
-(void)ConnectionDidFinishLoading:(NSString *)responseString :(NSString *)serviceName{
    NSLog(@"%@",serviceName);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if([serviceName isEqualToString:@"updateMood"]){
        
        

        self.responseDict = [responseString objectFromJSONString];
        self.moodTextField.text = [[self.responseDict objectForKey:@"user_info"]objectForKey:@"mood"];
        
        
        Singleton *singleObj = [Singleton retrieveSingleton];
        singleObj.mood = [[self.responseDict objectForKey:@"user_info"]objectForKey:@"mood"];
       
        
        [defaults setObject:[[self.responseDict objectForKey:@"user_info"]objectForKey:@"mood"] forKey:@"mood"];
        [defaults synchronize];
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Mood Updated" message:@"" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        alertView.tag = 999;
        [alertView show];
        
       // self.moodTextField.text = [defaults stringForKey:@"mood"];
       
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (alertView.tag == 999) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}


-(void)ConnectiondidFailWithError:(NSString *)responseString :(NSString *)serviceName{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please Check Your Internet Connection" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
}












@end
