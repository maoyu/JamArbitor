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
@synthesize users = _users;

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
		delegate.sinaWeibo.receiverViewDelegate = self;
		//[delegate.locationService startStandardLocationServcie:NO];
		[delegate.sinaWeibo querySuggestionUsers];
		self.users = nil;
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

-(void)savePressed:(id)sender{
    /*NSString * text = self.textField.text;
    if (text == nil) {
        return;
    }
    
    DataStore * store = [[AppDelegate delegate] dataes];
    [store setParameter:RECEIVER_KEY withValue:text];
    [self.navigationController popViewControllerAnimated:YES];
	*/
}

#pragma mark -
#pragma mark ReceiverViewRefreshUiDelegate methods
-(void)refreshUI {
		[self.tableView reloadData];
}

#pragma mark -
#pragma mark UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
		AppDelegate * delegate = [AppDelegate delegate];
		if(delegate.sinaWeibo.suggestionsUsers != nil) {
				self.users = delegate.sinaWeibo.suggestionsUsers;
				return [self.users count];
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
    
		NSDictionary * user = [self.users objectAtIndex:indexPath.row];
		if ([user isKindOfClass:[NSDictionary class]]) {
				cell.userNameLabel.text = [user objectForKey:@"screen_name"];
		}
    
    return cell;
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
		
		if (self.users == nil) {
				return nil;
		}
		 
		DataStore * store = [[AppDelegate delegate] dataes];
		NSString * userName = [[self.users objectAtIndex:indexPath.row] objectForKey:@"screen_name"];
		[store setParameter:RECEIVER_KEY withValue:userName];
		[self.navigationController popViewControllerAnimated:YES];
		return indexPath;
}


@end
