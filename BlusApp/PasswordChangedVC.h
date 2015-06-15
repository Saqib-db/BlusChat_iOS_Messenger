//
//  PasswordChangedVC.h
//  BlusApp
//
//  Created by gexton-macmini on 28/10/2014.
//  Copyright (c) 2014 Gexton. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Post.h"

@interface PasswordChangedVC : UIViewController{
    
    POST *post;
    CGRect keyboardBounds;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property(nonatomic, readwrite)BOOL isFirstTime;

@property (weak, nonatomic)NSMutableDictionary *responseDict;

@property (weak, nonatomic) IBOutlet UITextField *oldPassTxtField;

@property (weak, nonatomic) IBOutlet UITextField *nwPasTxtField;

@property (weak, nonatomic) IBOutlet UITextField *confirmPassTxtField;


- (IBAction)savePassBtnPressed:(id)sender;

@end
