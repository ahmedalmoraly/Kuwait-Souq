//
//  SearchViewController.m
//  Sooq
//
//  Created by Ahmad al-Moraly on 12/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SearchViewController.h"
#import "NWPickerField.h"
#import "NWPickerView.h"
#import "NetworkOperations.h"
#import "SearchResult.h"
#import "Global.h"
#import "TabBarController.h"

@interface SearchViewController() <NWPickerFieldDelegate, UITextFieldDelegate>

@property (retain, nonatomic) IBOutlet UITextField *titleTextField;
@property (retain, nonatomic) IBOutlet NWPickerField *categoryCombBox;
@property (retain, nonatomic) IBOutlet NWPickerField *typeCombBox;
@property (retain, nonatomic) IBOutlet NWPickerField *modelComboBox;
@property (retain, nonatomic) IBOutlet UITextField *priceFormTextField;
@property (retain, nonatomic) IBOutlet UITextField *priceToTextField;


@property (retain, nonatomic) NSMutableDictionary *categoriesDataSource;
@property (retain, nonatomic) NSMutableDictionary *typesDataSource;
@property (retain, nonatomic) NSMutableDictionary *modelDataSource;


-(void)loadCategories;
-(void)loadTypesWithCategoryID:(NSString *)categoryID;
-(void)loadModelsWithTypeID:(NSString *)typeID;

-(void)backViewDidTouched;
@end

@implementation SearchViewController
@synthesize titleTextField;
@synthesize categoryCombBox;
@synthesize typeCombBox;
@synthesize modelComboBox;
@synthesize priceFormTextField;
@synthesize priceToTextField;
@synthesize categoriesDataSource;
@synthesize typesDataSource;
@synthesize modelDataSource;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIControl *backView = [[UIControl alloc] initWithFrame:self.view.bounds];
        backView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:backView];
        [self.view sendSubviewToBack:backView];
        [backView addTarget:self action:@selector(backViewDidTouched) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)backViewDidTouched {
    [self.titleTextField resignFirstResponder];
    [self.categoryCombBox.pickerView resignFirstResponder];
    [self.typeCombBox.pickerView resignFirstResponder];
    [self.modelComboBox.pickerView resignFirstResponder];
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
    // Do any additional setup after loading the view from its nib.
    [self loadCategories];
    self.categoryCombBox.NWDelegate = self;
    self.typeCombBox.NWDelegate = self;
    self.modelComboBox.NWDelegate = self;
}

- (void)viewDidUnload
{
    [self setTitleTextField:nil];
    [self setCategoryCombBox:nil];
    [self setTypeCombBox:nil];
    [self setModelComboBox:nil];
    [self setPriceFormTextField:nil];
    [self setPriceToTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [titleTextField release];
    [categoryCombBox release];
    [typeCombBox release];
    [modelComboBox release];
    [priceFormTextField release];
    [priceToTextField release];
    [super dealloc];
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
    switch (pickerField.tag) {
        case 0:
            self.typeCombBox.enabled = NO;
            self.typeCombBox.enabled = NO;
            self.typesDataSource = nil;
            [self.typeCombBox.pickerView reloadAllComponents];
            self.typeCombBox.text = @"";
            self.modelDataSource = nil;
            [self.modelComboBox.pickerView reloadAllComponents];
            self.modelComboBox.text = @"";
            [self loadTypesWithCategoryID:[self.categoriesDataSource.allKeys objectAtIndex:row]];
            break;
        case 1:
            self.modelDataSource = nil;
            [self.modelComboBox.pickerView reloadAllComponents]; 
            self.modelComboBox.text = @"";           
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
        [self.categoryCombBox.pickerView reloadAllComponents];
        
    } failure:^(NSHTTPURLResponse *urlResponse, NSError *error) {
        NSLog(@"[ERROR]: %@", error.description);
    }];
}

-(void)loadTypesWithCategoryID:(NSString *)categoryID {
    UIActivityIndicatorView *spinner = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
    [self.typeCombBox addSubview:spinner];
    [spinner startAnimating];
    spinner.center = CGPointMake(spinner.superview.bounds.size.width/2, spinner.superview.bounds.size.height/2);
    [NetworkOperations POSTResponseWithURL:@"" andParameters:[NSDictionary dictionaryWithObjectsAndKeys:@"2", @"action", categoryID, @"secid", nil] success:^(id response) {
        [self.typeCombBox.subviews.lastObject removeFromSuperview];
        self.typesDataSource = [[[NSMutableDictionary alloc] init] autorelease];
        NSLog(@"TypeResponse: %@", response);
        for (NSArray *arr in response) {
            [self.typesDataSource setObject:[arr objectAtIndex:1] forKey:[arr objectAtIndex:0]];
        }
        self.typeCombBox.enabled = YES;
        self.modelComboBox.enabled = NO;
        [self.typeCombBox.pickerView reloadAllComponents];
    } failure:^(NSHTTPURLResponse *urlResponse, NSError *error) {
        NSLog(@"[ERROR]: %@", error.description);
        [self.typeCombBox.subviews.lastObject removeFromSuperview];
    }];
}

