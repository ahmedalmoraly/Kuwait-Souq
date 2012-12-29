//
//  Categories.m
//  Mosta3mal
//
//  Created by Islam on 11/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Categories.h"
#import "SubCategories.h"
#import "Products.h"
#import "ArabicCell.h"
#import "Global.h"
#import "NetworkOperations.h"

@interface CategoriesData : NSObject {

}

@property (nonatomic, strong) NSString* _id;
@property (nonatomic, strong) NSString *_title;

@end

@implementation CategoriesData 

@synthesize _id, _title;

@end

@implementation Categories
@synthesize activity_indicator = _activity_indicator;

@synthesize _category, _subCategory, _subCategoryData;

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
    UIView *backView;
    
    backView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    [self.view addSubview:backView];
    [backView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.9]];
    
    [self.view bringSubviewToFront:_activity_indicator];
    [_activity_indicator startAnimating];
    
    NSMutableArray *temp = [NSMutableArray array];
    NSDictionary *_dic = [[[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"action", nil] autorelease];
    [NetworkOperations POSTResponseWithURL:@"" andParameters:_dic success:^(id response) {
        for (NSArray *arr in response) {
            if (arr.count < 2) {
                continue;
            }
            CategoriesData *tempCat = [[CategoriesData alloc] init];
            tempCat._id = [arr objectAtIndex:0];
            tempCat._title = [arr objectAtIndex:1];
            [temp addObject:tempCat];
    }
        _category = [[NSArray alloc] initWithArray: temp];
        [_tableView reloadData];
        [_activity_indicator stopAnimating];
        [backView removeFromSuperview];
        [self.view sendSubviewToBack:_activity_indicator];
    } 
        failure:^(NSHTTPURLResponse *urlResponse, NSError *error) {
            NSLog(@"[ERROR]: %@", [error description] );
            [_activity_indicator stopAnimating];
            [backView removeFromSuperview];
            [self.view sendSubviewToBack:_activity_indicator];
    }]; 
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setActivity_indicator:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
    return [_category count];
}

-(NSString *) getRowString :(int) tableRow {
    return [_category objectAtIndex:tableRow];
}

-(BOOL) checkSubCategoryExisit :(int)tableRow {
    NSString *_rowValue = [self getRowString:tableRow];
    
    for (NSString *abbrev in _subCategory) {
        if (abbrev == _rowValue) {
            return YES;
        }
    }
    return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    ArabicCell *cell = (ArabicCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[ArabicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    
    cell.cell_text.transform = CGAffineTransformMakeTranslation(60, 0);
    [cell.cell_text setText:[[_category objectAtIndex:indexPath.row] _title]];
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

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SubCategories *sub;
    if (iPhone) {
        sub = [[SubCategories alloc] initWithNibName:@"SubCategories_iPhone" bundle:nil];
    }
    else {
        sub = [[SubCategories alloc] initWithNibName:@"SubCategories_iPad" bundle:nil];
    }
    sub._subCatID = [[_category objectAtIndex:indexPath.row] _id];
    [self.navigationController pushViewController:sub animated:YES];
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
