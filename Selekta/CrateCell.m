//
//  CrateCell.m
//  Selekta
//
//  Created by Charisse Ann Jain on 3/14/16.
//  Copyright © 2016 Jerk Magz. All rights reserved.
//

#import "CrateCell.h"

@implementation CrateCell

@synthesize artist,title1,img;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSArray *nibArray = [[NSBundle mainBundle]loadNibNamed:@"CrateCell" owner:self options:nil];
        self = [nibArray objectAtIndex:0];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
