//
//  SettingsViewController.h
//  BlusApp
//
//  Created by Usman Ghani on 24/06/2014.
//  Copyright (c) 2014 Gexton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "dbClass.h"
#import "HomeViewController.h"

@interface SettingsViewController : UIViewController{
    
    POST *post;
}

@property (strong, nonatomic) HomeViewController *homeVC;

@property (weak, nonatomic) NSMutableArray *msgsArray;
@property (weak, nonatomic) IBOutlet UIImageView *notificationIconImg;

@property (weak, nonatomic) IBOutlet UILabel *setting_header_lbl;

@property (strong, nonatomic)NSMutableDictionary *responseDict;
@property (strong, nonatomic)NSMutableArray *settingsArray;

@property (strong, nonatomic)NSString *payment_infoStr;

- (IBAction)toggleBtnPressed:(id)sender;


@end
