//
//  ReceiverViewController.h
//  JamArbiter
//
//  Created by Liu Wanwei on 12-3-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReceiverViewRefreshUiDelegate.h"

@class ReceiverTableViewCell;

@interface ReceiverViewController : UITableViewController <UITableViewDelegate,ReceiverViewRefreshUiDelegate> {
	UIView * activityView;
}

@property (retain, nonatomic) IBOutlet UIView * activityView;
@property (nonatomic,assign) NSArray * users;

@end
