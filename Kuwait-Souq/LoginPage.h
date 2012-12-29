//
//  LoginPage.h
//  Mosta3mal
//
//  Created by Islam on 11/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString* UserIsLoggedIn;

@interface LoginPage : UIView <UITextFieldDelegate> {
    IBOutlet UIView *loginView;
    IBOutlet UILabel *lbl_userName;
    IBOutlet UILabel *lbl_password;
    IBOutlet UITextField *txt_userName;
    IBOutlet UITextField *txt_password;
    IBOutlet UIButton *btn_login;
    IBOutlet UIButton *btn_cancel;
    IBOutlet UIButton *btn_register;
    IBOutlet UILabel *lbl_loginWord;
}

@property(nonatomic,retain) IBOutlet UIView *loginView;
@property(nonatomic, retain) IBOutlet UILabel *lbl_userName;
@property(nonatomic, retain) IBOutlet UILabel *lbl_password;
@property(nonatomic, retain) IBOutlet UILabel *lbl_loginWord;
@property(nonatomic, retain) IBOutlet UITextField *txt_userName;
@property(nonatomic, retain) IBOutlet UITextField *txt_password;
@property(nonatomic, retain) IBOutlet UIButton *btn_login;
@property(nonatomic, retain) IBOutlet UIButton *btn_cancel;
@property(nonatomic ,retain) IBOutlet UIButton *btn_register;

-(IBAction) btn_Pressed :(UIButton *)sender;
-(void)loadUserInfo;

+(void)loginWithUsername:(NSString *)username andPassword:(NSString *)password andDevice:(NSString *)device;
+(void)saveUsername:(NSString *)user andPassword:(NSString *)password;
@end
