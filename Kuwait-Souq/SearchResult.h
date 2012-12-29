//
//  SearchReslut.h
//  Mosta3mal
//
//  Created by Islam on 11/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterPage.h"

@interface SearchResult : MasterPage <UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *prosImages;
    NSMutableArray *prosNames;
}

@property (nonatomic, retain) IBOutlet UITableView *_tableView;
@property (nonatomic, retain) NSMutableArray *prosImages;
@property (nonatomic, retain) NSMutableArray *prosNames;

@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *_activity_indicator;

@property (retain, nonatomic) NSMutableDictionary *dataToSearch;
@end
