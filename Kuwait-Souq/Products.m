#import "Products.h"
#import "ArabicCell.h"
#import "ProductDetails.h"
#import "Global.h"
#import "NetworkOperations.h"

#import "GADBannerView.h"
#import "GADRequest.h"

#define kAdUnitID @"a14ee61c950bf72";

@interface ProductData : NSObject

@property (nonatomic, strong) NSString* _id;
@property (nonatomic, strong) NSString *_proName;
@property (nonatomic, strong) NSString *_price;
@property (nonatomic, strong) NSString *_pictures;
@property (nonatomic, strong) NSString *_title;
@property (nonatomic, strong) NSString *_type;
@property (nonatomic, strong) NSString *_model;

@end

@implementation ProductData

@synthesize  _id, _model, _type, _title , _proName, _pictures, _price;

@end

@implementation Products
@synthesize activity_indicator = _activity_indicator;
@synthesize adBanner = _adBanner;

@synthesize _pro, _categoryTitle, prosNames, prosImages, _ProductsID;

- (void)dealloc
{
    [_activity_indicator release];
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
    /*
    prosNames = [[NSMutableArray alloc] initWithObjects:@"سيارة أمريكية فاخرة", @"شنطة جلد ساحرة", @"حذاء حريمي", nil];
    prosImages = [[NSMutableArray alloc] initWithObjects:@"10039620-natalia-sls2.jpg", @"B_Bulgari_Sp-Su09_2.JPG", @"shoes431.3.08.jpg", nil];*/
    
    UIView *backView;
    backView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    [self.view addSubview:backView];
    [backView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.9]];
    
    [self.view bringSubviewToFront:_activity_indicator];
    [_activity_indicator startAnimating];
    
    prosNames = [[NSMutableArray alloc] init];
    NSDictionary *_dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"6",@"action",_ProductsID , @"secid", nil];
    
    [NetworkOperations POSTResponseWithURL:@"" andParameters:_dic success:^(id response) {
        NSLog(@"\nresponse = %@", response);
        NSString *str = [[response lastObject] lastObject];
        if ([str isEqualToString:@"0"]) {
            NSLog(@"No Response");
        } else {
            for (NSArray *arr in response) {
                NSMutableDictionary *record = [NSMutableDictionary dictionary];
                [record setObject:[arr objectAtIndex:0] forKey:@"id"];
                [record setObject:[arr objectAtIndex:1] forKey:@"title"];
                [record setObject:[arr objectAtIndex:2] forKey:@"price"];
                [record setObject:[arr objectAtIndex:4] forKey:@"section"];
                [record setObject:[arr objectAtIndex:5] forKey:@"type"];
                
                NSArray *tempImages = [[arr objectAtIndex:3] componentsSeparatedByString:@"@"];
                NSMutableArray *imagesURL = [[NSMutableArray alloc] init];
                for (NSString *imgStr in tempImages) {
                    if ([imgStr hasPrefix:@"alert('حجم الملف اقصى من الحجم المسموح به');"]) {
                        continue;
                    }
                    [imagesURL addObject:[NSURL URLWithString:[NSString stringWithFormat:@"http://sooqalq8.com/resize.php?file=%@&width=300&height=250", imgStr]]];
                }
                [record setObject:imagesURL forKey:@"images"];
                
                [prosNames addObject:record];
            }
            [_tableView reloadData];
        }
        
        [_activity_indicator stopAnimating];
        [backView removeFromSuperview];
        [self.view sendSubviewToBack:_activity_indicator];
    } failure:^(NSHTTPURLResponse *urlResponse, NSError *error) {
        NSLog(@"[ERROR]: %@", [error description] );
    }];
    
//    if (iPhone) {
//        self.adBanner = [[[GADBannerView alloc] initWithFrame:CGRectMake(0.0, 0.0, GAD_SIZE_320x50.width, GAD_SIZE_320x50.height)] autorelease];
//    } else {
//        self.adBanner = [[[GADBannerView alloc] initWithFrame:CGRectMake(20.0, 0.0, GAD_SIZE_728x90.width, GAD_SIZE_728x90.height)] autorelease];
//    }
//    
//    // Note: Edit SampleConstants.h to provide a definition for kSampleAdUnitID
//    // before compiling.
//    self.adBanner.adUnitID = kAdUnitID;
//    self.adBanner.delegate = self;
//    [self.adBanner setRootViewController:self];
//    [self.view addSubview:self.adBanner];
//    [self.adBanner loadRequest:[self createRequest]];
    
}
#pragma mark GADRequest generation

