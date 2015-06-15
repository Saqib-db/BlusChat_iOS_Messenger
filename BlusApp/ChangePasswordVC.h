//
//  ChangePasswordVC.h
//  BlusApp
//
//  Created by Usman Ghani on 23/06/2014.
//  Copyright (c) 2014 Gexton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "Post.h"


@interface ChangePasswordVC : UIViewController{
    
    POST *post;
    CGRect keyboardBounds;
    
}

@property (weak, nonatomic) NSMutableArray *msgsArray;
@property (weak, nonatomic) IBOutlet UIImageView *notificationIconImg;
@property (weak, nonatomic) IBOutlet UILabel *changePass_header_lbl;
@property (weak, nonatomic) IBOutlet UIButton *back_btn;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UITextField *oldPassTxtField;
@property (weak, nonatomic) IBOutlet UITextField *nwTxtField;
@property (weak, nonatomic) IBOutlet UITextField *confirmTxtField;

@property (strong, nonatomic)NSMutableDictionary *responseDict;

- (IBAction)backBtnPressed:(id)sender;
- (IBAction)changePassBtnPressed:(id)sender;



@end
