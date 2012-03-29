//
//  FirstViewController.m
//  JamArbiter
//
//  Created by Liu Wanwei on 12-3-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FirstViewController.h"
#import "AppDelegate.h"
#import "FirstViewTableViewCell.h"

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
				self.cell2 = [[FirstViewTableViewCell alloc] init];
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated{  
		AppDelegate * delegate = [AppDelegate delegate];
		delegate.imageManager.UIDelegate = self;
		delegate.sinaWeibo.UIDelegate = self;
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

- (void)notReady:(NSString *)error{
    [[[AppDelegate delegate] dataes] addActivity:error];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"错误" 
                                            message:error delegate:self 
                                           cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    if (motion == UIEventSubtypeMotionShake) {
        NSInteger index = [self.segment selectedSegmentIndex];
        NSString * jamState = [self.segment titleForSegmentAtIndex:index];
        AppDelegate * delegate = [AppDelegate delegate];
        [delegate.dataes resetActivity];
        [delegate.dataes addActivity:@"got shake"];
        if (jamState == nil) {
            [self notReady:@"交通状态未设置"];
            return;
        }

        NSString * sender = [delegate.dataes parameter:SINA_WEIBO_SENDER_NAME_KEY];
        if (nil == sender) {
            [self notReady:@"发送者未设置"];
            return;
        }
        
        NSString * receiver = [delegate.dataes parameter:RECEIVER_KEY];
        if (nil == receiver) {
            [self notReady:@"通知对象未设置"];
            return;
        }
        
        delegate.sinaWeibo.jamState = jamState;
				delegate.sinaWeibo.sendWeibo = YES;
        
        // 获取位置经纬度——将经纬度转化成地址——发送微博。
        [delegate.locationService startStandardLocationServcie];
        //[delegate.locationService startHeadingService];
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
		UIImage * receiverImage = nil;
    if (indexPath.section == 0) {
        cell = self.cell0;
    }else if(indexPath.section == 1){
        text = [[[AppDelegate delegate] dataes] parameter:SINA_WEIBO_SENDER_NAME_KEY];
        if (text == nil) {
            text = @"设置我的微博账号";
        }
        cell = self.cell1;
        cell.textLabel.text = text;        
    }else if(indexPath.section == 2){
				cell = self.cell2;
				text = [[[AppDelegate delegate] dataes] parameter:RECEIVER_KEY];
        if (nil == text) {
            text = @"设置微博发送对象";
						receiverImage = [UIImage imageNamed:@"user.png"];
						cell.imageView.image = receiverImage;
        }
				else {

						if ([[[AppDelegate delegate] imageManager] fileExistsAtName:@"receiver.png"]) {
								NSString  * path = [NSString stringWithFormat:@"%@/receiver.png",[[[AppDelegate delegate] imageManager] dataPath]];
								receiverImage = [[UIImage alloc] init];
								receiverImage = [receiverImage initWithContentsOfFile:path];
								cell.imageView.image = receiverImage;
								[receiverImage release];
						}
						else {
								[[AppDelegate delegate] sinaWeibo].senderInfoRequest = NO;
								[[[AppDelegate delegate] sinaWeibo] requestProfileImageUrl:text];
								receiverImage = [UIImage imageNamed:@"user.png"];
								cell.imageView.image = receiverImage;
						}

				}
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

#pragma mark -
#pragma mark JamArbiterUIDelegate methods
-(void)handleMsg:(int)msgWhat {
		NSString * url;
		switch (msgWhat) {
				case MSG_TYPE_SINA_WEIBO_PROFILE_IMAGE_URL_OK:
						url = [[[AppDelegate delegate] dataes] parameter:RECEIVER_IMAGE];
						[[[AppDelegate delegate] imageManager] loadImage:url];
						break;
				case MSG_TYPE_SINA_WEIBO_PROFILE_IMAGE_DOWNLOAD_OK:
						[self.tableView reloadData];
						break;
				default:
						break;
		}
}

@end
