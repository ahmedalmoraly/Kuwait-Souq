//
//  Add Ads.h
//  Mosta3mal
//
//  Created by Islam on 11/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterPage.h"

@interface Add_Ads : MasterPage <UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {

}

- (IBAction)FinishedBtnTouched:(id)sender;
- (IBAction)photoBtnTouceh:(id)sender;

@end
