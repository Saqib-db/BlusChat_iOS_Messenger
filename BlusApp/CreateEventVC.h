//
//  CreateEventVC.h
//  BlusApp
//
//  Created by Zeeshan Anwar on 8/25/14.
//  Copyright (c) 2014 Gexton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

@interface CreateEventVC : UIViewController <UITextFieldDelegate, UITextViewDelegate, UIAlertViewDelegate>{
    
    POST *post;
    CGRect keyboardBounds;
    
}

@property (weak, nonatomic) NSMutableArray *msgsArray;
@property (weak, nonatomic) IBOutlet UIImageView *notificationIconImg;
@property (strong, nonatomic)NSString *user_to_id_comma_seperated;

@property (weak, nonatomic) IBOutlet UILabel *usersCount;
@property (strong, nonatomic)NSMutableDictionary *responseDict;

@property (strong, nonatomic)NSMutableArray *selected_usersArray;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *eventTextField;
@property (weak, nonatomic) IBOutlet UITextView *eventTextView;


@property (strong, nonatomic) IBOutlet UIView *datePickerView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

- (IBAction)datePicker_doneBtnPressed:(id)sender;
- (IBAction)datePicker_valueChanged:(id)sender;


@property (strong, nonatomic) IBOutlet UIView *toDatePickerView;
@property (weak, nonatomic) IBOutlet UIDatePicker *toDatePicker;
- (IBAction)to_datePicker_valueChanged:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *fromDateLbl;
@property (weak, nonatomic) IBOutlet UILabel *toDateLbl;
- (IBAction)toDatePickerBtnPressed:(id)sender;
- (IBAction)toDatePicker_doneBtn:(id)sender;

- (IBAction)saveEventBtnPressed:(id)sender;
- (IBAction)backBtnPressed:(id)sender;
- (IBAction)datePickerBtnPressed:(id)sender;
- (IBAction)invite_userBtnPressed:(id)sender;


@end
