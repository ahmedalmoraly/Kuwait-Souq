//
//  About.h
//  Mosta3mal
//
//  Created by Islam on 11/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface AboutTheApplication : UIViewController <MFMailComposeViewControllerDelegate>{
    
}
-(IBAction)launchMailComposer;
-(IBAction)goToLascivio:(UIButton *)sender;
@end
