//
//  ImgDetailViewController.m
//  BlusApp
//
//  Created by Usman Ghani on 08/08/2014.
//  Copyright (c) 2014 Gexton. All rights reserved.
//

#import "ImgDetailViewController.h"

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@interface ImgDetailViewController ()

@end

@implementation ImgDetailViewController

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
    if (!IS_IPHONE_5) {
        
        self.scrollView.frame = CGRectMake(0.0,147.0, 320.0, 435.0);
    }
    
    NSLog(@"img---> %@", self.img);
    
    self.imgView.image = self.img;
    self.scrollView.contentSize = self.img.size;
    self.imgView.contentMode = UIViewContentModeScaleAspectFit;
    // For supporting zoom,
    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.maximumZoomScale = 2.0;
    self.scrollView.zoomScale = 1.0;
}


// Implement a single scroll view delegate method
- (UIView*)viewForZoomingInScrollView:(UIScrollView *)aScrollView {
    return self.imgView;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backBtnPressed:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
