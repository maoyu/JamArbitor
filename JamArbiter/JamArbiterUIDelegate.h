//
//  ReceiverViewRefreshUiDelegate.h
//  JamArbiter
//
//  Created by maoyu on 12-3-20.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MSG_TYPE_SINA_WEIBO_SUGGESTIONS_USERS_OK 0
#define MSG_TYPE_SINA_WEIBO_PROFILE_IMAGE_URL_OK 1
#define MSG_TYPE_SINA_WEIBO_PROFILE_IMAGE_DOWNLOAD_OK 2

@protocol JamArbiterUIDelegate <NSObject>

@optional

-(void)	handleMsg:(int) msgWhat;

@end
