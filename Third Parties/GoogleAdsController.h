//
//  GoogleAdsController.h
//  LARSAdControllerDemo
//
//  Created by Ahmad al-Moraly on 1/1/12.
//  Copyright (c) 2012 Lascivio. All rights reserved.
//
/*
*************************************************************************************************************************************************
*                                                                                                                                               *
* How To Use:                                                                                                                                   *
* ***************                                                                                                                               *
*                                                                                                                                               *
* 1) Consider Adding the following Frameworks                                                                                                   *
*                                                                                                                                               *
*   1.1) AudioToolBox.framework                                                                                                                 *
*   1.2) MessagueUI.framework                                                                                                                   *
*   1.3) SystemConfiguration.framework                                                                                                          *
*   1.4) QuartzCore.framework                                                                                                                   *
*                                                                                                                                               *
* 2) Import GoogleAdsController.h into your view Controller                                                                                     *
* 3) In GoogleAdsController.h change the kGoogleAdId with your own Publisher ID                                                                 *
* 4) In your viewWillAppear method add the following                                                                                            *
*                                                                                                                                               *
*        [[GoogleAdsController sharedManager] addAdContainerToView:self.view withParentViewController:self];                                    *
*        [[GoogleAdsController sharedManager] layoutBannerViewsForCurrentOrientation:self.interfaceOrientation];                                *
*                                                                                                                                               *
* 5) YOU ARE DONE :)                                                                                                                            *
*                                                                                                                                               *
*************************************************************************************************************************************************
 
*/


#import "GADBannerView.h"
#import "GADBannerViewDelegate.h"


//replace with your Google Publisher ID
#define kGoogleAdId @"a14ee61c950bf72"

@protocol GoogleAdsControllerDelegate <NSObject>

-(void)adjustViewForGoogleAdsView:(UIView *)adView;

@end

@interface GoogleAdsController : NSObject <GADBannerViewDelegate>

@property (nonatomic, strong)           GADBannerView     *googleAdBannerView;
@property (nonatomic, assign)           UIView            *parentView;
@property (nonatomic, assign)           UIViewController  *parentViewController;
@property (nonatomic, 
           getter = isGoogleAdVisible)  BOOL              googleAdVisible;
@property (nonatomic)                   BOOL              shouldAlertUserWhenLeaving;
@property (nonatomic)                   BOOL              lastOrientationWasPortrait;
@property (nonatomic)                   UIInterfaceOrientation currentOrientation;
@property (nonatomic, strong)           UIView            *containerView;

@property (assign) id <GoogleAdsControllerDelegate> delegate;
+ (GoogleAdsController *)sharedManager;
- (void)addAdContainerToView:(UIView *)view withParentViewController:(UIViewController *)viewController;

- (void)createGoogleAds;
- (UIView *)containerView;

//- (void)destroyGoogleAdsAnimated:(BOOL)animated;

//orientation support
- (NSString *)containerSizeForDeviceOrientation:(UIInterfaceOrientation)orientation;
- (void)layoutBannerViewsForCurrentOrientation:(UIInterfaceOrientation)orientation;
- (void)fixAdContainerFrame;
- (void)recenterGoogleAdBannerView;

@end