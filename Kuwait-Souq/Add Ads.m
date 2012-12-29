//
//  Add Ads.m
//  Mosta3mal
//
//  Created by Islam on 11/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Add Ads.h"
#import "Global.h"
#import "NWPickerField.h"
#import "NWPickerView.h"
#import "NetworkOperations.h"


extern NSString *const kAdvertiseWasUploadedSuccessfully;

@interface Add_Ads() <NWPickerFieldDelegate>

@property (retain, nonatomic) IBOutlet NWPickerField *categoryComboBox;
@property (retain, nonatomic) IBOutlet NWPickerField *typeComboBox;
@property (retain, nonatomic) IBOutlet NWPickerField *modelCombBox;
@property (retain, nonatomic) IBOutlet UITextField *additionalPhoneNumberTextField;

@property (retain, nonatomic) IBOutlet UITextField *adTitleTextField;
@property (retain, nonatomic) IBOutlet UIButton *photo1Btn;
@property (retain, nonatomic) IBOutlet UIButton *photo2Btn;
@property (retain, nonatomic) IBOutlet UIButton *photo3Btn;
@property (retain, nonatomic) IBOutlet UIButton *photo4Btn;
@property (retain, nonatomic) IBOutlet UITextView *descriptionTextField;
@property (retain, nonatomic) IBOutlet UITextField *priceTextField;

@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;

@property (retain, nonatomic) NSMutableDictionary *categoriesDataSource;
@property (retain, nonatomic) NSMutableDictionary *typesDataSource;
@property (retain, nonatomic) NSMutableDictionary *modelDataSource;

@property (nonatomic, retain) NSMutableArray *imagesArray;
@property (nonatomic, retain) NSMutableArray *uploadedImagesNames;
@property (nonatomic, retain) NSMutableDictionary *adDataDictionary;
@property (nonatomic, retain) UIView *loadingView;

@property (nonatomic, retain) UIPopoverController *popover;

@property (assign) UIButton *selectedButton;
@property (retain, nonatomic) IBOutlet UITextField *additionalPhoneNumber;

-(void)backgroundTouched;
-(void)loadCategories;
-(void)loadTypesWithCategoryID:(NSString *)categoryID;
-(void)loadModelsWithTypeID:(NSString *)typeID;
-(void)uploadImagesInBackground;
-(void)uploadAddData:(NSMutableDictionary *)dataToSend afterUploadingImages:(NSArray *)arrayOfImages;
-(BOOL)checkInputFields;

@end

@implementation Add_Ads
@synthesize categoryComboBox;
@synthesize typeComboBox;
@synthesize modelCombBox;
@synthesize additionalPhoneNumberTextField;
@synthesize adTitleTextField;
@synthesize photo1Btn;
@synthesize photo2Btn;
@synthesize photo3Btn;
@synthesize photo4Btn;
@synthesize descriptionTextField;
@synthesize priceTextField;
@synthesize scrollView;
@synthesize categoriesDataSource;
@synthesize typesDataSource;
@synthesize modelDataSource;
@synthesize selectedButton;
@synthesize additionalPhoneNumber;
@synthesize imagesArray;
@synthesize uploadedImagesNames;
@synthesize adDataDictionary;
@synthesize loadingView;
@synthesize popover;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)dealloc
{
    [adTitleTextField release];
    [photo1Btn release];
    [photo2Btn release];
    [photo3Btn release];
    [photo4Btn release];
    [descriptionTextField release];
    [priceTextField release];
    [categoryComboBox release];
    [typeComboBox release];
    [modelCombBox release];
    [scrollView release];
    [categoriesDataSource release];
    [typesDataSource release];
    [modelDataSource release];
    [popover release];
    [additionalPhoneNumberTextField release];
    [additionalPhoneNumber release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - TextFieldDelegate

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.priceTextField) {
        [UIView animateWithDuration:0.25 animations:^{
            self.scrollView.transform = CGAffineTransformMakeTranslation(0, -200);
        }];
    }

}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.priceTextField) {
        [UIView animateWithDuration:0.25 animations:^{
            self.scrollView.transform = CGAffineTransformMakeTranslation(0, 0);
        }];
    }
}

-(void)textViewDidBeginEditing:(UITextView *)textView {
    [UIView animateWithDuration:0.25 animations:^{
        self.scrollView.transform = CGAffineTransformMakeTranslation(0, -150);    
    }];
    
}

-(BOOL) textViewShouldEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
    [UIView animateWithDuration:0.25 animations:^{
        self.scrollView.transform = CGAffineTransformMakeTranslation(0, 0);
    }];
    return YES;
}

