//
//  IphoneAsyncImageView.h
//  IreoUniversal
//
//  Created by Faizan on 9/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface IphoneAsyncImageView : UIView {
    NSURLConnection *connection;
    NSMutableData *data;
    NSString *urlString; // key for image cache dictionary
}

@property(nonatomic, retain) NSMutableData *data;
@property(nonatomic, readwrite) CGFloat cv_width;
@property(nonatomic, readwrite) CGFloat cv_height;


-(void)loadImageFromURL:(NSURL*)url;

@end

@interface UIImage(Extras)
-(UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;
@end