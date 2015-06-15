//
//  ImgDetailViewController.h
//  BlusApp
//
//  Created by Usman Ghani on 08/08/2014.
//  Copyright (c) 2014 Gexton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImgDetailViewController : UIViewController <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic)UIImage *img;



- (IBAction)backBtnPressed:(id)sender;



@end
