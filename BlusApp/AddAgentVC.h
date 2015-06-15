//
//  AddAgentVC.h
//  BlusApp
//
//  Created by Zeeshan Anwar on 9/9/14.
//  Copyright (c) 2014 Gexton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "MBProgressHUD.h"
#import "IphoneAsyncImageView.h"
#import "Singleton.h"


@interface AddAgentVC : UIViewController{
    
    POST *post;
}
@property (weak, nonatomic) NSMutableArray *msgsArray;
@property (weak, nonatomic) IBOutlet UIImageView *notificationIconImg;

@property (weak, nonatomic) IBOutlet UILabel *assign_agent_header_lbl;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;

@property (strong, nonatomic)NSMutableArray *selected_Agents_Array;

@property(strong, nonatomic)NSMutableDictionary *responseDict;
@property(strong, nonatomic)NSMutableArray *agentsArray;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)cancelBtnPressed:(id)sender;
- (IBAction)doneBtnPressed:(id)sender;

@end
