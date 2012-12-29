//
//  LargeImageDetail.h
//  Mosta3mal
//
//  Created by Islam on 11/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterPage.h"

@interface largeImageDetails : MasterPage <UIScrollViewDelegate>{
    
}
@property (retain, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (retain, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic, retain) UIImage *_img;
@property (nonatomic, retain) NSArray *imagesArray;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *previousImageBtn;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *nextImageBtn;
@property (nonatomic, assign) NSInteger currentImageIndex;
- (IBAction)loadNextImage:(id)sender;
- (IBAction)loadPreviousImage:(id)sender;

@end
