//
//  PaymentViewController.m
//  BlusApp
//
//  Created by gexton-macmini on 16/08/2014.
//  Copyright (c) 2014 Gexton. All rights reserved.
//

#import "PaymentViewController.h"

@interface PaymentViewController ()

@end

@implementation PaymentViewController

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
    
    
}


-(void)viewWillAppear:(BOOL)animated{
    
    self.payment_header_lbl.font = [UIFont fontWithName:@"Lato-Regular" size:20];
    self.back_btn.titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:20];
    self.textView.font = [UIFont fontWithName:@"Lato-Regular" size:15];
    
    self.textView.text = self.payment_info_str;
    
}

#pragma mark UITEXTView

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)update_paymentBtnPressed:(id)sender {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading";
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        // MY CODE BEGIN //
        
        
        [post insert_payment_information:[defaults stringForKey:@"user_from_id"] :self.textView.text];
        
        
        
        // MY CODE ENDS //t
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            
        });
    });

}

-(void)ConnectionDidFinishLoading:(NSString *)responseString :(NSString *)serviceName{
    NSLog(@"%@",serviceName);
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if([serviceName isEqualToString:@"insertPaymentInfo"]){
        
        self.responseDict = [responseString objectFromJSONString];
        
        if ([[self.responseDict objectForKey:@"status"] isEqualToString:@"success"]) {
            
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Successful" message:@"Payment information updated" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            NSLog(@"doesn't insert payment record please check the parameter or service again");
        }
        
        
    }else if ([serviceName isEqualToString:@"get_payment_information"]){
        
         self.responseDict = [responseString objectFromJSONString];
    }
    
    
}

-(void)ConnectiondidFailWithError:(NSString *)responseString :(NSString *)serviceName{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    NSLog(@"ConnectiondidFailWithError->>:%@",responseString);
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please Check Your Internet Connection" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


- (IBAction)backBtnPressed:(id)sender {
    
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
