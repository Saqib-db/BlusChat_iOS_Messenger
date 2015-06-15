//
//  ChatVC.m
//  BlusApp
//
//  Created by Faizan Shaikh on 7/7/14.
//  Copyright (c) 2014 Gexton. All rights reserved.
//

#import "ChatVC.h"
#import "IphoneAsyncImageView.h"
#import "AppDelegate.h"
#import "SWNinePatchImageFactory.h"
#import "ImgDetailViewController.h"
#import "IphoneImageDetailViewController.h"
#import "AsyncImageDownloader.h"
#import "MFSideMenu.h"
#import "MFSideMenuContainerViewController.h"
#import "GalleryViewController.h"
#import "GalleryViewController.h"

#define defaults [NSUserDefaults standardUserDefaults]
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )



@interface ChatVC ()<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
@property(strong, nonatomic) NSMutableArray *msgsDetailArray;
@property (strong, nonatomic)NSMutableArray *msgsDetailArray_new;
@property(strong, nonatomic) NSMutableArray *maxIDArray;
@property(strong, nonatomic) NSMutableDictionary *responseDict;
@end

#define KEYBOARD_VIEW_MOVE_HEIGHT 216

@implementation ChatVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    
        // Custom initialization
    
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
     if (IS_IPHONE_5) {
  
        [NSTimer scheduledTimerWithTimeInterval:6.0
                                     target:self
                                   selector:@selector(getNotifications)
                                   userInfo:nil
                                    repeats:YES];
    
     
        self.msgsDetailArray = [[NSMutableArray alloc] init];
        self.msgsDetailArray_new = [[NSMutableArray alloc]init];
    
        self.maxIDArray = [[NSMutableArray alloc] init];
    
        post = [[POST alloc]init];
        post.delegate = self;

        // Set the header title
        [self.User_to_label setText:self.user_to_string];
        
        
        //scroll to the bottom of a UITableView before the view appears
        [self.tableView setContentOffset:CGPointMake(0, CGFLOAT_MAX)];
        
        dbClass *db = [[dbClass alloc]init];
        
        self.msgsDetailArray = [db getMessage:self.user_to_id UserFrom:[defaults stringForKey:@"user_from_id"]];
         NSLog(@"msgDetail---> %@", self.msgsDetailArray);
         
         
            //////// FOR iPhone 4s ///////////
    
    }else{
        
   
        
        [NSTimer scheduledTimerWithTimeInterval:6.0
                                         target:self
                                       selector:@selector(getNotifications)
                                       userInfo:nil
                                        repeats:YES];
        
        
        self.msgsDetailArray = [[NSMutableArray alloc] init];
        
        self.msgsDetailArray_new = [[NSMutableArray alloc]init];
        
        self.maxIDArray = [[NSMutableArray alloc] init];
            
        
        post = [[POST alloc]init];
        
        post.delegate = self;
            
        
        // Set the header title
        
        [self.User_to_label setText:self.user_to_string];
        
        dbClass *db = [[dbClass alloc]init];
        
        self.msgsDetailArray = [db getMessage:self.user_to_id UserFrom:[defaults stringForKey:@"user_from_id"]];
        
       // NSLog(@"msgsDetailArray--> %@", self.msgsDetailArray);
            
        self.tableView.frame = CGRectMake(0.0, 60.0, 320.0, 373.0);
        
        self.ViewForTextView.frame = CGRectMake(0.0, 435, 320.0, 44.0);
        
        //scroll to the bottom of a UITableView before the view appears
        [self.tableView setContentOffset:CGPointMake(0, CGFLOAT_MAX)];
  
   }
   
}


-(void)viewWillAppear:(BOOL)animated{

     dbClass *db = [[dbClass alloc]init];
    
     [db update_isRead:[defaults stringForKey:@"user_from_id"]];
    
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    // if cancel to send blus gallery image
    
   
    if([defaults stringForKey:@"YES"]){
        
        [defaults removeObjectForKey:@"YES"];
        
        self.photoBtn.enabled = YES;
    }
    
    
    
//    NSLog(@"doctdir_gallery--> %@", self.DocDir_galleryImg);
//    NSLog(@"self.isGalleryimag--> %hhd", self.is_galleryImg);
    
   // if (self.DocDir_galleryImg !=nil) {

     if (self.is_galleryImg || self.DocDir_galleryImg) {
       
         MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
         hud.mode = MBProgressHUDModeIndeterminate;
         
         hud.labelText = @"Sending..";
         [hud hide:YES afterDelay:4.0];
         dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
             // MY CODE BEGIN //
    
         
         [db insertMessages:self.user_to_id :[defaults stringForKey:@"user_from_id"] :self.DocDir_galleryImg :@"" :@"0" :@"0" :@"1" :@"0"];

//         [db update_isRead:[defaults stringForKey:@"user_from_id"]];
        
         self.maxIDArray = [db getMaxID];
         //NSLog(@"MAx_ID--> %@", [[self.maxIDArray objectAtIndex:0]objectForKey:@"id"]);
        
         NSData *data = [NSData dataWithContentsOfFile:self.DocDir_galleryImg];
        
            
         [post uploadMsgImg:self.user_to_id :[defaults stringForKey:@"user_from_id"] :[[self.maxIDArray objectAtIndex:0]objectForKey:@"id"] :@"img" :data];
        
        // After uploding the image , saving nil in it cuz when it will come in viewWillAppear then dont want to call uploadMsgImg
        
         self.DocDir_galleryImg = nil;
        
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 
             });
         });

        
    }else{
        
       //self.photoBtn.enabled = YES;
    }
    

}



