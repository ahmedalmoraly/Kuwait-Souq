//
//  GoogleAdsController.m
//  LARSAdControllerDemo
//
//  Created by Ahmad al-Moraly on 1/1/12.
//  Copyright (c) 2012 Mutual Mobile. All rights reserved.
//

#import "GoogleAdsController.h"
#import <QuartzCore/QuartzCore.h>

@implementation GoogleAdsController

@synthesize googleAdBannerView          = _googleAdBannerView;
@synthesize parentView                  = _parentView;
@synthesize googleAdVisible             = _googleAdVisible;
@synthesize parentViewController        = _parentViewController;
@synthesize shouldAlertUserWhenLeaving  = _shouldAlertUserWhenLeaving;
@synthesize lastOrientationWasPortrait  = _lastOrientationWasPortrait;
@synthesize currentOrientation          = _currentOrientation;
@synthesize containerView               = _containerView;

@synthesize delegate                    = _delegate;

static const CGFloat iPAD_AD_CONTAINER_HEIGHT = 90.0f;
static const CGFloat iPHONE_AD_CONTAINER_HEIGHT = 50.0f;

static GoogleAdsController *sharedController = nil;

#pragma mark -
#pragma mark Class Methods

+ (GoogleAdsController *)sharedManager{
    if (sharedController == nil) {
        sharedController = [[super allocWithZone:NULL] init];
        [sharedController setGoogleAdVisible:NO];
        [sharedController setParentViewController:nil];
        [sharedController setShouldAlertUserWhenLeaving:NO];
    }
    return sharedController;
}

+ (id)allocWithZone:(NSZone *)zone{
    return [[self sharedManager] retain];
}

#pragma mark -
#pragma mark Singleton Implementation Methods

- (id)copyWithZone:(NSZone *)zone{
    return self;
}

- (id)retain{
    return self;
}

- (NSUInteger)retainCount{
    return NSUIntegerMax;
}

- (oneway void)release{
    //empty implementation to prevent user releasing
}

- (id)autorelease{
    return self;
}

- (void)dealloc{//this should never get called
    [self.googleAdBannerView release];
    self.googleAdBannerView = nil;
    [self.containerView release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark Public Methods
- (void)addAdContainerToView:(UIView *)view withParentViewController:(UIViewController *)viewController{
    //remove container from superview
    //  add ad container to new view as subview at bottom
    if (![[view subviews] containsObject:[self containerView]]) {
        [self setCurrentOrientation:viewController.interfaceOrientation];
        [self setParentViewController:viewController];
        [self setParentView:view];
        if ([viewController respondsToSelector:@selector(adjustViewForGoogleAdsView:)]) {
            self.delegate = (id<GoogleAdsControllerDelegate>)viewController;
        }
        
        [[self containerView] addSubview:[self googleAdBannerView]];
        [self fixAdContainerFrame];
        [view addSubview:[self containerView]];
    }
    else{
        //ad container exists, and bring to front
        [view bringSubviewToFront:[self containerView]];
    }
    
}

- (UIView *)containerView{
    if (!_containerView) {
        CGFloat height = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? iPAD_AD_CONTAINER_HEIGHT : iPHONE_AD_CONTAINER_HEIGHT;
        CGRect frame = CGRectMake(0.0f,
                                  CGRectGetHeight(self.parentView.frame)-height,
                                  CGRectGetWidth(self.parentView.frame),
                                  height);
        NSLog(@"Container Frame: %@", NSStringFromCGRect(frame));
        
        _containerView                  = [[UIView alloc] initWithFrame:frame];
        _containerView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | 
        UIViewAutoresizingFlexibleHeight | 
        UIViewAutoresizingFlexibleTopMargin);
        _containerView.backgroundColor  = [UIColor clearColor];
        _containerView.userInteractionEnabled = NO;//off by default to ensure users can touch behind ad container
        
        self.containerView.layer.shadowOpacity = 0.5f;
        self.containerView.layer.shadowRadius = 10.0f;
        self.containerView.layer.shadowOffset = CGSizeMake(0.0f, -2.0f);
        self.containerView.layer.shouldRasterize = YES;
        self.containerView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    }
    return _containerView;
}

- (NSString *)containerSizeForDeviceOrientation:(UIInterfaceOrientation)orientation{
    CGFloat width = self.containerView.frame.size.width;
    CGFloat xOffset = (UIInterfaceOrientationIsLandscape(orientation)) ? CGRectGetWidth(self.parentView.frame) : CGRectGetHeight(self.parentView.frame);
    
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        if (self.lastOrientationWasPortrait)
            width = self.parentView.frame.size.height;
        
        self.lastOrientationWasPortrait = NO;
    }
    else{//portrait
        if (!self.lastOrientationWasPortrait)
            width = self.parentView.frame.size.width;
        
        self.lastOrientationWasPortrait = YES;
    }
    
    CGFloat height  = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? iPAD_AD_CONTAINER_HEIGHT :iPHONE_AD_CONTAINER_HEIGHT;
    CGRect frame    = CGRectMake(0.0f, xOffset-height, width, height);
    
    NSLog(@"Container Frame: %@", NSStringFromCGRect(frame));
    return NSStringFromCGRect(frame);
}

