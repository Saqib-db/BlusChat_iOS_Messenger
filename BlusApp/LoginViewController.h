//
//  LoginViewController.h
//  BlusApp
//
//  Created by Usman Ghani on 16/06/2014.
//  Copyright (c) 2014 Gexton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactsViewController.h"
#import "HomeViewController.h"
#import "Post.h"
#import "ChangePasswordVC.h"

@interface LoginViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate>{
    
    POST *post;
     CGRect keyboardBounds;
}

@property (strong, nonatomic)UITextField * alertTextField;
//@property (strong, nonatomic)UIAlertView *alertView;
@property (strong, nonatomic)NSMutableArray *user_Arrays_id;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *emailTxtField;
@property (weak, nonatomic) IBOutlet UITextField *passTxtField;

@property (weak, nonatomic)NSMutableDictionary *responseDict;
@property (weak, nonatomic)NSMutableArray *agentArray;
@property (strong, nonatomic)NSMutableArray *clientArray;
@property (strong, nonatomic)NSMutableArray *user_info_array;
@property (strong, nonatomic)NSMutableArray *allMsgsArray;

- (IBAction)loginBtnPressed:(id)sender;

@property (strong, nonatomic) HomeViewController *homeVC;
@property (strong, nonatomic) ChangePasswordVC *changePassVC;

- (IBAction)forgetPasswordBtnPressed:(id)sender;

//@property (strong, nonatomic) ContactsViewController *ContactsVC;
- (IBAction)switchChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *mySwitch;

@end