-(void)getNotifications{
    
    
    dbClass *db = [[dbClass alloc]init];
    
    NSMutableArray *newMsgsDetailArray = [db getMessage:self.user_to_id UserFrom:[defaults stringForKey:@"user_from_id"]];
    
    if ([newMsgsDetailArray count] > [self.msgsDetailArray count]) {
        
        self.msgsDetailArray = newMsgsDetailArray;
        
       // NSLog(@"Self.MsgsDetailArray-----> %@", self.msgsDetailArray);
       
        [self.tableView reloadData];
        
        
        //scroll the table view to the bottom
        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:([self.msgsDetailArray count] -1) inSection:0];
        
        [[self tableView] scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
    }
 
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-
#pragma tableview delegates


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ImgDetailViewController *imgDetail = [[ImgDetailViewController alloc]initWithNibName:@"ImgDetailViewController" bundle:nil];
    
    NSString *msg_str = [[self.msgsDetailArray objectAtIndex:indexPath.row]objectForKey:@"msg"];
    
    NSLog(@"msg_str--> %@", msg_str);
    
    
    if ([msg_str rangeOfString:@"Documents"].location == NSNotFound) {
        
        if ([msg_str rangeOfString:@".jpg"].location == NSNotFound) {
      
             if ([msg_str rangeOfString:@".png"].location == NSNotFound) {
                 
                 // if its text then don't do anything
                 NSLog(@"HelloWorld");
           
             }else{
                 // if path containts .png
                 dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                   
                     
                     if ([msg_str rangeOfString:@"http"].location == NSNotFound) {
                         // it doesn't contain URL
                         self.img  = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.blusserver.com/bluschat/assets/msg-img/%@", msg_str]]]];
                         
                     }else{
                            // it contains URL
                        self.img =  [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:msg_str]]];
                     }
                     
                                       
                     
                     NSLog(@"IMG==> %@", self.img);
                     
                     dispatch_async(dispatch_get_main_queue(), ^{
                         
                         imgDetail.img = self.img;
                         [self.navigationController pushViewController:imgDetail animated:YES];
                         [self.msgTxtview resignFirstResponder];
                         
                         
                     });
                 });

             }
       
        }else{
            
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                
                
                UIImage *img1 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.blusserver.com/bluschat/assets/msg-img/%@", msg_str]]]];
                
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    imgDetail.img = img1;
                    [self.navigationController pushViewController:imgDetail animated:YES];
                    [self.msgTxtview resignFirstResponder];
                    
                    
                });
            });
        }
        
    }else{
        
        // if th image is coming from database
    
        UIImage *img2 = [UIImage imageWithContentsOfFile:msg_str];
   
        NSLog(@"img2--> %@", img2);
        
        if (img2 !=nil) {
            
            imgDetail.img = img2;
            
            [self.navigationController pushViewController:imgDetail animated:YES];
            
            [self.msgTxtview resignFirstResponder];
            
        }
    }
}

- (NSString *)applicationDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

