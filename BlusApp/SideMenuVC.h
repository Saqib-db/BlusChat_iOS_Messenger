//
//  SideMenuVC.h
//  SocialVapping
//
//  Created by Zeeshan Shaikh on 4/10/14.
//  Copyright (c) 2014 Gexton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactsViewController.h"
#import "HomeViewController.h"
#import "GalleryViewController.h"

#import "MFSideMenuContainerViewController.h"
#import "MFSideMenu.h"
#import "Post.h"
#import "SettingsViewController.h"
#import "IphoneAsyncImageView.h"
#import "EventsTableVC.h"

@interface SideMenuVC : UIViewController <UIAlertViewDelegate>{
    UIImageView *activityImgView;
    POST *post;
    UILabel *moodLbl;
    UILabel *fnameLname;
}
@property (strong, nonatomic)UILabel *fnameLname;
@property (strong, nonatomic)UILabel *moodLbl;
@property (strong, nonatomic)NSMutableArray *agentArray;
@property (strong, nonatomic)NSMutableDictionary *responseDict;




@end
