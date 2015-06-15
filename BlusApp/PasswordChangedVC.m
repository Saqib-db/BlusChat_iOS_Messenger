//
//  PasswordChangedVC.m
//  BlusApp
//
//  Created by gexton-macmini on 28/10/2014.
//  Copyright (c) 2014 Gexton. All rights reserved.
//

#import "PasswordChangedVC.h"
#import "MBProgressHUD.h"
#import "HomeViewController.h"
#import "SideMenuVC.h"

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )


@interface PasswordChangedVC ()

@end

@implementation PasswordChangedVC

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



- (void)viewDidLoad {

    [super viewDidLoad];
    
    if (!IS_IPHONE_5) {
        
        self.scrollView.frame = CGRectMake(0.0, 150.0, 320.0, 500.0);
        
        self.scrollView.contentSize = CGSizeMake(320.0, 600.0);
    }
    
    
    keyboardBounds = CGRectMake(0.0, 480.0, 320.0, 216.0);
    
    post = [[POST alloc]init];
    post.delegate = self;


}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == self.oldPassTxtField) {
        [self.nwPasTxtField becomeFirstResponder];
    }
    else if (textField == self.nwPasTxtField){
        [self.confirmPassTxtField becomeFirstResponder];
    }
    else if (textField == self.confirmPassTxtField){
        [self.confirmPassTxtField resignFirstResponder];
        
        
        [self restoreScrollViewContentSize];
        
    }
    
    
    // Restore scrollView
    
    [self restoreScrollViewContentSize];
    
    
    return YES;
    
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self scrollViewToCenterOfScreen:textField];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollView
- (void) restoreScrollViewContentSize
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    
    self.scrollView.contentSize = CGSizeMake(320.0, 200.0);
    
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




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)savePassBtnPressed:(id)sender {
    
    [self.oldPassTxtField resignFirstResponder];
    [self.nwPasTxtField resignFirstResponder];
    [self.confirmPassTxtField resignFirstResponder];
    
    
    if ([self.oldPassTxtField.text isEqualToString:@""] || [self.nwPasTxtField.text isEqualToString:@""] || [self.confirmPassTxtField.text isEqualToString:@""]){
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"One or more fields are empty" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //alert.tag = 999;
        [alertView show];
        
    }
    
    else if (![self.nwPasTxtField.text isEqualToString: self.confirmPassTxtField.text ]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Password do not match" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
        //[MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
    }else{
      
        
        if ([self connectedToWiFi]) {
            
        
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            //  NSLog(@"User_ID-> %@", [defaults stringForKey:@"user_id"]);
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeIndeterminate;
            hud.labelText = @"Loading";
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                
                
                // MY CODE BEGIN //
                
                      
                [post changePassword_oldPass:self.oldPassTxtField.text newPass:self.nwPasTxtField.text confirmPass:self.confirmPassTxtField.text Id:[defaults stringForKey:@"user_from_id"]];
                
                
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


-(void)ConnectionDidFinishLoading:(NSString *)responseString :(NSString *)serviceName{
    NSLog(@"%@",serviceName);
    
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if([serviceName isEqualToString:@"changePassword"]){
    
        // NSLog(@"Response---> %@", responseString);
        
        self.responseDict = [responseString objectFromJSONString];
        
        if ([[self.responseDict objectForKey:@"status"] isEqualToString:@"success"]) {
            
        UIAlertView  *alertView = [[UIAlertView alloc]initWithTitle:@"Success" message:@"Password Successfully Updated" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        alertView.tag = 999;
        [alertView show];
        
        }else{
            
            UIAlertView  *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Incorrect Old Password" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            
            [alertView show];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (alertView.tag == 999) {
        
        
        HomeViewController *dashBoardVC = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
        SideMenuVC *leftMenuViewController = [[SideMenuVC alloc]init];
        
        MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController
                                                        containerWithCenterViewController:dashBoardVC
                                                        leftMenuViewController:leftMenuViewController
                                                        rightMenuViewController:nil];
        
        
        leftMenuViewController.agentArray = [self.responseDict objectForKey:@"agent"];
        [self.navigationController pushViewController:container animated:YES];
        
       // [self.navigationController popViewControllerAnimated:YES];
    }
}


-(void)ConnectiondidFailWithError:(NSString *)responseString :(NSString *)serviceName{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please Check Your Internet Connection" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
}


@end
    