-(BOOL)tableView:(UITableView*)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath*)indexPath{
    
    return YES;

}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
  
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    NSString *userID = [[self.msgsDetailArray objectAtIndex:indexPath.row]objectForKey:@"from_id"];

    NSString *imgUrl = [[self.msgsDetailArray objectAtIndex:indexPath.row]objectForKey:@"from_img_link"];
   
    // NSLog(@"img_url----> %@", imgUrl);
    // If Message is from the user who is online comes in this body and showed it on right otherwise goes in else.
    
  
    if ([userID isEqualToString:[defaults stringForKey:@"user_from_id"]] || userID == nil) {
    
        if ([imgUrl isEqual:[NSNull null]] || [imgUrl isEqualToString:@""])
        {
            
            IphoneAsyncImageView *participantImg = [[IphoneAsyncImageView alloc] initWithFrame:CGRectMake(12.0f, 15.0f, 47.0f, 47.0f)];
            participantImg.cv_width = 47.0f;
            participantImg.cv_height = 47.0f;
            participantImg.backgroundColor = [UIColor clearColor];
            [participantImg loadImageFromURL:[NSURL URLWithString:[defaults stringForKey:@"adminImg"]]];
            [cell.contentView addSubview:participantImg];
            
            
        }else{
        
               // NSString *img_link = [defaults stringForKey:@"img_link"];
                IphoneAsyncImageView *participantImg = [[IphoneAsyncImageView alloc] initWithFrame:CGRectMake(270.0f, 5.0f, 47.0f, 47.0f)];
                participantImg.cv_width = 47.0f;
                participantImg.cv_height = 47.0f;
                participantImg.backgroundColor = [UIColor clearColor];
                [participantImg loadImageFromURL:[NSURL URLWithString:imgUrl]];
                [cell.contentView addSubview:participantImg];
        }
        
      NSString *is_image = [[self.msgsDetailArray objectAtIndex:indexPath.row]objectForKey:@"is_image"];
//        NSString *is_image = [[self.msgsDetailArray objectAtIndex:indexPath.row]objectForKey:@"msg"];
        NSLog(@"is_image--> %@", is_image);
        
        
        if ([is_image isEqualToString:@"1"] )
//        if ([[is_image pathExtension]isEqualToString:@"png"]|| [[is_image pathExtension]isEqualToString:@"jpg"] )
        {
            
            UIImageView *whitePicBg = [[UIImageView alloc]initWithFrame:CGRectMake(90.0 ,3.0 ,180,166)];
            UIImage* resizableImage = [SWNinePatchImageFactory createResizableNinePatchImageNamed:@"bubble_green.9"];
            [whitePicBg setImage:resizableImage];
            [cell.contentView addSubview:whitePicBg];
                
                imgPathStr = [[self.msgsDetailArray objectAtIndex:indexPath.row]objectForKey:@"msg"];
                if ([imgPathStr rangeOfString:@"http://"].location == NSNotFound)
                {
                   
                    //local image
                    UIImageView *picImgView = [[UIImageView alloc]initWithFrame:CGRectMake(100.0, 10.0, 150.0, 150.0)];
                     IphoneAsyncImageView *participantImg = [[IphoneAsyncImageView alloc] initWithFrame:CGRectMake(100.0f, 10.0f, 150.0f, 150.0f)];
            
                    NSLog(@"imgPath--->%@", imgPathStr);
                    
                    if ([imgPathStr rangeOfString:@"Documents"].location == NSNotFound) {
                      
                        // NSLog(@"string does not contain Documents");
                      
                        participantImg.cv_width = 150.0f;
                        participantImg.cv_height = 150.0f;
                        participantImg.backgroundColor = [UIColor clearColor];
                        [participantImg loadImageFromURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.blusserver.com/bluschat/assets/msg-img/%@", imgPathStr]]];
                        [cell.contentView addSubview:participantImg];
                        
                    } else {
                        
                       // NSLog(@"string contains Documents!");
                      
                        picImgView.contentMode = UIViewContentModeScaleAspectFit;
                        //NSLog(@"picImgView--> %@", imgPathStr);
                        
                        picImgView.image =  [UIImage imageWithContentsOfFile:imgPathStr];
                        
                        [cell.contentView addSubview:picImgView];
                    }
//                    
//                    //local image
//                    UIImageView *picImgView = [[UIImageView alloc]initWithFrame:CGRectMake(100.0, 10.0, 150.0, 150.0)];
//                    
//                    picImgView.contentMode = UIViewContentModeScaleAspectFit;
//                    
//                    picImgView.image =  [UIImage imageWithContentsOfFile:imgPathStr];
//                    
//                    
//                    UIImageView *whitePicBg = [[UIImageView alloc]initWithFrame:CGRectMake(90.0 ,3.0 ,180,166)];
//                    
//                    UIImage* resizableImage = [SWNinePatchImageFactory createResizableNinePatchImageNamed:@"bubble_green.9"];
//                    
//                    [whitePicBg setImage:resizableImage];
//                    
//                    [cell.contentView addSubview:whitePicBg];
//                    
//                    [cell.contentView addSubview:picImgView];

                    
                    
                    NSString *dateTimeStr = [[self.msgsDetailArray objectAtIndex:indexPath.row]objectForKey:@"date_time"];
                    UILabel *dateTimeLabel = [[UILabel alloc]init];
                    [dateTimeLabel setText:dateTimeStr];
                    
                    dateTimeLabel.frame = CGRectMake(140,160 ,200, 30);
                    
                    dateTimeLabel.font = [UIFont fontWithName:@"Lato-Regular" size:12];
                    
                    [cell.contentView addSubview:dateTimeLabel];
          
                } else {
                   
                    //remote image
                    
                    IphoneAsyncImageView *participantImg = [[IphoneAsyncImageView alloc] initWithFrame:CGRectMake(170.0f, 10.0f, 200.0f, 100.0f)];
                    participantImg.cv_width = 200.0f;
                    participantImg.cv_height = 100.0f;
                    participantImg.backgroundColor = [UIColor clearColor];
                    [participantImg loadImageFromURL:[NSURL URLWithString:imgPathStr]];
                    [cell.contentView addSubview:participantImg];
                    
                }
                
            }
        
            else
                
            {
            
                NSString *msgStr = [[self.msgsDetailArray objectAtIndex:indexPath.row]objectForKey:@"msg"];
                UILabel *msgLbl = [[UILabel alloc]init];
                [msgLbl setText:msgStr];
                msgLbl.font = [UIFont fontWithName:@"Lato-Regular" size:14];
                msgLbl.numberOfLines = 10;
                msgLbl.backgroundColor = [UIColor clearColor];
                
              
                if ([msgLbl.text rangeOfString:@"http://"].location !=NSNotFound  || [msgLbl.text rangeOfString:@"www"].location !=NSNotFound  ){
                    
                   // NSLog(@"its a video link");
                    
                    UIButton *msg_link_btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    msg_link_btn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
                    [msg_link_btn setTitle:msgLbl.text forState:UIControlStateNormal];
                    [msg_link_btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                    msg_link_btn.titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:13];
                    
                    [msg_link_btn addTarget:self action:@selector(msgLinkBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
                    msg_link_btn.tag = indexPath.row;
                    
                    CGSize maximumSize = CGSizeMake(240, 180);
                    
                    CGSize maximum_size = CGSizeMake(240, 180.0);
                    
                    CGSize myString_size = [[[self.msgsDetailArray objectAtIndex:indexPath.row]objectForKey:@"msg"]
                                            sizeWithFont:msgLbl.font
                                            constrainedToSize:maximum_size
                                            lineBreakMode:NSLineBreakByWordWrapping];
                    
                    CGSize myStringSize = [[[self.msgsDetailArray objectAtIndex:indexPath.row]objectForKey:@"msg"]
                                           sizeWithFont:msgLbl.font
                                           constrainedToSize:maximumSize
                                           lineBreakMode:NSLineBreakByWordWrapping];
                    
                    
                    UIImageView *whiteTxtBg = [[UIImageView alloc]initWithFrame:CGRectMake(240 - myString_size.width ,10.0 ,myString_size.width+30, myString_size.height+20)];
                    
                    UIImage* resizableImage = [SWNinePatchImageFactory createResizableNinePatchImageNamed:@"bubble_green.9"];
                    [whiteTxtBg setImage:resizableImage];
                    
                    [cell.contentView addSubview:whiteTxtBg];
                    
                    
                    msg_link_btn.frame = CGRectMake(250 - myStringSize.width ,17.0 ,myStringSize.width, myStringSize.height);
                    
                    [cell.contentView addSubview:msg_link_btn];
                    
                    // DATE & TIME
                    NSString *dateTimeStr = [[self.msgsDetailArray objectAtIndex:indexPath.row]objectForKey:@"date_time"];
                    UILabel *dateTimeLabel = [[UILabel alloc]init];
                    dateTimeLabel.backgroundColor = [UIColor clearColor];
                    [dateTimeLabel setText:dateTimeStr];
                    
                    
                    CGSize dateMaxSize = CGSizeMake(240, 80);
                    CGSize myDateStrSize = [[[self.msgsDetailArray objectAtIndex:indexPath.row]objectForKey:@"date_time"]
                                            sizeWithFont:msgLbl.font
                                            constrainedToSize:dateMaxSize
                                            lineBreakMode:NSLineBreakByWordWrapping];
                    
                    dateTimeLabel.frame = CGRectMake(275 - myDateStrSize.width ,myStringSize.height +30 ,myDateStrSize.width, myDateStrSize.height);
                    
                    dateTimeLabel.font = [UIFont fontWithName:@"Lato-Regular" size:12];
                    
                    
                    
                    [cell.contentView addSubview:dateTimeLabel];

                
                
            }else{
            
                    CGSize maximumSize = CGSizeMake(240, 380); //180
                    
                    CGSize maximum_size = CGSizeMake(240, 380.0); //180
                    
                    CGSize myString_size = [[[self.msgsDetailArray objectAtIndex:indexPath.row]objectForKey:@"msg"]
                                          sizeWithFont:msgLbl.font
                                          constrainedToSize:maximum_size
                                          lineBreakMode:NSLineBreakByWordWrapping];
                    
                    CGSize myStringSize = [[[self.msgsDetailArray objectAtIndex:indexPath.row]objectForKey:@"msg"]
                                           sizeWithFont:msgLbl.font
                                           constrainedToSize:maximumSize
                                           lineBreakMode:NSLineBreakByWordWrapping];
                    
                    
                    UIImageView *whiteTxtBg = [[UIImageView alloc]initWithFrame:CGRectMake(240 - myString_size.width ,8.0 ,myString_size.width+30, myString_size.height+17)];
                    
                    UIImage* resizableImage = [SWNinePatchImageFactory createResizableNinePatchImageNamed:@"bubble_green.9"];
                    [whiteTxtBg setImage:resizableImage];
                    
                    [cell.contentView addSubview:whiteTxtBg];

                    
                    msgLbl.frame = CGRectMake(250 - myStringSize.width ,16.0 ,myStringSize.width, myStringSize.height);
                    
                    [cell.contentView addSubview:msgLbl];

                    NSString *dateTimeStr = [[self.msgsDetailArray objectAtIndex:indexPath.row]objectForKey:@"date_time"];
                    UILabel *dateTimeLabel = [[UILabel alloc]init];
                    dateTimeLabel.backgroundColor = [UIColor clearColor];
                    [dateTimeLabel setText:dateTimeStr];
                    
                    CGSize dateMaxSize = CGSizeMake(240, 70);
                    
                    CGSize myDateStrSize = [[[self.msgsDetailArray objectAtIndex:indexPath.row]objectForKey:@"date_time"]
                                            sizeWithFont:msgLbl.font
                                            constrainedToSize:dateMaxSize
                                            lineBreakMode:NSLineBreakByWordWrapping];
                    
                    dateTimeLabel.frame = CGRectMake(280 - myDateStrSize.width ,myStringSize.height +26 ,myDateStrSize.width, myDateStrSize.height);
                    
                    dateTimeLabel.font = [UIFont fontWithName:@"Lato-Regular" size:11];
                
                
                    [cell.contentView addSubview:dateTimeLabel];
                    
                }
           
            }
        
       
        return cell;
        
        
                ///////////// if the msg from the user to whom you talk////////////////////
        
    }else{
        
        // if imgURL(display pic) not available
        
        if ([imgUrl isEqual:[NSNull null]] || [imgUrl isEqualToString:@""]) {
            
           /* UIImage *profileImg = [UIImage imageNamed:@"test_dp.png"];
            UIImageView *profileImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10.0, 5.0, 35.0, 45.0)];
            [profileImgView setImage:profileImg];
            [cell.contentView addSubview:profileImgView];*/
            
            IphoneAsyncImageView *participantImg = [[IphoneAsyncImageView alloc] initWithFrame:CGRectMake(12.0f, 15.0f, 47.0f, 47.0f)];
            participantImg.cv_width = 47.0f;
            participantImg.cv_height = 47.0f;
            participantImg.backgroundColor = [UIColor clearColor];
            [participantImg loadImageFromURL:[NSURL URLWithString:[defaults stringForKey:@"adminImg"]]];
            [cell.contentView addSubview:participantImg];
            
        }else{
            
            IphoneAsyncImageView *participantImg = [[IphoneAsyncImageView alloc] initWithFrame:CGRectMake(10.0f, 5.0f, 47.0f, 47.0f)];
            participantImg.cv_width = 47.0f;
            participantImg.cv_height = 47.0f;
            participantImg.backgroundColor = [UIColor clearColor];
//         [participantImg loadImageFromURL:[NSURL URLWithString:[[self.msgsDetailArray objectAtIndex:indexPath.row]objectForKey:@"from_img_link"]]];
            [participantImg loadImageFromURL:[NSURL URLWithString:imgUrl]];
            [cell.contentView addSubview:participantImg];
        }
        
        //NSString *is_image = [NSString stringWithFormat:@"%@",[[self.msgsDetailArray objectAtIndex:indexPath.row]objectForKey:@"is_image"]];
                              
        
        NSString *is_image = [[self.msgsDetailArray objectAtIndex:indexPath.row]objectForKey:@"is_image"];
        
        NSLog(@"is_image--> %@", is_image);
        
        
        
        if ([is_image isEqualToString:@"1"])
        {
            
            imgPathStr = [[self.msgsDetailArray objectAtIndex:indexPath.row]objectForKey:@"msg"];
            
            NSLog(@"imgPathStr--> %@", imgPathStr);
            
            if ([imgPathStr rangeOfString:@"http://"].location == NSNotFound) {
                
                //local image
          
                UIImageView *whitePicBg = [[UIImageView alloc]initWithFrame:CGRectMake(50.0 ,3.0 ,180,170)];
            
                UIImage* resizableImage = [SWNinePatchImageFactory createResizableNinePatchImageNamed:@"bubble_yellow.9"];
                [whitePicBg setImage:resizableImage];
                
                [cell.contentView addSubview:whitePicBg];
                
                UIImageView *participan_img = [[UIImageView alloc]initWithFrame:CGRectMake(70.0f, 12.0f, 150.0f, 150.0f)];
                
                NSString *image_path_str = [[self.msgsDetailArray objectAtIndex:indexPath.row]objectForKey:@"msg"];
    
                NSLog(@"imagPath_str--> %@", image_path_str);
                
                if ([image_path_str rangeOfString:@"Documents"].location == NSNotFound) {
                    
                    // NSLog(@"string does not contain coreSimulator");
                    IphoneAsyncImageView *participantImg = [[IphoneAsyncImageView alloc] initWithFrame:
                                                            CGRectMake(69.0f, 12.0f, 150.0f, 150.0f)]; //
                    participantImg.cv_width = 150.0f;
                    participantImg.cv_height = 150.0f;
                    participantImg.backgroundColor = [UIColor clearColor];
                    [participantImg loadImageFromURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.blusserver.com/bluschat/assets/msg-img/%@", image_path_str]]];
                    [cell.contentView addSubview:participantImg];
                    
                } else {
                    
                    // NSLog(@"string contains coreSimulator!");
                    
                    self.path_img = [UIImage imageWithContentsOfFile:image_path_str];
                    [participan_img setImage:self.path_img];
                    participan_img.contentMode = UIViewContentModeScaleAspectFit;
                    
                    [cell.contentView addSubview:participan_img];
                    
                }
                
                NSString *dateTimeStr = [[self.msgsDetailArray objectAtIndex:indexPath.row]objectForKey:@
                                         "date_time"];
                UILabel *dateTimeLabel = [[UILabel alloc]init];
                [dateTimeLabel setText:dateTimeStr];
                dateTimeLabel.frame = CGRectMake(70,165 ,200, 30);
                dateTimeLabel.font = [UIFont fontWithName:@"Lato-Regular" size:12];
                dateTimeLabel.textColor = [UIColor blackColor];
                [cell.contentView addSubview:dateTimeLabel];
                
       
            } else {
                
                //remote image
                
               // UIImageView *whitePicBg = [[UIImageView alloc]initWithFrame:CGRectMake(50.0 ,3.0 ,260,210)];
                 UIImageView *whitePicBg = [[UIImageView alloc]initWithFrame:CGRectMake(50.0 ,3.0 ,180.0,180.0)];
                UIImage* resizableImage = [SWNinePatchImageFactory createResizableNinePatchImageNamed:@"bubble_yellow.9"];
                [whitePicBg setImage:resizableImage];
                
                [cell.contentView addSubview:whitePicBg];
                
                IphoneAsyncImageView *participantImg = [[IphoneAsyncImageView alloc] initWithFrame:
                                                        CGRectMake(69.0f, 12.0f, 150.0f, 150.0f)]; //CGRectMake(69.0f, 12.0f, 232.0f, 190.0f)]
                participantImg.cv_width = 150.0f;
                participantImg.cv_height = 150.0f;
                participantImg.backgroundColor = [UIColor clearColor];
                [participantImg loadImageFromURL:[NSURL URLWithString:imgPathStr]];
                [cell.contentView addSubview:participantImg];
                
              UIButton *downloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                
                if(downloadBtn.hidden == YES){
                    
                    
                }else{
                    
                    // CUSTOM UIBUTTON PRGOGRAMMATICALLY
                  
                    [downloadBtn addTarget:self action:@selector(downloadBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
                    downloadBtn.frame = CGRectMake(120.0, 60.0, 50.0, 50.0);
                    UIImage * buttonImage = [UIImage imageNamed:@"download_action.png"];
                    [downloadBtn setBackgroundImage:buttonImage forState:UIControlStateNormal];
                    downloadBtn.tag = indexPath.row;
                    
                    [cell.contentView addSubview:downloadBtn];
                }

                
            }
            
        }else{
        
            NSString *msgStr = [[self.msgsDetailArray objectAtIndex:indexPath.row]objectForKey:@"msg"];
            UILabel *msgLbl = [[UILabel alloc]init];
            [msgLbl setText:msgStr];
            msgLbl.font = [UIFont fontWithName:@"Lato-Regular" size:14];
            msgLbl.numberOfLines = 10;
            msgLbl.backgroundColor = [UIColor clearColor];
            
            if ([msgLbl.text rangeOfString:@"http://"].location !=NSNotFound  || [msgLbl.text rangeOfString:@"www"].location !=NSNotFound  ){
                
                //   NSLog(@"its a video link");
                
                UIButton *msg_link_btn = [UIButton buttonWithType:UIButtonTypeCustom];
                msg_link_btn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
                [msg_link_btn setTitle:msgLbl.text forState:UIControlStateNormal];
                [msg_link_btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                msg_link_btn.titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:13];
                
                [msg_link_btn addTarget:self action:@selector(msgLinkBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
                msg_link_btn.tag = indexPath.row;
                
                CGSize maximumSize = CGSizeMake(240, 180);
                
                CGSize myStringSize = [[[self.msgsDetailArray objectAtIndex:indexPath.row]objectForKey:@"msg"]
                                       sizeWithFont:msgLbl.font
                                       constrainedToSize:maximumSize
                                       lineBreakMode:NSLineBreakByWordWrapping];
                
                
                CGSize maximum_size = CGSizeMake(240, 180.0);
                
                CGSize myString_size = [[[self.msgsDetailArray objectAtIndex:indexPath.row]objectForKey:@"msg"]
                                        sizeWithFont:msgLbl.font
                                        constrainedToSize:maximum_size
                                        lineBreakMode:NSLineBreakByWordWrapping];
                
                UIImageView *whiteTxtBg = [[UIImageView alloc]initWithFrame:CGRectMake(45 ,10.0 ,myString_size.width+30, myString_size.height+10)];
                
                UIImage* resizableImage = [SWNinePatchImageFactory createResizableNinePatchImageNamed:@"bubble_yellow.9"];
                [whiteTxtBg setImage:resizableImage];
                
                [cell.contentView addSubview:whiteTxtBg];
                
                msg_link_btn.frame = CGRectMake(70 ,20.0 ,myString_size.width, myString_size.height);
                
                [cell.contentView addSubview:msg_link_btn];
                
                
                NSString *dateTimeStr = [[self.msgsDetailArray objectAtIndex:indexPath.row]objectForKey:@"date_time"];
                UILabel *dateTimeLabel = [[UILabel alloc]init];
                [dateTimeLabel setText:dateTimeStr];
                
                CGSize dateMaxSize = CGSizeMake(260, 80);
                
                CGSize myDateStrSize = [[[self.msgsDetailArray objectAtIndex:indexPath.row]objectForKey:@"date_time"]
                                        sizeWithFont:msgLbl.font
                                        constrainedToSize:dateMaxSize
                                        lineBreakMode:NSLineBreakByWordWrapping];
                
                dateTimeLabel.frame = CGRectMake(65,myStringSize.height +30 ,myDateStrSize.width, myDateStrSize.height);
                
                dateTimeLabel.font = [UIFont systemFontOfSize:12.0];
                
                [cell.contentView addSubview:dateTimeLabel];
                
                
            }else{
                
                
                CGSize maximumSize = CGSizeMake(240, 380); //80
                
                CGSize myStringSize = [[[self.msgsDetailArray objectAtIndex:indexPath.row]objectForKey:@"msg"]
                                       sizeWithFont:msgLbl.font
                                       constrainedToSize:maximumSize
                                       lineBreakMode:NSLineBreakByWordWrapping];
                
                
                CGSize maximum_size = CGSizeMake(240, 380.0); //70
                
                CGSize myString_size = [[[self.msgsDetailArray objectAtIndex:indexPath.row]objectForKey:@"msg"]
                                        sizeWithFont:msgLbl.font
                                        constrainedToSize:maximum_size
                                        lineBreakMode:NSLineBreakByWordWrapping];
                
                UIImageView *whiteTxtBg = [[UIImageView alloc]initWithFrame:CGRectMake(50 ,10.0 ,myString_size.width+30, myString_size.height+20)];
                
                UIImage* resizableImage = [SWNinePatchImageFactory createResizableNinePatchImageNamed:@"bubble_yellow.9"];
                [whiteTxtBg setImage:resizableImage];
                
                [cell.contentView addSubview:whiteTxtBg];
                
                msgLbl.frame = CGRectMake(68 ,18.0 ,myString_size.width, myString_size.height);
                [cell.contentView addSubview:msgLbl];
                
                
                NSString *dateTimeStr = [[self.msgsDetailArray objectAtIndex:indexPath.row]objectForKey:@"date_time"];
                UILabel *dateTimeLabel = [[UILabel alloc]init];
                [dateTimeLabel setText:dateTimeStr];
                
                CGSize dateMaxSize = CGSizeMake(260, 80);
                
                CGSize myDateStrSize = [[[self.msgsDetailArray objectAtIndex:indexPath.row]objectForKey:@"date_time"]
                                        sizeWithFont:msgLbl.font
                                        constrainedToSize:dateMaxSize
                                        lineBreakMode:NSLineBreakByWordWrapping];
                
                dateTimeLabel.frame = CGRectMake(65,myStringSize.height +27 ,myDateStrSize.width, myDateStrSize.height);
                
                dateTimeLabel.font = [UIFont systemFontOfSize:11.0];
                
                [cell.contentView addSubview:dateTimeLabel];
                
            }
        }

    
        return cell;
    
    }
    
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        
//        NSLog(@"index--> %lu", (long)indexPath.row);
//        
//        NSLog(@"id--> %@", [[self.msgsDetailArray objectAtIndex:indexPath.row]objectForKey:@"id"]);
        
        
        [[self.msgsDetailArray mutableCopy] removeObjectAtIndex:indexPath.row];
        
     //   [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"Deleting...";
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            
          
            NSString *lastId = [[self.msgsDetailArray objectAtIndex:indexPath.row]objectForKey:@"id"];
            NSString *serverMsgId = [[self.msgsDetailArray objectAtIndex:indexPath.row]objectForKey:@"server_msg_id"];
           
            NSString *server_msg_id_lastId = [NSString stringWithFormat:@"%@%@%@", serverMsgId,@"_", lastId];
            
            NSLog(@"servermsgid--> %@", server_msg_id_lastId);
            
            [post delMsgs:server_msg_id_lastId];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                
            });
        });
        
        
        
        
    }
    
    // [self.tableView reloadData];
    
    // }
    
}



-(void)msgLinkBtnPressed:(id)sender{
    
    UIButton *btn = (UIButton*)sender;
    
    //Hide the download icon of the particualar row
    btn.hidden = YES;
    
    NSString *url_str =  [[self.msgsDetailArray objectAtIndex:btn.tag]objectForKey:@"msg"];
    
    if ([url_str rangeOfString:@"http://"].location != NSNotFound) {
        
         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url_str]];
    }else{
        
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@", url_str]]];
    }
    
   
}
        