-(void)loadModelsWithTypeID:(NSString *)typeID {
    UIActivityIndicatorView *spinner = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
    [self.modelComboBox addSubview:spinner];
    [spinner startAnimating];
    spinner.center = CGPointMake(spinner.superview.bounds.size.width/2, spinner.superview.bounds.size.height/2);
    [NetworkOperations POSTResponseWithURL:@"" andParameters:[NSDictionary dictionaryWithObjectsAndKeys:@"3", @"action", typeID, @"typid", nil] success:^(id response) {
        [self.modelComboBox.subviews.lastObject removeFromSuperview];
        NSLog(@"ModelResponse: %@", response);

        self.modelDataSource = [[[NSMutableDictionary alloc] init] autorelease];
        for (NSArray *arr in response) {
            [self.modelDataSource setObject:[arr objectAtIndex:1] forKey:[arr objectAtIndex:0]];
        }
        self.modelComboBox.enabled = YES;
        [self.modelComboBox.pickerView reloadAllComponents];
    } failure:^(NSHTTPURLResponse *urlResponse, NSError *error) {
        NSLog(@"[ERROR]: %@", error.description);
        [self.modelComboBox.subviews.lastObject removeFromSuperview];
    }];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.priceToTextField || textField == self.priceFormTextField) {
        [UIView animateWithDuration:0.5 animations:^{
            self.view.transform = CGAffineTransformMakeTranslation(0, -170);
        }];
    }
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.priceToTextField || textField == self.priceFormTextField) {
        [UIView animateWithDuration:0.5 animations:^{
            self.view.transform = CGAffineTransformMakeTranslation(0, 0);
        }];
    }
    return [textField resignFirstResponder];
}

- (IBAction)searchBtnTouched:(id)sender {
    
    [self backViewDidTouched];
    
    NSMutableDictionary *dataToSearch = [NSMutableDictionary dictionary];
        //NSDictionary *_dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"9", @"action",_section, @"section", _type, @"type", _proTitle, @"q", _model, @"model", _price1, @"price1", _price2, @"price2", _pic, @"pic", nil];
    [dataToSearch setObject:self.titleTextField.text forKey:@"q"];
    
    if (![self.categoryCombBox.text isEqualToString:@""]) {
        [dataToSearch setObject:[self.categoriesDataSource.allKeys objectAtIndex:[self.categoriesDataSource.allValues indexOfObject:self.categoryCombBox.text]] forKey:@"section"];
    } else {
        [dataToSearch setObject:@"" forKey:@"section"];
    }
    
    if (![self.typeCombBox.text isEqualToString:@""]) {
        [dataToSearch setObject:[self.typesDataSource.allKeys objectAtIndex:[self.typesDataSource.allValues indexOfObject:self.typeCombBox.text]] forKey:@"type"];
    } else {
        [dataToSearch setObject:@"" forKey:@"type"];
    }
    
    if (![self.modelComboBox.text isEqualToString:@""]) {
        [dataToSearch setObject:[self.modelDataSource.allKeys objectAtIndex:[self.modelDataSource.allValues indexOfObject:self.modelComboBox.text]] forKey:@"model"];
    } else {
        [dataToSearch setObject:@"" forKey:@"model"];
    }
    
    
    [dataToSearch setObject:self.priceFormTextField.text forKey:@"price1"];
    [dataToSearch setObject:self.priceToTextField.text forKey:@"price2"];
    [dataToSearch setObject:@"0" forKey:@"pic"];
    
    SearchResult *resultController;
    if (iPhone) {
        resultController = [[SearchResult alloc] initWithNibName:@"SearchResult_iPhone" bundle:nil];
    } else {
        resultController = [[SearchResult alloc] initWithNibName:@"SearchResult_iPad" bundle:nil];
    }
    resultController.dataToSearch = dataToSearch;
    
    if ([[UIDevice currentDevice].systemVersion substringToIndex:1].integerValue > 4) {
        [(UINavigationController *)[(TabBarController *)self.presentingViewController selectedViewController] pushViewController:resultController animated:YES];
        [self.presentingViewController dismissViewControllerAnimated:NO completion:Nil];
    } else {
        [(UINavigationController *)[(TabBarController *)self.parentViewController selectedViewController] pushViewController:resultController animated:YES];
        [self.parentViewController dismissModalViewControllerAnimated:YES];
    }
    
    
}

- (IBAction)cancelBtnTouched:(id)sender {
    if ([[UIDevice currentDevice].systemVersion substringToIndex:1].integerValue > 4) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:Nil];
    }
    [self.parentViewController dismissModalViewControllerAnimated:YES];
}
@end
