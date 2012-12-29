//
//  MainMenu.h
//  Mosta3mal
//
//  Created by Islam on 11/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Categories.h"
#import "LoginPage.h"
#import "Add Ads.h"
#import "Registeration.h"
#import "Settings.h"
#import "SearchViewController.h"

@interface MainMenu : UIViewController <UIAlertViewDelegate>{
    IBOutlet UIButton *btn_left;
    IBOutlet UIButton *btn_right;
    IBOutlet UIButton *btn_up;
    IBOutlet UIButton *btn_down;
    
    Add_Ads *adds;
    LoginPage *login;
    Categories *category;
    SearchViewController *searchController;

}

@property (nonatomic, retain) UIButton *btn_left;
@property (nonatomic, retain) UIButton *btn_right;
@property (nonatomic, retain) UIButton *btn_up;
@property (nonatomic, retain) UIButton *btn_down;

-(IBAction) rotate :(UIButton *)sender;
-(IBAction)fireEvent :(UIButton *)sender;
-(void)updateLoginButtonWithLoginState:(BOOL)logedin;
-(void)userLoginStateDidChanged;
- (IBAction)registerationBtnTouched:(id)sender;
@end