-(void)downloadBtnPressed:(id)sender{
    
    
    UIButton *btn = (UIButton*)sender;
    
    //Hide the download icon of the particualar row
    btn.hidden = YES;
   
    // row id of the particualar row of the table
    self.row_id = [[self.msgsDetailArray objectAtIndex:btn.tag]objectForKey:@"id"];

    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
 
    hud.mode = MBProgressHUDModeIndeterminate;
    
    hud.labelText = @"Downloading..";
 
    // [hud hide:YES afterDelay:.0];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        // MY CODE BEGIN //
    
        NSString *img_url_str = [[self.msgsDetailArray objectAtIndex:btn.tag]objectForKey:@"msg"];
       
        NSLog(@"imgStr--> %@", img_url_str);
        
        if ([img_url_str rangeOfString:@"http://"].location == NSNotFound) {
            
            self.img = [UIImage imageWithContentsOfFile:img_url_str];
            
        }else{
            
            // set the url in UIImage
            
            img_url_str = [img_url_str stringByTrimmingCharactersInSet:
                           [NSCharacterSet whitespaceCharacterSet]];
            
           self.img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:img_url_str]]];
            
        }

    // Save the image in document directory by calling this method.
     [self saveImage:self.img];
        
        // MY CODE ENDS //
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
         [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        });
    });
    
}


