//
//  CreateEventVC.m
//  BlusApp
//
//  Created by Zeeshan Anwar on 8/25/14.
//  Copyright (c) 2014 Gexton. All rights reserved.
//

#import "CreateEventVC.h"
#import "ContactsViewController.h"
#import "Singleton.h"

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define Picker_View_Move_Hight 210
#define KEYBOARD_VIEW_MOVE_HEIGHT 210


@interface CreateEventVC ()

@end

@implementation CreateEventVC

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
                                   selector:@selector(check_notification11)
                                   userInfo:nil
                                    repeats:YES];
    
       if (!IS_IPHONE_5) {
        
        self.scrollView.frame = CGRectMake(0.0, 150.0, 320.0, 480.0);
        [self.scrollView setContentSize:CGSizeMake(320.0, 590.0)];
    }
    
    keyboardBounds = CGRectMake(0.0, 480.0, 320.0, 216.0);
    post = [[POST alloc]init];
    post.delegate = self;
}


-(void)check_notification11{
    
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
    
    
    Singleton *single = [Singleton retrieveSingleton];
    self.selected_usersArray = single.invitedUsersArray;
    self.usersCount.text = [NSString stringWithFormat:@"%lu", (unsigned long)[self.selected_usersArray count]];
    
   self.user_to_id_comma_seperated = [self.selected_usersArray componentsJoinedByString:@"_"];
   // NSLog(@"Result--> %@", self.user_to_id_comma_seperated);
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
    
    if (textField == self.eventTextField) {
        
        [self.eventTextField resignFirstResponder];
    }
    
     // Restore scrollView
    
    [self restoreScrollViewContentSize];
    
    return YES;
    
    
}



- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    [self myViewDown:self.datePickerView];
    [self myViewDown:self.toDatePickerView];
    
    [self scrollViewToCenterOfScreen:textField];
    
}

#pragma mark UITEXTView

-(void)textViewDidBeginEditing:(UITextView *)textView{
    
    [self myViewDown:self.datePickerView];
    [self myViewDown:self.toDatePickerView];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
     [self myViewDown:self.datePickerView];
    
    // Any new character added is passed in as the "text" parameter
    if ([text isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        [textView resignFirstResponder];
        
        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }
    // For any other character return TRUE so that the text gets added to the view
    return TRUE;
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

#pragma mark -From DatePicker
- (IBAction)datePicker_doneBtnPressed:(id)sender {
    
    [self myViewDown:self.datePickerView];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSString *theTime;
	theTime =  [dateFormatter stringFromDate:[_datePicker date]];
    
    self.fromDateLbl.text = theTime;
}

- (IBAction)datePicker_valueChanged:(id)sender {
   
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSString *theTime;
	theTime =  [dateFormatter stringFromDate:[_datePicker date]];
    
    self.fromDateLbl.text = theTime;
  
}


- (IBAction)datePickerBtnPressed:(id)sender {
    
    [self.eventTextField resignFirstResponder];
     [self.eventTextView resignFirstResponder];
    
    if (!IS_IPHONE_5) {
        
        self.datePickerView.frame = CGRectMake(0,450, 320, 260);
    }else{
        
        self.datePickerView.frame = CGRectMake(0,520, 320, 260);
        
    }
    
    [self.view addSubview:self.datePickerView];
	[self myViewUp:self.datePickerView];
    
}



#pragma mark- To Date Picker
- (IBAction)to_datePicker_valueChanged:(id)sender{
    
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSString *theTime;
	theTime =  [dateFormatter stringFromDate:[_datePicker date]];
    
    self.toDateLbl.text = theTime;
    
}

- (IBAction)toDatePickerBtnPressed:(id)sender {
    
    [self.eventTextField resignFirstResponder];
    
    if (!IS_IPHONE_5) {
        
        self.toDatePickerView.frame = CGRectMake(0,430, 320, 260);
    }else{
        
        self.toDatePickerView.frame = CGRectMake(0,520, 320, 260);
        
    }
    
    [self.view addSubview:self.toDatePickerView];
	[self myViewUp:self.toDatePickerView];
    

}

- (IBAction)toDatePicker_doneBtn:(id)sender {
    
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSString *theTime;
	theTime =  [dateFormatter stringFromDate:[_toDatePicker date]];
    
    
    self.toDateLbl.text = theTime;
    
    [self myViewDown:self.toDatePickerView];
   
    
}

#pragma mark - Save Event

- (IBAction)saveEventBtnPressed:(id)sender {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

   // NSLog(@"userTo==> %@", self.user_to_id_comma_seperated);
    
    if ([self.eventTextField.text isEqualToString:@""] ||[self.eventTextView.text isEqualToString:@""]|| [self.fromDateLbl.text isEqualToString:@""] || [self.toDateLbl.text isEqualToString:@""] || self.user_to_id_comma_seperated == nil) {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:@"One or more mandatary fields are empty" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
        
    }else{

    
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        hud.mode = MBProgressHUDModeIndeterminate;
        
        hud.labelText = @"Creating Event";
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            
            // MY CODE BEGIN //
            
            
            
            [post insert_event:self.eventTextField.text :self.eventTextView.text :self.fromDateLbl.text :self.toDateLbl.text :self.user_to_id_comma_seperated :[defaults stringForKey:@"user_from_id"]];
            
            // MY CODE ENDS //
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                
            });
        });

    }
   
    
}

- (IBAction)backBtnPressed:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Invite Users

- (IBAction)invite_userBtnPressed:(id)sender {
    
    ContactsViewController *contactsVc = [[ContactsViewController alloc]initWithNibName:@"ContactsViewController" bundle:nil];
    contactsVc.isPushed = @"eventPushed";
    
    [self presentViewController:contactsVc animated:YES completion:nil];
    

}


#pragma mark - Connections
-(void)ConnectionDidFinishLoading:(NSString *)responseString :(NSString *)serviceName{
    
    NSLog(@"%@",serviceName);
    
    //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if([serviceName isEqualToString:@"insert_event"]){
        
        self.responseDict = [responseString objectFromJSONString];
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Success" message:@"Event Created" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
        
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (buttonIndex == 0) {
        
        [self.navigationController popViewControllerAnimated:YES];
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
