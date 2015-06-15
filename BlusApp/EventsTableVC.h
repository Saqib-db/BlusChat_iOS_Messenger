//
//  EventsTableVC.h
//  BlusApp
//
//  Created by Zeeshan Anwar on 8/24/14.
//  Copyright (c) 2014 Gexton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dbClass.h"
#import "Reachability.h"
#import "Post.h"
#import "EventsDetailVC.h"
#import "HomeViewController.h"
#import "SideMenuVC.h"
#import "MFSideMenuContainerViewController.h"

@interface EventsTableVC : UIViewController <UIGestureRecognizerDelegate>{
    
    POST *post;
}


@property (strong, nonatomic) HomeViewController *homeVC;
@property (weak, nonatomic) NSMutableArray *msgsArray;
@property (weak, nonatomic) IBOutlet UIImageView *notificationIconImg;
@property (weak, nonatomic) IBOutlet UILabel *events_header_lbl;

@property (strong, nonatomic)NSMutableArray *usersArray;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)NSMutableDictionary *responseDict;
@property (strong, nonatomic)NSMutableArray *responseArray;
@property (weak, nonatomic) IBOutlet UIButton *create_EventBtn;

- (IBAction)createEventBtnPressed:(id)sender;

- (IBAction)toggleBtnPressed:(id)sender;

@end
