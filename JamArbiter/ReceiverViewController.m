//
//  ReceiverViewController.m
//  JamArbiter
//
//  Created by Liu Wanwei on 12-3-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ReceiverViewController.h"
#import "AppDelegate.h"

@interface ReceiverViewController ()

@end

@implementation ReceiverViewController

@synthesize textField = _textField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    NSString * value = [[[AppDelegate delegate] dataes] parameter:RECEIVER_KEY];
    self.textField.text = value;
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

-(void)savePressed:(id)sender{
    NSString * text = self.textField.text;
    if (text == nil) {
        return;
    }
    
    DataStore * store = [[AppDelegate delegate] dataes];
    [store setParameter:RECEIVER_KEY withValue:text];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
