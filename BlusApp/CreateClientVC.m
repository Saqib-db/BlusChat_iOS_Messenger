//
//  CreateClientVC.m
//  BlusApp
//
//  Created by Zeeshan Anwar on 9/9/14.
//  Copyright (c) 2014 Gexton. All rights reserved.
//

#import "CreateClientVC.h"
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define Picker_View_Move_Hight 210
#define KEYBOARD_VIEW_MOVE_HEIGHT 210

@interface CreateClientVC ()

@end

@implementation CreateClientVC

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


#pragma mark EmailFormat

-(BOOL)emailFormat
{
	BOOL status;
	status = YES;
	NSString *emailString;
	emailString =self.emailTxtField.text;
	NSString *emailReg = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailReg];
	
	if (([emailTest evaluateWithObject:emailString] != YES) || [emailString isEqualToString:@""])
	{
		status =  NO;
	}
	
	return status;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [NSTimer scheduledTimerWithTimeInterval:5.0
                                     target:self
                                   selector:@selector(check_notification:)
                                   userInfo:nil
                                    repeats:YES];
    
    if (!IS_IPHONE_5) {
        
        self.scrollView.frame = CGRectMake(0.0, 150.0, 320.0, 480.0);
        [self.scrollView setContentSize:CGSizeMake(320.0, 620.0)];
        
        self.assignAgent_Bg.frame = CGRectMake(92.0, 20.0, 150.0, 40.0);
    }else{
        self.assign_btn.frame = CGRectMake(92.0, 40.0, 140.0, 30.0);
        self.usersCount.frame = CGRectMake(216.0, 45.0, 26.0, 21.0);
    }
    
    keyboardBounds = CGRectMake(0.0, 480.0, 320.0, 216.0);
    post = [[POST alloc]init];
    post.delegate = self;
    
    NSDate *now = [NSDate date];
	[self.datePicker setDate:now animated:YES];
    
    self.genderArray = [[NSMutableArray alloc]initWithObjects:@"Male",@"Female", nil];
    //self.countryArray = [[NSMutableArray alloc]initWithObjects:@"Male",@"Female", nil];
    
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        
        [post getCountries];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            
        });
    });


}


-(void)check_notification:(id)sender{
    
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

   
    self.create_client_header_lbl.font = [UIFont fontWithName:@"Lato-Regular" size:20];
    self.back_btn.titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:20];
    self.fnameTxtField.font = [UIFont fontWithName:@"Lato-Regular" size:15];
    self.lnameTxtField.font = [UIFont fontWithName:@"Lato-Regular" size:15];
    self.usernameTxtField.font = [UIFont fontWithName:@"Lato-Regular" size:15];
    self.emailTxtField.font = [UIFont fontWithName:@"Lato-Regular" size:15];
    self.passwordTxtField.font = [UIFont fontWithName:@"Lato-Regular" size:15];
    self.genderLbl.font = [UIFont fontWithName:@"Lato-Regular" size:15];
    self.dobLbl.font = [UIFont fontWithName:@"Lato-Regular" size:15];
    self.countryLbl.font = [UIFont fontWithName:@"Lato-Regular" size:15];
    self.assign_btn.titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:16];
    self.usersCount.font = [UIFont fontWithName:@"Lato-Regular" size:16];
    
    Singleton *single = [Singleton retrieveSingleton];
    
    self.selectedAgents_Array = single.invitedUsersArray;
    
   // NSLog(@"selectAgentArray_Count---> %d", [self.selectedAgents_Array count]);
    
    
    self.usersCount.text = [NSString stringWithFormat:@"%lu", (unsigned long)[self.selectedAgents_Array count]];
    
    self.agent_id_dash_seperated = [self.selectedAgents_Array componentsJoinedByString:@"_"];
    
   // NSLog(@"Result--> %@", self.agent_id_dash_seperated);

    
    
}


#pragma mark - View Up/Down
/*Call when Dialog need to be Move from bottom to Up*/
- (void)myViewUp:(UIView*)sender
{
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
	
    CGRect rect = sender.frame;
	
	rect.origin.y -= Picker_View_Move_Hight;
	
	sender.frame = rect;
	
    [UIView commitAnimations];
}

/*Call When Remainder Dialog need to be Move from up to Down*/
- (void)myViewDown:(UIView*)sender
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    CGRect rect = sender.frame;
    
    rect.origin.y += 300;
    
    sender.frame = rect;
    
    [UIView commitAnimations];
}



