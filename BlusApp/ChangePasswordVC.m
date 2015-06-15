//
//  ChangePasswordVC.m
//  BlusApp
//
//  Created by Usman Ghani on 23/06/2014.
//  Copyright (c) 2014 Gexton. All rights reserved.
//

#import "ChangePasswordVC.h"
#import "dbClass.h"


#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@interface ChangePasswordVC ()

@end

@implementation ChangePasswordVC

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
                                   selector:@selector(check_notification6)
                                   userInfo:nil
                                    repeats:YES];
    
    self.changePass_header_lbl.font = [UIFont fontWithName:@"Lato-Regular" size:20];
    self.back_btn.titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:20];
    self.oldPassTxtField.font = [UIFont fontWithName:@"Lato-Regular" size:15];
    self.nwTxtField.font = [UIFont fontWithName:@"Lato-Regular" size:15];
    self.confirmTxtField.font = [UIFont fontWithName:@"Lato-Regular" size:15];
    
    if (!IS_IPHONE_5) {
        
        self.scrollView.frame = CGRectMake(0.0, 150.0, 320.0, 500.0);
        self.scrollView.contentSize = CGSizeMake(320.0, 600.0);
    }
    
    keyboardBounds = CGRectMake(0.0, 480.0, 320.0, 216.0);
    
    post = [[POST alloc]init];
    post.delegate = self;
    
    self.oldPassTxtField.secureTextEntry = YES;
    self.nwTxtField.secureTextEntry = YES;
    self.confirmTxtField.secureTextEntry = YES;
}


-(void)check_notification6{
    
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
}


-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == self.oldPassTxtField) {
        [self.nwTxtField becomeFirstResponder];
    }
    else if (textField == self.nwTxtField){
        [self.confirmTxtField becomeFirstResponder];
    }
    else if (textField == self.confirmTxtField){
        [self.confirmTxtField resignFirstResponder];
        
        
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



- (IBAction)backBtnPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)changePassBtnPressed:(id)sender {
    
    [self.oldPassTxtField resignFirstResponder];
    [self.nwTxtField resignFirstResponder];
    [self.confirmTxtField resignFirstResponder];
    
    
    if ([self.oldPassTxtField.text isEqualToString:@""] || [self.nwTxtField.text isEqualToString:@""] || [self.confirmTxtField.text isEqualToString:@""]){
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"One or more fields are empty" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //alert.tag = 999;
        [alertView show];
        
    }
    
    else if (![self.nwTxtField.text isEqualToString: self.confirmTxtField.text ]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Password do not match" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
        //[MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
    }else{
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
      //  NSLog(@"User_ID-> %@", [defaults stringForKey:@"user_id"]);
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"Loading";
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            
            
            // MY CODE BEGIN //
            
            [post changePassword_oldPass:self.oldPassTxtField.text newPass:self.nwTxtField.text confirmPass:self.confirmTxtField.text Id:[defaults stringForKey:@"user_from_id"]];
            
            
            // MY CODE ENDS //
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                
            });
        });

    }
}




-(void)ConnectionDidFinishLoading:(NSString *)responseString :(NSString *)serviceName{
    NSLog(@"%@",serviceName);
    
    // NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if([serviceName isEqualToString:@"changePassword"]){
       // NSLog(@"Response---> %@", responseString);
        self.responseDict = [responseString objectFromJSONString];
        
        UIAlertView  *alertView = [[UIAlertView alloc]initWithTitle:@"Success" message:@"Password Successfully Updated" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        alertView.tag = 999;
        [alertView show];
        
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
