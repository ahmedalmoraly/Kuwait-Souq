//
//  RegisterationAgreement.m
//  Sooq
//
//  Created by Islam on 11/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RegisterationAgreement.h"
#import "Registeration.h"
#import "Global.h"

@implementation RegisterationAgreement

- (IBAction)btn_selected:(UIButton *)sender {
    
    Registeration *_reg;
    
    switch (sender.tag) {
        case 1:
            if (iPhone) {
                _reg = [[Registeration alloc] initWithNibName:@"Registeration_iPhone" bundle:nil];
            }
            else {
                _reg = [[Registeration alloc] initWithNibName:@"Registeration_iPad" bundle:nil];
            }
            
            [self.navigationController pushViewController:_reg animated:YES];
            break;
            
        case 2:
            [self.navigationController popViewControllerAnimated:YES];
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
	return NO;
}

@end
