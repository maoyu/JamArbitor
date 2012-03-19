//
//  DataStore.m
//  JamHacker
//
//  Created by Liu Wanwei on 12-3-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DataStore.h"
#include <sys/xattr.h>

@implementation DataStore

@synthesize parameters = _parameters;
@synthesize logs = _logs;
@synthesize activity = _activity;

-(void)dealloc{
    [_logs release];
    [_activity release];
    
    [super dealloc];
}

- (NSString *)dataPath{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

- (NSString *)paramFilePath{
    static NSString * kFilename = @"collectionParameters.txt";
    return [[self dataPath] stringByAppendingPathComponent:kFilename];
}

- (NSString *)logFilePath{
    static NSString * kFilename = @"activityLogs.txt";
    return [[self dataPath] stringByAppendingPathComponent:kFilename];
}

- (id)initFromFile{
    if (self = [super init]) {
        NSFileManager * manager = [NSFileManager defaultManager];
        NSString * filePath;
            
        filePath = [self paramFilePath];
        if ([manager fileExistsAtPath:filePath]) {
            self.parameters = [[[NSMutableDictionary alloc] initWithContentsOfFile:filePath] autorelease];
        }else{
            self.parameters = [[NSMutableDictionary alloc] init];
        }
        
        filePath = [self logFilePath];
        if ([manager fileExistsAtPath:filePath]) {
            self.logs = [[[NSMutableArray alloc] initWithContentsOfFile:filePath] autorelease];
        }else{
            self.logs = [[NSMutableArray alloc] init];
        }
        
        NSMutableArray * array = [[[NSMutableArray alloc] init] autorelease];
        self.activity = [NSMutableDictionary dictionaryWithObjectsAndKeys:array, ACTIVITY_PROCESS_KEY, 
                         RESULT_FAILED, ACTIVITY_RESULT_KEY, nil];
    } 
    
    return self;
}

- (void)saveParameters{
    NSString * filePath = [self paramFilePath];
    [self.parameters writeToFile:filePath atomically:YES];
}

- (void)saveLogs{
    NSString * filePath = [self logFilePath];
    [self.logs writeToFile:filePath atomically:YES];
}

- (void)save{
    [self saveParameters];
    [self saveLogs];
}

- (NSString *)parameter:(NSString *)key{
    return [self.parameters objectForKey:key];
}

-(void)setParameter:(NSString *)key withValue:(NSString *)value{
    if (value == nil) {
        [self.parameters removeObjectForKey:key];
    }else{
        [self.parameters setValue:value forKey:key];
    }
}

-(void)resetActivity{
    NSMutableArray * array = [self.activity objectForKey:ACTIVITY_PROCESS_KEY];
    [array removeAllObjects];
    
    [self.activity setObject:RESULT_FAILED forKey:ACTIVITY_RESULT_KEY];
}

-(void)addActivity:(NSString *)activity{
    NSLog(@"%@", activity);
    NSMutableArray * activityArray = [self.activity objectForKey:ACTIVITY_PROCESS_KEY];
    [activityArray addObject:activity];
}


-(void)setResult:(BOOL)result{
    NSString * resultString = result ? RESULT_SUCCESSFUL : RESULT_FAILED;
    [self.activity setObject:resultString forKey:ACTIVITY_RESULT_KEY];
}

-(void)addFailedActivity:(NSString *)activity{
    [self addActivity:activity];
    [self setResult:NO];
    
    [self.logs addObject:self.activity];
    [self saveLogs];
}

-(void)addSuccessfulActivity:(NSString *)activity{
    [self addActivity:activity];
    [self setResult:YES];
    
    [self.logs addObject:self.activity];
    [self saveLogs];
}

-(BOOL)activityResult{
    NSString * resultString = [self.activity objectForKey:ACTIVITY_RESULT_KEY];
    if ([resultString isEqualToString:RESULT_SUCCESSFUL]) {
        return YES;
    }else{
        return NO;
    }
}

@end
