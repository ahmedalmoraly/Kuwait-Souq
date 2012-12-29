//
//  LargeImageDetail.m
//  Mosta3mal
//
//  Created by Islam on 11/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "largeImageDetails.h"
#import "AFImageRequestOperation.h"

#define ZOOM_VIEW_TAG 100
#define ZOOM_STEP 1.5


@interface largeImageDetails (UtilityMethods)

@property(nonatomic, retain) NSMutableArray *allImages;

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center;
-(void)loadAllImagesInBackground;

@end


@implementation largeImageDetails

@synthesize imageScrollView;
@synthesize imageView;
@synthesize _img;
@synthesize imagesArray;
@synthesize previousImageBtn;
@synthesize nextImageBtn;
@synthesize currentImageIndex;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [imageScrollView release];
    [imageView release];
    [previousImageBtn release];
    [nextImageBtn release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [imageView setImage:_img];
    
    if (currentImageIndex < self.imagesArray.count - 1) {
        nextImageBtn.enabled = YES;
    } else {
        nextImageBtn.enabled = NO;
    }
    
    if (currentImageIndex > 0) {
        previousImageBtn.enabled = YES;
    } else {
        previousImageBtn.enabled = NO;
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setImageScrollView:nil];
    [self setImageView:nil];
    [self setPreviousImageBtn:nil];
    [self setNextImageBtn:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)loadView {
    [super loadView];
    
    // set the tag for the image view
    [imageView setTag:ZOOM_VIEW_TAG];
    
    // add gesture recognizers to the image view
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    UITapGestureRecognizer *twoFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTwoFingerTap:)];
    
    [doubleTap setNumberOfTapsRequired:2];
    [twoFingerTap setNumberOfTouchesRequired:2];
    
    [imageView addGestureRecognizer:singleTap];
    [imageView addGestureRecognizer:doubleTap];
    [imageView addGestureRecognizer:twoFingerTap];
    
    [singleTap release];
    [doubleTap release];
    [twoFingerTap release];
    
    // calculate minimum scale to perfectly fit image width, and begin at that scale
    float minimumScale = [imageScrollView frame].size.width  / [imageView frame].size.width;
    [imageScrollView setMinimumZoomScale:minimumScale];
    [imageScrollView setZoomScale:minimumScale];
}

#pragma mark UIScrollViewDelegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return imageView;// [imageScrollView viewWithTag:ZOOM_VIEW_TAG];
}

#pragma mark TapDetectingImageViewDelegate methods

- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {
    // single tap does nothing for now
}

- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer {
    // double tap zooms in
    float newScale = [imageScrollView zoomScale] * ZOOM_STEP;
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
    [imageScrollView zoomToRect:zoomRect animated:YES];
}

- (void)handleTwoFingerTap:(UIGestureRecognizer *)gestureRecognizer {
    // two-finger tap zooms out
    float newScale = [imageScrollView zoomScale] / ZOOM_STEP;
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
    [imageScrollView zoomToRect:zoomRect animated:YES];
}

#pragma mark Utility methods

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    // the zoom rect is in the content view's coordinates. 
    //    At a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.
    //    As the zoom scale decreases, so more content is visible, the size of the rect grows.
    zoomRect.size.height = [imageScrollView frame].size.height / scale;
    zoomRect.size.width  = [imageScrollView frame].size.width  / scale;
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}

- (IBAction)loadNextImage:(id)sender {
    UIView *dimView = [[UIView alloc] initWithFrame:imageScrollView.frame];
    dimView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    [self.view addSubview:dimView];
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.hidesWhenStopped = YES;
    [spinner startAnimating];
    spinner.center = self.view.center;
    [self.view addSubview:spinner];
    
    currentImageIndex++;
    [[AFImageRequestOperation imageRequestOperationWithRequest:[NSURLRequest requestWithURL:[imagesArray objectAtIndex:currentImageIndex]] success:^(UIImage *image) {
        [self.imageView setImage:image];
        [spinner stopAnimating];
        [dimView removeFromSuperview];
        [dimView release];
        [spinner removeFromSuperview];
        [spinner release];
    }] start];
    if (currentImageIndex == imagesArray.count -1) {
        [(UIBarButtonItem *)sender setEnabled:NO];
    }
    self.previousImageBtn.enabled = YES;
}

- (IBAction)loadPreviousImage:(id)sender {
    UIView *dimView = [[UIView alloc] initWithFrame:imageScrollView.frame];
    dimView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    [self.view addSubview:dimView];
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.hidesWhenStopped = YES;
    [spinner startAnimating];
    spinner.center = self.view.center;
    [self.view addSubview:spinner];
    
    currentImageIndex--;
    [[AFImageRequestOperation imageRequestOperationWithRequest:[NSURLRequest requestWithURL:[imagesArray objectAtIndex:currentImageIndex]] success:^(UIImage *image) {
        [self.imageView setImage:image];
        [spinner stopAnimating];
        [dimView removeFromSuperview];
        [dimView release];
        [spinner removeFromSuperview];
        [spinner release];
    }] start];
    if (currentImageIndex == 0) {
        [(UIBarButtonItem *)sender setEnabled:NO];
    }
    self.nextImageBtn.enabled = YES;
}
@end