#pragma mark - UITextField

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == self.fnameTxtField) {
        [self.lnameTxtField becomeFirstResponder];
    }
    else if (textField == self.lnameTxtField){
        [self.usernameTxtField becomeFirstResponder];
    }
    else if (textField == self.usernameTxtField){
        [self.emailTxtField becomeFirstResponder];
    }
    else if (textField == self.emailTxtField){
        [self.passwordTxtField becomeFirstResponder];
    }
    else if (textField == self.passwordTxtField){
        [self.passwordTxtField resignFirstResponder];
    }
        
    // Restore scrollView
    
    [self restoreScrollViewContentSize];
    
    return YES;
    
    
}



- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    [self myViewDown:self.genderPickerView];
    [self myViewDown:self.datePickerView];
    [self myViewDown:self.countryPickerView];
    
    [self scrollViewToCenterOfScreen:textField];
    
}



#pragma mark - UIScrollView
- (void) restoreScrollViewContentSize
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    
    // self.scrollView.contentSize = CGSizeMake(320.0, 200.0);
    
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

- (IBAction)addAgentBtnPressed:(id)sender {
    
    AddAgentVC *addAgent = [[AddAgentVC alloc]initWithNibName:@"AddAgentVC" bundle:nil];
    [self presentViewController:addAgent animated:YES completion:nil];
}

