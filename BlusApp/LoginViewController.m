       //
//  LoginViewController.m
//  BlusApp
//
//  Created by Usman Ghani on 16/06/2014.
//  Copyright (c) 2014 Gexton. All rights reserved.
//

#import "LoginViewController.h"
#import "MBProgressHUD.h"
#import "SideMenuVC.h"
#import "MFSideMenuContainerViewController.h"
#import "PasswordChangedVC.h"



#define KEYBOARD_VIEW_MOVE_HEIGHT 210
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@interface LoginViewController ()

@end

@implementation LoginViewController

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
    
    
    self.user_Arrays_id = [[NSMutableArray alloc]init];
    
    self.emailTxtField.font = [UIFont fontWithName:@"Lato-Regular" size:15];
    self.passTxtField.font = [UIFont fontWithName:@"Lato-Regular" size:15];
    
    keyboardBounds = CGRectMake(0.0, 480.0, 320.0, 216.0);
    
    if (!IS_IPHONE_5) {
        
        self.scrollView.frame = CGRectMake(0.0, 80.0, 320.0, 500.0);
        
        self.scrollView.contentSize= CGSizeMake(320.0, 600.0);
    }
    
    self.navigationController.navigationBarHidden = YES;
    
    post = [[POST alloc]init];
    
    post.delegate = self;
    
  
    
}



-(void)viewWillAppear:(BOOL)animated{
   
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    // IF Already Login then switch to the sideMenu Container
    if ([[defaults stringForKey:@"login_status"] isEqualToString:@"success"]) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        HomeViewController *dashBoardVC = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
        
        self.homeVC = dashBoardVC;
        
        
        SideMenuVC *leftMenuViewController = [[SideMenuVC alloc]init];
        
        MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController
                                                        containerWithCenterViewController:self.homeVC
                                                        leftMenuViewController:leftMenuViewController
                                                        rightMenuViewController:nil];
        
        
        [self.navigationController pushViewController:container animated:NO];

    }
    
    
    if ([self.mySwitch isOn]) {
        
    }else{
        
        self.emailTxtField.text = nil;
        self.passTxtField.text = nil;
        
    }
}

#pragma mark UITextFieldDelegate

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == self.emailTxtField) {
        [self.passTxtField becomeFirstResponder];
    }
    else if (textField == self.passTxtField){
        [self.passTxtField resignFirstResponder];
    }
    [self restoreScrollViewContentSize];
    
    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self scrollViewToCenterOfScreen:textField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    //[self restoreScrollViewContentSize];
    
}

#pragma mark - UIScrollView
- (void) restoreScrollViewContentSize
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    
    self.scrollView.contentSize = CGSizeMake(320.0, 150.0);
    
    [UIView commitAnimations];
    
}



- (void)scrollViewToCenterOfScreen:(UIView *)theView {
    
    CGFloat viewCenterY = theView.center.y;
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    
    CGFloat availableHeight = applicationFrame.size.height - keyboardBounds.size.height;    // Remove area covered by keyboard
    
    CGFloat y = viewCenterY - availableHeight / 1.5;
    if (y < 0) {
        y = 0;
    }
    self.scrollView.contentSize = CGSizeMake(applicationFrame.size.width, applicationFrame.size.height + keyboardBounds.size.height);
    [self.scrollView setContentOffset:CGPointMake(0, y) animated:YES];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)ContactsVcScreen{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    HomeViewController *dashBoardVC = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
    
    self.homeVC = dashBoardVC;
    
    
    SideMenuVC *leftMenuViewController = [[SideMenuVC alloc]init];
    
    MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController
                                                    containerWithCenterViewController:self.homeVC
                                                    leftMenuViewController:leftMenuViewController
                                                    rightMenuViewController:nil];
    
    
    [self.navigationController pushViewController:container animated:YES];
    
}




- (IBAction)loginBtnPressed:(id)sender {
    HomeViewController *dashBoardVC = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
    SideMenuVC *leftMenuViewController = [[SideMenuVC alloc]init];
    
    MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController
                                                    containerWithCenterViewController:dashBoardVC
                                                    leftMenuViewController:leftMenuViewController
                                                    rightMenuViewController:nil];
    
    
    leftMenuViewController.agentArray = [self.responseDict objectForKey:@"agent"];
    [self.navigationController pushViewController:container animated:YES];
    
    
    
    [self.emailTxtField resignFirstResponder];
    [self.passTxtField resignFirstResponder];
    
    [self restoreScrollViewContentSize];
    
    if ([self.emailTxtField.text isEqualToString:@""] || [self.passTxtField.text isEqualToString:@""]){
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Email or Password field is empty" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }else{
        
        if ([self connectedToWiFi]) {
            

            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeIndeterminate;
            hud.labelText = @"Loading";
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                
                // MY CODE BEGIN //
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                
                //  NSLog(@"default token--> %@", [defaults stringForKey:@"deviceToken"]);
                
                [post login:self.emailTxtField.text :self.passTxtField.text :[defaults stringForKey:@"deviceToken"]];
                
                
                // MY CODE ENDS //
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                    
                });
            });
        
        }else{
           
            // IF not internet
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please check your internet connection" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            
            //[MBProgressHUD hideHUDForView:self.view animated:YES]
        }
    }
}



