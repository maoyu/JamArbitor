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
@synthesize heading = _heading;
@synthesize jamState = _jamState;
@synthesize weiboText = _weiboText;
@synthesize address = _address;
@synthesize soundRef = _soundRef;
@synthesize soundId = _soundId;

- (void)dealloc{
    [_sinaWeiboEngine release];
    [_jamState release];
    [_weiboText release];
    [_address release];
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

// 微博授权
-(BOOL)sinaWeiboLogin:(UIViewController *)topViewController{
    if ([self authorizationState] == AUTHORIZED) {
        return NO;
    }
    
    [self.sinaWeiboEngine setRootViewController:topViewController];    
    [self.sinaWeiboEngine logIn];
    
    return YES;
}

// 获取微博用户信息。
-(BOOL)requestScreenName{    
    if ([self authorizationState] != AUTHORIZED) {
        return NO;
    }
    NSDictionary * dictionary = [NSDictionary dictionaryWithObject:self.sinaWeiboEngine.userID forKey:@"uid"];
    [self.sinaWeiboEngine loadRequestWithMethodName:@"users/show.json" 
                                   httpMethod:@"GET" params:dictionary 
                                   postDataType:kWBRequestPostDataTypeNone 
                                   httpHeaderFields:nil];
    return YES;
}

- (BOOL)requestAddress{
    if ([self authorizationState] != AUTHORIZED) {
        return NO;
    }
    NSString * longitudeString = [self coordinateToString:self.longitude];
    NSString * latitudeString = [self coordinateToString:self.latitude];
    NSString * value = [NSString stringWithFormat:@"%@,%@", longitudeString, latitudeString];
    NSDictionary * dictionary = [NSDictionary dictionaryWithObjectsAndKeys:value, @"coordinate", nil];
    [self.sinaWeiboEngine loadRequestWithMethodName:SINA_WEIBO_GEO_METHOD
                                         httpMethod:@"GET" 
                                         params:dictionary 
                                         postDataType:kWBRequestPostDataTypeNone 
                                         httpHeaderFields:nil];
    [[[AppDelegate delegate] dataes] addActivity:@"请求实际地址"];
    return YES;
}

// 将经纬度数值转换成字符串，并用+-符号标示经纬度的不同方向。
-(NSString *)coordinateToString:(double)number{
    NSString * string = [NSString stringWithFormat:@"%f", number];
    return string;
    if ([string hasPrefix:@"-"]) {
        return string;
    }else{
        NSString * positiveString = [NSString stringWithFormat:@"+%@", string];
        return positiveString;
    }
}

-(BOOL)composeWeiboText{
    AppDelegate * delegate = [AppDelegate delegate];
    NSString * receiver = [delegate.dataes parameter:RECEIVER_KEY];
    NSString * safeReceiver;
    if (! [receiver hasPrefix:@"@"]) {
        safeReceiver = [NSString stringWithFormat:@"@%@", receiver];
    }else{
        safeReceiver = receiver;
    }
    
    // TODO heading方向已经得到，但45度方向是自南向北，还是自西向东？
    
    // TODO 得到的地址中，要有“路”，才能说自哪儿向哪儿。
    
    NSString * text = [NSString stringWithFormat:@"测试：%@ %@ 召唤 %@", 
                       self.address, self.jamState, safeReceiver];
    self.weiboText = text;
    
    return YES;
}

// 发送一条微博（微博内容已经设置在实例属性中）。
-(BOOL)sendWeibo{
    if ([self authorizationState] != AUTHORIZED) {
        return NO;
    }
    
    if ([self composeWeiboText] == NO) {
        return NO;
    }
    
    NSString * tude;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:4];
    
    [params setObject:self.weiboText forKey:@"status"]; 
    tude = [self coordinateToString:self.latitude];
    [params setObject:tude  forKey:@"lat"];
    tude = [self coordinateToString:self.longitude];
    [params setObject:tude forKey:@"long"];
    // 这样写会在WBAuthorize的时候被截掉，那里只支持string类型的字典对象。
    NSArray * array = [NSArray arrayWithObject:ANNOTATIONS_SEND_WEIBO];
    [params setObject:array forKey:ANNOTATIONS];
    
    [[[AppDelegate delegate] dataes] addActivity:@"发送微博"];
    [self.sinaWeiboEngine loadRequestWithMethodName:SINA_WEIBO_SEND_METHOD
                        httpMethod:@"POST"
                        params:params
                        postDataType:kWBRequestPostDataTypeNormal
                        httpHeaderFields:nil];
    return YES;
}