- (void)saveImage: (UIImage*)image
{
  
    if (image != nil)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSString * timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000];
        
        pngPath = [NSString stringWithFormat:@"%@/%@test.png",documentsDirectory,timestamp];
        
        NSData *data = [NSData dataWithData:UIImageJPEGRepresentation(image, 1.0f)];//1.0f = 100% quality
       
        [data writeToFile:pngPath atomically:YES];
        
        NSLog(@"Path---> %@", pngPath);
        
        dbClass *db = [[dbClass alloc]init];
        
        //self.maxIDArray = [db getMaxID];
        

            [db updatePicturepath:pngPath :self.row_id];
        
//        [db updatePicturepath:pngPath :[[self.maxIDArray objectAtIndex:0]objectForKey:@"id"]];
        
        self.msgsDetailArray = [db getMessage:self.user_to_id UserFrom:[defaults stringForKey:@"user_from_id"]];
        
      //  [self.tableView reloadData];
        
        //NSLog(@"msgsDetail---> %@", self.msgsDetailArray);
        
    }
    
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.msgsDetailArray count];
}




-(int)calculateCellHeightWithString:(NSString*)text
{
    CGSize myStringSize = [text sizeWithFont:[UIFont fontWithName:@"Lato-Regular" size:13]
                           constrainedToSize:CGSizeMake(258, 1000)
                               lineBreakMode:NSLineBreakByCharWrapping];
    
    
//    CGSize myStringSize = [text sizeWithFont:[UIFont systemFontOfSize:13]
//                             constrainedToSize:CGSizeMake(258, 1000)  // - 40 For cell padding
//                                 lineBreakMode:NSLineBreakByWordWrapping];
    
    
    return  myStringSize.height +70;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    // imgPathDocDir is a doc dir path
    
    NSString *imgPathDocDir = [[self.msgsDetailArray objectAtIndex:indexPath.row]objectForKey:@"msg"];
    
  //  NSLog(@"imgPathDocDir---> %@", imgPathDocDir);
    
        if ([[imgPathDocDir pathExtension] isEqualToString:@"jpeg"] ||[[imgPathDocDir pathExtension] isEqualToString:@"jpg"]||[[imgPathDocDir pathExtension] isEqualToString:@"png"])
        {
            
            NSString *is_image = [[self.msgsDetailArray objectAtIndex:indexPath.row]objectForKey:@"is_image"];
            
            if ([is_image isEqualToString:@"1"]) {
                
                return 220.0;
                
            } else {
                
                return [self calculateCellHeightWithString:[[self.msgsDetailArray objectAtIndex:indexPath.row]objectForKey:@"msg"]];
            }
            
            
        }else
        {
            
            NSString *is_image = [[self.msgsDetailArray objectAtIndex:indexPath.row]objectForKey:@"is_image"];
            
            if ([is_image isEqualToString:@"1"]) {
                
                return 200.0;
                
            } else {
                
                return [self calculateCellHeightWithString:[[self.msgsDetailArray objectAtIndex:indexPath.row]objectForKey:@"msg"]];
            }
            
        }
    
}


