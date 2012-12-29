//
//  UserAdds.m
//  شبكة سوق الكويت 
//
//  Created by Islam on 11/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UserAdds.h"
#import "ArabicCell.h"
#import "ProductDetails.h"
#import "Global.h"
#import "NetworkOperations.h"
#import "LoginPage.h"
#import "GoogleAdsController.h"

@interface UserAdds() <UITableViewDelegate, UITableViewDataSource, GoogleAdsControllerDelegate>

@property (retain, nonatomic) IBOutlet UITableView *table;
@property (nonatomic, retain) NSString *userID;
@property (nonatomic, retain) NSMutableArray *arrayOfAds;

-(void)loadUserAds;
-(void)deleteUserAdWithID:(NSString *)adId;
@end

@implementation UserAdds

@synthesize table;
@synthesize userID;
@synthesize arrayOfAds;

- (void)dealloc
{
    [table release];
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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setTable:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!userLoginState) {
        [[[[UIAlertView alloc] initWithTitle:@"خطأ" message:@"عفواً\nانت غير مسجل\nبرجاء تسجيل الدخول لمشاهدة الاعلانات الخاصة بكم" delegate:nil cancelButtonTitle:@"موافق" otherButtonTitles:nil] autorelease] show];
    } else {
        [self.table setEditing:TRUE animated:TRUE];
        self.table.allowsSelectionDuringEditing = YES;
        self.arrayOfAds = [[NSMutableArray alloc] init];
        self.table.userInteractionEnabled = NO;
        [self loadUserAds];
    }
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
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.arrayOfAds.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = IMAGE_CELL_IDENTIFIER;
    
    ArabicCell *cell = (ArabicCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[ArabicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    
    NSMutableDictionary *currentRecord = [self.arrayOfAds objectAtIndex:indexPath.row];
    [cell.imgView setImageWithURL:[[currentRecord objectForKey:@"images"] lastObject] placeholderImage:[UIImage imageNamed:@"Icon.png"]];
    [cell.cell_text setText:[currentRecord objectForKey:@"title"]];
    [cell.cell_subtitle setText:[NSString stringWithFormat:@"السعر : %@",[currentRecord objectForKey:@"price"]]];
    [[cell viewWithTag:100] removeFromSuperview];
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

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath { 
    [self deleteUserAdWithID:[[self.arrayOfAds objectAtIndex:indexPath.row] objectForKey:@"id"]];
    [self.arrayOfAds removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductDetails *pro;
    if (iPhone) {
        pro = [[ProductDetails alloc] initWithNibName:@"ProductDetails_iPhone" bundle:nil];
    }
    else {
        pro = [[ProductDetails alloc] initWithNibName:@"ProductDetails_iPad" bundle:nil];
    }    
    NSMutableDictionary *current = [arrayOfAds objectAtIndex:indexPath.row];
    NSMutableArray *array = [arrayOfAds mutableCopy];
    pro._ProductID = [current objectForKey:@"id"];
    pro._productList = array;
    pro._curPro = indexPath.row;
    [[pro.view viewWithTag:8] setHidden:YES];
    [[pro.view viewWithTag:7] setHidden:YES];
    
    [UIView beginAnimations:@"animation" context:nil];
    [UIView setAnimationDuration:0.5];
    [self.navigationController pushViewController:pro animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
}

#pragma mark - Loading Methods

-(void)loadUserAds {
    [NetworkOperations POSTResponseWithURL:@"" andParameters:[NSDictionary dictionaryWithObjectsAndKeys:@"15", @"action", _userID, @"userid", nil] success:^(id response) {
        NSString *str = [[response lastObject] lastObject];
        if ([str isEqualToString:@"0"]) {
            NSLog(@"No Response");
        } else {
            NSLog(@"response: %@", response);
            for (NSArray *arr in response) {
                NSMutableDictionary *record = [NSMutableDictionary dictionary];
                
                [record setObject:[arr objectAtIndex:0] forKey:@"id"];
                [record setObject:[arr objectAtIndex:1] forKey:@"title"];
                [record setObject:[arr objectAtIndex:2] forKey:@"price"];
                [record setObject:[arr objectAtIndex:4] forKey:@"section"];
                
                NSArray *tempImages = [[arr objectAtIndex:3] componentsSeparatedByString:@"@"];
                NSMutableArray *imagesURL = [NSMutableArray array];
                for (NSString *imgStr in tempImages) {
                    [imagesURL addObject:[NSURL URLWithString:[NSString stringWithFormat:@"http://sooqalq8.com/resize.php?file=%@&width=300&height=250", imgStr]]];
                }
                [record setObject:imagesURL forKey:@"images"];

                [self.arrayOfAds addObject:record];
            }
            [self.table reloadData];
            self.table.userInteractionEnabled = YES;
        }

    } failure:^(NSHTTPURLResponse *urlResponse, NSError *error) {
        NSLog(@"[ERROR]: %@", error.description);
    }];
}

-(void)deleteUserAdWithID:(NSString *)adId {
    //mobile.php?action=16&id=12&userid=1
    [NetworkOperations POSTResponseWithURL:@"" andParameters:[NSDictionary dictionaryWithObjectsAndKeys:@"16",@"action", adId, @"id", _userID, @"userid" ,nil] success:^(id response) {
        NSLog(@"Response from delete: %@", response);
    } failure:^(NSHTTPURLResponse *urlResponse, NSError *error) {
        NSLog(@"[ERROR]: %@", error.description);
    }];
}

-(void)adjustViewForGoogleAdsView:(UIView *)adView {
//    self.table.frame = CGRectMake(self.table.frame.origin.x,
//                                  self.table.frame.origin.y,
//                                  self.table.frame.size.width,
//                                  (adView.frame.origin.y - self.table.frame.origin.y));
    adView.alpha = 0.0;
    
    [UIView animateWithDuration:1 delay:3.0 options:0 animations:^{
        table.contentInset = UIEdgeInsetsMake(0, 0, adView.frame.size.height, 0);
        adView.alpha = 1.0;
    } completion:nil];
}

@end
