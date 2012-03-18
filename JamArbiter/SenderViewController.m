//
//  SenderViewController.m
//  JamArbiter
//
//  Created by Liu Wanwei on 12-3-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SenderViewController.h"
#import "AppDelegate.h"

@interface SenderViewController ()

@end

@implementation SenderViewController

@synthesize tableView = _tableView;
@synthesize weiboServiceProvider = _weiboServiceProvider;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSArray * array = [NSArray arrayWithObjects:@"新浪微博", nil];
        self.weiboServiceProvider = array;
    }
    return self;
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return [self.weiboServiceProvider count];
    }else{
        return 0;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"微博服务商";
    }else{
        return nil;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellIdentifier = @"weiboserviceprovideridentifier";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    cell.textLabel.text = [self.weiboServiceProvider objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == [actionSheet destructiveButtonIndex]) {
        [[[[AppDelegate delegate] sinaWeibo] sinaWeiboEngine] logOut];
    }
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            [self trySinaWeiboLogin];
            break;            
        default:
            break;
    }
}

- (void)trySinaWeiboLogin{
    AppDelegate * delegate = [AppDelegate delegate];
    if (! [delegate.sinaWeibo sinaWeiboLogin:self]) {
        NSString * userName = [delegate.dataes parameter:SINA_WEIBO_SENDER_NAME_KEY];
        NSString * message = [NSString stringWithFormat:@"微博用户%@已经经过授权", userName];
        UIActionSheet * sheet = [[UIActionSheet alloc] 
                                 initWithTitle:message 
                                 delegate:self 
                                 cancelButtonTitle:@"什么也不做" 
                                 destructiveButtonTitle:@"取消授权" 
                                 otherButtonTitles:nil, 
                                 nil];
        [sheet showFromTabBar:delegate.tabBarController.tabBar];
        [sheet release];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

@end
