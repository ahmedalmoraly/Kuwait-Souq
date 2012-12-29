//
//  LoginPage.m
//  Mosta3mal
//
//  Created by Islam on 11/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LoginPage.h"
#import <QuartzCore/QuartzCore.h>
#import "RegisterationAgreement.h"
#import "NetworkOperations.h"
#import "MainMenu.h"

NSString* UserIsLoggedIn = @"UserIsLoggedIn";

@implementation LoginPage

@synthesize lbl_password, lbl_userName, txt_password, txt_userName, btn_login, btn_cancel, loginView, lbl_loginWord, btn_register;

- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

-(IBAction) btn_Pressed:(UIButton *)sender {
    RegisterationAgreement *_regAgr;
    if (iPhone) {
        _regAgr = [[RegisterationAgreement alloc] initWithNibName:@"RegisterationAgreement_iPhone" bundle:nil];
    }
    else {
        _regAgr = [[RegisterationAgreement alloc] initWithNibName:@"RegisterationAgreement_iPad" bundle:nil];
    }
    
    UIAlertView *_alert = [[UIAlertView alloc] initWithTitle:@"دخول البرنامج" message:@"من فضلك راجع المدخلات ثانية" delegate:nil cancelButtonTitle:@"تم" otherButtonTitles:nil, nil];
    
    UIAlertView *_alert2 = [[UIAlertView alloc] initWithTitle:@"دخول البرنامج" message:@"تم الدخول بنجاح" delegate:nil cancelButtonTitle:@"تم" otherButtonTitles:nil, nil];

    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
    NSLog(@"Device: %@", token);

    NSDictionary *_dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"8", @"action", txt_userName.text, @"user", txt_password.text, @"password", token, @"device", nil];
    
    switch (sender.tag) {
        case 1:
            
            [NetworkOperations POSTResponseWithURL:@"" andParameters:_dic success:^(id response) {
                //NSLog(@"response in login %@", response);
                if ([[[response objectAtIndex:0] objectAtIndex:0] intValue] == 0) {
                    [_alert show];
                    [_alert release];
                } 
                else {
                    //NSLog(@"%@", response);
                    userLoginState = YES;
                    _userID = [[response objectAtIndex:0] objectAtIndex:0];
                    [_alert2 show];
                    
                    [LoginPage saveUsername:txt_userName.text andPassword:txt_password.text];
                    
                    [(MainMenu *)[self viewController] updateLoginButtonWithLoginState:YES];
                    [self performSelectorInBackground:@selector(loadUserInfo) withObject:nil];
                    [self removeFromSuperview];
                }
                
            } failure:^(NSHTTPURLResponse *urlResponse, NSError *error) {
                NSLog(@"[ERROR]: %@", [error description] );
            }];            
            
            break;
            
        case 2:
            [self removeFromSuperview];
            break;
            
        case 3:
            [[[self viewController] navigationController] pushViewController:_regAgr animated:YES];
            break;
            
        default:
            break;
    }
    
}

