#import "MainMenu.h"
#import "LoginPage.h"
#import "Global.h"
#import "SearchViewController.h"
#import "AdvertisingViewController.h"
#import "RegisterationAgreement.h"

#define LoginButtonSmall_iPhone @"Login3_iPhone"
#define LoginButtonMedium_iPhone @"Login2_iPhone"
#define LoginButtonLarge_iPhone @"Login_iPhone"

#define LoginButtonSmall_iPad @"Login3_iPhone"
#define LoginButtonMedium_iPad @"Login2_iPhone"
#define LoginButtonLarge_iPad @"Login_iPhone"

#define LogoutButtonSmall_iPhone @"Logout3_iPhone"
#define LogoutButtonMedium_iPhone @"Logout2_iPhone"
#define LogoutButtonLarge_iPhone @"Logout_iPhone"

#define LogoutButtonSmall_iPad @"Logout3_iPad"
#define LogoutButtonMedium_iPad @"Logout2_iPad"
#define LogoutButtonLarge_iPad @"Logout_iPad"

#define AddAdsButtonSmall_iPhone @"AddAds3_iPhone"
#define AddAdsButtonMedium_iPhone @"AddAds2_iPhone"
#define AddAdsButtonLarge_iPhone @"AddAds_iPhone"

#define AddAdsButtonSmall_iPad @"AddAds3_iPad"
#define AddAdsButtonMedium_iPad @"AddAds2_iPad"
#define AddAdsButtonLarge_iPad @"AddAds_iPad"

#define SearchButtonSmall_iPhone @"Search3_iPhone"
#define SearchButtonMedium_iPhone @"Search2_iPhone"
#define SearchButtonLarge_iPhone @"Search1_iPhone"

#define SearchButtonSmall_iPad @"Search3_iPad"
#define SearchButtonMedium_iPad @"Search2_iPad"
#define SearchButtonLarge_iPad @"Search1_iPad"

#define SectionsButtonSmall_iPhone @"Sections3_iPhone"
#define SectionsButtonMedium_iPhone @"Sections2_iPhone"
#define SectionsButtonLarge_iPhone @"Sections_iPhone"

#define SectionsButtonSmall_iPad @"Sections3_iPad"
#define SectionsButtonMedium_iPad @"Sections2_iPad"
#define SectionsButtonLarge_iPad @"Sections_iPad"


enum ImageType {
    small, meduim, large 
};

enum Direction {
    up, left, down, right
};

struct ButtonProperty {
    CGRect buttonProp;
    enum ImageType _imgType;
    enum Direction _dir;

} downButton, upButton, leftButton, rightButton;

@implementation MainMenu

@synthesize btn_down, btn_up, btn_left, btn_right;

