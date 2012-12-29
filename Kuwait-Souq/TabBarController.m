//
//  TabBarController.m
//  Sooq
//
//  Created by Ahmad al-Moraly on 12/15/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TabBarController.h"

#import "MainMenu.h"
#import "UserAdds.h"
#import "AboutTheApplication.h"
#import "Settings.h"

@interface TabBarController()

@property (nonatomic, strong) UIButton *homeBtn;
@property (nonatomic, strong) UIButton *settingsBtn;
@property (nonatomic, strong) UIButton *myAdsBtn;
@property (nonatomic, strong) UIButton *aboutBtn;


@property (nonatomic, strong) UIImage *homeBtnNormalImage;
@property (nonatomic, strong) UIImage *settingsBtnNormalImage;
@property (nonatomic, strong) UIImage *myAdsBtnNormalImage;
@property (nonatomic, strong) UIImage *aboutBtnNormalImage;

@property (nonatomic, strong) UIImage *homeBtnSelectedImage;
@property (nonatomic, strong) UIImage *settingsBtnSelectedImage;
@property (nonatomic, strong) UIImage *myAdsBtnSelectedImage;
@property (nonatomic, strong) UIImage *aboutBtnSelectedImage;

@property (nonatomic) CGRect homeBtnRect;
@property (nonatomic) CGRect settingsBtnRect;
@property (nonatomic) CGRect myAdsBtnRect;
@property (nonatomic) CGRect aboutBtnRect;

-(IBAction)tabBarButtonTouched:(UIButton *)sender;

-(void)setButton:(UIButton *)aButton 
       withFrame:(CGRect)aFrame
 withNormalImage:(UIImage *)normalImage 
andSelectedImage:(UIImage *)selectedImage 
         withTag:(NSInteger)aTag 
     andSelector:(SEL)aSelector ;

-(void)adjustViewForiPhone;
-(void)adjustViewForiPad;

@end

@implementation TabBarController
@synthesize homeBtn = _homeBtn;
@synthesize settingsBtn = _settingsBtn;
@synthesize myAdsBtn = _myAdsBtn;
@synthesize aboutBtn = _aboutBtn;

@synthesize homeBtnRect = _homeBtnRect;
@synthesize settingsBtnRect = _settingsBtnRect;
@synthesize myAdsBtnRect = _myAdsBtnRect;
@synthesize aboutBtnRect = _aboutBtnRect;

@synthesize aboutBtnNormalImage = _aboutBtnNormalImage;
@synthesize aboutBtnSelectedImage = _aboutBtnSelectedImage;
@synthesize settingsBtnNormalImage = _settingsBtnNormalImage;
@synthesize settingsBtnSelectedImage = _settingsBtnSelectedImage;
@synthesize myAdsBtnNormalImage = _myAdsBtnNormalImage;
@synthesize myAdsBtnSelectedImage = _myAdsBtnSelectedImage;
@synthesize homeBtnNormalImage = _homeBtnNormalImage;
@synthesize homeBtnSelectedImage = _homeBtnSelectedImage;

- (id)init {
    self = [super init];
    if (self) {
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            [self adjustViewForiPhone];
        } else {
            [self adjustViewForiPad];
        }
        
        [self.view addSubview:self.homeBtn];
        [self.view addSubview:self.settingsBtn];
        [self.view addSubview:self.myAdsBtn];
        [self.view addSubview:self.aboutBtn];
        
        
        UINavigationController *homeNavigation = [[UINavigationController alloc] initWithRootViewController:homeController];
        UINavigationController *myAdsNavigation = [[UINavigationController alloc] initWithRootViewController:myAdsController];
        
        self.viewControllers = [NSArray arrayWithObjects:aboutController, settingsController, myAdsNavigation, homeNavigation, nil];
        
        [self setSelectedViewController:self.viewControllers.lastObject];
        
        [aboutController release];
        [settingsController release];
        [myAdsController release];
        [homeController release];
        
        [homeNavigation release];
        [myAdsNavigation release];
    }
    return self;
    
}

