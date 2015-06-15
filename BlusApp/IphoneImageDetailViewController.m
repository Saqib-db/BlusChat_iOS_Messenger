//
//  IphoneImageDetailViewController.m
//  IreoUniversal
//
//  Created by Faizan on 9/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IphoneImageDetailViewController.h"
#import "MBProgressHUD.h"
#import "dbClass.h"
#import "ContactsViewController.h"

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@implementation IphoneImageDetailViewController
@synthesize scrollview;
@synthesize index;
@synthesize imagesArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    
    
   // NSLog(@"ImgArr--> %@", self.imagesArray);
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    
    hud.labelText = @"Attaching..";
    // [hud hide:YES afterDelay:5.0];
    
    NSString *urlString = [self.imagesArray objectAtIndex:self.selectedImageIndex];
    NSURL *imgUrl = [NSURL URLWithString:urlString];
  //  NSLog(@"urlStr--> %@", urlString);
   // NSLog(@"lengthstr--> %lu", (unsigned long)urlString.length);
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
       
      NSData *dataImg = [NSData dataWithContentsOfURL:imgUrl];
       
        // saving image data to uiimage
      
       self.img = [UIImage imageWithData:dataImg];
       
        NSLog(@"self.img--> %@", self.img);
        
         // MY CODE End //
        dispatch_async(dispatch_get_main_queue(), ^{
           // Stop the loader
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        });
    });

}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)homeBtn
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)backBtnPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveImage: (UIImage*)image
{
    if (image != nil)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSString * timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000];
        
        self.jpegPath = [NSString stringWithFormat:@"%@/%@test.jpeg",documentsDirectory,timestamp];
        
        NSData *data = [NSData dataWithData:UIImageJPEGRepresentation(image, 1.0f)];//1.0f = 100% quality
        
        [data writeToFile:self.jpegPath atomically:YES];
        
       // NSLog(@"Path---> %@", self.jpegPath);
        
        
    }
    
    
}

- (IBAction)sendBtnPressed:(id)sender {
    
      // Save the image in document directory by calling this method.
   
        [self saveImage:self.img];

    
    // If it comes from the camera btnPressed
    
    if ([self.is_blusGalleryBtnPressed isEqualToString:@"yes"]) {
 
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Confirm?" message:@"Do you want to send it ?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        
            [alert show];
        
        
    }else{
        
        // If it comes from the Gallery Side Menu
        // set the url in UIImage
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Confirm?" message:@"Do you want to send it ?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        
        alert.tag = 777;
        [alert show];
        
        

    
//        ContactsViewController *contactsVc = [[ContactsViewController alloc]initWithNibName:@"ContactsViewController" bundle:nil];
//        NSLog(@"jpegPath--> %@", self.jpegPath);
//        
//        contactsVc.gallery_image = self.jpegPath;
//        NSString *is_pushed = @"yes";
//        contactsVc.isPushed = is_pushed;
//        contactsVc.is_galleryImg = YES;
//        
//        [self.navigationController pushViewController:contactsVc animated:YES];
    }
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        
        NSArray *navArr=self.navigationController.viewControllers;
        
        
        // For find out the desired controller which is in the stack
        for (UIViewController *nav in navArr)
        {
            
            if ([nav isKindOfClass:[ChatVC class]])
            {
                ChatVC *controller = (ChatVC*) nav;
                
                NSLog(@"self.jpeg--> %@", self.jpegPath);
                
                controller.DocDir_galleryImg = self.jpegPath;
                
                // this is again for chatVc condition on backBtnPressed
                
                controller.isPushedBack = YES;
                
                [self.navigationController popToViewController:nav animated:YES];
            }
            
        }

    
    }
    if (alertView.tag == 777) {
        
        if (buttonIndex == 1) {
            
            ContactsViewController *contactsVc = [[ContactsViewController alloc]initWithNibName:@"ContactsViewController" bundle:nil];
            NSLog(@"jpegPath--> %@", self.jpegPath);
            
            contactsVc.gallery_image = self.jpegPath;
            NSString *is_pushed = @"yes";
            contactsVc.isPushed = is_pushed;
            contactsVc.is_galleryImg = YES;
            
            [self.navigationController pushViewController:contactsVc animated:YES];
        }
        
    }
}




#pragma mark - View lifecycle