- (IBAction)backBtnPressed:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveNewClientBtnPressed:(id)sender {
    
    
      NSLog(@"country--> %@", self.countryLbl.text);
    NSLog(@"country_id--> %@", self.country_id);
    
    BOOL emailFormat = [self emailFormat];
    
    if ([self.usernameTxtField.text isEqualToString:@""] || [self.fnameTxtField.text isEqualToString:@""] || [self.lnameTxtField.text isEqualToString:@""] || [self.emailTxtField.text isEqualToString:@""] || [self.passwordTxtField.text isEqualToString:@""] || self.agent_id_dash_seperated == nil){
        
        alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"One or more fields are empty" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    
    else
    {
        if (!emailFormat) {
            alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Wrong Email Format. Example:abc@abc.com" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
        else{
            
            if ([self connectedToWiFi]) {
                
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeIndeterminate;
                hud.labelText = @"Loading";
                dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                    
                    // MY CODE BEGIN //
                    
                     [post create_client:self.fnameTxtField.text :self.lnameTxtField.text :self.country_id :self.usernameTxtField.text :self.emailTxtField.text :self.passwordTxtField.text :@"0" :self.agent_id_dash_seperated];
                   
                    
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

- (IBAction)datePicker_doneBtnPressed:(id)sender {
    
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd"];
    self.dobLbl.text = [NSString stringWithFormat:@"%@",[df stringFromDate:self.datePicker.date]];
    
    [self myViewDown:self.datePickerView];
    
}

- (IBAction)datePicker_valueChanged:(id)sender {
    
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd"];
    self.dobLbl.text = [NSString stringWithFormat:@"%@",[df stringFromDate:self.datePicker.date]];
    

}

- (IBAction)dobBtnPressed:(id)sender {
    
    [self.fnameTxtField resignFirstResponder];
    [self.lnameTxtField resignFirstResponder];
    [self.emailTxtField resignFirstResponder];
    [self.usernameTxtField resignFirstResponder];
    [self.passwordTxtField resignFirstResponder];
    
    if (!IS_IPHONE_5) {
        
        self.datePickerView.frame = CGRectMake(0,450, 320, 260);
    }else{
        
        self.datePickerView.frame = CGRectMake(0,520, 320, 260);
        
    }
    
    [self.view addSubview:self.datePickerView];
	[self myViewUp:self.datePickerView];
}
- (IBAction)countryDoneBtnPressed:(id)sender {
    
    [self.countryLbl setText:[NSString stringWithFormat:@"%@", [[self.countryArray objectAtIndex:[self.countryPicker selectedRowInComponent:0]]objectForKey:@"country"]]];
    
    self.country_id = [[self.countryArray objectAtIndex:0]objectForKey:@"id"];
    NSLog(@"country_id---> %@", self.country_id);
    
    
    [self myViewDown:self.countryPickerView];
}

- (IBAction)countryBtnPressed:(id)sender {
    [self.fnameTxtField resignFirstResponder];
    [self.lnameTxtField resignFirstResponder];
    [self.emailTxtField resignFirstResponder];
    [self.usernameTxtField resignFirstResponder];
    [self.passwordTxtField resignFirstResponder];
    
    [self myViewDown:self.datePickerView];
    [self myViewDown:self.genderPickerView];
    
    if (!IS_IPHONE_5) {
        
        self.countryPickerView.frame = CGRectMake(0,450, 320, 260);
    }else{
        
        self.countryPickerView.frame = CGRectMake(0,520, 320, 260);
        
    }
    
    [self.view addSubview:self.countryPickerView];
    [self myViewUp:self.countryPickerView];
    
    
}
- (IBAction)gender_doneBtnPressed:(id)sender {
    
    [self.genderLbl setText:[NSString stringWithFormat:@"%@", [self.genderArray objectAtIndex:[self.genderPicker selectedRowInComponent:0]]]];
    
    NSLog(@"Gender--> %@", self.genderLbl.text);
    
    if ([self.genderLbl.text isEqualToString:@"Male"]) {
        
        self.genderValue = @"0";
        
    }else{
        
        self.genderValue = @"1";
    }

    [self myViewDown:self.genderPickerView];

}

- (IBAction)genderBtnPressed:(id)sender {
    
    [self myViewDown:self.datePickerView];
    [self myViewDown:self.countryPickerView];
    
    [self.fnameTxtField resignFirstResponder];
    [self.lnameTxtField resignFirstResponder];
    [self.emailTxtField resignFirstResponder];
    [self.usernameTxtField resignFirstResponder];
    [self.passwordTxtField resignFirstResponder];
    
    if (!IS_IPHONE_5) {
        
        self.genderPickerView.frame = CGRectMake(0,450, 320, 260);
    }else{
        
        self.genderPickerView.frame = CGRectMake(0,520, 320, 260);
        
    }

    [self.view addSubview:self.genderPickerView];
    [self myViewUp:self.genderPickerView];
    
    
}



#pragma mark - PickerView

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (thePickerView == self.countryPicker) {
        
        return [self.countryArray count];
        
    }
    
    else if (thePickerView == self.genderPicker){
        
        return [self.genderArray count];
    }
    
    return YES;
}

-(NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    if (thePickerView == self.countryPicker) {
        
        return [[self.countryArray objectAtIndex:row]objectForKey:@"country"];
    }
    else if (thePickerView == self.genderPicker){
        
        return [self.genderArray objectAtIndex:row];
    }
    
    return NO;
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
	
	return 1;
}


- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    
	if (thePickerView == self.countryPicker) {
        self.countryLbl.text = [[self.countryArray objectAtIndex:row]objectForKey:@"country"];
        self.country_id = [[self.countryArray objectAtIndex:row]objectForKey:@"id"];
        NSLog(@"country_id---> %@", self.country_id);
    
    }
    else if (thePickerView == self.genderPicker){
        self.genderLbl.text = [self.genderArray objectAtIndex:row];
        
        NSLog(@"Gender---< %@", self.genderLbl.text);
        
        if ([self.genderLbl.text isEqualToString:@"Male"]) {
            
            self.genderValue = @"0";
            
        }else{
            
            self.genderValue = @"1";
        }
    }
    
}




#pragma mark - Connections
-(void)ConnectionDidFinishLoading:(NSString *)responseString :(NSString *)serviceName{
    
    NSLog(@"%@",serviceName);
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if([serviceName isEqualToString:@"getCountries"]){
        
        self.responseDict = [responseString objectFromJSONString];
        self.countryArray = [self.responseDict objectForKey:@"countries"];
        
        
    }
    else if ([serviceName isEqualToString:@"create_client"]){
        
        NSMutableDictionary *statusDict = [responseString objectFromJSONString];
        
        if ([[statusDict objectForKey:@"status"] isEqualToString:@"success"]) {
            
            alertView = [[UIAlertView alloc]initWithTitle:@"Success" message:@"Client Added Successfully" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertView show];
            
        }
        else{
            alertView = [[UIAlertView alloc]initWithTitle:@"Alert" message:[statusDict objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertView show];
        }
       
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (buttonIndex == 0) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)ConnectiondidFailWithError:(NSString *)responseString :(NSString *)serviceName{
    
     [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Check Your Internet Connection" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alertView show];
}

@end