#pragma mark - Buttons Getters
#define OFFSET [UIScreen mainScreen].bounds.size.height - 50
-(CGRect)homeBtnRect {
    if (CGRectIsEmpty(_homeBtnRect)) {
        _homeBtnRect = CGRectMake(240, OFFSET, 80, 50);
    }
    return _homeBtnRect;
}

-(CGRect)myAdsBtnRect {
    if (CGRectIsEmpty(_myAdsBtnRect)) {
        _myAdsBtnRect = CGRectMake(160, OFFSET, 80, 50);
    }
    return _myAdsBtnRect;
}

-(CGRect)settingsBtnRect {
    if (CGRectIsEmpty(_settingsBtnRect)) {
        _settingsBtnRect = CGRectMake(80, OFFSET, 80, 50);
    }
    return _settingsBtnRect;
}

-(CGRect)aboutBtnRect {
    if (CGRectIsEmpty(_aboutBtnRect)) {
        _aboutBtnRect = CGRectMake(0, OFFSET, 80, 50);
    }
    return _aboutBtnRect;
}

-(UIButton *)homeBtn {
    if (!_homeBtn) {
        _homeBtn = [[UIButton alloc] init];
        [self setButton:_homeBtn 
              withFrame:self.homeBtnRect 
        withNormalImage:self.homeBtnNormalImage 
       andSelectedImage:self.homeBtnSelectedImage 
                withTag:3 
            andSelector:@selector(tabBarButtonTouched:)];
        [_homeBtn setSelected:YES];
    }
    return _homeBtn;
}

-(UIButton *)myAdsBtn {
    if (!_myAdsBtn) {
        _myAdsBtn = [[UIButton alloc] init];
        [self setButton:_myAdsBtn 
              withFrame:self.myAdsBtnRect 
        withNormalImage:self.myAdsBtnNormalImage 
       andSelectedImage:self.myAdsBtnSelectedImage 
                withTag:2 
            andSelector:@selector(tabBarButtonTouched:)];
    }
    return  _myAdsBtn;
}

-(UIButton *)settingsBtn {
    if (!_settingsBtn) {
        _settingsBtn = [[UIButton alloc] init];
        [self setButton:_settingsBtn 
              withFrame:self.settingsBtnRect 
        withNormalImage:self.settingsBtnNormalImage 
       andSelectedImage:self.settingsBtnSelectedImage
                withTag:1 
            andSelector:@selector(tabBarButtonTouched:)];
    }
    return _settingsBtn;
}

-(UIButton *)aboutBtn {
    if (!_aboutBtn) {
        _aboutBtn = [[UIButton alloc] init];
        [self setButton:_aboutBtn 
              withFrame:self.aboutBtnRect 
        withNormalImage:self.aboutBtnNormalImage 
       andSelectedImage:self.aboutBtnSelectedImage 
                withTag:0 
            andSelector:@selector(tabBarButtonTouched:)];
    }
    return _aboutBtn;
}
#pragma mark - Actions

-(void)tabBarButtonTouched:(UIButton *)sender {
    switch (sender.tag) {
        case 0:
            [self.aboutBtn setSelected:YES];
            [self.settingsBtn setSelected:NO];
            [self.myAdsBtn setSelected:NO];
            [self.homeBtn setSelected:NO];
            break;
        case 1:
            [self.aboutBtn setSelected:NO];
            [self.settingsBtn setSelected:YES];
            [self.myAdsBtn setSelected:NO];
            [self.homeBtn setSelected:NO];
            break;
        case 2:
            [self.aboutBtn setSelected:NO];
            [self.settingsBtn setSelected:NO];
            [self.myAdsBtn setSelected:YES];
            [self.homeBtn setSelected:NO];
            break;
        case 3:
            [self.aboutBtn setSelected:NO];
            [self.settingsBtn setSelected:NO];
            [self.myAdsBtn setSelected:NO];
            [self.homeBtn setSelected:YES];
            break;
            
        default:
            break;
    }
    [self setSelectedIndex:sender.tag];
}