-(UIButton *)createButton :(CGRect)_frame :(UIImage *)normalImage :(UIImage *)selectedImage :(UIImage *)highlightedImage :(NSInteger) btn_tag :(UIColor *)textColor :(NSString *)btn_text {
    UIButton *newButton = [[[UIButton alloc] initWithFrame:_frame] autorelease];
    [newButton setBackgroundImage:normalImage forState:UIControlStateNormal];
    [newButton setBackgroundImage:selectedImage forState:UIControlStateSelected];
    [newButton setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
    [newButton setTitle:btn_text forState:UIControlStateNormal];
    [newButton setTitle:btn_text forState:UIControlStateSelected];
    [newButton setTitle:btn_text forState:UIControlStateHighlighted];
    [newButton setTitleColor:textColor forState:UIControlStateNormal];
    [newButton setTitleColor:textColor forState:UIControlStateSelected];
    [newButton setTitleColor:textColor forState:UIControlStateHighlighted];
    [newButton setTag:btn_tag];
    [newButton addTarget:self action:@selector(btn_Pressed:) forControlEvents:UIControlEventTouchUpInside];
    [loginView addSubview:newButton];
    return newButton;
}

-(UITextField *) createTextField :(CGRect)_frame :(UIImage *)normalImage :(NSString *)placeHolderText :(BOOL)setSecure {
    UITextField *newTextField = [[[UITextField alloc] initWithFrame:_frame] autorelease];
    [newTextField setBackground:normalImage];
    [newTextField setPlaceholder:placeHolderText];
    [newTextField setTextAlignment:UITextAlignmentCenter];
    [newTextField setSecureTextEntry:setSecure];
    [newTextField setKeyboardAppearance:UIKeyboardAppearanceAlert];
    [loginView addSubview:newTextField];
    return newTextField;
}

-(UILabel *) createLabel :(CGRect)_frame :(NSString *)labelText :(UIColor *)textColor {
    UILabel *newLebel = [[[UILabel alloc] initWithFrame:_frame] autorelease];
    [newLebel setText:labelText];
    [newLebel setTextColor:textColor];
    [newLebel setBackgroundColor:[UIColor clearColor]];
    [loginView addSubview:newLebel];
    return newLebel;
}

-(void) blackBG :(NSTimer *)timer {
    self.backgroundColor = [UIColor blackColor];
    [self setAlpha:0.7];
    [self addSubview:loginView];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (iPhone) {
            loginView = [[UIView alloc] initWithFrame:CGRectMake(30, 80, 265, 295)];
            loginView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"LoginBG_iPhone.png"]];
        }
        else {
            loginView = [[UIView alloc] initWithFrame:CGRectMake(210, 328, 348, 346)];
            loginView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"LoginBG_iPad.png"]];
        }
        
        [loginView.layer setCornerRadius:25.0];
        [loginView.layer setMasksToBounds:YES];
        [loginView setTransform:CGAffineTransformMakeScale(0.1, 0.1)];
        UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        [self addSubview:view];
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:loginView];
        
        [UIView animateWithDuration:0.4 animations:^(void) {
            [loginView setTransform:CGAffineTransformMakeScale(1, 1)];
        } ];
    }
    return self;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (iPhone) {
        if (textField == txt_password) {
            [loginView setTransform:CGAffineTransformMakeTranslation(0, -40)];
        }
    }
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (iPhone) {
        if (textField == txt_password) {
            [loginView setTransform:CGAffineTransformMakeTranslation(0, 0)];
        }
    }
    return YES;
}

- (void)drawRect:(CGRect)rect
{
    if (iPhone) {
        lbl_loginWord = [self createLabel:CGRectMake(89, 8, 90, 21) :@"تسجيل الدخول" :[UIColor whiteColor]];
        lbl_userName = [self createLabel:CGRectMake(167, 49, 87, 21) :@"إسم المستخدم" :[UIColor blackColor]];
        txt_userName = [self createTextField:CGRectMake(15, 78, 239, 31) :[UIImage imageNamed:@"txtBox_iPhone.png"] :@"أدخل إسم المستخدم من فضلك" :NO]; 
        lbl_password = [self createLabel:CGRectMake(186, 111, 66, 21) :@"كلمة المرور" :[UIColor blackColor]];
        txt_password = [self createTextField:CGRectMake(15, 144, 239, 31) :[UIImage imageNamed:@"txtBox_iPhone.png"] :@"أدخل كلمة المرور من فضلك" :YES];
        
        btn_login = [self createButton:CGRectMake(176, 189, 78, 34) 
                                      :[UIImage imageNamed:@"LoginBtn_iPhone.png"] 
                                      :[UIImage imageNamed:@"LoginBtnHover_iPhone.png"] 
                                      :[UIImage imageNamed:@"LoginBtnHover_iPhone.png"] 
                                      :1 
                                      :[UIColor whiteColor] 
                                      :@"دخول"];
        
        btn_cancel = [self createButton:CGRectMake(13, 189, 78, 34) 
                                       :[UIImage imageNamed:@"LoginBtn_iPhone.png"] 
                                       :[UIImage imageNamed:@"LoginBtnHover_iPhone.png"] 
                                       :[UIImage imageNamed:@"LoginBtnHover_iPhone.png"]
                                       :2 
                                       :[UIColor whiteColor] 
                                       :@"إلغاء"];
        
        btn_register = [self createButton:CGRectMake(30, 240, 265, 21) :[UIImage imageNamed:@""] :[UIImage imageNamed:@""] :[UIImage imageNamed:@""] :3 :[UIColor blackColor] :@"مستخدم جديد ؟ سجل الأن!"];
        btn_register.titleLabel.textColor = [UIColor blueColor];

    }
    
    else {
        lbl_loginWord = [self createLabel:CGRectMake(128, 9, 89, 21) :@"تسجيل الدخول" :[UIColor whiteColor]];
        lbl_userName = [self createLabel:CGRectMake(251, 61, 104, 21) :@"إسم المستخدم" :[UIColor blackColor]];
        txt_userName = [self createTextField:CGRectMake(21, 96, 309, 31) :[UIImage imageNamed:@"txtBox_iPad.png"] :@"أدخل إسم المستخدم من فضلك" :NO];
        lbl_password = [self createLabel:CGRectMake(263, 138, 67, 21) :@"كلمة المرور" :[UIColor blackColor]];
        txt_password = [self createTextField:CGRectMake(21, 172, 309, 31) :[UIImage imageNamed:@"txtBox_iPad.png"] :@"أدخل كلمة المرور من فضلك" :YES];
        btn_login = [self createButton:CGRectMake(263, 221, 72, 37) 
                                      :[UIImage imageNamed:@"LoginBtn_iPad.png"] :[UIImage imageNamed:@"LoginBtnHover_iPad.png"] :[UIImage imageNamed:@"LoginBtnHover_iPad.png"] :1 :[UIColor whiteColor] :@"دخول"];
        btn_cancel = [self createButton:CGRectMake(21, 221, 72, 37) 
                                       :[UIImage imageNamed:@"LoginBtn_iPad.png"] :[UIImage imageNamed:@"LoginBtnHover_iPad.png"] :[UIImage imageNamed:@"LoginBtnHover_iPad.png"] :2 :[UIColor whiteColor] :@"إلغاء"];
        
        btn_register = [self createButton:CGRectMake(82, 266, 185, 37) :[UIImage imageNamed:@""] :[UIImage imageNamed:@""] :[UIImage imageNamed:@""] :3 :[UIColor blueColor] :@"مستخدم جديد ؟ سجل الأن!"];
    }
    txt_userName.delegate = self;
    txt_password.delegate = self;
}