-(IBAction)fireEvent :(UIButton *) sender {
    
    switch (sender.tag) {
        case 1:
            if (iPhone) {
                category = [[Categories alloc] initWithNibName:@"Categories_iPhone" bundle:nil];
            } else {
                category = [[Categories alloc] initWithNibName:@"Categories_iPad" bundle:nil];
            }
                [self.navigationController pushViewController:category animated:YES];
            break;
            
        case 2:       
            if (iPhone) {
                searchController = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
            } else {
                searchController = [[SearchViewController alloc] initWithNibName:@"SearchViewController_iPad" bundle:nil];
            }
            [self presentModalViewController:searchController animated:YES];
            break;
            
        case 3:
            //if (userLoginState)
            {
                if (iPhone) {
                    adds = [[Add_Ads alloc] initWithNibName:@"AddAdsLoginState_iPhone" bundle:nil];                    
                } else {
                    adds = [[Add_Ads alloc] initWithNibName:@"AddAdsLoginState_iPad" bundle:nil];
                }
                [self.navigationController pushViewController:adds animated:YES];
            }
            //else
            {
                [[[[UIAlertView alloc] initWithTitle:@"عفواً" message:@"لإضافة اعلان جديد فضلا قم بتسجيل الدخول" delegate:nil cancelButtonTitle:@"موافق" otherButtonTitles: nil] autorelease] show];
            }
            break;
            
        case 4:
            if (userLoginState) {
                [[[[UIAlertView alloc] initWithTitle:@"تسجيل الخروج" message:@"تم تسجيل الخروج بنجاح" delegate:nil cancelButtonTitle:@"موافق" otherButtonTitles:nil] autorelease] show];
                userLoginState = NO;
                _userID = 0;
                [userInfo release];
                [self updateLoginButtonWithLoginState:NO];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"username"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"password"];
                
            } else {
                if (iPhone) {
                    login = [[LoginPage alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
                } else {
                    login = [[LoginPage alloc] initWithFrame:CGRectMake(0, 0, 768, 1004)];
                }
                [self.view addSubview:login];
                loginView = YES;
            
            }
            break;
            
        default:
            break;
    }
    
}

-(enum Direction) getDirInRight :(struct ButtonProperty) currectButton {
    
    if (currectButton._dir == down) {
        currectButton._dir = right;
    }
    
    else if (currectButton._dir == right) {
        currectButton._dir = up;
    }
    
    else if (currectButton._dir == up) {
        currectButton._dir = left;
    }
    
    else if (currectButton._dir == left) {
        currectButton._dir = down;
    }
    
    return currectButton._dir;
}

-(enum Direction) getDirInLeft :(struct ButtonProperty) currectButton {
    
    if (currectButton._dir == down) {
        currectButton._dir = left;
    }
    
    else if (currectButton._dir == right) {
        currectButton._dir = down;
    }
    
    else if (currectButton._dir == up) {
        currectButton._dir = right;
    }
    
    else if (currectButton._dir == left) {
        currectButton._dir = up;
    }
    
    return currectButton._dir;
}

-(CGRect) getButtonRect:(enum Direction)newDir {
    CGRect newRect;
    
    if (iPhone) {
        if (newDir == down) { 
            newRect = CGRectMake(106, 238, 109, 165);
        }
        
        else if (newDir == right) {
            newRect = CGRectMake(223, 171, 83, 127);
        }
        
        else if (newDir == up) {
            newRect = CGRectMake(125, 94, 71, 106);
        }
        
        else if (newDir == left) {
            newRect = CGRectMake(15, 171, 83, 127);
        }
        
    }
    
    else {
        if (newDir == down) { 
            newRect = CGRectMake(299, 634, 167, 246);
        }
        
        else if (newDir == right) {
            newRect = CGRectMake(474, 425, 136, 201);
        }
        
        else if (newDir == up) {
            newRect = CGRectMake(321, 212, 122, 183);
        }
        
        else if (newDir == left) {
            newRect = CGRectMake(155, 425, 136, 201);
        }
    }
    
    
    return newRect;
}

-(enum ImageType) getNewImageType:(enum Direction) btnDir {
    if (btnDir == left || btnDir == right) {
        return meduim;
    }
    else if (btnDir == up) {
        return small;
    }
    
    else {
        return large;
    }
}
// don't understand this part
-(NSString *)getNewImage :(UIButton *)btn :(enum Direction)dir {
    
    // down button.
    if (btn == btn_down && dir == down) {
        if (iPhone) 
            return SectionsButtonLarge_iPhone;
        else
            return SectionsButtonLarge_iPad;
    }
    
    else if (btn == btn_down && (dir == right || dir == left)) {
        if (iPhone) 
            return SectionsButtonMedium_iPhone;
        else
            return SectionsButtonMedium_iPad;
    }
    
    else if (btn == btn_down && dir == up) {
        if (iPhone) 
            return SectionsButtonSmall_iPhone;
        else
            return SectionsButtonSmall_iPad;
    }
    
    // right button
    if (btn == btn_right && dir == down) {
        if (iPhone) 
            return SearchButtonLarge_iPhone;
        else
            return SearchButtonLarge_iPad;
    }
    
    else if (btn == btn_right && (dir == right || dir == left)) {
        if (iPhone) 
            return SearchButtonMedium_iPhone;
        else
            return SearchButtonMedium_iPad;
    }
    
    else if (btn == btn_right && dir == up) {
        if (iPhone) 
            return SearchButtonSmall_iPhone;
        else
            return SearchButtonSmall_iPad;
    }
    
    // up button
    if (btn == btn_up && dir == down) {
        if (iPhone) 
            return AddAdsButtonLarge_iPhone;
        else
            return AddAdsButtonLarge_iPad;
    }
    
    else if (btn == btn_up && (dir == right || dir == left)) {
        if (iPhone) 
            return AddAdsButtonMedium_iPhone;
        else
            return AddAdsButtonMedium_iPad;
    }
    
    else if (btn == btn_up && dir == up) {
        if (iPhone) 
            return AddAdsButtonSmall_iPhone;
        else
            return AddAdsButtonSmall_iPad;
    }
    
    // left button
    if (btn == btn_left && dir == down) {
        return _login1;
    }
    
    else if (btn == btn_left && (dir == right || dir == left)) {
        return _login2;
    }
    
    else if (btn == btn_left && dir == up) {
        return _login3;
    }
 ////////////////////////////////////////////////till here   
    
    return NULL;
}

-(void) makeAnimation :(NSString *)image :(CGRect)btnRect :(UIButton *)btnToChange {
    [UIView animateWithDuration:0.2 animations:^(void) {
        [btnToChange setTransform:CGAffineTransformMakeTranslation(btnRect.origin.x, btnRect.origin.y)];
        [btnToChange setFrame:btnRect];
        [btnToChange setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    }];
}

-(struct ButtonProperty)saveState: (enum Direction)btnDir :(CGRect)btnRect {
    struct ButtonProperty savedButtonState;
    savedButtonState._dir = btnDir;
    savedButtonState.buttonProp = btnRect;
    return savedButtonState;
}

-(void) rotateRight {
    enum Direction downButtonDir = [self getDirInRight:downButton];
    enum Direction rightButtonDir = [self getDirInRight:rightButton];
    enum Direction upButtonDir = [self getDirInRight:upButton];
    enum Direction leftButtonDir = [self getDirInRight:leftButton];

    
    CGRect downRect = [self getButtonRect:downButtonDir];
    CGRect rightRect = [self getButtonRect:rightButtonDir];
    CGRect upRect = [self getButtonRect:upButtonDir];
    CGRect leftRect = [self getButtonRect:leftButtonDir];

    
    NSString *downImgToDisplay = [self getNewImage:btn_down :downButtonDir];
    NSString *rightImgToDisplay = [self getNewImage:btn_right :rightButtonDir];
    NSString *upImgToDisplay = [self getNewImage:btn_up :upButtonDir];
    NSString *leftImgToDisplay = [self getNewImage:btn_left :leftButtonDir];
    
    [self makeAnimation :downImgToDisplay :downRect :btn_down];
    [self makeAnimation :rightImgToDisplay :rightRect :btn_right];
    [self makeAnimation :upImgToDisplay :upRect :btn_up];
    [self makeAnimation :leftImgToDisplay :leftRect :btn_left];
    downButton = [self saveState:downButtonDir :downRect];
    rightButton = [self saveState:rightButtonDir :rightRect];
    upButton = [self saveState:upButtonDir :upRect];
    leftButton = [self saveState:leftButtonDir :leftRect];
}

-(void) rotateLeft {
    enum Direction downButtonDir = [self getDirInLeft:downButton];
    enum Direction rightButtonDir = [self getDirInLeft:rightButton];
    enum Direction upButtonDir = [self getDirInLeft:upButton];
    enum Direction leftButtonDir = [self getDirInLeft:leftButton];
    
    CGRect downRect = [self getButtonRect:downButtonDir];
    CGRect rightRect = [self getButtonRect:rightButtonDir];
    CGRect upRect = [self getButtonRect:upButtonDir];
    CGRect leftRect = [self getButtonRect:leftButtonDir];
    
    NSString *downImgToDisplay = [self getNewImage:btn_down :downButtonDir];
    NSString *rightImgToDisplay = [self getNewImage:btn_right :rightButtonDir];
    NSString *upImgToDisplay = [self getNewImage:btn_up :upButtonDir];
    NSString *leftImgToDisplay = [self getNewImage:btn_left :leftButtonDir];
    
    [self makeAnimation :downImgToDisplay :downRect :btn_down];
    [self makeAnimation :rightImgToDisplay :rightRect :btn_right];
    [self makeAnimation :upImgToDisplay :upRect :btn_up];
    [self makeAnimation :leftImgToDisplay :leftRect :btn_left];
    
    downButton = [self saveState:downButtonDir :downRect];
    rightButton = [self saveState:rightButtonDir :rightRect];
    upButton = [self saveState:upButtonDir :upRect];
    leftButton = [self saveState:leftButtonDir :leftRect];
}

-(IBAction) rotate:(UIButton *)sender {
    switch (sender.tag) {
            
        case 1:
            [self rotateRight];
            break;
            
        case 2:
            [self rotateLeft];
            break;
            
        default:
            break;
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginStateDidChanged) name:UserIsLoggedIn object:nil];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES];
    if (loginView) {
        [login removeFromSuperview];
        loginView = NO;
    }

    
}

