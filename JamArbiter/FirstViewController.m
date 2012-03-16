//
//  FirstViewController.m
//  JamArbiter
//
//  Created by Liu Wanwei on 12-3-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FirstViewController.h"
#import "AppDelegate.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

@synthesize tableView = _tableView;
@synthesize cell0 = _cell0;
@synthesize cell1 = _cell1;
@synthesize cell2 = _cell2;
@synthesize segment = _segment;
@synthesize senderViewController = _senderViewController;
@synthesize receiverViewController = _receiverViewController;

-(void) dealloc{
    [_tableView release];
    [_cell0 release];
    [_cell1 release];
    [_cell2 release];
    [_segment release];
    [_senderViewController release];
    [_receiverViewController release];
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"First", @"First");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated{    
    [self.tableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self setTitle:@"摇一摇"];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - handle shake event

- (BOOL)canBecomeFirstResponder{
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    if (motion == UIEventSubtypeMotionShake) {
        NSLog(@"got shake"); 
        AppDelegate * delegate = [AppDelegate delegate];
        NSString * receiver = [delegate.dataes parameter:RECEIVER_KEY];
        NSString * atWhom;
        if (! [receiver hasPrefix:@"@"]) {
            atWhom = [NSString stringWithFormat:@"@%@", receiver];
        }else{
            atWhom = receiver;
        }
        
        NSString * jamState = [self.segment titleForSegmentAtIndex:[self.segment selectedSegmentIndex]];
        NSString * contents = [NSString stringWithFormat:@"测试：%@ 请开车出来一起闹他 %@", jamState, atWhom];
        [[[AppDelegate delegate] sinaWeibo] sendWeibo:contents];
    }else{
        NSLog(@"got something not shake");
    }
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger number = 0;
    switch (section) {
        case 0:
            number = 1;
            break;
        case 1:
            number = 1;
            break;
        case 2:
            number = 1;
            break;
        default:
            break;
    }
    
    return number;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * text = nil;
    UITableViewCell * cell = nil;
    if (indexPath.section == 0) {
        text = [[[AppDelegate delegate] dataes] parameter:JAM_STATE_KEY];
        if (nil == text) {
            self.segment.selectedSegmentIndex = 0;
        }
        cell = self.cell0;
    }else if(indexPath.section == 1){
        text = [[[AppDelegate delegate] dataes] parameter:SINA_WEIBO_SENDER_KEY];
        if (text == nil) {
            text = @"设置我的微博账号";
        }
        cell = self.cell1;
        cell.textLabel.text = text;        
    }else if(indexPath.section == 2){
        text = [[[AppDelegate delegate] dataes] parameter:RECEIVER_KEY];
        if (nil == text) {
            text = @"设置微博发送对象";
        }
        cell = self.cell2;
        cell.textLabel.text = text;        
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 43;
    }else{
        return 44;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"拥堵状况：";
    }else if(section == 1){
        return @"我的微博：";
    }else if(section == 2){
        return @"@给谁：";
    }else{
        return nil;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (self.senderViewController == nil) {
            SenderViewController * sender = [[SenderViewController alloc] initWithNibName:@"SenderViewController" bundle:nil];
            self.senderViewController = sender;
            [sender release];
        }
        
        [self.navigationController pushViewController:self.senderViewController animated:YES];
        
    }else if(indexPath.section == 2){
        if (self.receiverViewController == nil) {
            ReceiverViewController * receiver = [[ReceiverViewController alloc] initWithNibName:@"ReceiverViewController" bundle:nil];
            self.receiverViewController = receiver;
            [receiver release];
        }
        
        [self.navigationController pushViewController:self.receiverViewController animated:YES];
    }
}


@end
