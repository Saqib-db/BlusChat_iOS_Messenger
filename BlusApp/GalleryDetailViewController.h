//
//  GalleryDetailViewController.h
//  BlusApp
//
//  Created by gexton-macmini on 15/08/2014.
//  Copyright (c) 2014 Gexton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IphoneAsyncImageView.h"
#import "IphoneImageDetailViewController.h"
#import "HomeViewController.h"
#import "SideMenuVC.h"
#import "MFSideMenuContainerViewController.h"


@interface GalleryDetailViewController : UIViewController <UIAlertViewDelegate>{
    
    int x;
    int y;
}
@property (strong, nonatomic) HomeViewController *homeVC;
@property (weak, nonatomic) NSMutableArray *msgsArray;
@property (weak, nonatomic) IBOutlet UIImageView *notificationIconImg;

@property (strong, nonatomic)NSString *is_blusGalleryBtnPressed;
@property (weak, nonatomic) IBOutlet UIButton *back_btn;
@property (nonatomic)NSInteger cat_id;

@property (nonatomic)NSInteger indexpath;
@property (weak, nonatomic) IBOutlet UILabel *category_nameLbl;
@property (strong, nonatomic)NSString *cat_name_str;
@property (strong, nonatomic)NSMutableArray *galleryArray;
@property (strong, nonatomic)NSMutableArray *galleryArray_new;

- (IBAction)backBtnPressed:(id)sender;

@end
