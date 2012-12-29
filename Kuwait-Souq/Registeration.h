//
//  Registration.h
//  Mosta3mal
//
//  Created by Islam on 11/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterPage.h"

@interface Registeration : MasterPage <UITextFieldDelegate> {
    
    IBOutlet UITextField *txt_userName;
    IBOutlet UITextField *txt_phone;
    IBOutlet UITextField *txt_cell;
    IBOutlet UITextField *txt_password;
    IBOutlet UITextField *txt_passwordValid;
    IBOutlet UITextField *txt_email;
    IBOutlet UITextField *txt_emailValid;
    IBOutlet UIScrollView *_scrollView;
}
- (IBAction)makeKeyboardDisapear :(UITextField *) txt_fields;
- (IBAction)makeRegister;
@end