- (void) addToTableView:(NSMutableDictionary*)dict
{
    
    if([self.msgsDetailArray count]>0){
        
        // Adding dict to array
        [self.msgsDetailArray addObject:dict];

        [self.tableView reloadData];
        
        
        //scroll the table view to the bottom
        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:([self.msgsDetailArray count] -1) inSection:0];
        [[self tableView] scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
    } else {
        
        [dict setValue:[dict objectForKey:@"msg"] forKeyPath:@"msg"];
        
        [self.msgsDetailArray addObject:dict];

    
        [self.tableView reloadData];
    }
    
    self.msgTxtview.text = @"";
    
}




- (IBAction)sendMsgBtnPressed:(id)sender {

    if([self.msgTxtview.text length] >=1){
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        [dict setObject:self.msgTxtview.text forKey:@"msg"];
        
        [self addToTableView:dict];
        
        dbClass *db = [[dbClass alloc]init];
        
        
        [db insertMessages:self.user_to_id :[defaults stringForKey:@"user_from_id"] :[dict objectForKey:@"msg"]:@"0" :@"0" :@"0" :@"0" :@"0"];
   
        
        [db update_isRead:[defaults stringForKey:@"user_from_id"]];
        
        self.maxIDArray = [db getMaxID];
        
        
       //CALL THE WEBSERVICE HERE.
        
        if ([self.user_to_id isEqualToString:@"0"]) {
            
             [post sendMessages:@"admin" UserID_from:[defaults stringForKey:@"user_from_id"]  Message:[dict objectForKey:@"msg"] database_lastID:[[self.maxIDArray objectAtIndex:0]objectForKey:@"id"] Status:@"msg"];
            
        }else{
        
            [post sendMessages:self.user_to_id UserID_from:[defaults stringForKey:@"user_from_id"]  Message:[dict objectForKey:@"msg"] database_lastID:[[self.maxIDArray objectAtIndex:0]objectForKey:@"id"] Status:@"msg"];
        }
        
        
        //NSLog(@"View-> %f", self.view.frame.origin.y);
        // Checking the Y if the keyboard is up so its y origin is -216
       
        if (self.view.frame.origin.y == -216 || self.view.frame.origin.y == -250) {
            
          //  [self myWholeViewDown:self.view];
          //  [self.msgTxtview resignFirstResponder];
        
        }else{
            
          //  [self.msgTxtview resignFirstResponder];
        }
        
        
        
    } else {
        
        UIAlertView *successAlert = [[UIAlertView alloc] initWithTitle:@"Info"
                                                               message:@"Please type atleast one character"
                                                              delegate:self
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
        [successAlert show];
        
    }

}


- (IBAction)backBtnPressed:(id)sender {
    
    dbClass *db = [[dbClass alloc]init];
    
     [db update_isRead:self.user_to_id];

    // if coming back from camera
    if (self.isPushedBack == YES) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        
            // if coming from gallery image
         if (self.is_galleryImg == YES) {
             
             
             [self.navigationController popToRootViewControllerAnimated:YES];
             
             
         }else{
             // simple back
             [self.navigationController popViewControllerAnimated:YES];
         }
    }
}



