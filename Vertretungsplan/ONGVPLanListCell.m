//
//  HPIFoodListCell.m
//  HPI Food
//
//  Created by Carl Ambroselli on 01.10.12.
//  Copyright (c) 2012 Carl Ambroselli. All rights reserved.
//

#import "ONGVPLanListCell.h"

@implementation ONGVLpanListCell

@synthesize description;

#define PADDING 7.0f
- (id)initWithText: (NSString*) alt neu:(NSString *)neu
{
    self = [super init];
    if (self) {
        NSString *text = [NSString stringWithFormat:@"%@ -> %@", [self htmlEntityDecode:alt], [self htmlEntityDecode:neu]];
        CGSize textSize = [text sizeWithFont:[UIFont fontWithName:@"Signika Negative" size:18.0f] constrainedToSize:CGSizeMake(320 - PADDING * 3, 1000.0f)];
        self.description = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, (textSize.height + PADDING * 3))];
        self.description.numberOfLines = 0;
        self.description.textColor = [UIColor colorWithRed:0/255.f green:0/255.f blue:10/255.f alpha:1.0f];
        self.description.text = text;
        self.description.font = [UIFont fontWithName:@"Signika Negative" size:18.0f];
        [self.contentView addSubview:self.description];
        
    }
    
    return self;
}

-(NSString *)htmlEntityDecode:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"&auml;" withString:@"ä"];
    string = [string stringByReplacingOccurrencesOfString:@"&ouml;" withString:@"ö"];
    string = [string stringByReplacingOccurrencesOfString:@"&uuml;" withString:@"ü"];
    return string;
}

@end
