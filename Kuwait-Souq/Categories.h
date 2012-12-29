//
//  Categories.h
//  Mosta3mal
//
//  Created by Islam on 11/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterPage.h"

@interface Categories : MasterPage <UITableViewDelegate, UITableViewDataSource, GoogleAdsControllerDelegate>  {
    NSArray *_category;
    NSMutableDictionary *_subCategory;
    NSArray *_subCategoryData;
    IBOutlet UITableView *_tableView;
}

@property (nonatomic ,retain) NSArray *_category;
@property (nonatomic ,retain) NSArray *_subCategoryData;
@property (nonatomic ,retain) NSMutableDictionary *_subCategory;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activity_indicator;
@end
