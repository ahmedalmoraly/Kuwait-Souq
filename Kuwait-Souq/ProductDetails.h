//
//  ProductDetails.h
//  Mosta3mal
//
//  Created by Islam on 11/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterPage.h"

@interface ProductDetails : MasterPage {
    
    IBOutlet UILabel *lbl_ProductName;
    IBOutlet UIButton *btn_right;
    IBOutlet UIButton *btn_left;
    IBOutlet UIButton *btn_proRight;
    IBOutlet UIButton *btn_proLeft;
    IBOutlet UILabel *lbl_numberOfPicture;
    IBOutlet UIButton *img_product;
    IBOutlet UITextView *txt_description;
    
    int _proCounter;
    int _proListCounter;
    NSMutableArray *_images, *swapImages;
    NSMutableArray *_productList;
    NSMutableArray *_singleProductImgList;
    id lastImageURL;
}

@property (assign) int _proCounter;
@property (assign) int _proListCounter;
@property (nonatomic, retain) NSMutableArray *_productList;
@property (nonatomic, retain) NSMutableArray *_singleProductImgList;
@property (nonatomic, retain) IBOutlet UIButton *img_product;
@property (nonatomic, strong) NSString *_ProductID;
@property (assign) int _curPro;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *_activity_indicator;

@property (nonatomic, strong) UIImage *adImage;

- (IBAction)btn_selected:(UIButton *)sender;
-(void)loadImageWithURL:(NSURL *)url;
- (IBAction)shareOnFacebook:(id)sender;
- (IBAction)tweet:(id)sender;

@end
