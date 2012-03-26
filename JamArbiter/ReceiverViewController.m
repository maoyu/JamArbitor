//
//  ReceiverViewController.m
//  JamArbiter
//
//  Created by Liu Wanwei on 12-3-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ReceiverViewController.h"
#import "AppDelegate.h"
#import "ReceiverTableViewCell.h"

@implementation ReceiverViewController

@synthesize activityView = _activityView;
@synthesize suggestedUsers = _suggestedUsers;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
        [self setTitle:@"发送对象"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
		AppDelegate * delegate = [AppDelegate delegate];
		delegate.sinaWeibo.UIDelegate = self;
		delegate.sinaWeibo.sendWeibo = NO;
		//[delegate.locationService startStandardLocationServcie];
		[delegate.sinaWeibo querySuggestedUsers];
		self.suggestedUsers = nil;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)refreshUI {
		[self.tableView reloadData];
}

#pragma mark -
#pragma mark JamArbiterUIDelegate methods
-(void)handleMsg:(int)msgWhat {
		switch (msgWhat) {
				case MSG_TYPE_SINA_WEIBO_SUGGESTIONS_USERS_OK:
						[self refreshUI];
						break;
				default:
						break;
		}
}

#pragma mark -
#pragma mark UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
		AppDelegate * delegate = [AppDelegate delegate];
		if(delegate.sinaWeibo.suggestedUsers != nil) {
				self.suggestedUsers = delegate.sinaWeibo.suggestedUsers;
				return [self.suggestedUsers count];
		}
		return 0;
}

#pragma mark -
#pragma mark UITableViewDelegate methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ReceiverTableViewCell";
    
    ReceiverTableViewCell *cell = nil;
		cell = (ReceiverTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
				NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ReceiverTableViewCell"
																																 owner:self
																															 options:nil];
				cell = (ReceiverTableViewCell *)[topLevelObjects objectAtIndex:0];
    }
    
		id user = [self.suggestedUsers objectAtIndex:indexPath.row];
		if ([user isKindOfClass:[NSDictionary class]]) {
				cell.userNameLabel.text = [user objectForKey:@"screen_name"];
		}
    
    return cell;
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
		
		if (self.suggestedUsers == nil) {
				return nil;
		}
		 
		DataStore * store = [[AppDelegate delegate] dataes];
		NSString * userName = [[self.suggestedUsers objectAtIndex:indexPath.row] objectForKey:@"screen_name"];
		[store setParameter:RECEIVER_KEY withValue:userName];
		[self.navigationController popViewControllerAnimated:YES];
		return indexPath;
}


@end
