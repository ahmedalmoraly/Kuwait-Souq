//
//  RecentViewController.m
//  Sooq
//
//  Created by Ahmad al-Moraly on 12/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RecentViewController.h"
#import "ArabicCell.h"
#import "NetworkOperations.h"
#import "ProductDetails.h"
#import "Global.h"
#import "TabBarController.h"

@interface RecentViewController() <UITableViewDelegate, UITableViewDataSource, GoogleAdsControllerDelegate>

@property (retain, nonatomic) IBOutlet UITableView *table;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activity_indicator;
@property (retain, nonatomic) NSMutableArray *arrayOfRecords;

@property (retain, nonatomic) IBOutlet UIImageView *headerImageView;
@property (retain, nonatomic) IBOutlet UIButton *backBtn;

@end


@implementation RecentViewController
@synthesize headerImageView;
@synthesize backBtn;
@synthesize table, activity_indicator, arrayOfRecords;

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
    
    UIView *backView;
    if (iPhone) {
        backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    } else {
        headerImageView.frame = CGRectMake(0, 0, 768, 150);
        headerImageView.image = [UIImage imageNamed:@"Header_iPad"];
        table.frame = CGRectMake(0, 150, 768, 805);
        backBtn.frame = CGRectMake(20, 85, 51, 51);
        [backBtn setImage:[UIImage imageNamed:@"BackBtn_iPad"] forState:UIControlStateNormal];
        backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 1004)];
    }
    
    [self.view addSubview:backView];
    [backView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
    activity_indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activity_indicator.center = backView.center;
    [self.view addSubview:activity_indicator];
    [activity_indicator startAnimating];
    
    arrayOfRecords = [[NSMutableArray alloc] init];
    NSDictionary *_dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"4",@"action", nil];
    
    [NetworkOperations POSTResponseWithURL:@"" andParameters:_dic success:^(id response) {
        NSLog(@"\nresponse = %@", response);
        NSString *str = [[response lastObject] lastObject];
        if ([str isEqualToString:@"0"]) {
            NSLog(@"No Response");
        } else {
            for (NSArray *arr in response) {
                if (arr.count < 6) {
                    continue;
                }
                NSMutableDictionary *record = [NSMutableDictionary dictionary];
                [record setObject:[arr objectAtIndex:0] forKey:@"id"];
                [record setObject:[arr objectAtIndex:1] forKey:@"title"];
                [record setObject:[arr objectAtIndex:2] forKey:@"price"];
                [record setObject:[arr objectAtIndex:4] forKey:@"section"];
                [record setObject:[arr objectAtIndex:5] forKey:@"type"];
                
                NSArray *tempImages = [[arr objectAtIndex:3] componentsSeparatedByString:@"@"];
                NSMutableArray *imagesURL = [[NSMutableArray alloc] init];
                for (NSString *imgStr in tempImages) {
                    if ([imgStr hasPrefix:@"alert"]) {
                        continue;
                    }
                    [imagesURL addObject:[NSURL URLWithString:[NSString stringWithFormat:@"http://sooqalq8.com/resize.php?file=%@&width=300&height=250", imgStr]]];
                }
                [record setObject:imagesURL forKey:@"images"];
                
                [arrayOfRecords addObject:record];
            }
            [table reloadData];
        }
        
        [activity_indicator stopAnimating];
        [backView removeFromSuperview];
        [self.view sendSubviewToBack:activity_indicator];
    } failure:^(NSHTTPURLResponse *urlResponse, NSError *error) {
        NSLog(@"[ERROR]: %@", [error description] );
    }];

    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[GoogleAdsController sharedManager] addAdContainerToView:self.view withParentViewController:self];
    [[GoogleAdsController sharedManager] layoutBannerViewsForCurrentOrientation:self.interfaceOrientation];
}

- (void)viewDidUnload
{
    [self setTable:nil];
    [self setHeaderImageView:nil];
    [self setBackBtn:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [table release];
    [headerImageView release];
    [backBtn release];
    [super dealloc];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrayOfRecords count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = IMAGE_CELL_IDENTIFIER;
    
    ArabicCell *cell = (ArabicCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[ArabicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSMutableDictionary *current = [arrayOfRecords objectAtIndex:indexPath.row];
    
    // Configure the cell...
    cell.cell_img = [UIImage imageNamed:@"Icon.png"];
    
    NSMutableArray *imagesArray = [current objectForKey:@"images"];
    if (imagesArray.count) {
        [cell.imgView setImageWithURL:[imagesArray objectAtIndex:0] placeholderImage:[UIImage imageNamed:@"Icon.png"]];   
    }
    
    NSString *_proPrice = @"السعر : ";
    
    [_proPrice stringByAppendingString:[current objectForKey:@"price"]];
    [cell.cell_text setText:[current objectForKey:@"title"]];
    [cell.cell_subtitle setText:[NSString stringWithFormat:@"السعر : %@",[current objectForKey:@"price"]]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (iPhone) {
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
    
    NSMutableDictionary *current = [arrayOfRecords objectAtIndex:indexPath.row];
    
    pro._ProductID = [current objectForKey:@"id"];
    pro._productList = arrayOfRecords;
    pro._curPro = indexPath.row;
    [UIView beginAnimations:@"animation" context:nil];
    [UIView setAnimationDuration:0.5]; 
    if ([[UIDevice currentDevice].systemVersion substringToIndex:1].integerValue > 4) {
        [(UINavigationController *)[(TabBarController *)self.presentingViewController selectedViewController] pushViewController:pro animated:YES];
        [self.presentingViewController dismissViewControllerAnimated:NO completion:Nil];
    } else {
        [(UINavigationController *)[(TabBarController *)self.parentViewController selectedViewController] pushViewController:pro animated:YES];
        [self.parentViewController dismissModalViewControllerAnimated:YES];
    }
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
}

- (IBAction)backBtnTouched:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}


-(void)adjustViewForGoogleAdsView:(UIView *)adView {
//    self.table.frame = CGRectMake(table.frame.origin.x,
//                                  table.frame.origin.y,
//                                  table.frame.size.width,
//                                  (adView.frame.origin.y - table.frame.origin.y));
    adView.alpha = 0.0;
    
    [UIView animateWithDuration:1 delay:3.0 options:0 animations:^{
        table.contentInset = UIEdgeInsetsMake(0, 0, adView.frame.size.height, 0);
        adView.alpha = 1.0;
    } completion:nil];
}

@end