-(void)backgroundTouched {
    [self.adTitleTextField resignFirstResponder];
    [self.descriptionTextField resignFirstResponder];
    [self.priceTextField resignFirstResponder];
    
    if (!self.categoryComboBox.pickerView.hidden) {
        [self.categoryComboBox.pickerView toggle];
    }
    if (!self.typeComboBox.pickerView.hidden) {
        [self.typeComboBox.pickerView toggle];
    }
    if (!self.modelCombBox.pickerView.hidden) {
        [self.modelCombBox.pickerView toggle];
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIControl *backControlView;
    if (iPhone) {
        [self.scrollView setContentSize:CGSizeMake(320, 900)];
        backControlView = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 320, 900)];
    } else {
        backControlView = [[UIControl alloc] initWithFrame:self.view.frame];    
    }
    
    
    self.categoryComboBox.NWDelegate = self;
    self.typeComboBox.NWDelegate = self;
    self.modelCombBox.NWDelegate = self;
    
    backControlView.backgroundColor = [UIColor clearColor];
    [backControlView addTarget:self action:@selector(backgroundTouched) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:backControlView];
    [self.scrollView sendSubviewToBack:backControlView];
    
    
    self.typeComboBox.delegate = self;
    self.typeComboBox.enabled = NO;
    self.modelCombBox.enabled = NO;
    [self loadCategories];
    imagesArray = [[NSMutableArray alloc] init];
    uploadedImagesNames = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidUnload
{
    [self setAdTitleTextField:nil];
    [self setPhoto1Btn:nil];
    [self setPhoto2Btn:nil];
    [self setPhoto3Btn:nil];
    [self setPhoto4Btn:nil];
    [self setDescriptionTextField:nil];
    [self setPriceTextField:nil];
    [self setCategoryComboBox:nil];
    [self setTypeComboBox:nil];
    [self setModelCombBox:nil];
    [self setScrollView:nil];
    [self setCategoriesDataSource:nil];
    [self setTypesDataSource:nil];
    [self setModelDataSource:nil];
    [self setAdditionalPhoneNumberTextField:nil];
    [self setAdditionalPhoneNumber:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
     
-(void)uploadImagesInBackground {
    @autoreleasepool {
        UIImage *image = imagesArray.lastObject;
        if (image) {
            NSData *imageData = UIImageJPEGRepresentation(image, 0.0);
            image = [UIImage imageWithData:imageData];

            [NetworkOperations uploadImage:image withParameters:[NSDictionary dictionaryWithObject:@"13" forKey:@"action"] success:^(id response) {
                [imagesArray removeLastObject];
                [uploadedImagesNames addObject:response];
                if (imagesArray.count) {
                    [self uploadImagesInBackground];
                } else {
                    [self uploadAddData:self.adDataDictionary afterUploadingImages:uploadedImagesNames];
                }
            } failure:^(NSHTTPURLResponse *urlResponse, NSError *error) {
                NSLog(@"[ERROR]: %@", error.description);
            }];   
        }
    }
}

-(void)uploadAddData:(NSMutableDictionary *)dataToSend afterUploadingImages:(NSArray *)arrayOfImages {
    if (arrayOfImages) {
        NSString *imagesString = [arrayOfImages componentsJoinedByString:@"@"];
        
        [dataToSend setObject:imagesString forKey:@"picstr"];
    }    
    NSLog(@"Dictionary: %@", dataToSend);
    [NetworkOperations POSTResponseWithURL:@"" andParameters:dataToSend success:^(id response) {
        
        [self.loadingView removeFromSuperview];
        
        [[[[UIAlertView alloc] initWithTitle:@"تم بنجاح" message:@"تم إضافة الاعلان بنجاح" delegate:nil cancelButtonTitle:@"إخفاء" otherButtonTitles:nil] autorelease] show];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSHTTPURLResponse *urlResponse, NSError *error) {
        NSLog(@"[ERROR]: %@", error.description);
        [self.loadingView removeFromSuperview];
        
        [[[[UIAlertView alloc] initWithTitle:@"[ERROR]" message:error.description delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] autorelease] show];
    }];
}


- (IBAction)FinishedBtnTouched:(id)sender {
    
    if (![self checkInputFields]) {
        [[[[UIAlertView alloc] initWithTitle:@"خطأ" message:@"برجاء ادخال البيانات الاساسية" delegate:nil cancelButtonTitle:@"موافق" otherButtonTitles:nil] autorelease] show];
        return;
    }
    
    [(UIButton *)sender setEnabled:NO];
    loadingView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    loadingView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.8];
    UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [loadingView addSubview:view];
    [view startAnimating];
    view.center = CGPointMake(loadingView.bounds.size.width/2, loadingView.bounds.size.height/2);
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 100)] autorelease];
    label.text = @"انتظر قليلاً جاري رفع الاعلان...";
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.center = CGPointMake(view.center.x, view.center.y + view.frame.size.height + 50);
    [loadingView addSubview:label];
    [self.view addSubview:loadingView];
    
    
    adDataDictionary = [[NSMutableDictionary alloc] init];
    
    [adDataDictionary setObject:@"12" forKey:@"action"];
    if (_userID) {
        [adDataDictionary setObject:_userID forKey:@"userid"];
        [adDataDictionary setObject:[userInfo objectForKey:@"username"] forKey:@"username"];
        [adDataDictionary setObject:[userInfo objectForKey:@"email"] forKey:@"email"];
        if (![self.additionalPhoneNumberTextField.text isEqualToString:@""]) {
            [adDataDictionary setObject:self.additionalPhoneNumberTextField.text forKey:@"phone"];
        } else {
            [adDataDictionary setObject:[userInfo objectForKey:@"phone"] forKey:@"phone"];
        }
        [adDataDictionary setObject:[userInfo objectForKey:@"mobile"] forKey:@"mobile"];
    }
        
    if (![self.categoryComboBox.text isEqualToString:@""]) {
        [adDataDictionary setObject:[self.categoriesDataSource.allKeys objectAtIndex:[self.categoriesDataSource.allValues indexOfObject:self.categoryComboBox.text]] forKey:@"sectionid"];
    } else {
        [adDataDictionary setObject:@"" forKey:@"sectionid"];
    }
    
    if (![self.typeComboBox.text isEqualToString:@""]) {
        [adDataDictionary setObject:[self.typesDataSource.allKeys objectAtIndex:[self.typesDataSource.allValues indexOfObject:self.typeComboBox.text]] forKey:@"typeid"];
    } else {
        [adDataDictionary setObject:@"" forKey:@"typeid"];
    }
    
    if (![self.modelCombBox.text isEqualToString:@""]) {
        [adDataDictionary setObject:[self.modelDataSource.allKeys objectAtIndex:[self.modelDataSource.allValues indexOfObject:self.modelCombBox.text]] forKey:@"modelid"];
    } else {
        [adDataDictionary setObject:@"" forKey:@"modelid"];
    }
    
    [adDataDictionary setObject:self.adTitleTextField.text forKey:@"proname"];
    [adDataDictionary setObject:self.descriptionTextField.text forKey:@"detail"];
    [adDataDictionary setObject:self.priceTextField.text forKey:@"price"];
    
    if (imagesArray && imagesArray.count) {
        [self performSelectorInBackground:@selector(uploadImagesInBackground) withObject:nil];    
    } else {
        [adDataDictionary setObject:@"" forKey:@"picstr"];
        [self uploadAddData:adDataDictionary afterUploadingImages:nil];
    }
}

