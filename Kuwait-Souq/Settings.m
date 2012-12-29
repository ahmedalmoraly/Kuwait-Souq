#import "Settings.h"
#import "NetworkOperations.h"

@implementation Settings
@synthesize txt_tag;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[GoogleAdsController sharedManager] addAdContainerToView:self.view withParentViewController:self];
    [[GoogleAdsController sharedManager] layoutBannerViewsForCurrentOrientation:self.interfaceOrientation];
}

- (void)viewDidUnload
{
    [self setTxt_tag:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)FireTagSaver {
    
    UIAlertView *_alert = [[[UIAlertView alloc] initWithTitle:@"الإعدادات" message:@"تم الحفظ" delegate:nil cancelButtonTitle:@"تم" otherButtonTitles:nil, nil] autorelease];
    
    NSDictionary *_dic = [NSDictionary dictionaryWithObjectsAndKeys:@"30", @"action",txt_tag.text, @"tag",  nil];
    
    [NetworkOperations POSTResponseWithURL:@"" andParameters:_dic success:^(id response) {
        
        [_alert show];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    } failure:^(NSHTTPURLResponse *urlResponse, NSError *error) {
        NSLog(@"[ERROR]: %@", [error description] );
    }];
}

- (void)dealloc {
    [txt_tag release];
    [super dealloc];
}

#pragma mark - TextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(void)adjustViewForGoogleAdsView:(UIView *)adView {
}

@end