- (void)layoutBannerViewsForCurrentOrientation:(UIInterfaceOrientation)orientation{
    [self setCurrentOrientation:orientation];
    [self fixAdContainerFrame];
    [self recenterGoogleAdBannerView];
    [self.delegate adjustViewForGoogleAdsView:self.containerView];
}

- (void)fixAdContainerFrame{
    [[self containerView] setFrame:CGRectFromString([self containerSizeForDeviceOrientation:self.currentOrientation])];
}

#pragma mark -
#pragma mark AdMob/Google Methods

-(GADBannerView *)googleAdBannerView {
    if (!_googleAdBannerView) {
        [self createGoogleAds];
    }
    return _googleAdBannerView;
}

- (void)createGoogleAds{
//    if (_googleAdBannerView == nil) {
//        CGRect frame;
//        
//        //create size depending on device and orientation
//        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//            frame = CGRectMake(0.0f, self.containerView.frame.size.height, 
//                               GAD_SIZE_728x90.width, 
//                               GAD_SIZE_728x90.height);
//        }
//        else{
//            frame = CGRectMake(0.0f, 
//                               self.containerView.frame.size.height, 
//                               GAD_SIZE_320x50.width, 
//                               GAD_SIZE_320x50.height);
//        }
//        
//        _googleAdBannerView = [[GADBannerView alloc] initWithFrame:frame];
//        [self recenterGoogleAdBannerView];
//        [[self googleAdBannerView] setAdUnitID:kGoogleAdId];
//        
//        [[self googleAdBannerView] setRootViewController:[self parentViewController]];
//        [[self googleAdBannerView] setDelegate:self];
//        GADRequest *request = [GADRequest request];
//        request.testDevices = [NSArray arrayWithObjects:
//                               GAD_SIMULATOR_ID,                       
//                               nil];
//        [[self googleAdBannerView] loadRequest:request];
//        
//        [[self containerView] addSubview:[self googleAdBannerView]];
//        [[self containerView] sendSubviewToBack:[self googleAdBannerView]];
//    }
}

- (void)recenterGoogleAdBannerView{
    if (_googleAdBannerView) {
        [[self googleAdBannerView] setCenter:CGPointMake(self.containerView.frame.size.width/2, self.googleAdBannerView.center.y)];
    }
}
//
//- (void)destroyGoogleAdsAnimated:(BOOL)animated{
//    if (_googleAdBannerView) {
//        if (animated && self.googleAdVisible) {
//            [UIView animateWithDuration:0.250
//                                  delay:0.0
//                                options:UIViewAnimationOptionCurveEaseInOut
//                             animations:^{
//                                 [[self googleAdBannerView] setFrame:
//                                  CGRectOffset(self.googleAdBannerView.frame, 
//                                               0.0, 
//                                               self.googleAdBannerView.frame.size.height)];
//                             }
//                             completion:^(BOOL finished){
//                                 dispatch_async(dispatch_get_main_queue(), ^{
//                                     [self destroyGoogleAdsAnimated:NO];
//                                 });
//                             }
//             ];
//        }
//        else{
//            [[self googleAdBannerView] removeFromSuperview];
//            [[self googleAdBannerView] setDelegate:nil];
//            [[self googleAdBannerView] setRootViewController:nil];
//            [self.googleAdBannerView release];
//            self.googleAdBannerView = nil;
//            self.googleAdVisible = NO;
//        }
//    }
//}

#pragma mark -
#pragma mark AdMob/Google Delegate Methods
- (void)adViewDidReceiveAd:(GADBannerView *)bannerView{
    [UIView animateWithDuration:0.250
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         if (self.googleAdVisible) {
                             [UIView animateWithDuration:1.0 animations:^{
                                 self.googleAdBannerView.alpha = 0;
                                 self.googleAdBannerView.transform = CGAffineTransformMakeTranslation(0, self.googleAdBannerView.frame.size.height);
                             } completion:^(BOOL finished) {
                                 [UIView animateWithDuration:1.0 delay:3 options:0 animations:^{
                                     self.googleAdBannerView.alpha = 1;
                                     self.googleAdBannerView.transform = CGAffineTransformIdentity;
                                 } completion:nil];
                             }];
                             
                         } else {
                             [[self googleAdBannerView] setFrame:
                              CGRectOffset(self.googleAdBannerView.frame,
                                           0.0,
                                           -(self.googleAdBannerView.frame.size.height-2.0f))];
                             [self.delegate adjustViewForGoogleAdsView:self.containerView];
                         }
                     }
                     completion:^(BOOL finished){
                         self.googleAdVisible = YES;
                         [[self containerView] setUserInteractionEnabled:YES];
                         [[self googleAdBannerView] setUserInteractionEnabled:YES];
                     }
     ];
    NSLog(@"Google ad did receive ad");
}

- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error{
    [UIView animateWithDuration:0.250
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [[self googleAdBannerView] setFrame:
                          CGRectOffset(self.googleAdBannerView.frame, 
                                       0.0, 
                                       self.googleAdBannerView.frame.size.height-2.0f)];
                     }
                     completion:^(BOOL finished){
                         self.googleAdVisible = NO;
                         [[self containerView] setUserInteractionEnabled:NO];//assuming if a google ad fails to appear, there are no ads at all
                     }
     ];
    NSLog(@"\nGoogle ad failed to receive ad with Error: %@ and Recovery suggestion: %@\n", error.localizedFailureReason, error.localizedRecoverySuggestion);
}


@end