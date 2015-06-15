//
//  IphoneAsyncImageView.m
//  IreoUniversal
//
//  Created by Faizan on 9/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IphoneAsyncImageView.h"
#import "ImageCacheObject.h"
#import "ImageCache.h"


static ImageCache *imageCache = nil;


@implementation IphoneAsyncImageView

//
// Key's are URL strings.
// Value's are ImageCacheObject's
//
@synthesize data;
@synthesize cv_width;
@synthesize cv_height;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
    [connection cancel];
    [connection release];
    [data release];
    [super dealloc];
}

-(void)loadImageFromURL:(NSURL*)url {
    
    if (connection != nil) {
        [connection cancel];
        [connection release];
        connection = nil;
    }
    if (data != nil) {
        [data release];
        data = nil;
    }
    
    if (imageCache == nil) // lazily create image cache
        imageCache = [[ImageCache alloc] initWithMaxSize:2*1024*1024];  // 2 MB Image cache
    
    [urlString release];
    urlString = [[url absoluteString] copy];
    UIImage *cachedImage = [imageCache imageForKey:urlString];
	if ([[self subviews] count] > 0) {
		//int subViewCount = [[self subviews] count];
		for (UIView *view in self.subviews) {
			[view removeFromSuperview];
		}
	}
    if (cachedImage != nil) {
        if ([[self subviews] count] > 0) {
			//int subViewCount = [[self subviews] count];
			for (UIView *view in self.subviews) {
				[view removeFromSuperview];
			}
        }

        
//        
        UIImage *imageNamed2 = [cachedImage imageByScalingAndCroppingForSize:CGSizeMake(self.cv_width,self.cv_height)];
//        
        
        UIImageView *imageView = [[[UIImageView alloc] initWithImage:imageNamed2] autorelease];
//        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.clipsToBounds = YES;;
        imageView.autoresizingMask =
		UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		imageView.backgroundColor = [UIColor clearColor];
        
        
        [self addSubview:imageView];
        imageView.frame = self.bounds;
        [imageView setNeedsLayout]; // is this necessary if superview gets setNeedsLayout?
        [self setNeedsLayout];
        return;
	} 
	
	// andy@luibh.ie 6th March 2010 - including modified code by Robert A of http://photoaperture.com/
	// this shows a default place holder image if no cached image exists.
	else {
		
		// Use a default placeholder when no cached image is found
		UIImageView *imageView = [[[UIImageView alloc] initWithImage:[UIImage
																	  imageNamed:@"placeHolder.png"]] autorelease];
		imageView.contentMode = UIViewContentModeScaleAspectFit;
		imageView.autoresizingMask =
		UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		imageView.backgroundColor = [UIColor clearColor];
		[self addSubview:imageView];
		imageView.frame = self.bounds;
		[imageView setNeedsLayout];
		[self setNeedsLayout];
	}    
	
#define SPINNY_TAG 5555   
    
//    UIActivityIndicatorView *spinny = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    UIActivityIndicatorView *spinny = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];

    spinny.tag = SPINNY_TAG;
    //spinny.center = self.center;
	CGPoint centrePoint = CGPointMake(self.center.x - self.frame.origin.x, self.center.y - self.frame.origin.y);
	spinny.center = centrePoint;
    [spinny startAnimating];
    [self addSubview:spinny];
	[spinny release];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url 
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy 
                                         timeoutInterval:60.0];
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)connection 
    didReceiveData:(NSData *)incrementalData {
    if (data==nil) {
        data = [[NSMutableData alloc] initWithCapacity:2048];
    }
    [data appendData:incrementalData];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)aConnection {
    [connection release];
    connection = nil;
    
    UIView *spinny = [self viewWithTag:SPINNY_TAG];
    [spinny removeFromSuperview];
    
    if ([[self subviews] count] > 0) {
        [[[self subviews] objectAtIndex:0] removeFromSuperview];
    }
    

    UIImage *image = [UIImage imageWithData:data];    
    [imageCache insertImage:image withSize:[data length] forKey:urlString];
	
    
     
    UIImage *imageNamed2 = [image imageByScalingAndCroppingForSize:CGSizeMake(self.cv_width,self.cv_height)];
    
    
    
    UIImageView *imageView = [[[UIImageView alloc] 
                               initWithImage:imageNamed2] autorelease];
	
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    imageView.autoresizingMask = 
	UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:imageView];
    imageView.frame = self.bounds;
    [imageView setNeedsLayout]; // is this necessary if superview gets setNeedsLayout?
    [self setNeedsLayout];
    [data release];
    data = nil;
}



@end

@implementation UIImage(Extras)

-(UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize
{
	UIImage *sourceImage = self;
	UIImage *newImage = nil;
	CGSize imageSize = sourceImage.size;
	CGFloat width = imageSize.width;
	CGFloat height = imageSize.height;
	CGFloat targetWidth = targetSize.width;
	CGFloat targetHeight = targetSize.height;
	CGFloat scaleFactor = 0.0;
	CGFloat scaledWidth = targetWidth;
	CGFloat scaledHeight = targetHeight;
	CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
	
	if (CGSizeEqualToSize(imageSize, targetSize) == NO)
	{
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
		
        if (widthFactor > heightFactor)
			scaleFactor = widthFactor; // scale to fit height
        else
			scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
		
        // center the image
        if (widthFactor > heightFactor)
		{
			thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
		}
        else
			if (widthFactor < heightFactor)
			{
				thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
			}
	}
	
	UIGraphicsBeginImageContext(targetSize); // this will crop
	
	CGRect thumbnailRect = CGRectZero;
	thumbnailRect.origin = thumbnailPoint;
	thumbnailRect.size.width  = scaledWidth;
	thumbnailRect.size.height = scaledHeight;
	
	[sourceImage drawInRect:thumbnailRect];
	
	newImage = UIGraphicsGetImageFromCurrentImageContext();
	if(newImage == nil)
        NSLog(@"could not scale image");
	
	//pop the context to get back to the default
	UIGraphicsEndImageContext();
	return newImage;
}



@end
