//
//  ImageManager.m
//  JamArbiter
//
//  Created by maoyu on 12-3-27.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ImageManager.h"


@implementation ImageManager

@synthesize operationQueue = _operationQueue;
@synthesize UIDelegate = _UIDelegate;

- (id)init{
    if (self = [super init]) {
				NSOperationQueue * queue = [[NSOperationQueue alloc] init];
				[queue setMaxConcurrentOperationCount:10];
				self.operationQueue = queue;
				[queue release];
    }
    
    return self;
}

- (void) dealloc{
		[_operationQueue release];
		[super dealloc];
}

- (NSString *)dataPath{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

- (BOOL)fileExistsAtName:(NSString *) fileName{
		NSFileManager * manager = [NSFileManager defaultManager];
		NSString * path = [[self dataPath] stringByAppendingPathComponent:fileName];
		
    if ([manager fileExistsAtPath:path]) {
				return YES;
		}
		
		return NO;
}

-(void)loadImage:(NSString *) url{
		NSInvocationOperation * operation = [[NSInvocationOperation alloc]
																				 initWithTarget:self
																				 selector:@selector(loadNetImage:) object:url];
		[self.operationQueue addOperation:operation];
		[operation release];
}

-(void)deleteImage{
		NSFileManager * manager = [NSFileManager defaultManager];
		NSString * path = [[self dataPath] stringByAppendingPathComponent:@"receiver.png"];
		
    [manager removeItemAtPath:path error:nil];
		
}

-(void)loadNetImage:(NSString * )url{
		NSData * imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:url]];
		[imageData writeToFile:[NSString stringWithFormat:@"%@/receiver.png",[self dataPath]] atomically:YES];
		[imageData release];
		if ([self.UIDelegate respondsToSelector:@selector(handleMsg:)]) {
				[self.UIDelegate handleMsg:MSG_TYPE_SINA_WEIBO_PROFILE_IMAGE_DOWNLOAD_OK];
		}
}

@end
