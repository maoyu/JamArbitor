//
//  ReceiverViewController.h
//  JamArbiter
//
//  Created by Liu Wanwei on 12-3-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JamArbiterUIDelegate.h"

@class ReceiverTableViewCell;

@interface ReceiverViewController : UITableViewController <UITableViewDelegate,JamArbiterUIDelegate>

		@property (retain, nonatomic) IBOutlet UIView * activityView;
		@property (nonatomic,assign) NSArray * suggestedUsers;

@end
