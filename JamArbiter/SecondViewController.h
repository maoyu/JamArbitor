//
//  SecondViewController.h
//  JamArbiter
//
//  Created by Liu Wanwei on 12-3-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityViewControllerViewController.h"

@interface SecondViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (retain, nonatomic) IBOutlet UITableView * tableView;
@property (retain, nonatomic) ActivityViewControllerViewController * activityViewController;
@property (nonatomic) NSInteger logCount;

@end
