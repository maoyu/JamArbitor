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

@synthesize locations = _locations;
@synthesize parameters = _parameters;
@synthesize standardLocations = _standardLocations;

- (NSString *)dataPath{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

- (NSString *)locationFilePath{
    static NSString * kFilename = @"collectedLocations.txt";
    return [[self dataPath] stringByAppendingPathComponent:kFilename];
}

- (NSString *)standardLocationFilePath{
    static NSString * kFilename = @"standardCollectedLocations.txt";
    return [[self dataPath] stringByAppendingPathComponent:kFilename];
}

- (NSString *)paramFilePath{
    static NSString * kFilename = @"collectionParameters.txt";
    return [[self dataPath] stringByAppendingPathComponent:kFilename];
}

-(BOOL) addSkipBackupAttributeToFile:(NSString *)file{
    return YES;
    const char * filePath = [file fileSystemRepresentation];
    const char * attrName = "com.apple.MobileBackup";
    uint8_t attrValue = 1;
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    return result == 0;
}

- (id)initFromFile{
    if (self = [super init]) {
        NSFileManager * manager = [NSFileManager defaultManager];
        NSString * filePath = [self locationFilePath];
        if ([manager fileExistsAtPath:filePath]) {
            [self addSkipBackupAttributeToFile:filePath];
            self.locations = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
        }else{
            self.locations = [[NSMutableArray alloc] init];
        }
        
        filePath = [self standardLocationFilePath];
        if ([manager fileExistsAtPath:filePath]) {
            [self addSkipBackupAttributeToFile:filePath];
            self.standardLocations = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
        }else{
            self.standardLocations = [[NSMutableArray alloc] init];
        }
        
        filePath = [self paramFilePath];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            [self addSkipBackupAttributeToFile:filePath];
            self.parameters = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
        }else{
            self.parameters = [[NSMutableDictionary alloc] init];
        }
    } 
    
    return self;
}

- (void)save{
    BOOL ret;
    NSString * filePath;
    
    filePath = [self locationFilePath];
    ret = [self.locations writeToFile:filePath atomically:YES];
    
    filePath = [self standardLocationFilePath];     
    ret = [self.standardLocations writeToFile:filePath atomically:YES];
    
    filePath = [self paramFilePath];
    ret = [self.parameters writeToFile:filePath atomically:YES];
}

- (NSString *)monitoring{
    return [self.parameters objectForKey:MONITORING_KEY];
}

- (void)setMonitoringValue:(NSString *)value{
    if (value == nil) {
        [self.parameters removeObjectForKey:MONITORING_KEY];
    }else{
        [self.parameters setValue:value forKey:MONITORING_KEY];   
    }
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

@end
