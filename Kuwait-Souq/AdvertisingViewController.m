//
//  AdvertisingViewController.m
//  Kuwait-Souq
//
//  Created by Mac mini2 on 3/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AdvertisingViewController.h"
#import "NetworkOperations.h"

@interface AdvertisingViewController ()
@property (strong, nonatomic) NSArray *responseArray;
@end

@implementation AdvertisingViewController
@synthesize imageView;
@synthesize responseArray = _responseArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = self.imageView.frame;
    [self.view insertSubview:button aboveSubview:self.imageView];
    [button addTarget:self action:@selector(adButtonDidTouched) forControlEvents:UIControlEventTouchUpInside];
    
    [NetworkOperations POSTResponseWithURL:@"" andParameters:[NSDictionary dictionaryWithObject:@"17" forKey:@"action"] success:^(id response) {
        self.responseArray = response;
        [self.imageView setImageWithURL:[NSURL URLWithString:[[response objectAtIndex:0] objectAtIndex:0]]];
    } failure:^(NSHTTPURLResponse *urlResponse, NSError *error) {
        [self closeBtnTouched:nil];
    }];
    
}

- (void)viewDidUnload
{
    [self setImageView:nil];
    [self setResponseArray:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)dealloc {
    [_responseArray release];
    [imageView release];
    [super dealloc];
}
- (IBAction)closeBtnTouched:(id)sender {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
#else
    [self.parentViewController dismissModalViewControllerAnimated:YES];
#endif
}

-(void)adButtonDidTouched {
    // go to advertise website.
    
    NSURL *url = [NSURL URLWithString:[[self.responseArray objectAtIndex:0] objectAtIndex:1]];
    
    [[UIApplication sharedApplication] openURL:url];
    
}

@end
