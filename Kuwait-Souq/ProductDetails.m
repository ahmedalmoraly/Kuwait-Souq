//
//  ProductDetails.m
//  Mosta3mal
//
//  Created by Islam on 11/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ProductDetails.h"
#import "largeImageDetails.h"
#import "Global.h"
#import "NetworkOperations.h"
#import "AFImageRequestOperation.h"
#import "DEFacebookComposeViewController.h"
#ifdef __IPHONE_6_0
    #import <Social/Social.h>
#endif 

#ifdef __IPHONE_5_0
#import <Twitter/Twitter.h>
#endif


@interface ProDetails : NSObject

@property (nonatomic, strong) NSString* _id;
@property (nonatomic, strong) NSString *_proName;
@property (nonatomic, strong) NSString *_price;
@property (nonatomic, strong) NSString *_pictures;
@property (nonatomic, strong) NSString *_title;
@property (nonatomic, strong) NSString *_type;
@property (nonatomic, strong) NSString *_model;
@property (nonatomic, strong) NSString *_userID;
@property (nonatomic, strong) NSString *_secName;
@property (nonatomic, strong) NSString *_user;
@property (nonatomic, strong) NSString *_detail;
@property (nonatomic, strong) NSString *_phone;
@property (nonatomic, strong) NSString *_mobile;
@property (nonatomic, strong) NSString *_email;


@end

@implementation ProDetails

@synthesize _id;
@synthesize _proName;
@synthesize _price;
@synthesize _pictures;
@synthesize _title;
@synthesize _type;
@synthesize _model;
@synthesize _userID;
@synthesize _secName;
@synthesize _user;
@synthesize _detail;
@synthesize _phone;
@synthesize _mobile;
@synthesize _email;

@end

@interface ProductDetails()

@property (nonatomic, retain) NSArray *imagesArray;
@property(nonatomic, retain) NSMutableDictionary *productInfo;
-(void)loadAdWithID:(NSString *)idString;

@end

@implementation ProductDetails
@synthesize _activity_indicator, adImage, productInfo, imagesArray;

@synthesize _productList, _singleProductImgList, _proCounter, _proListCounter, img_product, _ProductID, _curPro;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [lbl_ProductName release];
    [btn_right release];
    [btn_left release];
    [btn_proRight release];
    [btn_proLeft release];
    [lbl_numberOfPicture release];
    [img_product release];
    [txt_description release];
    [_activity_indicator release];
    [_images release];
    [lastImageURL release];
    [swapImages release];
    [productInfo release];
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
    
    _proCounter = 0;
    _proListCounter = 0;
    
    [self loadAdWithID:_ProductID];
}

