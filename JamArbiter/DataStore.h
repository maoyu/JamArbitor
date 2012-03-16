//
//  DataStore.h
//  JamHacker
//
//  Created by Liu Wanwei on 12-3-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MONITORING_KEY                       @"monitoring"
#define SIGNIFICENT_CHANGE_LOCATION_SERVICE  @"significent-change"
#define STANDARD_LOCATION_SERVICE            @"stardard-location-service"

#define ACCURACY_KEY                         @"accuracy"
#define DISTANCE_FILTER_KEY                  @"distance-filter"

#define DESCRIPTION_KEY                      @"discription"
#define DETAILS_KEY                          @"details"

#define DEFAULT_DISTANCE_FILTER              100.0
#define DEFAULT_ACCURACY                     kCLLocationAccuracyKilometer

#define JAM_STATE_KEY                       @"jam-state-key"
#define RECEIVER_KEY                        @"receiver-key"
#define SINA_WEIBO_SENDER_KEY               @"sina-weibo-sender-key"


@interface DataStore : NSObject

@property (strong, nonatomic) NSMutableArray * locations;
@property (strong, nonatomic) NSMutableArray * standardLocations;
@property (strong, nonatomic) NSMutableDictionary * parameters;

-(id)initFromFile;
-(void)save;

-(NSString *)monitoring;
-(void)setMonitoringValue:(NSString *)value;

-(NSString *)parameter:(NSString *)key;
-(void)setParameter:(NSString *)key withValue:(NSString *)value;

@end