-(void)setButton:(UIButton *)aButton withFrame:(CGRect)aFrame withNormalImage:(UIImage *)normalImage andSelectedImage:(UIImage *)selectedImage withTag:(NSInteger)aTag andSelector:(SEL)aSelector {
    [aButton setFrame:aFrame];
    [aButton setTag:aTag];
    [aButton setBackgroundImage:normalImage forState:UIControlStateNormal];
    [aButton setBackgroundImage:selectedImage forState:UIControlStateSelected];
    [aButton addTarget:self action:aSelector forControlEvents:UIControlEventTouchUpInside];
}

-(void)adjustViewForiPhone {
    
    self.aboutBtnNormalImage = [UIImage imageNamed:@"About_iPhone.png"];
    self.settingsBtnNormalImage = [UIImage imageNamed:@"Options_iPhone.png"];
    self.myAdsBtnNormalImage = [UIImage imageNamed:@"Ads_iPhone.png"];
    self.homeBtnNormalImage = [UIImage imageNamed:@"Home_iPhone.png"];
    
    self.aboutBtnSelectedImage = [UIImage imageNamed:@"AboutHover_iPhone.png"];
    self.settingsBtnSelectedImage = [UIImage imageNamed:@"OptionsHover_iPhone.png"];
    self.myAdsBtnSelectedImage = [UIImage imageNamed:@"AdsHover_iPhone.png"];
    self.homeBtnSelectedImage = [UIImage imageNamed:@"HomeHover_iPhone.png"];
    
    
    homeController = [[MainMenu alloc] initWithNibName:@"MainMenu_iPhone" bundle:nil];
    myAdsController = [[UserAdds alloc] initWithNibName:@"UserAdds_iPhone" bundle:nil];
    settingsController = [[Settings alloc] initWithNibName:@"Settings" bundle:nil];
    aboutController = [[AboutTheApplication alloc] initWithNibName:@"AboutTheApplication_iPhone" bundle:nil];
}

-(void)adjustViewForiPad {
    
    
    self.aboutBtnNormalImage = [UIImage imageNamed:@"About_iPad.png"];
    self.settingsBtnNormalImage = [UIImage imageNamed:@"Options_iPad.png"];
    self.myAdsBtnNormalImage = [UIImage imageNamed:@"Ads_iPad.png"];
    self.homeBtnNormalImage = [UIImage imageNamed:@"Home_iPad.png"];
    
    self.aboutBtnSelectedImage = [UIImage imageNamed:@"AboutHover_iPad.png"];
    self.settingsBtnSelectedImage = [UIImage imageNamed:@"OptionsHover_iPad.png"];
    self.myAdsBtnSelectedImage = [UIImage imageNamed:@"AdsHover_iPad.png"];
    self.homeBtnSelectedImage = [UIImage imageNamed:@"HomeHover_iPad.png"];
    
    self.aboutBtnRect    = CGRectMake(0, 970, 192, 54);
    self.settingsBtnRect = CGRectMake(192, 970, 192, 54);
    self.myAdsBtnRect    = CGRectMake(384, 970, 192, 54);
    self.homeBtnRect     = CGRectMake(576, 970, 192, 54);
    
    homeController = [[MainMenu alloc] initWithNibName:@"MainMenu_iPad" bundle:nil];
    myAdsController = [[UserAdds alloc] initWithNibName:@"UserAdds_iPad" bundle:nil];
    settingsController = [[Settings alloc] initWithNibName:@"Settings_iPad" bundle:nil];
    aboutController = [[AboutTheApplication alloc] initWithNibName:@"AboutTheApplication_iPad" bundle:nil];
}
@end
