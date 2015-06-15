                        //
//  GalleryDetailViewController.m
//  BlusApp
//
//  Created by gexton-macmini on 15/08/2014.
//  Copyright (c) 2014 Gexton. All rights reserved.
//

#import "GalleryDetailViewController.h"
#import "dbClass.h"

@interface GalleryDetailViewController ()

@end

@implementation GalleryDetailViewController

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
    
    [NSTimer scheduledTimerWithTimeInterval:5.0
                                     target:self
                                   selector:@selector(check_notification8)
                                   userInfo:nil
                                    repeats:YES];

    
    self.category_nameLbl.font = [UIFont fontWithName:@"Lato-Regular" size:20];
    self.back_btn.titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:20];
    
    x=0;
    y= 60;
    
    self.galleryArray_new = [[NSMutableArray alloc]init];
    
    [self.category_nameLbl setText:self.cat_name_str];
    
    
    // Filling the Array
       for (int index=0; index < [self.galleryArray count]; index++) {
           
           if (self.cat_id == [[[self.galleryArray objectAtIndex:index]objectForKey:@"category_id"]intValue]) {
          
               // Encoding the str path
              NSString *imgStr = [[self.galleryArray objectAtIndex:index]objectForKey:@"img"];
               imgStr = [imgStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

               [self.galleryArray_new addObject:[NSString stringWithFormat:@"http://www.blusserver.com/bluschat/assets/gallery/%@", imgStr]];
           }

       }
 
    for (int i = 1; i <=[self.galleryArray_new count]; i++) {

        

          NSString *urlString = [self.galleryArray_new objectAtIndex:i-1];
        
       // urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        if (i % 4 == 0) {
            y =y+ 105;
            x=0;
        }
        
        
        IphoneAsyncImageView *participantImg = [[IphoneAsyncImageView alloc] initWithFrame:CGRectMake(x, y, 100.0f, 100.0f)];
        participantImg.cv_width = 100.0f;
        participantImg.cv_height = 100.0f;
        participantImg.contentMode = UIViewContentModeScaleAspectFit;
        participantImg.backgroundColor = [UIColor clearColor];
        [participantImg loadImageFromURL:[NSURL URLWithString:urlString]];
        [self.view addSubview:participantImg];
        
       // NSLog(@"%d,%d,",x,y);
        
        UIButton *imgeBtn = [[UIButton alloc]initWithFrame:CGRectMake(x, y, 100.0, 100.0)];
        imgeBtn.backgroundColor = [UIColor clearColor];
        [imgeBtn addTarget:self action:@selector(imageButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        imgeBtn.tag = i-1;
        [self.view addSubview:imgeBtn];
        
       x= x+105;
        
       
    }
   
  
}
-(void)check_notification8{
    
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

-(void)imageButtonPressed:(id)sender{
    
    
    UIButton *btn = (UIButton*)sender;
   // NSLog(@"Button Tag %ld", (long)btn.tag);
    
    IphoneImageDetailViewController *imgDetail = [[IphoneImageDetailViewController alloc]initWithNibName:@"IphoneImageDetailViewController" bundle:nil];
    imgDetail.index = btn.tag;

    imgDetail.imagesArray = self.galleryArray_new;
    imgDetail.is_blusGalleryBtnPressed = self.is_blusGalleryBtnPressed;
    
    [self.navigationController pushViewController:imgDetail animated:YES];
 
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
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backBtnPressed:(id)sender {
    
//    if ([[[self.msgsArray objectAtIndex:0]objectForKey:@"is_read"] isEqualToString:@"0"] || [[self.msgsArray objectAtIndex:0]objectForKey:@"is_read"] == nil) {
//        
//        
//        HomeViewController *dashBoardVC = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
//        
//        self.homeVC = dashBoardVC;
//        
//        
//        SideMenuVC *leftMenuViewController = [[SideMenuVC alloc]init];
//        
//        MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController
//                                                        containerWithCenterViewController:self.homeVC
//                                                        leftMenuViewController:leftMenuViewController
//                                                        rightMenuViewController:nil];
//        
//        [self.navigationController pushViewController:container animated:NO];
//        
//        
//    }else{
    
        [self.navigationController popViewControllerAnimated:YES];
   // }
}
@end
