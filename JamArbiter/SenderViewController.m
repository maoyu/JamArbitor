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
    NSString * screenName = [delegate.dataes parameter:SINA_WEIBO_SENDER_KEY];
    if (nil == screenName) {
        [delegate.sinaWeibo.sinaWeiboEngine logIn];
    }else{
        NSLog(@"can't, already login");
    }
    
    [[[AppDelegate delegate] sinaWeibo] sinaWeiboLogin:self];
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
