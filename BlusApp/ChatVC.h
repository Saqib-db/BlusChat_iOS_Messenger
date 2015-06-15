//
//  ChatVC.h
//  BlusApp
//
//  Created by Faizan Shaikh on 7/7/14.
//  Copyright (c) 2014 Gexton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "dbClass.h"
#import "MBProgressHUD.h"
#import "HomeViewController.h"

#import "UIImage+imageWithImage.h"

@interface ChatVC : UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate,UITextViewDelegate, UIAlertViewDelegate>{
    
    POST *post;
    NSData *dataImage;
   // UIButton *downloadBtn;
    NSString *imgPathStr;
     NSString *pngPath;
    
    
    

}

@property (strong, nonatomic)NSString *row_id;
@property (weak, nonatomic) IBOutlet UIButton *photoBtn;

@property (weak, nonatomic) IBOutlet UIView *ViewForTextView;


@property (strong, nonatomic)NSString *alert_textField;

@property (assign)BOOL isPushedBack;
@property (strong, nonatomic)NSString *DocDir_galleryImg;
@property (assign)BOOL is_galleryImg;

@property (strong, nonatomic)UIImage *path_img;
@property (strong, nonatomic)UIImage *img;
@property (strong, nonatomic) NSMutableArray *imgArray;
@property (strong, nonatomic)UIImage *downloadedImage;

@property (strong, nonatomic) IBOutlet UIImageView *imgView;

@property (strong, nonatomic)NSString *user_to_id;

@property (weak, nonatomic)NSString *user_to_string;

@property (weak, nonatomic) IBOutlet UILabel *User_to_label;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

//@property (weak, nonatomic) IBOutlet UITextField *msgTxtview;
@property (weak, nonatomic) IBOutlet UITextView *msgTxtview;

- (IBAction)backBtnPressed:(id)sender;

- (IBAction)sendMsgBtnPressed:(id)sender;

- (IBAction)Picture_Taken_Btn_Pressed:(id)sender;

- (IBAction)addVideoLink_BtnPressed:(id)sender;

- (void)saveImage: (UIImage*)image;

- (UIImage*)loadImage;


@end