- (void)dealloc
{
    [btn_up release];
    btn_up = nil;
    [btn_down release];
    btn_down = nil;
    [btn_right release];
    btn_right = nil;
    [btn_left release];
    btn_left = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/////////////////////////////////////////////////MoshFahmaElpartDa
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (userLoginState) {
        if (iPhone) {
            _login1 = LogoutButtonLarge_iPhone;
            _login2 = LogoutButtonMedium_iPhone;
            _login3 = LogoutButtonSmall_iPhone;
        }
        else {
            _login1 = LogoutButtonLarge_iPad;
            _login2 = LogoutButtonMedium_iPad;
            _login3 = LogoutButtonSmall_iPad;
        }
    }
    else {
        if (iPhone) {
            _login1 = LoginButtonLarge_iPhone;
            _login2 = LoginButtonMedium_iPhone;
            _login3 = LoginButtonSmall_iPhone;
        }
        else {
            _login1 = LoginButtonLarge_iPad;
            _login2 = LoginButtonMedium_iPad;
            _login3 = LoginButtonSmall_iPad;
        }
    }
////////////////////////////////////////////////till here
    downButton._dir = down;
    downButton._imgType = large;
    
    upButton._dir = up;
    upButton._imgType = small;

    
    leftButton._dir = left;
    leftButton._imgType = meduim;
    
    rightButton._dir = right;
    rightButton._imgType = meduim;
    
    if (iPhone) {
        leftButton.buttonProp = CGRectMake(15, 171, 83, 127);
        upButton.buttonProp = CGRectMake(125, 94, 71, 109);
        downButton.buttonProp = CGRectMake(106, 238, 109, 165);
        rightButton.buttonProp = CGRectMake(223, 171, 83, 127);
    }
    
    else {
        leftButton.buttonProp = CGRectMake(155, 425, 136, 201);
        upButton.buttonProp = CGRectMake(321, 212, 122, 183);
        downButton.buttonProp = CGRectMake(299, 634, 167, 246);
        rightButton.buttonProp = CGRectMake(474, 425, 136, 201);
        
    }
    
    
    if (iPhone) {
        [btn_down setBackgroundImage:[UIImage imageNamed:SectionsButtonLarge_iPhone] forState:UIControlStateNormal]; 
        [btn_up setBackgroundImage:[UIImage imageNamed:AddAdsButtonSmall_iPhone] forState:UIControlStateNormal];
        [btn_left setBackgroundImage:[UIImage imageNamed:_login2] forState:UIControlStateNormal];
        [btn_right setBackgroundImage:[UIImage imageNamed:SearchButtonMedium_iPhone] forState:UIControlStateNormal];
    }
    
    else {
        [btn_down setBackgroundImage:[UIImage imageNamed:SectionsButtonLarge_iPad] forState:UIControlStateNormal]; 
        [btn_up setBackgroundImage:[UIImage imageNamed:AddAdsButtonSmall_iPad] forState:UIControlStateNormal];
        [btn_left setBackgroundImage:[UIImage imageNamed:_login2] forState:UIControlStateNormal];
        [btn_right setBackgroundImage:[UIImage imageNamed:SearchButtonMedium_iPad] forState:UIControlStateNormal];
    }
    
    [btn_down addTarget:self action:@selector(fireEvent:) forControlEvents:UIControlEventTouchUpInside];
    [btn_left addTarget:self action:@selector(fireEvent:) forControlEvents:UIControlEventTouchUpInside];
    [btn_up addTarget:self action:@selector(fireEvent:) forControlEvents:UIControlEventTouchUpInside];
    [btn_right addTarget:self action:@selector(fireEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    AdvertisingViewController *advertise;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        advertise = [[AdvertisingViewController alloc] initWithNibName:@"AdvertisingViewController" bundle:nil];
    } else {
        advertise = [[AdvertisingViewController alloc] initWithNibName:@"AdvertisingViewController_iPad" bundle:nil];
    }
    
    if ([[UIDevice currentDevice].systemVersion substringToIndex:1].integerValue > 4) {
        [self presentViewController:advertise animated:YES completion:nil];
    }
    else
    {
        [self presentModalViewController:advertise animated:YES];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [btn_up release];
    [btn_down release];
    [btn_right release];
    [btn_left release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)updateLoginButtonWithLoginState:(BOOL)loggedin {
    if (loggedin) {
        if (iPhone) {
            _login1 = LogoutButtonLarge_iPhone;
            _login2 = LogoutButtonMedium_iPhone;
            _login3 = LogoutButtonSmall_iPhone;
        }
        else {
            _login1 = LogoutButtonLarge_iPad;
            _login2 = LogoutButtonMedium_iPad;
            _login3 = LogoutButtonSmall_iPad;
        }
    }
    else {
        if (iPhone) {
            _login1 = LoginButtonLarge_iPhone;
            _login2 = LoginButtonMedium_iPhone;
            _login3 = LoginButtonSmall_iPhone;
        }
        else {
            _login1 = LoginButtonLarge_iPad;
            _login2 = LoginButtonMedium_iPad;
            _login3 = LoginButtonSmall_iPad;
        }
    }
    
    switch (leftButton._dir) {
        case up:
            [btn_left setBackgroundImage:[UIImage imageNamed:_login3] forState:UIControlStateNormal];
            break;
        case down:
            [btn_left setBackgroundImage:[UIImage imageNamed:_login1] forState:UIControlStateNormal];
            break;
        case left:
            [btn_left setBackgroundImage:[UIImage imageNamed:_login2] forState:UIControlStateNormal];
            break;
        case right:
            [btn_left setBackgroundImage:[UIImage imageNamed:_login2] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    
}

-(void)userLoginStateDidChanged {
    if (userLoginState) {
        [self updateLoginButtonWithLoginState:YES];
    } else {
        [self updateLoginButtonWithLoginState:NO];
    }
}

- (IBAction)registerationBtnTouched:(id)sender {
    RegisterationAgreement *_regAgr;
    if (iPhone) {
        _regAgr = [[RegisterationAgreement alloc] initWithNibName:@"RegisterationAgreement_iPhone" bundle:nil];
    }
    else {
        _regAgr = [[RegisterationAgreement alloc] initWithNibName:@"RegisterationAgreement_iPad" bundle:nil];
    }
    
    [self.navigationController pushViewController:_regAgr animated:YES];

}

@end
