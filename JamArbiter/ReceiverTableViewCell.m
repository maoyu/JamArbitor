//
//  ReceiverTableViewCell.m
//  JamArbiter
//
//  Created by maoyu on 12-3-22.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ReceiverTableViewCell.h"

@implementation ReceiverTableViewCell

@synthesize userNameLabel = _userNameLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){}
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]){}
    return self;
}

- (void)dealloc {
		[self.userNameLabel release];
    [super dealloc];
}

@end