-(void)viewDidAppear:(BOOL)animated{
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    self.selectedImageIndex = self.index;
    
    for (int i = 0; i<[imagesArray count]; i++)
	{
        
    }
    //NSLog(@"IMAGESSS ARRAY--> %@", self.imagesArray);
    
    // Create a view of the standard size at the top of the screen.
    // Available AdSize constants are explained in GADAdSize.h.
    //bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    
    if (IS_IPHONE_5) {
        self.scrollview.frame = CGRectMake(0.0, 58.0, 320.0, 516);
        
//        origin = CGPointMake(0.0,
//                             self.view.frame.size.height +88 -
//                             CGSizeFromGADAdSize(kGADAdSizeBanner).height);
    }
    else{
        
//        
//        origin = CGPointMake(0.0,
//                             self.view.frame.size.height  -
//                             CGSizeFromGADAdSize(kGADAdSizeBanner).height);
    }
    // Use predefined GADAdSize constants to define the GADBannerView.
//    bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner
//                                                 origin:origin];
    
    // Specify the ad unit ID.
//    bannerView_.adUnitID = @"a152d100a858888";
    
    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
//    bannerView_.rootViewController = self;
//    [self.view addSubview:bannerView_];
//    
//    // Initiate a generic request to load it with an ad.
//    [bannerView_ loadRequest:[GADRequest request]];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] init];
    barButton.title = @"Back";
    self.navigationItem.backBarButtonItem = barButton; 
    [barButton release];
    
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Iphonelogo1.png"]] autorelease]];
    self.navigationItem.rightBarButtonItem = item;
    [item release];
    
    scrollview.pagingEnabled = YES;
	scrollview.autoresizesSubviews = NO;
    scrollview.contentMode = UIViewContentModeScaleAspectFit;
	scrollview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[scrollview setBackgroundColor:[UIColor blackColor]];
	[scrollview setCanCancelContentTouches:YES];
	scrollview.indicatorStyle = UIScrollViewIndicatorStyleWhite;	
	scrollview.clipsToBounds = YES;	 // default is NO, we want to restrict drawing within our scrollview
	scrollview.tag = 999;
	
	scrollview.directionalLockEnabled = YES;
	[scrollview setShowsHorizontalScrollIndicator:YES];
	self.title = @"Event Images";
	[self setUpScroller];

}



-(void)setUpScroller
{		
	CGFloat curXLoc = 0.0;
	for (int i = 0; i<[imagesArray count]; i++)
	{
		myview = [[[UIView alloc] initWithFrame:CGRectMake(curXLoc, 0.0, 320.0, 510.0)] autorelease];
		[myview setBackgroundColor:[UIColor clearColor]];
		myview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		
		
		IphoneAsyncImageView *participantImg = [[IphoneAsyncImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f,320.0f,500.0f)];
        
        participantImg.cv_width = 320.0f;        
        participantImg.cv_height = 500.0f;
        participantImg.contentMode = UIViewContentModeScaleAspectFit;
		participantImg.backgroundColor = [UIColor clearColor];
		[participantImg loadImageFromURL:[NSURL URLWithString:[imagesArray objectAtIndex:i]]];
        
        participantImg.tag = 201;
        
		[self.view addSubview:participantImg];
		
		UIScrollView *tempScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0,0.0,320.0,510.0)];
		tempScroll.delegate = self;
		tempScroll.tag = 5554;
		tempScroll.maximumZoomScale = 7.0f;
		tempScroll.minimumZoomScale = 1.0f;
		tempScroll.backgroundColor = [UIColor clearColor];
		tempScroll.contentSize = participantImg.frame.size; 
		tempScroll.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		tempScroll.autoresizesSubviews = YES;
        
		[tempScroll addSubview:participantImg];
		
        [participantImg release];
		
        [myview addSubview:tempScroll];
		
        [tempScroll release];
		
        [scrollview addSubview:myview];
		
		curXLoc+=320;
	}
	[scrollview setBounces:YES];
	
	[self layoutScrollImages];
}



- (void)layoutScrollImages
{
	UIView *view1 = nil;
	NSArray *subviews1 = [scrollview subviews];
	
	CGFloat curXLoc = 0.0;
	
	for (view1 in subviews1)			
	{
		
		if ([view1 isKindOfClass:[UIView class]] && view1.tag > 0)
		{
			CGRect frame = CGRectMake(curXLoc, 00.0, 320.0, 510.0);
			view1.frame = frame;
			curXLoc += 368.0;
		}
	}
	[scrollview setContentSize:CGSizeMake(([imagesArray count] * 320), ([scrollview bounds].size.height))];
	int temp = index*320;
	[scrollview setContentOffset:CGPointMake(temp,0)];
	
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)containerView{
	
	NSLog(@"%d",containerView.tag);
	return [containerView viewWithTag:201];  
	NSLog(@"ZOOM");
	
	
	
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = CGRectGetWidth(self.scrollview.frame);
    NSLog(@"PAGE NUMBER: %f", floor((self.scrollview.contentOffset.x - pageWidth / 2) / pageWidth) + 1);
    
    self.selectedImageIndex = floor((self.scrollview.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    
    
}

- (void)viewDidUnload
{
    [self setScrollview:nil];
    
    [imagesArray release];
    imagesArray= nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [scrollview release];
    [imagesArray release];
    [super dealloc];
}
@end
