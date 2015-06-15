//
//  IphoneImageDetailViewController.h
//  IreoUniversal
//
//  Created by Faizan on 9/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IphoneAsyncImageView.h"
#import "dbClass.h"
//#import "GADBannerView.h"

//@class GADBannerView;
//@class GADRequest;

@interface IphoneImageDetailViewController : UIViewController<UIScrollViewDelegate, UIAlertViewDelegate> {
    NSString *strUrl;
	NSMutableArray *imagesArray;
	NSInteger index;
	UIView *myview;
    
  //  GADBannerView *bannerView_;
    CGPoint origin;
}

@property (strong, nonatomic) NSMutableArray *msgsArray;
@property (strong, nonatomic) IBOutlet UIImageView *notificationIconImg;


@property (strong, nonatomic)NSString *is_blusGalleryBtnPressed;

@property (strong, nonatomic)UIImage *img;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollview;
@property(nonatomic,retain) NSMutableArray *imagesArray;
@property(nonatomic,readwrite) NSInteger index;
@property(nonatomic,readwrite) NSInteger selectedImageIndex;
@property(nonatomic,retain) NSString *jpegPath;

-(void)setUpScroller;
- (void)layoutScrollImages;

- (IBAction)backBtnPressed:(id)sender;
- (IBAction)sendBtnPressed:(id)sender;

@end
