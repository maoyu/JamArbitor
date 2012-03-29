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

@class FirstViewTableViewCell;

@interface FirstViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,JamArbiterUIDelegate>

@property (retain, nonatomic) IBOutlet UITableView * tableView;
@property (retain, nonatomic) IBOutlet UITableViewCell * cell0;
@property (retain, nonatomic) IBOutlet UITableViewCell * cell1;
@property (retain, nonatomic) FirstViewTableViewCell * cell2;
@property (retain, nonatomic) IBOutlet UISegmentedControl * segment;
@property (retain, nonatomic) SenderViewController * senderViewController;
@property (retain, nonatomic) ReceiverViewController * receiverViewController;

@end
