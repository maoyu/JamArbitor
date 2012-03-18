//
//  SenderViewController.h
//  JamArbiter
//
//  Created by Liu Wanwei on 12-3-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SenderViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UITableView * tableView;
@property (strong, nonatomic) NSArray * weiboServiceProvider;

- (void)trySinaWeiboLogin;

@end
