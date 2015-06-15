//
//  GalleryViewController.h
//  BlusApp
//
//  Created by gexton-macmini on 15/08/2014.
//  Copyright (c) 2014 Gexton. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MBProgressHUD.h"
#import "SideMenuVC.h"
#import "MFSideMenuContainerViewController.h"
#import "dbClass.h"
#import "Reachability.h"
#import "Post.h"
#import "IphoneAsyncImageView.h"
#import "GalleryDetailViewController.h"
#import "HomeViewController.h"


@interface GalleryViewController : UIViewController{
    
    POST *post;
}

@property (strong, nonatomic) HomeViewController *homeVC;
@property (weak, nonatomic) NSMutableArray *msgsArray;
@property (weak, nonatomic) IBOutlet UIImageView *notificationIconImg;

@property (weak, nonatomic) IBOutlet UILabel *blus_gallery_header_lbl;
@property (weak, nonatomic) IBOutlet UIButton *toggleBtn;
- (IBAction)cancelBtnPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (strong, nonatomic)NSString *is_blusGalleryBtnPressed;
@property (nonatomic)NSInteger category_id;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)NSMutableDictionary *responseDict;
@property (strong, nonatomic)NSMutableArray *responseArray;

- (IBAction)toggleBtnPressed:(id)sender;

@end
