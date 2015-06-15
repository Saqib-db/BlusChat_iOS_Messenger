//
//  PaymentViewController.h
//  BlusApp
//
//  Created by gexton-macmini on 16/08/2014.
//  Copyright (c) 2014 Gexton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "Post.h"

@interface PaymentViewController : UIViewController <UITextViewDelegate>{
    
    POST *post;
}
@property (weak, nonatomic) IBOutlet UILabel *payment_header_lbl;
@property (weak, nonatomic) IBOutlet UIButton *back_btn;

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic)NSString *payment_info_str;

@property (strong, nonatomic)NSMutableDictionary *responseDict;
- (IBAction)backBtnPressed:(id)sender;
- (IBAction)update_paymentBtnPressed:(id)sender;

@end
