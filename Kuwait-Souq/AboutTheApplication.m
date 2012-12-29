//
//  About.m
//  Mosta3mal
//
//  Created by Islam on 11/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AboutTheApplication.h"


@implementation AboutTheApplication

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
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(IBAction)launchMailComposer {
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    if (![[picker class] canSendMail]) {
        
        NSString *recipients = @"mailto:first@example.com";
        
        recipients = [recipients stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:recipients]];
        
        return;
    }
	picker.mailComposeDelegate = self;
	
	// Set up recipients
	NSArray *toRecipients = [NSArray arrayWithObject:@"info@sooqalq8.com"]; 
    
	
	[picker setToRecipients:toRecipients];
	
	// Attach an image to the email
	
	[self presentModalViewController:picker animated:YES];
    [picker release];
    
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{	
	[self dismissModalViewControllerAnimated:YES];
}

-(void)goToLascivio:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://lascivio.co/ar/mobile"]];
}
@end
