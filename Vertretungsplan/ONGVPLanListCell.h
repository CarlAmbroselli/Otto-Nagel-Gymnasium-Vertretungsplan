//
//  HPIFoodListCell.h
//  HPI Food
//
//  Created by Carl Ambroselli on 01.10.12.
//  Copyright (c) 2012 Carl Ambroselli. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface ONGVLpanListCell : UITableViewCell

@property (nonatomic, strong) UILabel * description;

- (id)initWithText: (NSString*) alt neu: (NSString*) neu;
-(NSString *)htmlEntityDecode:(NSString *)string;
@end
