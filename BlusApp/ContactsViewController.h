//
//  DashBoardVC.h
//  BlusApp
//
//  Created by Usman Ghani on 16/06/2014.
//  Copyright (c) 2014 Gexton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "Post.h"
#import "ChatVC.h"
#import "HomeViewController.h"

@interface ContactsViewController : UIViewController{
    
    POST *post;
   // BOOL isPushed_picture;
   
}

@property (strong, nonatomic) HomeViewController *homeVC;

@property (nonatomic, strong)NSMutableArray *selectedRowIndex;
@property (nonatomic)NSInteger selectedRow;

@property (weak, nonatomic) IBOutlet UIImageView *notificationIconImg;

@property (weak, nonatomic) NSMutableArray *msgsArray;

@property (weak, nonatomic) IBOutlet UILabel *contacts_header_lbl;

@property (nonatomic, strong)NSMutableArray *selectedUsersArray;

@property (weak, nonatomic) IBOutlet UIButton *toggle_btn;
@property (strong, nonatomic)NSString *isPushed;
@property (strong, nonatomic)NSString *isPushed_client;

@property (assign)BOOL is_galleryImg;

@property (strong, nonatomic)NSString *gallery_image;

@property (strong, nonatomic)NSString *login_status;
@property (strong, nonatomic)NSString *offline_status;
@property (strong, nonatomic)NSString *user_to_id;
@property (strong, nonatomic)NSMutableArray *agentArray;
@property (strong, nonatomic)NSMutableArray *dublicate_AgentArray;
@property (strong, nonatomic)NSMutableArray *clientArray;
@property (strong, nonatomic)NSMutableDictionary *responseDict;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *okBtn;
- (IBAction)okBtnPressed:(id)sender;

- (IBAction)createClientBtnPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *createClient_Btn;

- (IBAction)toggleBtnPressed:(id)sender;

-(BOOL)connectedToWiFi;



@end
