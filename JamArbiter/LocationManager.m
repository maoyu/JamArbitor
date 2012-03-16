//
//  LocationManager.m
//  JamArbiter
//
//  Created by Liu Wanwei on 12-3-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LocationManager.h"
#import "AppDelegate.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation LocationManager

@synthesize locationManager = _locationManager;

- (id)init{
    if (self = [super init]) {
        self.locationManager = [[[CLLocationManager alloc] init] autorelease];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = 10;        
    }
    
    return self;
}

- (void)startStandardLocationServcie{
    [self.locationManager startUpdatingLocation];
}

- (void)stopStandardLocationService{
    [self.locationManager stopUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    NSDate * date = newLocation.timestamp;
    NSTimeInterval howRecent = [date timeIntervalSinceNow];
    if (abs(howRecent) < 5) {
        AppDelegate * delegate = [AppDelegate delegate];        
        delegate.sinaWeibo.latitude = newLocation.coordinate.latitude;
        delegate.sinaWeibo.longitude = newLocation.coordinate.longitude;
        [delegate.sinaWeibo sendWeibo];
        
        [self stopStandardLocationService];
        
        // 震动提示。
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSString * message = [error description];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"定位" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

@end