- (NSInteger)authorizationState{
    if ([self.sinaWeiboEngine isLoggedIn] == NO) {
        [[[AppDelegate delegate] dataes] addFailedActivity:@"用户未授权"];
        return NOT_AUTHORIZED;
    }else{
        if ([self.sinaWeiboEngine isAuthorizeExpired]) {
            [[[AppDelegate delegate] dataes] addFailedActivity:@"授权已过期"];
            return AUTHORIZATION_EXPIRED;
        }else{
            return AUTHORIZED;
        }
    }    
}

#pragma mark - WBEngineDelegate

-(void)engineAlreadyLoggedIn:(WBEngine *)engine{
    NSLog(@"already login");
}

-(void)engineDidLogIn:(WBEngine *)engine{
    NSLog(@"login success");
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"成功" message:@"授权成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
        
    // 请求用户信息，目标：用户昵称，用户是否开启地理位置共享。
    [self requestScreenName];
}

-(void)engine:(WBEngine *)engine didFailToLogInWithError:(NSError *)error{
    NSLog(@"login error: %@", [error localizedFailureReason]);
}

-(void)engineDidLogOut:(WBEngine *)engine{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"取消授权成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

-(void)engine:(WBEngine *)engine requestDidSucceedWithResult:(id)result{
    NSLog(@"request back");
    if ([result isKindOfClass:[NSDictionary class]]) {
        NSDictionary * dict = (NSDictionary *)result;
        NSString * screenName = [dict objectForKey:@"screen_name"];
        if (nil != screenName) {
            [[[AppDelegate delegate] dataes] setParameter:SINA_WEIBO_SENDER_NAME_KEY withValue:screenName];
            NSLog(@"got screen_name: %@", screenName);    
        }
        
        NSNumber * geoEnabled = [dict objectForKey:@"geo_enabled"];
        if (geoEnabled != nil && [geoEnabled integerValue] == 0) {
            // TODO 地理信息未开时提示到微博中设置。或帮助自动设置？
            [[[AppDelegate delegate] dataes] addActivity:@"地理位置共享未开启"];
        }
        
        NSArray * geosArray = [dict objectForKey:@"geos"];
        NSDictionary * geosDict = [geosArray objectAtIndex:0];
        if ([geosDict isKindOfClass:[NSDictionary class]]) {
            NSString * address = [geosDict objectForKey:@"address"];
            if (address != nil) {
                [[[AppDelegate delegate] dataes] addActivity:address];
                self.address = address;
                [self sendWeibo];
            }    
        }
        
        NSString * mid = [dict objectForKey:@"mid"];
        if (mid != nil) {
            [[[AppDelegate delegate] dataes] addSuccessfulActivity:@"微博发送成功"];
            // TODO 发送成功，可以震动了。以后在这里自定义个delegate，通知UI层。 
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        }
    }
}

-(void)playErrorSound{
    if (self.soundRef == nil) {
        NSURL * tapSound = [[NSBundle mainBundle] URLForResource:@"tap" withExtension:@"aif"];
        self.soundRef = (CFURLRef)[tapSound retain];
        AudioServicesCreateSystemSoundID(self.soundRef, &_soundId);                
    }
    
    AudioServicesPlaySystemSound(self.soundId);
}

-(void)engine:(WBEngine *)engine requestDidFailWithError:(NSError *)error{
    NSString * request = [error.userInfo objectForKey:@"request"];
    NSString * errorInfo = [error.userInfo objectForKey:@"error"];
    NSInteger errorCode = [[error.userInfo objectForKey:@"error_code"] integerValue];
    if ([request hasSuffix:SINA_WEIBO_SEND_METHOD]) {
        if (errorCode == 20019) {
            // 微博内容重复。
            [[[AppDelegate delegate] dataes] addFailedActivity:@"微博内容重复"];
            [self playErrorSound];
        }
    }else if([request hasSuffix:SINA_WEIBO_GEO_METHOD]){
        if (errorCode == 21903) {
            // 确实没有定位地址数据。
            [[[AppDelegate delegate] dataes] addFailedActivity:@"经纬度没有对应定位数据"];
            [self playErrorSound];
        }
    }
    NSLog(@"request %@", errorInfo);
}

@end