#pragma mark UITextFieldDelegate

//-(BOOL) textFieldShouldReturn:(UITextField *)textField{
//
//    [textField resignFirstResponder];
//    return YES;
//}

/*
 ;*/



-(void)ConnectionDidFinishLoading:(NSString *)responseString :(NSString *)serviceName{
    
    NSLog(@"%@",serviceName);
   
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if([serviceName isEqualToString:@"login"]){
        
        self.responseDict = [responseString objectFromJSONString];
       
        if ([[self.responseDict objectForKey:@"status"] isEqualToString:@"error"]) {
        
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Invalid Email Or Password" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
         
            [alertView show];
            
       
        }else{
            
         
            if ([self.responseDict objectForKey:@"admin"]) {
                
                NSString *adminImg = [NSString stringWithFormat:@"http://www.blusserver.com/bluschat/assets/images/img/%@",[[self.responseDict objectForKey:@"admin"]objectForKey:@"image"]];
                
                
                [defaults setObject:adminImg forKey:@"adminImg"];
                [defaults synchronize];
            }
            
            dbClass *db = [[dbClass alloc]init];
           
            self.user_info_array = [[NSMutableArray alloc] initWithObjects:[self.responseDict objectForKey:@"user_info"], nil];
            
            NSLog(@"userInfo--> %@", self.user_info_array);
            
            
            [db insertContacts:self.user_info_array];
            
          
            
            if ([[[self.user_info_array objectAtIndex:0]objectForKey:@"status_user"] isEqualToString:@"1"]) {
                
                
               
                NSString *statusUser = [[self.user_info_array objectAtIndex:0]objectForKey:@"status_user"];
                
                [defaults setObject:statusUser forKey:@"status_user"];
                
                [defaults synchronize];
 
                self.agentArray = [self.responseDict objectForKey:@"agent"];
                
                [db insertContacts:self.agentArray];
                
            } else {
               
                self.clientArray = [self.responseDict objectForKey:@"client"];
                NSLog(@"client--> %@", self.clientArray);
                
                [db insertContacts:self.clientArray];
                
            }
            
            self.allMsgsArray = [self.responseDict objectForKey:@"allMessages"];
            [db insertAllMessages:self.allMsgsArray];
            
            
            // LETS START FROM HERE ///
            
            
            NSString *img_link =[[self.responseDict objectForKey:@"user_info"]objectForKey:@"img_link"];
            if ([img_link isEqual:[NSNull null]]) {
                img_link = @"";
            }
            
            NSString *mood =[[self.responseDict objectForKey:@"user_info"]objectForKey:@"mood"];
            
            if ([mood isEqual:[NSNull null]]) {
              
                mood = @"";
           
            }            
            
            [defaults setObject:[self.responseDict objectForKey:@"status"] forKey:@"login_status"];
            [defaults setObject:[[self.responseDict objectForKey:@"user_info"]objectForKey:@"id"] forKey:@"user_from_id"];
            [defaults setObject:[[self.responseDict objectForKey:@"user_info"]objectForKey:@"username"] forKey:@"user_name"];
            [defaults setObject:[[self.responseDict objectForKey:@"user_info"]objectForKey:@"fname"] forKey:@"fname"];
            [defaults setObject:[[self.responseDict objectForKey:@"user_info"]objectForKey:@"lname"] forKey:@"lname"];
            [defaults setObject:[[self.responseDict objectForKey:@"user_info"]objectForKey:@"email"] forKey:@"email"];
            [defaults setObject: img_link forKey:@"img_link"];
            [defaults setObject:mood forKey:@"mood"];
            
            //first time login by any user in the app
            if (![defaults objectForKey:@"user_id_array"]){
                
                //add user id into array
                [self.user_Arrays_id addObject:[[self.responseDict objectForKey:@"user_info"]objectForKey:@"id"]];
                [defaults setBool:YES forKey:@"isFirstLogin"];
                
                //dashBoardVC.isFirstLogin = YES;
                
                
            } else {
                
                self.user_Arrays_id = [defaults objectForKey:@"user_id_array"];
                
             //  NSLog(@"-->> %@ ", [[self.responseDict objectForKey:@"user_info"]objectForKey:@"id"]);
                
                NSString *user_id = [[self.responseDict objectForKey:@"user_info"]objectForKey:@"id"];
                
                if (![self.user_Arrays_id containsObject:user_id]) {
                    
                    //add user id into array
                    
                    NSMutableArray *tempArray = [self.user_Arrays_id mutableCopy];
                    [tempArray addObject:[[self.responseDict objectForKey:@"user_info"]objectForKey:@"id"]];
                    self.user_Arrays_id = tempArray;
                    
                    
                  //  [self.user_Arrays_id addObject:[[[self.responseDict objectForKey:@"user_info"]objectForKey:@"id"]mutableCopy]];
                   // [[self.user_Arrays_id mutableCopy] addObject:[[self.responseDict objectForKey:@"user_info"]objectForKey:@"id"]];
                  
                    
                   // NSLog(@"array--> %@", self.user_Arrays_id);
                    
                    [defaults setBool:YES forKey:@"isFirstLogin"];
                  
                }
            }
            
            
            [defaults setObject:self.user_Arrays_id forKey:@"user_id_array"];
            
            [defaults synchronize];
            
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if([defaults boolForKey:@"isFirstLogin"]){
            //first login
           
                PasswordChangedVC *passwordChangedVC = [[PasswordChangedVC alloc]initWithNibName:@"PasswordChangedVC" bundle:nil];
                
                SideMenuVC *leftMenuViewController = [[SideMenuVC alloc]init];
                
                MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController
                                                                containerWithCenterViewController:passwordChangedVC
                                                                leftMenuViewController:leftMenuViewController
                                                                rightMenuViewController:nil];
                [self.navigationController pushViewController:container animated:YES];

                
            } else {
                
            // not first login
                

                HomeViewController *dashBoardVC = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
                SideMenuVC *leftMenuViewController = [[SideMenuVC alloc]init];
                
                MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController
                                                                containerWithCenterViewController:dashBoardVC
                                                                leftMenuViewController:leftMenuViewController
                                                                rightMenuViewController:nil];
                
                
                leftMenuViewController.agentArray = [self.responseDict objectForKey:@"agent"];
                [self.navigationController pushViewController:container animated:YES];
                
                
            }
        }
        
        
    }else if ([serviceName isEqualToString:@"forgetPassword"]){
        
        self.responseDict = [responseString objectFromJSONString];
        if ([[self.responseDict objectForKey:@"status"] isEqualToString:@"success"]) {
            
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Success" message:[self.responseDict objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil, nil];
            [alertView show];
            
            
        }else{
            
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:[self.responseDict objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertView show];
        }
        
    }
    
}