-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidUnload
{
    [lbl_ProductName release];
    lbl_ProductName = nil;
    [btn_right release];
    btn_right = nil;
    [btn_left release];
    btn_left = nil;
    [btn_proRight release];
    btn_proRight = nil;
    [btn_proLeft release];
    btn_proLeft = nil;
    [lbl_numberOfPicture release];
    lbl_numberOfPicture = nil;
    [txt_description release];
    txt_description = nil;
    [self set_activity_indicator:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)btn_selected:(UIButton *)sender {
    
    largeImageDetails *imgDetails;

    
    switch (sender.tag) {
        case 1:
            if (_curPro > 0) {
                _curPro --;
                NSMutableDictionary *current = [self._productList objectAtIndex:_curPro];
                
                _ProductID = [current objectForKey:@"id"];
                [self loadAdWithID:_ProductID];
                
                if (_curPro == 0) {
                    [sender setEnabled:NO];
                }
                [btn_proRight setEnabled:YES];
            }
            break;
            
        case 2:
            if (_curPro < _productList.count - 1) {
                _curPro ++;
                NSMutableDictionary *current = [self._productList objectAtIndex:_curPro];
                _ProductID = [current objectForKey:@"id"];
                [self loadAdWithID:_ProductID];
                if (_curPro == self._productList.count - 1) {
                    [sender setEnabled:NO];
                }
                [btn_proLeft setEnabled:YES];
            }
            break;
            
        case 3:
            if (swapImages.count) {
                
                [self loadImageWithURL:swapImages.lastObject];
                [_images addObject:lastImageURL];
                [lastImageURL release];
                lastImageURL = [swapImages.lastObject retain];
                [swapImages removeLastObject];
                
                [btn_left setEnabled:YES];
                [btn_left setUserInteractionEnabled:YES];
                [btn_right setEnabled:YES];
                [btn_right setUserInteractionEnabled:YES];
                if (!swapImages.count) {
                    [btn_left setEnabled:NO];
                    [btn_left setUserInteractionEnabled:NO];
                }
            }
            break;
            
        case 4:
            if (_images.count) {
                [self loadImageWithURL:_images.lastObject];
                [swapImages addObject:lastImageURL];
                [lastImageURL release];
                lastImageURL = [_images.lastObject retain];
                [_images removeLastObject];
                
                [btn_left setEnabled:YES];
                [btn_left setUserInteractionEnabled:YES];
                [btn_right setEnabled:YES];
                [btn_right setUserInteractionEnabled:YES];
                if (!_images.count) {
                    [btn_right setEnabled:NO];
                    [btn_right setUserInteractionEnabled:NO];
                }
            }
            break;
            
        case 5:
            if (iPhone) {
                imgDetails = [[largeImageDetails alloc] initWithNibName:@"LargeImageDetails_iPhone" bundle:nil];
            } else {
                imgDetails = [[largeImageDetails alloc] initWithNibName:@"largeImageDetails_iPad" bundle:nil];
            }
            imgDetails._img = img_product.imageView.image;
            imgDetails.imagesArray = self.imagesArray;
            
            [self.navigationController pushViewController:imgDetails animated:YES];
            break;
            
        default:
            break;
    }
}

-(void)loadImageWithURL:(NSURL *)url {
    [_activity_indicator startAnimating];
    [self.view bringSubviewToFront:_activity_indicator];
//    [[AFImageRequestOperation imageRequestOperationWithRequest:[NSURLRequest requestWithURL:url] success:^(UIImage *image) { 
//        adImage = [[UIImage alloc] initWithCGImage:image.CGImage];
//        [img_product setTransform:CGAffineTransformMakeScale(0.1, 0.1)];
//        [UIView animateWithDuration:0.5 animations:^{
//            [img_product setTransform:CGAffineTransformMakeScale(1, 1)];
//            [img_product setImage:image forState:UIControlStateNormal];
//        }];
//        [_activity_indicator stopAnimating];
//        NSLog(@"Image Loaded Successfully");
//    }] start];
    
    [[AFImageRequestOperation imageRequestOperationWithRequest:[NSURLRequest requestWithURL:url]  imageProcessingBlock:nil cacheName:url.absoluteString success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        adImage = [[UIImage alloc] initWithCGImage:image.CGImage];
        [img_product setTransform:CGAffineTransformMakeScale(0.1, 0.1)];
        [UIView animateWithDuration:0.5 animations:^{
            [img_product setTransform:CGAffineTransformMakeScale(1, 1)];
            [img_product setImage:image forState:UIControlStateNormal];
        }];
        [_activity_indicator stopAnimating];
        NSLog(@"Image Loaded Successfully");
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        [_activity_indicator stopAnimating];
    }] start];
    
}


