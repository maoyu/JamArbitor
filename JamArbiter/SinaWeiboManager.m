//
//  SinaWeiboManager.m
//  JamArbiter
//
//  Created by Liu Wanwei on 12-3-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SinaWeiboManager.h"
#import <AudioToolbox/AudioToolbox.h>
#import "AppDelegate.h"

@implementation SinaWeiboManager

@synthesize sinaWeiboEngine = _sinaWeiboEngine;

- (void)dealloc{
    [_sinaWeiboEngine release];
    [super dealloc];
}

- (id)init{
    if(self = [super init]){
        WBEngine * engine = [[WBEngine alloc] initWithAppKey:kSinaWeiboAppKey appSecret:kSinaWeiboAppSecret];
        [engine setDelegate:self];
        [engine setRedirectURI:@"http://"];
        [engine setIsUserExclusive:NO];
        self.sinaWeiboEngine = engine;
        [engine release];
    }
    
    return self;
}

-(void)sinaWeiboLogin:(UIViewController *)topViewController{
    if (self.sinaWeiboEngine.isLoggedIn) {
        AppDelegate * delegate = [AppDelegate delegate];
        if ([delegate.dataes parameter:SINA_WEIBO_SENDER_KEY] == nil) {
            [self requestScreenName];    
        }
        return;
    }
    [self.sinaWeiboEngine setRootViewController:topViewController];    
    [self.sinaWeiboEngine logIn];
}

-(void)requestScreenName{
    // 获取微博昵称。
    NSDictionary * dictionary = [NSDictionary dictionaryWithObject:self.sinaWeiboEngine.userID forKey:@"uid"];
    [self.sinaWeiboEngine loadRequestWithMethodName:@"users/show.json" 
                                   httpMethod:@"GET" params:dictionary 
                                   postDataType:kWBRequestPostDataTypeNone 
                                   httpHeaderFields:nil];
}

-(void)sendWeibo:(NSString *)text{    
    if (nil == [[[AppDelegate delegate] dataes] parameter:SINA_WEIBO_SENDER_KEY]) {
        NSLog(@"not certified");
        return;
    }

    // 震动提示。
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:2];
    [params setObject:text forKey:@"status"];    
    // eee, 打开后，发送失败。
    //[params setObject:ANNOTATIONS_SEND_WEIBO forKey:ANNOTATIONS];
    
    NSLog(@"send weibo");
    [self.sinaWeiboEngine loadRequestWithMethodName:@"statuses/update.json"
                        httpMethod:@"POST"
                        params:params
                        postDataType:kWBRequestPostDataTypeNormal
                        httpHeaderFields:nil];
}

#pragma mark - WBEngineDelegate

-(void)engineAlreadyLoggedIn:(WBEngine *)engine{
    NSLog(@"already login");
    AppDelegate * delegate = [AppDelegate delegate];
    if ([delegate.dataes parameter:SINA_WEIBO_SENDER_KEY] == nil) {
        [self requestScreenName];    
    }    
}

-(void)engineDidLogIn:(WBEngine *)engine{
    NSLog(@"login success");
    [self requestScreenName];
}

-(void)engine:(WBEngine *)engine didFailToLogInWithError:(NSError *)error{
    NSLog(@"login error: %@", [error localizedFailureReason]);
}

-(void)engine:(WBEngine *)engine requestDidSucceedWithResult:(id)result{
    NSLog(@"request back");
    if ([result isKindOfClass:[NSDictionary class]]) {
        NSDictionary * dict = (NSDictionary *)result;
        NSString * screenName = [dict objectForKey:@"screen_name"];
        if (nil != screenName) {
            [[[AppDelegate delegate] dataes] setParameter:SINA_WEIBO_SENDER_KEY withValue:screenName];
            NSLog(@"got screen_name: %@", screenName);    
        }
        
        NSString * annotations = [dict objectForKey:ANNOTATIONS];
        if ([annotations isEqualToString:ANNOTATIONS_SEND_WEIBO]) {
            NSLog(@"weibo 发送成功");
        }
    }
}

@end
