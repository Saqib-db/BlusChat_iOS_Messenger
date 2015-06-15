//
//  GalleryViewController.m
//  BlusApp
//
//  Created by gexton-macmini on 15/08/2014.
//  Copyright (c) 2014 Gexton. All rights reserved.
//

#import "GalleryViewController.h"

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@interface GalleryViewController ()

@end

@implementation GalleryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(BOOL)connectedToWiFi
{
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    bool result = false;
    if (internetStatus == ReachableViaWiFi )
    {
        result = true;
    }
    else if(internetStatus == ReachableViaWWAN){
        result = true;
    }
    return result;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [NSTimer scheduledTimerWithTimeInterval:5.0
                                     target:self
                                   selector:@selector(check_notification7)
                                   userInfo:nil
                                    repeats:YES];
    
    
    [self.navigationController setNavigationBarHidden:YES];
    
    if (!IS_IPHONE_5) {
        self.tableView.frame = CGRectMake(0.0, 60.0, 320.0, 420.0);
    }

    
    post = [[POST alloc]init];
    post.delegate = self;
    
    
   // if ([self connectedToWiFi]) {
    
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        
        hud.labelText = @"Loading";
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            
            // MY CODE BEGIN //
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
          //  NSLog(@"user_from_id --> %@", [defaults stringForKey:@"user_from_id"]);
            
            [post get_gallery:[defaults stringForKey:@"user_from_id"]];
            
            
            // MY CODE ENDS //
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                
            });
        });
  
//    }else{
//        
//        // IF not internet
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please check your internet connection" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//        [alert show];
//    }
    
}


-(void)check_notification7{
    
    dbClass *db = [[dbClass alloc]init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.msgsArray = [db get_conversation:[defaults stringForKey:@"user_from_id"]];
    
    if ([self.msgsArray count] != 0) {
        
        
        if ([[[self.msgsArray objectAtIndex:0]objectForKey:@"is_read"] isEqualToString:@"0"]) {
            
            
            self.notificationIconImg.hidden = NO;
            //  NSLog(@"one msg is unread");
        }
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    
    self.notificationIconImg.hidden = YES;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    dbClass *db = [[dbClass alloc]init];
    
    // Checking if there is any unread msg, if it is then show the number icon on header
    
    self.msgsArray = [db get_conversation:[defaults stringForKey:@"user_from_id"]];
   
    if ([self.msgsArray count] !=0) {
        
        if ([[[self.msgsArray objectAtIndex:0]objectForKey:@"is_read"] isEqualToString:@"0"]) {
            
            self.notificationIconImg.hidden = NO;
            
        }
    }
    
    
    self.blus_gallery_header_lbl.font = [UIFont fontWithName:@"Lato-Regular" size:20];
    
    if ([self.is_blusGalleryBtnPressed isEqualToString:@"yes"]) {
        
        self.toggleBtn.hidden = YES;
        self.cancelBtn.hidden = NO;
        
       // UIButton *cancelBtn = [UIButton alloc]initWithFrame:<#(CGRect)#>
    }
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  //  NSLog(@"count--> %lu", (unsigned long)[self.responseArray count]);
    return [self.responseArray count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 120;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // For CellStyleDefault
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    UILabel *cat_nameLbl = [[UILabel alloc]initWithFrame:CGRectMake(120.0, 50.0, 250.0, 30.0)];
   
    cat_nameLbl.font = [UIFont fontWithName:@"Lato-Regular" size:17];
    cat_nameLbl.backgroundColor = [UIColor clearColor];
    
    [cat_nameLbl setText:[[self.responseArray objectAtIndex:indexPath.row]objectForKey:@"name"]];
    [cell.contentView addSubview:cat_nameLbl];
    
    
    NSString *img_url = [[self.responseArray objectAtIndex:indexPath.row]objectForKey:@"categoryImg"];
    img_url = [img_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
   
    
    IphoneAsyncImageView *participantImg = [[IphoneAsyncImageView alloc] initWithFrame:CGRectMake(12.0f, 10.0f, 80.0f, 100.0f)];
    participantImg.cv_width = 80.0f;
    participantImg.cv_height = 100.0f;
    participantImg.backgroundColor = [UIColor clearColor];
    [participantImg loadImageFromURL:[NSURL URLWithString:img_url]];
    [cell.contentView addSubview:participantImg];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GalleryDetailViewController *galleryDetail = [[GalleryDetailViewController alloc]initWithNibName:@"GalleryDetailViewController" bundle:nil];
    
    galleryDetail.indexpath = indexPath.row;
    galleryDetail.cat_name_str = [[self.responseArray objectAtIndex:indexPath.row]objectForKey:@"name"];
    
    galleryDetail.is_blusGalleryBtnPressed = self.is_blusGalleryBtnPressed;
   
    self.category_id = [[[self.responseArray objectAtIndex:indexPath.row]objectForKey:@"id"]integerValue];

    galleryDetail.cat_id = self.category_id;
    
    galleryDetail.galleryArray =  [self.responseDict objectForKey:@"gallery"];
    [self.navigationController pushViewController:galleryDetail animated:YES];
}


- (IBAction)toggleBtnPressed:(id)sender {
    
    NSLog(@"isREa--> %@", [[self.msgsArray objectAtIndex:0]objectForKey:@"is_read"]);
    
    if ([[[self.msgsArray objectAtIndex:0]objectForKey:@"is_read"] isEqualToString:@"0"] || [[self.msgsArray objectAtIndex:0]objectForKey:@"is_read"] == nil) {
        
        
        HomeViewController *dashBoardVC = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
        
        self.homeVC = dashBoardVC;
        
        
        SideMenuVC *leftMenuViewController = [[SideMenuVC alloc]init];
        
        MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController
                                                        containerWithCenterViewController:self.homeVC
                                                        leftMenuViewController:leftMenuViewController
                                                        rightMenuViewController:nil];
        
        [self.navigationController pushViewController:container animated:NO];
        
        
    }else{
    
   
        [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
        
    }];
  
    }
}


#pragma mark - Connections
-(void)ConnectionDidFinishLoading:(NSString *)responseString :(NSString *)serviceName{
    
    NSLog(@"%@",serviceName);
    //  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if([serviceName isEqualToString:@"get_gallery"]){
        
        self.responseDict = [responseString objectFromJSONString];
        
        if ([[self.responseDict objectForKey:@"msg"] isEqualToString:@"record not found"]) {
            
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Gallery is empty" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertView show];
        }else{
        
        self.responseArray = [self.responseDict objectForKey:@"cateory"];
        
        
        [self.tableView reloadData];
     
        }
        
    }
    
}

-(void)ConnectiondidFailWithError:(NSString *)responseString :(NSString *)serviceName{
    /*
     [MBProgressHUD hideHUDForView:self.view animated:YES];
     
     UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please Check Your Internet Connection" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
     [alertView show];
     */
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelBtnPressed:(id)sender {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:@"Cancel" forKey:@"YES"];
    [defaults synchronize];
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
