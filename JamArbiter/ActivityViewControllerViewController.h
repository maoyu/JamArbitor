//
//  ActivityViewControllerViewController.h
//  JamArbiter
//
//  Created by Liu Wanwei on 12-3-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityViewControllerViewController : UITableViewController

@property (nonatomic) NSInteger logIndex;
@property (strong, nonatomic) NSMutableArray * activities;

@end
