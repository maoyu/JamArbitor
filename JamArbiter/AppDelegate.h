//
//  AppDelegate.h
//  JamArbiter
//
//  Created by Liu Wanwei on 12-3-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataStore.h"
#import "SinaWeiboManager.h"
#import "LocationManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;
@property (strong, nonatomic) UINavigationController * firstNavigation;
@property (strong, nonatomic) UINavigationController * secondNavigation;
@property (strong, nonatomic) DataStore * dataes;
@property (strong, nonatomic) SinaWeiboManager * sinaWeibo;
@property (strong, nonatomic) LocationManager * locationService;

+(AppDelegate *)delegate;


@end