#pragma mark - Connections
-(void)ConnectionDidFinishLoading:(NSString *)responseString :(NSString *)serviceName{
    
    dbClass *db = [[dbClass alloc]init];
    
    NSLog(@"%@",serviceName);
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if([serviceName isEqualToString:@"sendMessages"]){
        
        self.responseDict = [responseString objectFromJSONString];
        
        
        [db updateMessages:[self.responseDict objectForKey:@"date_time"] is_sent:@"1" server_msg_id:[[self.responseDict objectForKey:@"server_msg_id"]stringValue ] return_id:[self.responseDict objectForKey:@"lastId"]];
        
       self.msgsDetailArray = [db getMessage:self.user_to_id UserFrom:[defaults stringForKey:@"user_from_id"]];
        
       [self.tableView reloadData];
        
    }
    else if ([serviceName isEqualToString:@"uploadMsgImg"]){
        
         self.responseDict = [responseString objectFromJSONString];
        
        if ([[self.responseDict objectForKey:@"status"] isEqualToString:@"success"]) {
            
           
            [db update_isRead:[defaults stringForKey:@"user_from_id"]];
            
            self.photoBtn.enabled = YES;
            
            [db updateMessages:[self.responseDict objectForKey:@"date_time"] is_sent:@"1" server_msg_id:[[self.responseDict objectForKey:@"server_msg_id"]stringValue ] return_id:[[self.maxIDArray objectAtIndex:0]objectForKey:@"id"]];
            
            //scroll the table view to the bottom
            NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:([self.msgsDetailArray count] -1) inSection:0];
          
            [[self tableView] scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];

            
            [self.tableView reloadData];
            
          
            
        }
      
    }
    
     else if ([serviceName isEqualToString:@"delMsgs"]){
         
         self.responseDict = [responseString objectFromJSONString];
         
         if ([[self.responseDict objectForKey:@"status"] isEqualToString:@"success"]) {
             
             dbClass *db = [[dbClass alloc]init];
             
             [db deletemsgs:[[[self.responseDict objectForKey:@"lastIds"]objectAtIndex:0]objectForKey:@"msgId"]];
                       
             self.msgsDetailArray = [db getMessage:self.user_to_id UserFrom:[defaults stringForKey:@"user_from_id"]];
             
              // NSLog(@"MsgsDetailarrayyyy---->> %@", self.msgsDetailArray);
                          
             [self.tableView reloadData];

         }
     }
    
        [db update_isRead:[defaults stringForKey:@"user_from_id"]];
}

-(void)ConnectiondidFailWithError:(NSString *)responseString :(NSString *)serviceName{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
//    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please Check Your Internet Connection" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//    [alertView show];
  
}



- (void)myWholeViewDown:(UIView*)sender
{
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
	
    CGRect rect = sender.frame;
	
    if (IS_IPHONE_5) {
        
        rect.origin.y += KEYBOARD_VIEW_MOVE_HEIGHT+34;
        
    }else{
	
        rect.origin.y += KEYBOARD_VIEW_MOVE_HEIGHT;
    }
	sender.frame = rect;
	
    [UIView commitAnimations];
    
}


- (void)myWholeViewUp:(UIView*)sender
{
	[UIView beginAnimations:nil context:NULL];

    [UIView setAnimationDuration:0.3];
	
    CGRect rect = sender.frame;

    if (IS_IPHONE_5) {
        
        rect.origin.y -= KEYBOARD_VIEW_MOVE_HEIGHT+34;
    
    }else{
	
        rect.origin.y -= KEYBOARD_VIEW_MOVE_HEIGHT;
    }
    NSLog(@"rect.origin.y--> %f", rect.origin.y);
	sender.frame = rect;
    
	
    [UIView commitAnimations];
    
}


#pragma mark UITEXTView

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    // Any new character added is passed in as the "text" parameter
    if ([text isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        [textView resignFirstResponder];
        [self myWholeViewDown:self.view];
        
        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }
    // For any other character return TRUE so that the text gets added to the view
    return TRUE;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    [self myWholeViewUp:self.view];
}

/*

#pragma mark UITextFieldDelegate


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}


//for making textview up and down while keyboard is shown
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self myWholeViewUp:self.view];
    
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self myWholeViewDown:self.view];
}
 
 */


