//
//  SinaWeiboManager.m
//  JamArbiter
//
//  Created by Liu Wanwei on 12-3-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SinaWeiboManager.h"
#import "AppDelegate.h"

@implementation SinaWeiboManager

@synthesize sinaWeiboEngine = _sinaWeiboEngine;
@synthesize longitude = _longitude;
@synthesize latitude = _latitude;
@synthesize weiboText = _weiboText;

- (void)dealloc{
    [_sinaWeiboEngine release];
    [_weiboText release];
    [super dealloc];
}

- (id)init{
    if(self = [super init]){
        WBEngine * engine = [[WBEngine alloc] initWithAppKey:kSinaWeiboAppKey appSecret:kSinaWeiboAppSecret];
        [engine setDelegate:self];
        [engine setRedirectURI:@"http://"];
        [engine setIsUserExclusive:YES];
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

-(NSString *)floatToNSString:(double)number{
    NSString * string = [NSString stringWithFormat:@"%f", number];
    if ([string hasPrefix:@"-"]) {
        return string;
    }else{
        NSString * positiveString = [NSString stringWithFormat:@"+%@", string];
        return positiveString;
    }
}

-(BOOL)sendWeibo{    
    NSString * tude;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:4];
    
    [params setObject:self.weiboText forKey:@"status"]; 
    tude = [self floatToNSString:self.latitude];
    [params setObject:tude  forKey:@"lat"];
    tude = [self floatToNSString:self.longitude];
    [params setObject:tude forKey:@"long"];
    // eee, 打开后，发送失败。
    //[params setObject:ANNOTATIONS_SEND_WEIBO forKey:ANNOTATIONS];
    
    NSLog(@"send weibo");
    [self.sinaWeiboEngine loadRequestWithMethodName:@"statuses/update.json"
                        httpMethod:@"POST"
                        params:params
                        postDataType:kWBRequestPostDataTypeNormal
                        httpHeaderFields:nil];
    return YES;
}

#pragma mark - WBEngineDelegate

-(void)engineAlreadyLoggedIn:(WBEngine *)engine{
    NSLog(@"already login");
    AppDelegate * delegate = [AppDelegate delegate];
    if ([delegate.dataes parameter:SINA_WEIBO_SENDER_KEY] == nil) {
        [self requestScreenName];    
    }else{
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"不用" message:@"已经设置" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
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
        
        NSString * geoEnabled = [dict objectForKey:@"geo_enabled"];
        if (geoEnabled) {
            // TODO 地理信息未开时提示到微博中设置。或帮助自动设置？
            NSLog(@"%@", geoEnabled);
        }
        
        NSString * annotations = [dict objectForKey:ANNOTATIONS];
        if ([annotations isEqualToString:ANNOTATIONS_SEND_WEIBO]) {
            NSLog(@"weibo 发送成功");
        }
    }
}

#pragma mark - WBRequestDelegate
-(void)request:(WBRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"request error: %@", [error description]);
}

@end
