//
//  FirstViewTableViewCell.m
//  JamArbiter
//
//  Created by maoyu on 12-3-28.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "FirstViewTableViewCell.h"
#import <QuartzCore/QuartzCore.h>


@implementation FirstViewTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){}
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]){}
    return self;
}

-(void)layoutSubviews {
		[super layoutSubviews];
		self.imageView.frame = CGRectMake(8, 5, 35, 35);
		self.imageView.layer.cornerRadius = 5.0f;
		self.imageView.layer.masksToBounds = YES;
		self.textLabel.font = [UIFont fontWithName:@"SystemFont" size:17.0];
		self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)dealloc {
    [super dealloc];
}

@end