// Here we're creating a simple GADRequest and whitelisting the simulator
// and two devices for test ads. You should request test ads during development
// to avoid generating invalid impressions and clicks.
//- (GADRequest *)createRequest {
//    GADRequest *request = [GADRequest request];
//    
//    request.additionalParameters =
//    [NSMutableDictionary dictionaryWithObjectsAndKeys:
//     @"AAAAFF", @"color_bg",
//     @"FFFFFF", @"color_bg_top",
//     @"FFFFFF", @"color_border",
//     @"000080", @"color_link",
//     @"808080", @"color_text",
//     @"008000", @"color_url",
//     nil];
//    
//    
//    //Make the request for a test ad
//    request.testDevices = [NSArray arrayWithObjects:
//                           GAD_SIMULATOR_ID,                       
//                           nil];
//    
//    return request;
//}
//
//#pragma mark GADBannerViewDelegate impl
//
//// Since we've received an ad, let's go ahead and set the frame to display it.
//- (void)adViewDidReceiveAd:(GADBannerView *)adView {
//    NSLog(@"Received ad");
//    
//    //    [UIView animateWithDuration:1.0 animations:^ {
//    //        adView.frame = CGRectMake(0.0,
//    //                                  self.view.frame.size.height -
//    //                                  adView.frame.size.height,
//    //                                  adView.frame.size.width,
//    //                                  adView.frame.size.height);
//    //        
//    //    }];
//    //    
//    [self.prosNames insertObject:adView atIndex:0];
//    [_tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
//}
//
//- (void)adView:(GADBannerView *)view
//didFailToReceiveAdWithError:(GADRequestError *)error {
//    NSLog(@"Failed to receive ad with error: %@", [error localizedFailureReason]);
//}

- (void)viewDidUnload
{
    [self setActivity_indicator:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [[GoogleAdsController sharedManager] addAdContainerToView:self.view withParentViewController:self];
    [[GoogleAdsController sharedManager] layoutBannerViewsForCurrentOrientation:self.interfaceOrientation];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [prosNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 && [[self.prosNames objectAtIndex:0] isKindOfClass:[GADBannerView class]]) {
        UITableViewCell *adCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"adCell"];
        GADBannerView *adView = [self.prosNames objectAtIndex:0];
        [adCell.contentView addSubview:adView];
        adCell.contentView.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0.7];
        return adCell;
    }
    
    static NSString *CellIdentifier = @"Cell";
    if (!iPhone) {
        CellIdentifier = IMAGE_CELL_IDENTIFIER;
    }
    ArabicCell *cell = (ArabicCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[ArabicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSMutableDictionary *current = [prosNames objectAtIndex:indexPath.row];
    
    // Configure the cell...
    if ([[current objectForKey:@"images"] count]) {
        [cell.imgView setImageWithURL:[[current objectForKey:@"images"] objectAtIndex:0] placeholderImage:[UIImage imageNamed:@"Icon.png"]];
    } else {
        [cell.imgView setImage:[UIImage imageNamed:@"Icon.png"]];
    }
    
    NSString *_proPrice = @"السعر : ";
    
    [_proPrice stringByAppendingString:[current objectForKey:@"price"]];
    [cell.cell_text setText:[current objectForKey:@"title"]];
    [cell.cell_subtitle setText:[NSString stringWithFormat:@"السعر : %@",[current objectForKey:@"price"]]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (iPhone) {
        if (indexPath.row == 0 && [[self.prosNames objectAtIndex:0] isKindOfClass:[GADBannerView class]]) {
            return 50;
        }
        return 75;
    }
    else {
        return 100;
    }
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductDetails *pro;
    if (iPhone) {
        pro = [[ProductDetails alloc] initWithNibName:@"ProductDetails_iPhone" bundle:nil];
    }
    else {
        pro = [[ProductDetails alloc] initWithNibName:@"ProductDetails_iPad" bundle:nil];
    }
    
    NSMutableDictionary *current = [prosNames objectAtIndex:indexPath.row];
    NSMutableArray *array = [prosNames mutableCopy];
    pro._ProductID = [current objectForKey:@"id"];
    pro._productList = array;
    pro._curPro = indexPath.row;
    [UIView beginAnimations:@"animation" context:nil];
    [UIView setAnimationDuration:0.5];
    [self.navigationController pushViewController:pro animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
}


-(void)adjustViewForGoogleAdsView:(UIView *)adView {
//    _tableView.frame = CGRectMake(_tableView.frame.origin.x,
//                                  _tableView.frame.origin.y,
//                                  _tableView.frame.size.width,
//                                  (adView.frame.origin.y - _tableView.frame.origin.y));
    adView.alpha = 0.0;
    
    [UIView animateWithDuration:1 delay:3.0 options:0 animations:^{
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, adView.frame.size.height, 0);
        adView.alpha = 1.0;
    } completion:nil];
}
@end
