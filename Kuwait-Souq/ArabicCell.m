//
//  ArabicCell.m
//  Mosta3mal
//
//  Created by Islam on 11/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ArabicCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation ArabicCell

@synthesize cell_text;
@synthesize cell_img;
@synthesize cell_subtitle;
@synthesize imgView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if (iPhone) {
            cell_imgView = [[UIImageView alloc] initWithFrame:CGRectMake(13, 25, 17, 20)];
            [cell_imgView setImage:[UIImage imageNamed:@"MenuLeftArrow_iPhone.png"]];
            [cell_imgView setTag:100];
            cell_text = [[UILabel alloc] initWithFrame:CGRectMake(95, 5, 220, 21)];
            cell_subtitle = [[UILabel alloc] initWithFrame:CGRectMake(87, 34, 220, 21)];
            imgView = [[UIImageView alloc] init];
            [cell_text setText:@"إختبار"];
            //[cell_subtitle setText:@"ترجمة"];
            [cell_text setTextAlignment:UITextAlignmentRight];
            [cell_subtitle setTextAlignment:UITextAlignmentRight];
            [cell_subtitle setTextColor:[UIColor grayColor]];
            cell_img = [[UIImage alloc] init];
            
            imgView = [[UIImageView alloc] initWithFrame:CGRectMake(249, 3, 69, 69)];
            [imgView.layer setCornerRadius:10.0f];
            [imgView.layer setMasksToBounds:YES];
            [self addSubview:imgView];
            [cell_text setFrame:CGRectMake(51, 5, 192, 21)];
            [cell_subtitle setFrame:CGRectMake(51, 34, 187, 21)];
            
            [self addSubview:cell_text];
            [self addSubview:cell_subtitle];
            [self addSubview:cell_imgView];
        }
        else {
            if ([reuseIdentifier isEqualToString:IMAGE_CELL_IDENTIFIER]) {
                cell_text = [[UILabel alloc] initWithFrame:CGRectMake(50, 8, 600, 21)];
                cell_subtitle = [[UILabel alloc] initWithFrame:CGRectMake(50, 44, 600, 21)];
                imgView = [[UIImageView alloc] initWithFrame:CGRectMake(670, 2, 90, 90)];
                imgView.layer.cornerRadius = 10;
                imgView.layer.masksToBounds = YES;
                [self addSubview:imgView];
            } else {
                cell_text = [[UILabel alloc] initWithFrame:CGRectMake(241, 8, 424, 21)];
                cell_subtitle = [[UILabel alloc] initWithFrame:CGRectMake(241, 44, 424, 21)];
            }
            cell_imgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 28, 28, 49)];
            [cell_imgView setImage:[UIImage imageNamed:@"MenuLeftArrow_iPad.png"]];
            [cell_imgView setTag:100];
            [cell_text setTextAlignment:UITextAlignmentRight];
            [cell_subtitle setTextAlignment:UITextAlignmentRight];
            [cell_subtitle setTextColor:[UIColor grayColor]];
            
            [self addSubview:cell_text];
            [self addSubview:cell_subtitle];
            [self addSubview:cell_imgView];
        }
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)dealloc
{
    [cell_img release];
    [cell_text release];
    [cell_imgView release];
    [super dealloc];
}

@end