- (IBAction)photoBtnTouceh:(UIButton *)sender {
    self.selectedButton = sender;
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = (UIImagePickerControllerSourceTypePhotoLibrary | UIImagePickerControllerSourceTypeSavedPhotosAlbum);
    if (iPhone) {
        [self presentModalViewController:imagePicker animated:YES];        
    } else {
        self.popover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        [self.popover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    
}

#pragma mark - ImagePickerViewDelegate

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissModalViewControllerAnimated:YES];
    [picker release];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self.imagesArray addObject:[info objectForKey:UIImagePickerControllerOriginalImage]];
    [self.selectedButton setImage:[info objectForKey:UIImagePickerControllerOriginalImage] forState:UIControlStateNormal];
    [self dismissModalViewControllerAnimated:YES];
    [self.popover dismissPopoverAnimated:YES];
    [self.popover release];
    self.popover = nil;
    [picker release];
}

#pragma mark - NWPikerFieldDelegate
-(NSInteger)numberOfComponentsInPickerField:(NWPickerField *)pickerField {
    return 1;
}
-(NSInteger)pickerField:(NWPickerField *)pickerField numberOfRowsInComponent:(NSInteger)component {
    switch (pickerField.tag) {
        case 0:
            return self.categoriesDataSource.count;
            break;
        case 1:
            return self.typesDataSource.count;
            break;
        case 2:
            return self.modelDataSource.count;
            break;
        default:
            return 0;
            break;
    }
}
-(NSString *)pickerField:(NWPickerField *)pickerField titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (pickerField.tag) {
        case 0:
            return [self.categoriesDataSource objectForKey:[self.categoriesDataSource.allKeys objectAtIndex:row]];
            break;
        case 1:
            return [self.typesDataSource objectForKey:[self.typesDataSource.allKeys objectAtIndex:row]];
            break;
        case 2:
            return [self.modelDataSource objectForKey:[self.modelDataSource.allKeys objectAtIndex:row]];
            break;
        default:
            return @"";
            break;
    }
}


