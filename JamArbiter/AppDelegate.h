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

@property (retain, nonatomic) UIWindow *window;
@property (retain, nonatomic) UITabBarController *tabBarController;
@property (retain, nonatomic) UINavigationController * firstNavigation;
@property (retain, nonatomic) UINavigationController * secondNavigation;
@property (retain, nonatomic) DataStore * dataes;
@property (retain, nonatomic) SinaWeiboManager * sinaWeibo;
@property (retain, nonatomic) LocationManager * locationService;

+(AppDelegate *)delegate;


@end
