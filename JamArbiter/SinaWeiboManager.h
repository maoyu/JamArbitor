//
//  SinaWeiboManager.h
//  JamArbiter
//
//  Created by Liu Wanwei on 12-3-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../SinaWeiBoSDK/SinaWeiBoSDK/SinaWeiBoSDK/WBEngine.h"

#define kSinaWeiboAppKey                        @"3602270595"
#define kSinaWeiboAppSecret                     @"f50e1a9ae3a3de1827f7b973b65c68ee"

#define ANNOTATIONS                             @"annotations"
#define ANNOTATIONS_SEND_WEIBO                  @"send_weibo"

@interface SinaWeiboManager : NSObject <WBEngineDelegate, WBRequestDelegate>

@property (strong, nonatomic) WBEngine * sinaWeiboEngine;
@property (nonatomic) double longitude;
@property (nonatomic) double latitude;
@property (strong, nonatomic) NSString * weiboText;

-(id)init;
-(void)sinaWeiboLogin:(UIViewController *)topViewController;
-(void)requestScreenName;
-(BOOL)sendWeibo;

@end
