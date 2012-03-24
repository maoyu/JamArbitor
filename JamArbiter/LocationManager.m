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
		AppDelegate * delegate = [AppDelegate delegate];
		delegate.sinaWeibo.sendWeiboSign = YES;

    [self.locationManager startUpdatingLocation];
}

- (void)startStandardLocationServcie:(BOOL) gotHeading{
    if (self.locationManager == nil) {
        [self initLocationManager];
    }
    
    self.gotCoordinate = NO;
		AppDelegate * delegate = [AppDelegate delegate];
		delegate.sinaWeibo.sendWeiboSign = NO;
		if(gotHeading == NO) {
			self.gotHeading = YES;
			
		}
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
