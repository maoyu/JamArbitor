//
//  SecondViewController.m
//  JamArbiter
//
//  Created by Liu Wanwei on 12-3-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SecondViewController.h"
#import "AppDelegate.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

@synthesize tableView = _tableView;
@synthesize activityViewController = _activityViewController;
@synthesize logCount;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // TODO self.title = NSLocalizedString(@"Second", @"Second");
        self.title = @"发送日志";
        self.tabBarItem.image = [UIImage imageNamed:@"second"];
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    self.logCount = [[[[AppDelegate delegate] dataes] logs] count];
    return self.logCount;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * kReuseIdentifier = @"reuseTableViewCellIdentifier";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kReuseIdentifier];
    if (nil == cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kReuseIdentifier] autorelease];
    }
    
    NSMutableArray * logs = [[[AppDelegate delegate] dataes] logs];
    NSMutableDictionary * dict = [logs objectAtIndex:self.logCount - indexPath.row - 1];
    NSMutableArray * activity = [dict objectForKey:ACTIVITY_PROCESS_KEY];
    NSString * result = [dict objectForKey:ACTIVITY_RESULT_KEY];    
    NSString * lastActivity = [activity objectAtIndex:[activity count] - 1];
    NSString * message = [NSString stringWithFormat:@"[%@] %@", result, lastActivity];
    cell.textLabel.text = message;
    
    return cell;
}

#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (nil == self.activityViewController) {
        self.activityViewController = [[[ActivityViewControllerViewController alloc] init] autorelease];
    }
    
    self.activityViewController.logIndex = self.logCount - indexPath.row - 1;
    [self.navigationController pushViewController:self.activityViewController animated:YES];
}

@end
