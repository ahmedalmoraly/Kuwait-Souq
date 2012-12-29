//
//  ArabicCell.h
//  Mosta3mal
//
//  Created by Islam on 11/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define IMAGE_CELL_IDENTIFIER @"imageCellIdentifier"


@interface ArabicCell : UITableViewCell {
    UIImage *cell_img;
    UILabel *cell_text;
    UILabel *cell_subtitle;
    UIImageView *cell_imgView;
    UIImageView *imgView;
}
@property (nonatomic, retain) UILabel *cell_text;
@property (nonatomic, retain, setter = setCellImage:) UIImage *cell_img;
@property (nonatomic, retain) UILabel *cell_subtitle;
@property (nonatomic, retain) UIImageView *imgView;
@end