-(void)ConnectiondidFailWithError:(NSString *)responseString :(NSString *)serviceName{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    NSLog(@"ConnectiondidFailWithError->>:%@",responseString);
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please Check Your Internet Connection" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
}

- (IBAction)forgetPasswordBtnPressed:(id)sender {
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Please verify your email address:"
                                                      message:nil
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:@"Send", nil];
    
    [message setAlertViewStyle:UIAlertViewStylePlainTextInput];
    
    [message show];
    
    message.tag = 999;
    
}


#pragma mark EmailFormat

-(BOOL)emailFormat
{
    BOOL status;
    status = YES;
    NSString *emailString;
    //    emailString = self.emailTxtField.text;
    emailString = self.alertTextField.text;
    NSString *emailReg = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailReg];
    
    if (([emailTest evaluateWithObject:emailString] != YES) || [emailString isEqualToString:@""])
    {
        status =  NO;
    }
    
    return status;
}




- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        
        self.alertTextField = [alertView textFieldAtIndex:0];
        
        //NSLog(@"alerttextfiled - %@",self.alertTextField.text);
        
        
        BOOL emailFormat = [self emailFormat];
        
        if (!emailFormat) {
            
            alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Wrong Email Format. Example:abc@abc.com" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alertView show];
            
            
        }else{
            
            if ([self connectedToWiFi]) {
                
    
                NSString *inputText  = [[alertView textFieldAtIndex:0] text];
                
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeIndeterminate;
                hud.labelText = @"Loading";
                dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                    
                    
                    
                    [post forgetPassword:inputText];
                    
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
}



- (IBAction)switchChanged:(id)sender {
    
    if ([sender isOn]) {
        
        if ([self.emailTxtField.text isEqualToString:@""] || [self.passTxtField.text isEqualToString:@""]) {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Email or Password Field is Empty" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            
            [sender setOn:NO];
        }
        
      //  [self.mySwitch setOn:YES];
       
    }else{
        
        
        [sender setOn:NO];
    }
}
@end
