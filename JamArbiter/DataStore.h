//
//  DataStore.h
//  JamHacker
//
//  Created by Liu Wanwei on 12-3-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SINA_WEIBO_SENDER_NAME_KEY          @"sina-weibo-sender-key"
#define RECEIVER_KEY                        @"receiver-key"

#define ACTIVITY_PROCESS_KEY                @"activity-process"
#define ACTIVITY_RESULT_KEY                 @"activity-result"

#define RESULT_FAILED                       @"failed"
#define RESULT_SUCCESSFUL                   @"successful"

@interface DataStore : NSObject

@property (strong, nonatomic) NSMutableDictionary * parameters;
@property (strong, nonatomic) NSMutableArray * logs;
@property (strong, nonatomic) NSMutableDictionary * activity;

-(id)initFromFile;
-(void)save;

-(NSString *)parameter:(NSString *)key;
-(void)setParameter:(NSString *)key withValue:(NSString *)value;

-(void)resetActivity;
-(void)addActivity:(NSString *)activity;
-(void)addFailedActivity:(NSString *)activity;
-(void)addSuccessfulActivity:(NSString*)activity;
-(BOOL)activityResult;

@end
