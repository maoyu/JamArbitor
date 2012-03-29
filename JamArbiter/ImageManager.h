//
//  ImageManager.h
//  JamArbiter
//
//  Created by maoyu on 12-3-27.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JamArbiterUIDelegate.h"

@interface ImageManager : NSObject
		
@property (retain,nonatomic) NSOperationQueue * operationQueue; 
@property (nonatomic,assign) id<JamArbiterUIDelegate> UIDelegate;

-(NSString *) dataPath;
-(BOOL)fileExistsAtName:(NSString*) fileName;
-(void)loadImage:(NSString *) url;
-(void)deleteImage;

@end