- (IBAction)Picture_Taken_Btn_Pressed:(id)sender {
   
    
    if ([[defaults stringForKey:@"status_user"] isEqualToString:@"1"]) {
        NSLog(@"Its Client");
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Complete action using" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Take Photo", @"Choose Photo", nil];
        alertView.tag = 777;
        [alertView show];

        
    }else{
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Complete action using" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Take Photo", @"Choose Photo", @"Blu's Gallery", nil];
        alertView.tag = 777;
        [alertView show];
    }
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
   
      if (alertView.tag == 777){
        if (buttonIndex == 1) {
            [self takePhotoBtnPressed];
        }else if (buttonIndex == 2){
            [self choosePhotoBtnPressed];
        }else if (buttonIndex == 3){
            [self blusGalleryBtnPressed];
        }
        
        
        /////// Insert The Video Link/////////////
        
    }else if (alertView.tag == 999){
        
            if (buttonIndex == 1) {
                
         //   NSLog(@"alert_textField--> %@", self.alert_textField);
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            
            [dict setObject:self.msgTxtview.text forKey:@"msg"];
            
            [self addToTableView:dict];
            
            dbClass *db = [[dbClass alloc]init];
            
            
            [db insertMessages:self.user_to_id :[defaults stringForKey:@"user_from_id"] :self.alert_textField :@"0" :@"0" :@"0" :@"0" :@"0"];
            
            
            [db update_isRead:[defaults stringForKey:@"user_from_id"]];
            
            self.maxIDArray = [db getMaxID];
            
            
            //CALL THE WEBSERVICE HERE.
            
            if ([self.user_to_id isEqualToString:@"0"]) {
                
                [post sendMessages:@"admin" UserID_from:[defaults stringForKey:@"user_from_id"]  Message:self.alert_textField database_lastID:[[self.maxIDArray objectAtIndex:0]objectForKey:@"id"] Status:@"msg"];
                
            }else{
                
                [post sendMessages:self.user_to_id UserID_from:[defaults stringForKey:@"user_from_id"]  Message:self.alert_textField database_lastID:[[self.maxIDArray objectAtIndex:0]objectForKey:@"id"] Status:@"msg"];
            }
        
           
        }
        
    }
    
}


-(void)takePhotoBtnPressed{
    
    self.photoBtn.enabled = NO;
    
     if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        self.imgView.image = [UIImage imageWithImage:self.imgView.image scaledToSize:CGSizeMake(100.0, 100.0)];
        
        [self presentViewController:picker animated:YES completion:NULL];
    }
    else {
        
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error accessing Camera" message:@"This device is unable to access camera" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
        
        self.photoBtn.enabled = YES;
    }
    
}

-(void)choosePhotoBtnPressed{
    
    self.photoBtn.enabled = NO;
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
 //    self.imgView.image = [UIImage imageWithImage:self.imgView.image scaledToSize:CGSizeMake(100.0, 100.0)];
    
    [self presentViewController:picker animated:YES completion:NULL];
     
    
}

-(void)blusGalleryBtnPressed{
    
    self.photoBtn.enabled = NO;
    
    GalleryViewController *galleryVc = [[GalleryViewController alloc]init];
    
    NSString *isBlusGalleryBtnpressed = @"yes";
    
    galleryVc.is_blusGalleryBtnPressed = isBlusGalleryBtnpressed;
    
    self.imgView.image = [UIImage imageWithImage:self.imgView.image scaledToSize:CGSizeMake(100.0, 100.0)];
    [self.navigationController pushViewController:galleryVc animated:YES];
    //[self presentViewController:galleryVc animated:YES completion:nil];

}

// this method takes uiimage saves into doc directory and return it;s local path.
- (NSString*)saveImageIntoDocPathWithFileName:(UIImage *)image
{
    NSTimeInterval  todaysDate = [[NSDate date] timeIntervalSince1970];
    NSString *timeinNSString = [NSString stringWithFormat:@"%f", todaysDate];
    
    //path of document directory
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@.png",docDir, timeinNSString];
    NSData *nsData = [NSData dataWithData:UIImagePNGRepresentation(image)];
    [nsData writeToFile:pngFilePath atomically:YES];
    return pngFilePath;
}


#pragma mark - Image Picker Controller delegate methods

// This method is called when an image has been chosen from the library or taken from the camera.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
        
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
  
    self.imgView = [[UIImageView alloc]init];
    
    self.imgView.image = image;
    
    NSString *docDirectoryFilePath =[self saveImageIntoDocPathWithFileName:self.imgView.image];
    
    dbClass *db = [[dbClass alloc]init];
    
    NSLog(@"Doc--> %@", docDirectoryFilePath);
    
    if (docDirectoryFilePath == nil || [docDirectoryFilePath isEqualToString:@""] || [docDirectoryFilePath isEqual:[NSNull null]]) {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Erro" message:@"Something went wrong" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alertView show];
        
    }else{
   
        [db insertMessages:self.user_to_id :[defaults stringForKey:@"user_from_id"] :docDirectoryFilePath :@"" :@"0" :@"0" :@"1" :@"0"];
    
    [db update_isRead:[defaults stringForKey:@"user_from_id"]];
    
    }
    
    dataImage = [[NSData alloc] initWithData:UIImageJPEGRepresentation(self.imgView.image, 1)];
    
    self.imgView.image = [UIImage imageWithImage:self.imgView.image scaledToSize:CGSizeMake(250.0, 250.0)];
    
    self.maxIDArray = [db getMaxID];
   
        
        [post uploadMsgImg:self.user_to_id :[defaults stringForKey:@"user_from_id"] :[[self.maxIDArray objectAtIndex:0]objectForKey:@"id"] :@"img" :UIImagePNGRepresentation(self.imgView.image)];
    
   // }];

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    self.photoBtn.enabled = YES;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


- (IBAction)addVideoLink_BtnPressed:(id)sender {
    
   
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Paste Video Link Here:"
                                                          message:nil
                                                         delegate:self
                                                cancelButtonTitle:@"Cancel"
                                                otherButtonTitles:@"Send", nil];
        
        [message setAlertViewStyle:UIAlertViewStylePlainTextInput];
        
        [message show];
    
    message.tag = 999;
    
    
}



-(BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    
    BOOL result;
    
    if (alertView.tag == 999) {
        
        NSString *inputText = [[alertView textFieldAtIndex:0] text];
        
        if( [inputText length] >= 10 )
        {
            self.alert_textField = inputText;
           
            result = YES;
            return result;
        }
        else
        {
            result = NO;
            return NO;
        }
    
    }else  if (alertView.tag == 777){
       
        result = YES;
    
    }
    
    return result;
}





@end
