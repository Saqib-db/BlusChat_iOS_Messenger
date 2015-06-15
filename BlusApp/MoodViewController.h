//
//  MoodViewController.h
//  BlusApp
//
//  Created by Usman Ghani on 24/06/2014.
//  Copyright (c) 2014 Gexton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "MBProgressHUD.h"
#import "HomeViewController.h"


@interface MoodViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate>{
    
    POST *post;
}

@property (strong, nonatomic) HomeViewController *homeVC;
@property (weak, nonatomic) NSMutableArray *msgsArray;
@property (weak, nonatomic) IBOutlet UIImageView *notificationIconImg;
@property (weak, nonatomic) IBOutlet UILabel *setMood_header_lbl;
@property (weak, nonatomic) IBOutlet UIButton *back_btn;
@property (weak, nonatomic) IBOutlet UIButton *setMood_btn;


@property (strong, nonatomic)NSMutableDictionary *responseDict;


@property (weak, nonatomic) IBOutlet UITextField *moodTextField;

- (IBAction)backBtnPressed:(id)sender;
- (IBAction)setMoodBtnPressed:(id)sender;

@end