-(void)pickerField:(NWPickerField *)pickerField didSelectRow:(NSInteger)row forComponent:(NSInteger)component {
    NSLog(@"Picker DidSelectRow: %i", row);

    switch (pickerField.tag) {
        case 0:
            self.typesDataSource = nil;
            [self.typeComboBox.pickerView reloadAllComponents];
            self.typeComboBox.text = @"";
            self.modelDataSource = nil;
            [self.modelCombBox.pickerView reloadAllComponents];
            self.modelCombBox.text = @"";
            [self loadTypesWithCategoryID:[self.categoriesDataSource.allKeys objectAtIndex:row]];
            break;
        case 1:
            self.modelDataSource = nil;
            [self.modelCombBox.pickerView reloadAllComponents]; 
            self.modelCombBox.text = @"";           
            [self loadModelsWithTypeID:[self.typesDataSource.allKeys objectAtIndex:row]];
            break;
        default:
            break;
    }
}
#pragma mark - Loading DataSource

-(void)loadCategories {
    self.categoriesDataSource = [[[NSMutableDictionary alloc] init] autorelease];
    [NetworkOperations POSTResponseWithURL:@"" andParameters:[NSDictionary dictionaryWithObject:@"1" forKey:@"action"] success:^(id response) {
        for (NSArray *arr in response) {
            if (arr.count < 2) {
                continue;
            }
            [self.categoriesDataSource setObject:[arr objectAtIndex:1] forKey:[arr objectAtIndex:0]];
        }
        [self.categoryComboBox.pickerView reloadAllComponents];
        
    } failure:^(NSHTTPURLResponse *urlResponse, NSError *error) {
        NSLog(@"[ERROR]: %@", error.description);
    }];
}

-(void)loadTypesWithCategoryID:(NSString *)categoryID {
    UIActivityIndicatorView *spinner = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
    [self.typeComboBox addSubview:spinner];
    [spinner startAnimating];
    spinner.center = CGPointMake(spinner.superview.bounds.size.width/2, spinner.superview.bounds.size.height/2);
    
    [NetworkOperations POSTResponseWithURL:@"" andParameters:[NSDictionary dictionaryWithObjectsAndKeys:@"2", @"action", categoryID, @"secid", nil] success:^(id response) {
        [self.typeComboBox.subviews.lastObject removeFromSuperview];
        self.typesDataSource = [[[NSMutableDictionary alloc] init] autorelease];
        for (NSArray *arr in response) {
            [self.typesDataSource setObject:[arr objectAtIndex:1] forKey:[arr objectAtIndex:0]];
        }
        self.typeComboBox.enabled = YES;
        self.modelCombBox.enabled = NO;
        [self.typeComboBox.pickerView reloadAllComponents];
    } failure:^(NSHTTPURLResponse *urlResponse, NSError *error) {
        NSLog(@"[ERROR]: %@", error.description);
        [self.typeComboBox.subviews.lastObject removeFromSuperview];
    }];
}

-(void)loadModelsWithTypeID:(NSString *)typeID {
    
    UIActivityIndicatorView *spinner = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
    [self.modelCombBox addSubview:spinner];
    [spinner startAnimating];
    spinner.center = CGPointMake(spinner.superview.bounds.size.width/2, spinner.superview.bounds.size.height/2);
    
    [NetworkOperations POSTResponseWithURL:@"" andParameters:[NSDictionary dictionaryWithObjectsAndKeys:@"3", @"action", typeID, @"typid", nil] success:^(id response) {
        [self.modelCombBox.subviews.lastObject removeFromSuperview];
        self.modelDataSource = [[[NSMutableDictionary alloc] init] autorelease];
        for (NSArray *arr in response) {
            [self.modelDataSource setObject:[arr objectAtIndex:1] forKey:[arr objectAtIndex:0]];
        }
        self.modelCombBox.enabled = YES;
        [self.modelCombBox.pickerView reloadAllComponents];
    } failure:^(NSHTTPURLResponse *urlResponse, NSError *error) {
        NSLog(@"[ERROR]: %@", error.description);
        [self.modelCombBox.subviews.lastObject removeFromSuperview];
    }];
}

-(BOOL)checkInputFields {
    if (![self.typeComboBox.text isEqualToString:@""] && ![self.modelCombBox.text isEqualToString:@""] && ![self.categoryComboBox.text isEqualToString:@""] && ![self.adTitleTextField.text isEqualToString:@""] && ![descriptionTextField.text isEqualToString:@""]) {
        return YES;
    }
    return NO;
}


@end
