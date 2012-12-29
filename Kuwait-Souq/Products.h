//
//  Products.h
//  Mosta3mal
//
//  Created by Islam on 11/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterPage.h"
#import "GADBannerViewDelegate.h"

@class GADBannerView, GADRequest;
@interface Products : MasterPage <UITableViewDelegate, UITableViewDataSource, GoogleAdsControllerDelegate, GADBannerViewDelegate> {
    IBOutlet UITableView *_tableView;
    NSMutableArray *prosImages;
    NSMutableArray *prosNames;
}

@property (nonatomic, retain) NSArray *_pro;
@property (nonatomic, retain) NSString *_categoryTitle;
@property (nonatomic, retain) NSString* _ProductsID;
@property (nonatomic, retain) NSMutableArray *prosImages;
@property (nonatomic, retain) NSMutableArray *prosNames;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activity_indicator;
@property (nonatomic, retain) GADBannerView *adBanner;

//-(GADRequest *)createRequest;
@end
