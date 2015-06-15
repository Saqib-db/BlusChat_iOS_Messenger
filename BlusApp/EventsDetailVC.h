//
//  EventsDetailVC.h
//  BlusApp
//
//  Created by Zeeshan Anwar on 8/24/14.
//  Copyright (c) 2014 Gexton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "HomeViewController.h"
#import "SideMenuVC.h"
#import "MFSideMenuContainerViewController.h"


@interface EventsDetailVC : UIViewController{
    
    POST *post;
}

@property (strong, nonatomic) HomeViewController *homeVC;
@property (weak, nonatomic) NSMutableArray *msgsArray;
@property (weak, nonatomic) IBOutlet UIImageView *notificationIconImg;
@property (weak, nonatomic) IBOutlet UITextView *eventDetailTextView;
@property (weak, nonatomic)NSString *userFrom;
@property (weak, nonatomic) IBOutlet UILabel *startEvent_Lbl;
@property (weak, nonatomic) IBOutlet UILabel *endEvent_Lbl;


@property (weak, nonatomic) IBOutlet UIButton *backBtn_lbl;
@property (weak, nonatomic) IBOutlet UIButton *inviteClient_Lbl;
@property (weak, nonatomic) IBOutlet UILabel *eventDetail_headerLbl;

@property (strong, nonatomic)NSString *event_id;
@property (strong, nonatomic)NSMutableDictionary *responseDict;
@property (strong, nonatomic)NSMutableArray *selected_usersArray_clients;
@property (strong, nonatomic)NSString *user_to_id_comma_seperated;

@property (nonatomic)NSInteger index;

@property (strong, nonatomic)NSMutableArray *usersArray;
@property (strong, nonatomic)NSMutableArray *dublicate_users_Array;


@property (weak, nonatomic) IBOutlet UILabel *eventCreated_Lbl;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic)NSString *event_title_str;
@property (weak, nonatomic) IBOutlet UILabel *event_title_Lbl;

@property (weak, nonatomic)NSString *event_detail_str;
@property (weak, nonatomic) IBOutlet UILabel *event_detail_Lbl;

@property (weak, nonatomic)NSString *start_date_str;
@property (weak, nonatomic) IBOutlet UILabel *startDate_Lbl;

@property (weak, nonatomic)NSString *start_time_str;
@property (weak, nonatomic) IBOutlet UILabel *startTime_Lbl;

@property (weak, nonatomic)NSString *end_date_str;
@property (weak, nonatomic) IBOutlet UILabel *endDate_Lbl;

@property (weak, nonatomic)NSString *end_time_str;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLbl;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)backBtnPressed:(id)sender;
- (IBAction)inviteClientBtnPressed:(id)sender;

@end