-(void)loadAdWithID:(NSString *)idString {
    
    _ProductID = idString;
    
    UIView *backView;
    backView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    [self.view addSubview:backView];
    [backView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
    
    [self.view bringSubviewToFront:_activity_indicator];
    
    _activity_indicator.hidesWhenStopped = YES;
    [_activity_indicator startAnimating];
    
    NSDictionary* _dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"5", @"action",_ProductID ,@"id", nil];
    
    _singleProductImgList = [[NSMutableArray alloc] init];
    
    productInfo = [[NSMutableDictionary alloc] init];
    [img_product setImage:[UIImage imageNamed:@"Icon@2x.png"] forState:UIControlStateNormal];
    [NetworkOperations POSTResponseWithURL:@"" andParameters:_dic success:^(id response) {
        NSLog(@"Response Is :== %@", response);
        
        NSString *str = [[response lastObject] lastObject];
        if ([str isEqualToString:@"0"]) {
            NSLog(@"No Response");
        } else {
            NSArray *arr = [response lastObject];
            [productInfo setObject:[arr objectAtIndex:0] forKey:@"id"];
            [productInfo setObject:[arr objectAtIndex:1] forKey:@"title"];
            [productInfo setObject:[arr objectAtIndex:2] forKey:@"section"];
            [productInfo setObject:[arr objectAtIndex:3] forKey:@"type"];
            [productInfo setObject:[arr objectAtIndex:4] forKey:@"model"];
            [productInfo setObject:[arr objectAtIndex:5] forKey:@"price"];
            [productInfo setObject:[arr objectAtIndex:6] forKey:@"email"];
            [productInfo setObject:[arr objectAtIndex:7] forKey:@"phone"];
            [productInfo setObject:[arr objectAtIndex:8] forKey:@"mobile"];
            [productInfo setObject:[arr objectAtIndex:9] forKey:@"images"];
            [productInfo setObject:[arr objectAtIndex:10] forKey:@"username"];
            [productInfo setObject:[arr objectAtIndex:11] forKey:@"userID"];
            [productInfo setObject:[arr objectAtIndex:12] forKey:@"details"];
            [productInfo setObject:[arr objectAtIndex:13] forKey:@"link"];
            
            lbl_ProductName.text = [productInfo objectForKey:@"title"];
            
            txt_description.text = [NSString stringWithFormat:@"التفاصيل : %@\n السعر : %@\n القسم : %@\n النوع : %@\n الموديل : %@\n صاحب الاعلان : %@\n الهاتف : %@\n", [productInfo objectForKey:@"details"]?[productInfo objectForKey:@"details"]:@"", [productInfo objectForKey:@"price"]?[productInfo objectForKey:@"price"]:@"", [productInfo objectForKey:@"section"], [productInfo objectForKey:@"type"], [productInfo objectForKey:@"model"], [productInfo objectForKey:@"username"], [productInfo objectForKey:@"phone"]];
            
            if (![[arr objectAtIndex:9] isEqualToString:@""]) {
                NSArray *tempImages = [[arr objectAtIndex:9] componentsSeparatedByString:@"@"];
                _images = [[NSMutableArray alloc] init];
                swapImages = [[NSMutableArray alloc] init];
                
                for (NSString *imgStr in tempImages) {
                    if ([imgStr hasPrefix:@"alert("]) {
                        continue;
                    }
                    [_images addObject:[NSURL URLWithString:[NSString stringWithFormat:@"http://sooqalq8.com/resize.php?file=%@&width=300&height=250", imgStr]]];
                }
                self.imagesArray = [_images copy];
                
                [self loadImageWithURL:_images.lastObject];
                lastImageURL = [_images.lastObject retain];
                [_images removeLastObject];
                
                if (!_images.count) {
                    btn_left.enabled = NO;
                    btn_right.enabled = NO;
                }
                
            } else {
                [self._activity_indicator stopAnimating];
            }
            
        }
        
        [backView removeFromSuperview];
    } failure:^(NSHTTPURLResponse *urlResponse, NSError *error) {
        NSLog(@"[ERROR]: %@", [error description] );
    }];
    
    
    
    [btn_left setEnabled:NO];
    
}



- (IBAction)shareOnFacebook:(id)sender
{
    DEFacebookComposeViewController *facebookViewComposer = [[DEFacebookComposeViewController alloc] init];
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    [facebookViewComposer addImage:self.img_product.currentImage];
    [facebookViewComposer addURL:[NSURL URLWithString:self.productInfo[@"link"]]];
    [facebookViewComposer setInitialText:self.productInfo[@"title"]];
    facebookViewComposer.completionHandler = ^(DEFacebookComposeViewControllerResult result) {
        switch (result) {
            case DEFacebookComposeViewControllerResultCancelled:
                NSLog(@"Facebook Result: Cancelled");
                break;
            case DEFacebookComposeViewControllerResultDone:
                NSLog(@"Facebook Result: Sent");
                break;
        }
        
        [self dismissModalViewControllerAnimated:YES];
    };
    [self presentViewController:facebookViewComposer animated:YES completion:nil];
}

- (IBAction)tweet:(id)sender
{

    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6)
    {
        SLComposeViewController *tweet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweet addImage:self.img_product.currentImage];
        [tweet addURL:[NSURL URLWithString:self.productInfo[@"link"]]];
        [tweet setInitialText:self.productInfo[@"title"]];
        [self presentViewController:tweet animated:YES completion:nil];
    }
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 5)
    {
        TWTweetComposeViewController *twtweet = [[TWTweetComposeViewController alloc] init];
        [twtweet addURL:[NSURL URLWithString:self.productInfo[@"link"]]];
        [twtweet setInitialText:self.productInfo[@"title"]];
        [twtweet addImage:self.img_product.currentImage];
        [self presentViewController:twtweet animated:YES completion:nil];
    }
}

@end
