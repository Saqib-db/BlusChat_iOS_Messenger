//
//  HomeViewController.h
//  BlusApp
//
//  Created by Usman Ghani on 21/07/2014.
//  Copyright (c) 2014 Gexton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "CreateClientVC.h"

@interface HomeViewController : UIViewController <UIAlertViewDelegate> {
    
    POST *post;
    NSTimer *silenceTimer;
}

@property (nonatomic, retain) NSTimer *silenceTimer;
@property (weak, nonatomic) IBOutlet UILabel *contactLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)NSMutableArray *conversationArray;
@property (strong, nonatomic)NSString *user_to_id;
@property (strong, nonatomic)NSMutableArray *responseArray;
@property (strong, nonatomic)NSMutableDictionary *responseDict;
@property(nonatomic, readwrite)BOOL isFirstLogin;
- (IBAction)toggleBtnPressed:(id)sender;

@end
