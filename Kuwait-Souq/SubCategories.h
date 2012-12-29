//
//  SubCategories.h
//  Mosta3mal
//
//  Created by Islam on 11/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterPage.h"

@interface SubCategories : MasterPage <UITableViewDelegate, UITableViewDataSource, GoogleAdsControllerDelegate> {
    IBOutlet UITableView *_tableView;
}

@property (nonatomic ,retain) NSMutableArray *_subCategory;
@property (nonatomic, retain) NSString* _subCatID;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *_activity_indicator;

@end
