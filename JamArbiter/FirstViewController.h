//
//  FirstViewController.h
//  JamArbiter
//
//  Created by Liu Wanwei on 12-3-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SenderViewController.h"
#import "ReceiverViewController.h"

@interface FirstViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView * tableView;
@property (strong, nonatomic) IBOutlet UITableViewCell * cell0;
@property (strong, nonatomic) IBOutlet UITableViewCell * cell1;
@property (strong, nonatomic) IBOutlet UITableViewCell * cell2;
@property (strong, nonatomic) IBOutlet UISegmentedControl * segment;
@property (strong, nonatomic) SenderViewController * senderViewController;
@property (strong, nonatomic) ReceiverViewController * receiverViewController;

@end
