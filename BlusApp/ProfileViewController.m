//
//  SettingsViewController.m
//  BlusApp
//
//  Created by Usman Ghani on 23/06/2014.
//  Copyright (c) 2014 Gexton. All rights reserved.
//

#import "ProfileViewController.h"
#import "MBProgressHUD.h"
#import "SideMenuVC.h"
#import "MFSideMenuContainerViewController.h"
#import "UIImage+imageWithImage.h"
#import "ChangePasswordVC.h"

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@interface ProfileViewController ()

@end

@implementation ProfileViewController

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
   
    if (!IS_IPHONE_5) {
        
        self.scrollView.frame = CGRectMake(0.0, 150.0, 320.0, 500.0);
        self.scrollView.contentSize = CGSizeMake(320.0, 600.0);
    }
    
    keyboardBounds = CGRectMake(0.0, 480.0, 320.0, 216.0);
    post = [[POST alloc]init];
    post.delegate = self;
    
    [NSTimer scheduledTimerWithTimeInterval:5.0
                                     target:self
                                   selector:@selector(check_notification3)
                                   userInfo:nil
                                    repeats:YES];
    
}
-(void)check_notification3{
        
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
    
    self.profile_header_lb.font = [UIFont fontWithName:@"Lato-Regular" size:20];
    self.back_btn.titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:20];
    self.fnameLbl.font = [UIFont fontWithName:@"Lato-Regular" size:16];
    self.lnameLbl.font = [UIFont fontWithName:@"Lato-Regular" size:16];
    self.emailLbl.font = [UIFont fontWithName:@"Lato-Regular" size:16];
    self.fnameTxtField.font = [UIFont fontWithName:@"Lato-Regular" size:15];
    self.lnameTxtField.font = [UIFont fontWithName:@"Lato-Regular" size:15];
    self.emailAddressTxtField.font = [UIFont fontWithName:@"Lato-Regular" size:15];
    

    self.usernameTxtField.text = [defaults stringForKey:@"user_name"];
    self.fnameTxtField.text = [defaults stringForKey:@"fname"];
    self.lnameTxtField.text = [defaults stringForKey:@"lname"];
    self.emailAddressTxtField.text = [defaults stringForKey:@"email"];
    
    if ([defaults stringForKey:@"img_link"] == nil || [[defaults stringForKey:@"img_link"] isEqualToString:@""]){
        
        UIImageView *defaultPic = [[UIImageView alloc]initWithFrame:CGRectMake(115.0, 22.0, 84.0, 82.0)];
        [defaultPic setImage:[UIImage imageNamed:@"test_dp.png"]];
        [self.scrollView addSubview:defaultPic];
        [self.scrollView sendSubviewToBack:defaultPic];
        
        
    }else{
        IphoneAsyncImageView *participantImg = [[IphoneAsyncImageView alloc] initWithFrame:CGRectMake(115.0f, 22.0f,84.0f,82.0f)];
        
        participantImg.cv_width = 84.0f;
        participantImg.cv_height = 82.0f;
        
        participantImg.backgroundColor = [UIColor clearColor];
         participantImg.contentMode = UIViewContentModeScaleToFill;
       // NSLog(@"image_link=> %@", [defaults stringForKey:@"img_link"]);
        [participantImg loadImageFromURL:[NSURL URLWithString:[defaults stringForKey:@"img_link"]]];
        participantImg.tag = 201;
       // [participantImg setContentMode:UIViewContentModeScaleAspectFit];
        [self.scrollView addSubview:participantImg];
        [self.scrollView sendSubviewToBack:participantImg];
    
    
    }

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





#pragma mark -UPDATE PROFILE INFO

- (IBAction)updateProfileBtnPressed:(id)sender {
    
    
    [self.usernameTxtField resignFirstResponder];
    [self.fnameTxtField resignFirstResponder];
    [self.lnameTxtField resignFirstResponder];
   
    [self restoreScrollViewContentSize];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading";
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        // MY CODE BEGIN //
       
        
        [post updateProfile_firstName:self.fnameTxtField.text lastName:self.lnameTxtField.text username:self.usernameTxtField.text user_id:[defaults stringForKey:@"user_from_id"]];
        
        
        
        // MY CODE ENDS //
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            
        });
    });
    

}


/*
 
 if application is active
 image size cropped
 
 */

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

