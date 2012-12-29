//
//  SearchReslut.m
//  Mosta3mal
//
//  Created by Islam on 11/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SearchResult.h"
#import "ArabicCell.h"
#import "ProductDetails.h"
#import "Global.h"
#import "NetworkOperations.h"
#import "UIImageView+AFNetworking.h"

@implementation SearchResult
@synthesize _activity_indicator;

@synthesize _tableView, prosNames, prosImages;
@synthesize dataToSearch;

- (void)dealloc
{
    [_activity_indicator release];
    [dataToSearch release];
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
    if (iPhone) {
        backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    }
    
    else {
        backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 1004)];
    }
    
    [self.view addSubview:backView];
    [backView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
    
    [self.view bringSubviewToFront:_activity_indicator];
    [_activity_indicator startAnimating];

    
    [self.dataToSearch setObject:@"9" forKey:@"action"];

    NSLog(@"Dictionry: %@", dataToSearch);
    
    prosNames = [[NSMutableArray alloc] init];
    [NetworkOperations POSTResponseWithURL:@"" andParameters:dataToSearch success:^(id response) {
        NSLog(@"data finished: %@", response);
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
    NSLog(@"data updated");
}

- (void)viewDidUnload
{
    [self set_activity_indicator:nil];
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
    return [prosNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    ArabicCell *cell = (ArabicCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[ArabicCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSMutableDictionary *current = [prosNames objectAtIndex:indexPath.row];
    
    // Configure the cell...
    cell.cell_img = [UIImage imageNamed:@"Icon.png"];
      
    [cell.imgView setImageWithURL:[[current objectForKey:@"images"] objectAtIndex:0] placeholderImage:[UIImage imageNamed:@"Icon.png"]];

    NSString *_proPrice = @"السعر : ";
    
    [_proPrice stringByAppendingString:[current objectForKey:@"price"]];
    [cell.cell_text setText:[current objectForKey:@"title"]];
    [cell.cell_subtitle setText:[NSString stringWithFormat:@"السعر : %@",[current objectForKey:@"price"]]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
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
    
    NSMutableDictionary *current = [prosNames objectAtIndex:indexPath.row];
    
    pro._ProductID = [current objectForKey:@"id"];
    pro._productList = prosNames;
    pro._curPro = indexPath.row;
    [UIView beginAnimations:@"animation" context:nil];
    [UIView setAnimationDuration:0.5];
    [self.navigationController pushViewController:pro animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
}



@end
