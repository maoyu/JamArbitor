//
//  LocationManager.m
//  JamArbiter
//
//  Created by Liu Wanwei on 12-3-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LocationManager.h"
#import "AppDelegate.h"

@implementation LocationManager

@synthesize locationManager = _locationManager;
@synthesize gotHeading = _gotHeading;
@synthesize gotCoordinate = _gotCoordinate;

- (id)init{
    if (self = [super init]) {
				/* FIXME maoyu 12-3-26
				 目前Heading没有用到，并且查询联想用户信息时，也会查询地理坐标信息，
				 但获取到地理坐标信息后，会根据Heading状态进行地理描述信息查询，
				 因此在这里先将Heading状态置为yes，并将获取heading的代码注释掉
				*/
				self.gotHeading = YES;
    }
    
    return self;
}

- (void)initLocationManager{
    self.locationManager = [[[CLLocationManager alloc] init] autorelease];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 10; 
    
    self.locationManager.headingFilter = 5;
}

- (void)startStandardLocationServcie{
    if (self.locationManager == nil) {
        [self initLocationManager];
    }
    
    self.gotCoordinate = NO;
    [self.locationManager startUpdatingLocation];
}

- (void)stopStandardLocationService{
    [self.locationManager stopUpdatingLocation];
}

- (void)startHeadingService{
    if (self.locationManager == nil) {
        [self initLocationManager];
    }
    
    self.gotHeading = NO;
    if ([CLLocationManager headingAvailable]) {
        [self.locationManager startUpdatingHeading];
    }
}

- (void)stopHeadingService{
    [self.locationManager stopUpdatingHeading];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    NSDate * date = newLocation.timestamp;
    NSTimeInterval howRecent = [date timeIntervalSinceNow];
    if (abs(howRecent) < 5 && self.gotCoordinate == NO) {
        AppDelegate * delegate = [AppDelegate delegate];
        [delegate.dataes addActivity:@"得到经纬度"];
        
        delegate.sinaWeibo.latitude = newLocation.coordinate.latitude;
        delegate.sinaWeibo.longitude = newLocation.coordinate.longitude;
        
        self.gotCoordinate = YES;
        [self stopStandardLocationService];
        
        if (self.gotHeading == YES) {
            [delegate.sinaWeibo requestAddress];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
    if (newHeading.headingAccuracy >= 0) {
        CLLocationDirection theHeading = ((newHeading.trueHeading > 0)? newHeading.trueHeading : newHeading.magneticHeading);
        AppDelegate * delegate = [AppDelegate delegate];
        [delegate.dataes addActivity:@"得到方向"];
        
        delegate.sinaWeibo.heading = theHeading;
        
        self.gotHeading = YES;
        [self stopHeadingService];
        
        if (self.gotCoordinate == YES) {
            [delegate.sinaWeibo requestAddress];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSString * message = [error description];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"定位" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

@end
