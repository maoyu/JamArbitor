//
//  SinaWeiboManager.h
//  JamArbiter
//
//  Created by Liu Wanwei on 12-3-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "../SinaWeiBoSDK/SinaWeiBoSDK/SinaWeiBoSDK/WBEngine.h"
#import "JamArbiterUIDelegate.h"

#define kSinaWeiboAppKey                        @"3602270595"
#define kSinaWeiboAppSecret                     @"f50e1a9ae3a3de1827f7b973b65c68ee"

#define ANNOTATIONS                             @"annotations"
#define ANNOTATIONS_SEND_WEIBO                  @"send_weibo"

#define SINA_WEIBO_SEND_METHOD                  @"statuses/update.json"
#define SINA_WEIBO_GEO_METHOD                   @"location/geo/geo_to_address.json" 
#define	SINA_WEIBO_SUGGESTIONS_USERS_METHOD			@"search/suggestions/users.json"
#define SINA_WEIBO_USERS_SHOW_METHOD						@"users/show.json"

#define NOT_AUTHORIZED                               -1
#define AUTHORIZATION_EXPIRED                        0
#define AUTHORIZED                                   1

@interface SinaWeiboManager : NSObject <WBEngineDelegate, WBRequestDelegate>

@property (retain, nonatomic) WBEngine * sinaWeiboEngine;
@property (nonatomic) double longitude;
@property (nonatomic) double latitude;
@property (nonatomic) double heading;
@property (retain, nonatomic) NSString * jamState;
@property (retain, nonatomic) NSString * address;
@property (retain, nonatomic) NSString * weiboText;
@property	(retain, nonatomic) NSString * cityName;
@property (readwrite) CFURLRef soundRef;
@property (readonly) SystemSoundID soundId;
@property	(nonatomic) BOOL	sendWeibo;
@property (nonatomic) BOOL	senderInfoRequest;
@property	(retain,nonatomic) NSArray * suggestedUsers;
@property (nonatomic,assign) id<JamArbiterUIDelegate> UIDelegate;

-(id)init;
-(BOOL)sinaWeiboLogin:(UIViewController *)topViewController;
-(BOOL)requestScreenName;
-(BOOL)requestProfileImageUrl:(NSString *) screenName;
-(BOOL)requestAddress;
-(BOOL)sendWeibo;
-(BOOL)querySuggestedUsers;
-(NSInteger)authorizationState;

@end
