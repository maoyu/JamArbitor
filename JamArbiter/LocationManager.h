//
//  LocationManager.h
//  JamArbiter
//
//  Created by Liu Wanwei on 12-3-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationManager : NSObject <CLLocationManagerDelegate>

@property (retain, nonatomic) CLLocationManager * locationManager;
@property (nonatomic) BOOL gotHeading;
@property (nonatomic) BOOL gotCoordinate;

- (id)init;

- (void)startStandardLocationServcie;
- (void)startStandardLocationServcie: (BOOL) gotHeading;
- (void)stopStandardLocationService;

- (void)startHeadingService;
- (void)stopHeadingService;

@end
