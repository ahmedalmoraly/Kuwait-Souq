//
//  MasterPage.m
//  Mosta3mal
//
//  Created by Islam on 11/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MasterPage.h"
#import "SearchResult.h"
#import "Products.h"
#import "AboutTheApplication.h"
#import "Products.h"
#import "UserAdds.h"
#import "Settings.h"
#import "SearchViewController.h"
#import "RecentViewController.h"

@implementation MasterPage

@synthesize myView, btn_search, btn_back, btnRecent, btnContactUs;
@synthesize addsWindow, seetingsWindow, tabBarNavigationController_Adds, tabBarNavigationController_Seetings, _window;
@synthesize tabBarController;

-(IBAction) tabBarPreesed:(UIButton *)sender {
    
    SearchViewController *searchController;
    RecentViewController *recent;
    
    [_prevButton setSelected:NO];
    switch (sender.tag) {
                    
        case 5:
            [self.navigationController popViewControllerAnimated:YES];
            break;
            
        case 6:
            if (iPhone) {
                searchController = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
            } else {
                searchController = [[SearchViewController alloc] initWithNibName:@"SearchViewController_iPad" bundle:nil];
            }
            [self presentModalViewController:searchController animated:YES];
            break;
            
        case 7:
            [self launchMailComposer];
            break;
            
        case 8:
            recent = [[RecentViewController alloc] initWithNibName:@"RecentViewController" bundle:nil];
            [self presentModalViewController:recent animated:YES];
            break;
            
        default:
            break;
    }
    
}

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

    [myView release];
    myView = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */


-(UIButton *) addButton:(CGRect)_frame normalImage:(UIImage *)_image highlightImage:(UIImage *) _highImage selectedImage:(UIImage *) _selectedImage :(NSInteger)_tag {
    UIButton *newButton = [[[UIButton alloc] initWithFrame:_frame] autorelease];
    [newButton setBackgroundImage:_image forState:UIControlStateNormal];
    [newButton setBackgroundImage:_highImage forState:UIControlStateHighlighted];
    [newButton setBackgroundImage:_selectedImage forState:UIControlStateSelected];
    [newButton setTag:_tag];
    [newButton addTarget:self action:@selector(tabBarPreesed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:newButton];
    return newButton;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tabBarController = [[UITabBarController alloc] init];
    
    if (iPhone) {
        
        myView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 63)];
        [myView setImage:[UIImage imageNamed:@"Header_iPhone.png"]];
        [self.view addSubview:myView];
        
        btn_back = [self addButton:CGRectMake(10, 20, 40, 40) normalImage:[UIImage imageNamed:@"BackBtn_iPhone.png"] highlightImage:[UIImage imageNamed:@"BackBtnHover_iPhone.png"] selectedImage:[UIImage imageNamed:@"BackBtnHover_iPhone.png"] :5];
        
        btn_search = [self addButton:CGRectMake(55, 20, 40, 40) normalImage:[UIImage imageNamed:@"SearchBtn_iPhone.png"] highlightImage:[UIImage imageNamed:@"SearchBtnHover_iPhone.png"] selectedImage:[UIImage imageNamed:@"SearchBtnHover_iPhone.png"] :6];
        
        btnContactUs = [self addButton:CGRectMake(275, 20, 40, 40) normalImage:[UIImage imageNamed:@"ContactUsBtn_iPhone.png"] highlightImage:[UIImage imageNamed:@"ContactUsBtnHover_iPhone.png"] selectedImage:[UIImage imageNamed:@"ContactUsBtnHover_iPhone.png"] :7];
        
        btnRecent = [self addButton:CGRectMake(230, 20, 40, 40) normalImage:[UIImage imageNamed:@"label_blue_new.png"] highlightImage:nil selectedImage:nil :8];
        
        
    }
    
    else {
        
        myView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 768, 150)];
        [myView setImage:[UIImage imageNamed:@"Header_iPad.png"]];
        [self.view addSubview:myView];
        
        btn_back = [self addButton:CGRectMake(20, 85, 51, 51) normalImage:[UIImage imageNamed:@"BackBtn_iPad.png"] highlightImage:[UIImage imageNamed:@"BackBtnHover_iPad.png"] selectedImage:[UIImage imageNamed:@"BackBtnHover_iPad.png"] :5];
        
        btn_search = [self addButton:CGRectMake(89, 85, 51, 51) normalImage:[UIImage imageNamed:@"SearchBtn_iPad.png"] highlightImage:[UIImage imageNamed:@"SearchBtnHover_iPad.png"] selectedImage:[UIImage imageNamed:@"SearchBtnHover_iPad.png"] :6];
        btnContactUs = [self addButton:CGRectMake(631, 85, 51, 51) normalImage:[UIImage imageNamed:@"ContactUsBtn_iPad.png"] highlightImage:[UIImage imageNamed:@"ContactUsBtnHover_iPad.png"] selectedImage:[UIImage imageNamed:@"ContactUsBtnHover_iPad.png"] :7];
        
        btnRecent = [self addButton:CGRectMake(697, 85, 51, 51) normalImage:[UIImage imageNamed:@"label_blue_new.png"] highlightImage:[UIImage imageNamed:@"label_blue_new.png"] selectedImage:[UIImage imageNamed:@"label_blue_new.png"] :8];
        
    }
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)launchMailComposer {
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


@end
