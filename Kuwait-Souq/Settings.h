//
//  Settings.h
//  Sooq
//
//  Created by Islam on 12/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Settings : UIViewController <UITextFieldDelegate>

@property (retain, nonatomic) IBOutlet UITextField *txt_tag;

- (IBAction)FireTagSaver;

@end
