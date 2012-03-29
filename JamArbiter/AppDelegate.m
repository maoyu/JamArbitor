//
//  AppDelegate.m
//  JamArbiter
//
//  Created by Liu Wanwei on 12-3-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "FirstViewController.h"

#import "SecondViewController.h"

#import "DataStore.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;
@synthesize firstNavigation = _firstNavigation;
@synthesize secondNavigation = _secondNavigation;
@synthesize dataes = _dataes;
@synthesize sinaWeibo = _sinaWeibo;
@synthesize locationService = _locationService;
@synthesize imageManager = _imageManager;

- (void)dealloc
{
    [_window release];
    [_tabBarController release];
    [_firstNavigation release];
    [_secondNavigation release];
    [_sinaWeibo release];
    [_locationService release];
		[_imageManager release];
    [super dealloc];
}

+ (AppDelegate *)delegate{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    
    self.dataes = [[[DataStore alloc] initFromFile] autorelease];
    self.sinaWeibo = [[[SinaWeiboManager alloc] init] autorelease];
    self.locationService = [[[LocationManager alloc] init] autorelease];
		self.imageManager = [[[ImageManager alloc] init] autorelease];
    if ([self.sinaWeibo authorizationState] == AUTHORIZATION_EXPIRED) {
        [self.dataes setParameter:SINA_WEIBO_SENDER_NAME_KEY withValue:@""];
    }
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    UIViewController *viewController1 = [[[FirstViewController alloc] initWithNibName:@"FirstViewController" bundle:nil] autorelease];
    UINavigationController * controller = [[[UINavigationController alloc] initWithRootViewController:viewController1] autorelease];
    self.firstNavigation = controller;
    
    UIViewController *viewController2 = [[[SecondViewController alloc] initWithNibName:@"SecondViewController" bundle:nil] autorelease];
    controller = [[[UINavigationController alloc] initWithRootViewController:viewController2] autorelease];
    self.secondNavigation = controller;
    self.tabBarController = [[[UITabBarController alloc] init] autorelease];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:self.firstNavigation, self.secondNavigation, nil];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self.dataes save];  
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
