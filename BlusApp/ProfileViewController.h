//
//  SettingsViewController.h
//  BlusApp
//
//  Created by Usman Ghani on 23/06/2014.
//  Copyright (c) 2014 Gexton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "IphoneAsyncImageView.h"
#import "HomeViewController.h"


@interface ProfileViewController : UIViewController <UIAlertViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate>{
    
    POST *post;
    NSData *dataImage;
    CGRect keyboardBounds;
}

@property (strong, nonatomic) HomeViewController *homeVC;
@property (weak, nonatomic) NSMutableArray *msgsArray;
@property (weak, nonatomic) IBOutlet UIImageView *notificationIconImg;


@property (weak, nonatomic) IBOutlet UILabel *profile_header_lb;
@property (weak, nonatomic) IBOutlet UILabel *fnameLbl;
@property (weak, nonatomic) IBOutlet UILabel *lnameLbl;
@property (weak, nonatomic) IBOutlet UILabel *emailLbl;
@property (weak, nonatomic) IBOutlet UIButton *back_btn;

@property (strong, nonatomic)NSString *imgLinkStr;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *usernameTxtField;
@property (weak, nonatomic) IBOutlet UITextField *fnameTxtField;
@property (weak, nonatomic) IBOutlet UITextField *lnameTxtField;
@property (weak, nonatomic) IBOutlet UITextField *emailAddressTxtField;

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic)NSMutableDictionary *responseDict;

@property (weak, nonatomic) IBOutlet UIImageView *backBtnPressed;

- (IBAction)photoTakenBtnPressed:(id)sender;
- (IBAction)updateProfileBtnPressed:(id)sender;

- (IBAction)backBtnPressed:(id)sender;

@end
