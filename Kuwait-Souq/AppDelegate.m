//
//  AppDelegate.m
//  Sooq
//
//  Created by Islam on 11/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "MainMenu.h"
#import "Global.h"
#import "Reachability.h"
#import "NetworkOperations.h"
#import <FacebookSDK/FacebookSDK.h>

static const NSInteger kGANDisPatchPeriodSec = 10;

@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBarController;
@synthesize navigationController;

- (void)dealloc
{
    [_window release];
    [navigationController release];
    [super dealloc];
}

-(void)reachabilityDidChangedWithNotification:(NSNotification *)notification {
    Reachability *reach = [notification object];
    if (![reach isReachable]) {
        [[[[UIAlertView alloc] initWithTitle:@"ERROR" message:@"No Internet connection, please ensure that your device is connected to the Internet" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] autorelease] show];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    
//    [[GANTracker sharedTracker] startTrackerWithAccountID:@"UA-28541935-1" dispatchPeriod:kGANDisPatchPeriodSec delegate:nil];
//    
//    NSError *error;
//    if (![[GANTracker sharedTracker] trackPageview:@"/app_entry_point" withError:&error]) {
//        NSLog(@"[ERROR]: %@", error);
//    }
//    
//    
//    [[GANTracker sharedTracker] trackPageview:@"" withError:nil];
//    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityDidChangedWithNotification:) name:kReachabilityChangedNotification object:nil];
    
    [[Reachability reachabilityWithHostname:@"www.sooqalq8.com"] startNotifier];
    
    // Login
    NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
    if (username) {
        NSString *password = [[NSUserDefaults standardUserDefaults] stringForKey:@"password"];
        [LoginPage loginWithUsername:username andPassword:password andDevice:[[NSUserDefaults standardUserDefaults] stringForKey:@"deviceToken"]];
    }
    
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        iPhone = YES;
    } else {
        iPhone = NO;
    }
    self.tabBarController = [[TabBarController alloc] init];
    
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString* newToken = [deviceToken description];
	newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
	newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [[NSUserDefaults standardUserDefaults] setObject:newToken forKey:@"deviceToken"];
	NSLog(@"My token is: %@", newToken);

}
- (BOOL)application:(UIApplication *)application
             openURL:(NSURL *)url
   sourceApplication:(NSString *)sourceApplication
          annotation:(id)annotation {
    
    // attempt to extract a token from the url
    return [FBSession.activeSession handleOpenURL:url];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"RemoteNotificationError: %@", error.localizedDescription);
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
