//
//  CreateClientVC.h
//  BlusApp
//
//  Created by Zeeshan Anwar on 9/9/14.
//  Copyright (c) 2014 Gexton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "MBProgressHUD.h"
#import "AddAgentVC.h"
#import "Singleton.h"
#import "dbClass.h"

@interface CreateClientVC : UIViewController <UITextFieldDelegate, UIAlertViewDelegate>{
    
    POST *post;
    CGRect keyboardBounds;
    UIAlertView *alertView;
    NSString *genderValue;

}

@property (weak, nonatomic) NSMutableArray *msgsArray;
@property (weak, nonatomic) IBOutlet UIImageView *notificationIconImg;
@property (weak, nonatomic) IBOutlet UILabel *create_client_header_lbl;
@property (weak, nonatomic) IBOutlet UIButton *back_btn;
@property (weak, nonatomic) IBOutlet UIButton *assign_btn;
@property (weak, nonatomic) IBOutlet UILabel *usersCount;

@property (strong, nonatomic)NSString *agent_id_dash_seperated;

@property (strong, nonatomic)NSMutableArray *selectedAgents_Array;

@property (weak, nonatomic) IBOutlet UIImageView *assignAgent_Bg;

@property (strong, nonatomic)NSMutableDictionary *responseDict;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic)NSMutableArray *countryArray;
@property (strong, nonatomic)NSMutableArray *genderArray;
@property (strong, nonatomic)NSString *genderValue;

@property (weak, nonatomic) IBOutlet UITextField *fnameTxtField;
@property (weak, nonatomic) IBOutlet UITextField *lnameTxtField;
@property (weak, nonatomic) IBOutlet UITextField *usernameTxtField;
@property (weak, nonatomic) IBOutlet UITextField *emailTxtField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxtField;



- (IBAction)addAgentBtnPressed:(id)sender;

- (IBAction)backBtnPressed:(id)sender;
- (IBAction)saveNewClientBtnPressed:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *datePickerView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UILabel *dobLbl;

- (IBAction)datePicker_doneBtnPressed:(id)sender;
- (IBAction)datePicker_valueChanged:(id)sender;
- (IBAction)dobBtnPressed:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *countryPickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *countryPicker;
@property (weak, nonatomic) IBOutlet UILabel *countryLbl;
@property (weak, nonatomic)NSString *country_id;

- (IBAction)countryDoneBtnPressed:(id)sender;
- (IBAction)countryBtnPressed:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *genderPickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *genderPicker;
@property (weak, nonatomic) IBOutlet UILabel *genderLbl;

- (IBAction)gender_doneBtnPressed:(id)sender;
- (IBAction)genderBtnPressed:(id)sender;


@end
