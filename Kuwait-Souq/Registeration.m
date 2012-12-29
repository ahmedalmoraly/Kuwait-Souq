//
//  Registration.m
//  Mosta3mal
//
//  Created by Islam on 11/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Registeration.h"
#import "NetworkOperations.h"
#import "Global.h"
#import "LoginPage.h"

@implementation Registeration

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
    [txt_userName release];
    [txt_phone release];
    [txt_cell release];
    [txt_password release];
    [txt_passwordValid release];
    [txt_email release];
    [txt_emailValid release];
    [_scrollView release];
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
    [_scrollView setScrollEnabled:YES];
    [_scrollView setContentSize:CGSizeMake(320, 610)];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [txt_userName release];
    txt_userName = nil;
    [txt_phone release];
    txt_phone = nil;
    [txt_cell release];
    txt_cell = nil;
    [txt_password release];
    txt_password = nil;
    [txt_passwordValid release];
    txt_passwordValid = nil;
    [txt_email release];
    txt_email = nil;
    [txt_emailValid release];
    txt_emailValid = nil;
    [_scrollView release];
    _scrollView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == txt_email) {
        [_scrollView setTransform:CGAffineTransformMakeTranslation(0, -40)];
    }
    
    else if (textField == txt_emailValid) {
        [_scrollView setTransform:CGAffineTransformMakeTranslation(0, -110)];
    }
    
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (textField == txt_email) {
        [_scrollView setTransform:CGAffineTransformMakeTranslation(0, 0)];
        //[_scrollView setContentSize:CGSizeMake(320, 900)];
    }
    
    else if (textField == txt_emailValid) {
        [_scrollView setTransform:CGAffineTransformMakeTranslation(0, 0)];
        //[_scrollView setContentSize:CGSizeMake(320, 900)];
    }
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;
}

- (IBAction)makeKeyboardDisapear :(UITextField *) txt_fields {
    [txt_fields resignFirstResponder];
}

- (IBAction)makeRegister {
    
    NSString *emailRegEx =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    
    NSPredicate *predicate;
    predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    BOOL emailFlag = NO;
    BOOL userNameFlag = NO;
    BOOL passwordFlag = NO;
    
    if (([txt_email.text isEqualToString:txt_emailValid.text]) && [predicate evaluateWithObject:txt_email.text]) {
        emailFlag = YES;
    }
    if ([txt_password.text isEqualToString:txt_passwordValid.text]) {
        passwordFlag = YES;
    }
    if (![txt_userName.text isEqualToString:@""]) {
        userNameFlag = YES;
    }
    
    NSDictionary *_dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"7", @"action", txt_userName.text, @"user", txt_password.text, @"password", txt_email.text, @"email", txt_phone.text, @"phone", @" ", @"mobile", nil];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"تسجيل البرنامج" message:@"من فضلك راجع البيانات مجددا" delegate:nil cancelButtonTitle:@"تم" otherButtonTitles:nil, nil];
    UIAlertView *_alert = [[[UIAlertView alloc] initWithTitle:@"تسجيل البرنامج" message:@"تم التسجيل بنجاح" delegate:nil cancelButtonTitle:@"تم" otherButtonTitles:nil, nil] autorelease];
    
    if (userNameFlag && emailFlag && passwordFlag) {
        
        [NetworkOperations POSTResponseWithURL:@"" andParameters:_dic success:^(id response) {
            NSLog(@"Register : %@", response);
            if ([[[response objectAtIndex:0] objectAtIndex:0] intValue]== 1) {
                userLoginState = true;
                [_alert show];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            
            else if ([[[response objectAtIndex:0] objectAtIndex:0] intValue]== 0) {
                [alert show];
                [alert release];
            }
            
            
            switch ([[[response objectAtIndex:0] objectAtIndex:0] intValue]) {
                case 0:
                    [alert show];
                    [alert release];
                    break;
                case 1:
                    //userLoginState = true;
                    
                    [_alert show];
                    
                    [LoginPage loginWithUsername:txt_userName.text andPassword:txt_password.text andDevice:[[NSUserDefaults standardUserDefaults] stringForKey:@"deviceToken"]];
                    
                    [self.navigationController popToRootViewControllerAnimated:YES];

                    break;
                case 2:
                    alert.message = @" عفواً الاسم الذى ادخلته غير متاح ، برحاء اختيار اسم اخر";
                    [alert show];
                    [alert release];
                    break;
                case 3:
                    alert.message = @"عفواً ، البريد الالكتروني الذى ادخلته موجود بالفعل ، من فضلك اعد التسجيل بحساب اخر آخر";
                    [alert show];
                    [alert release];
                    break;
                default:
                    break;
            }
            
        } failure:^(NSHTTPURLResponse *urlResponse, NSError *error) {
            NSLog(@"[ERROR]: %@", [error description] );
        }];
    }
    
    else {
        [alert show];
        [alert release];
    }
}


@end
