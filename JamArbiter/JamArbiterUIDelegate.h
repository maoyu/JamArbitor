//
//  ReceiverViewRefreshUiDelegate.h
//  JamArbiter
//
//  Created by maoyu on 12-3-20.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MSG_TYPE_SINA_WEIBO_SUGGESTIONS_USERS_OK 0

@protocol JamArbiterUIDelegate <NSObject>

@optional

-(void)	handleMsg:(int) msgWhat;

@end