#pragma mark - PHOTO TAKEN
- (IBAction)photoTakenBtnPressed:(id)sender {
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Complete action using" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Take Photo", @"Choose Photo", nil];
    alertView.tag = 888;
    [alertView show];
    
}


-(void)takePhotoBtnPressed{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:NULL];
    }
    else {
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error accessing Camera" message:@"This device is unable to access camera" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
    }
}

-(void)choosePhotoBtnPressed{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}



#pragma mark - Image Picker Controller delegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    self.imgView.image = chosenImage;
    
    dataImage = [[NSData alloc] initWithData:UIImageJPEGRepresentation(chosenImage, 1)];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    
    self.imgView.image = [UIImage imageWithImage:self.imgView.image scaledToSize:CGSizeMake(120.0, 100.0)];
    
    [self.imgView setImage:self.imgView.image];
    
    [self.scrollView bringSubviewToFront:self.imgView];
    
   // dbClass *db =[[dbClass alloc]init];
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading";
    
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        // MY CODE BEGIN //
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        
        [post profile_img:UIImagePNGRepresentation(self.imgView.image) :[defaults stringForKey:@"user_from_id"]];
        
        
        // MY CODE ENDS //
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            
        });
    });
    
    
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}




#pragma mark UITextFieldDelegate

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    
 if (textField == self.fnameTxtField){
        [self.lnameTxtField becomeFirstResponder];
 }
    else if (self.lnameTxtField ==self.lnameTxtField){
        [self.lnameTxtField resignFirstResponder];
        
        [self restoreScrollViewContentSize];
    }
    
   

    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    
    [self scrollViewToCenterOfScreen:textField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self restoreScrollViewContentSize];
    
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
    
    CGFloat y = viewCenterY - availableHeight / 2.0;
    if (y < 0) {
        y = 0;
    }
    self.scrollView.contentSize = CGSizeMake(applicationFrame.size.width, applicationFrame.size.height + keyboardBounds.size.height);
    [self.scrollView setContentOffset:CGPointMake(0, y) animated:YES];
}



#pragma mark - Connections
-(void)ConnectionDidFinishLoading:(NSString *)responseString :(NSString *)serviceName{
    NSLog(@"%@",serviceName);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if([serviceName isEqualToString:@"updateProfile"]){
        
        self.responseDict = [responseString objectFromJSONString];
       
        [defaults setObject:[[self.responseDict objectForKey:@"user_info"] objectForKey:@"username"] forKey:@"user_name"];
        [defaults setObject:[[self.responseDict objectForKey:@"user_info"] objectForKey:@"fname"] forKey:@"fname"];
        [defaults setObject:[[self.responseDict objectForKey:@"user_info"] objectForKey:@"lname"] forKey:@"lname"];
        
        [defaults synchronize];
        
       UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Success" message:@"Profile Successfully Updated" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        alertView.tag = 999;
        [alertView show];
        
    
    }
    
    
    else if([serviceName isEqualToString:@"profile_img"]){
       
    
        self.responseDict = [responseString objectFromJSONString];
        
        if ([[self.responseDict objectForKey:@"status"] isEqualToString:@"success"]) {
            
            [defaults removeObjectForKey:@"img_link"];
            
            
            [defaults setObject:[[self.responseDict objectForKey:@"user_info" ] objectForKey:@"img_link"] forKey:@"img_link"];
          
            [defaults synchronize];


            self.imgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[defaults stringForKey:@"img_link"]]]];
          
            [self.scrollView bringSubviewToFront:self.imgView];
            
            dbClass *db = [[dbClass alloc]init];
            
            // 
            [db updateProfilePicturepath:[[self.responseDict objectForKey:@"user_info"]objectForKey:@"img_link"] :[[self.responseDict objectForKey:@"user_info"]objectForKey:@"id"]];
            
              
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Success" message:@"Profile Picture Successfully Updated" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
           
            [alertView show];
        }
        
    }
    
}

-(void)ConnectiondidFailWithError:(NSString *)responseString :(NSString *)serviceName{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please Check Your Internet Connection" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
}

#pragma mark - UIALERTVIEW

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (alertView.tag == 888){
        
        if (buttonIndex == 1) {
            
            [self takePhotoBtnPressed];
            
        }else if (buttonIndex == 2){
            
            [self choosePhotoBtnPressed];
        }
    
    
    }else if (alertView.tag == 999){
        
     
        [self restoreScrollViewContentSize];
        
    }
}




@end
