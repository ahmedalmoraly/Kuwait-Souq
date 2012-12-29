//
//  MasterPage.h
//  Mosta3mal
//
//  Created by Islam on 11/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface MasterPage : UIViewController <MFMailComposeViewControllerDelegate>{
    
    UIButton *btnRecent;
    UIButton *btnContactUs;

    IBOutlet UIImageView * myView;
    IBOutlet UIButton* btn_search;
    IBOutlet UIButton* btn_back;
    UIButton *_prevButton;
}

@property (nonatomic, retain) UIButton *btnRecent;
@property (nonatomic, retain) UIButton *btnContactUs;
@property (nonatomic, retain) IBOutlet UIView* myView;
@property (nonatomic, retain) IBOutlet UIButton* btn_search;
@property (nonatomic, retain) IBOutlet UIButton* btn_back;

@property (nonatomic, retain) UITabBarController *tabBarController;

@property (nonatomic, retain) UIWindow *_window;

@property (nonatomic, retain) IBOutlet UIViewController *addsWindow;
@property (nonatomic, retain) IBOutlet UIViewController *seetingsWindow;

@property (nonatomic, retain) UINavigationController *tabBarNavigationController_Adds;
@property (nonatomic, retain) UINavigationController *tabBarNavigationController_Seetings;

-(IBAction) tabBarPreesed :(UIButton *)sender;

-(void)launchMailComposer;

@end