- (void)dealloc
{
    [lbl_password release];
    lbl_password = nil;
    [lbl_userName release];
    lbl_userName = nil;
    [txt_password release];
    txt_password = nil;
    [txt_userName release];
    txt_userName = nil;
    [btn_login release];
    btn_login = nil;
    [btn_cancel release];
    btn_cancel = nil;
    [loginView release];
    loginView = nil;
    [super dealloc];
}

-(void)loadUserInfo {
    userInfo = [[NSMutableDictionary alloc] init];
    [NetworkOperations POSTResponseWithURL:@"" andParameters:[NSDictionary dictionaryWithObjectsAndKeys:@"11", @"action", _userID, @"id", nil] success:^(id response) {
        
        NSArray *temp = [response lastObject];
        [userInfo setObject:[temp objectAtIndex:0] forKey:@"id"];
        [userInfo setObject:[temp objectAtIndex:1] forKey:@"username"];
        [userInfo setObject:[temp objectAtIndex:2] forKey:@"password"];
        [userInfo setObject:[temp objectAtIndex:3] forKey:@"email"];
        [userInfo setObject:[temp objectAtIndex:4] forKey:@"joinDate"];
        [userInfo setObject:[temp objectAtIndex:5] forKey:@"mobile"];
        [userInfo setObject:[temp objectAtIndex:6] forKey:@"phone"];
        
        //NSLog(@"UserInfo: %@", userInfo);
        
    } failure:^(NSHTTPURLResponse *urlResponse, NSError *error) {
        NSLog(@"[ERROR]: %@", error.description);
    }];
}

+(void)loginWithUsername:(NSString *)username andPassword:(NSString *)password andDevice:(NSString *)device {
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:@"8", @"action", username, @"user", password, @"password", device, @"device", nil];

    [NetworkOperations POSTResponseWithURL:@"" andParameters:parameters success:^(id response) {
//        NSLog(@"response in login %@", response);
        if ([response count]) {
            if ([[[response objectAtIndex:0] objectAtIndex:0] intValue] == 0) {
                
                [[[[UIAlertView alloc] initWithTitle:@"دخول البرنامج" message:@"من فضلك راجع المدخلات ثانية" delegate:nil cancelButtonTitle:@"تم" otherButtonTitles:nil] autorelease] show];
            } 
            else {
                userLoginState = YES;
                _userID = [[response objectAtIndex:0] objectAtIndex:0];
                [[[[UIAlertView alloc] initWithTitle:@"دخول البرنامج" message:@"تم الدخول بنجاح" delegate:nil cancelButtonTitle:@"تم" otherButtonTitles:nil] autorelease] show];
                [LoginPage saveUsername:username andPassword:password];
                [[[[LoginPage alloc] init] autorelease] loadUserInfo];
                [[NSNotificationCenter defaultCenter] postNotificationName:UserIsLoggedIn object:nil];
            }
            
        }
        
    } failure:^(NSHTTPURLResponse *urlResponse, NSError *error) {
        NSLog(@"[ERROR]: %@", error.description);
        [[[[UIAlertView alloc] initWithTitle:@"دخول البرنامج" message:@"من فضلك تأكد من وجود الانترنت" delegate:nil cancelButtonTitle:@"تم" otherButtonTitles:nil] autorelease] show];
    }];
    
}

+(void)saveUsername:(NSString *)user andPassword:(NSString *)password {
    [[NSUserDefaults standardUserDefaults] setObject:user forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"password"];
}

@end
