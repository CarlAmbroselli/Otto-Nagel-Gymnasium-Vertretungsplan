//
//  ONGVPLanViewController.h
//  Vertretungsplan
//
//  Created by Carl Ambroselli on 01.10.12.
//  Copyright (c) 2012 Carl Ambroselli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ONGAppDelegate.h"
#import "ONGVPLanListCell.h"
#import "Reachability.h"
#import "MBProgressHUD.h"
#import "EGORefreshTableHeaderView.h"

@interface ONGVPLanViewController : UITableViewController <EGORefreshTableHeaderDelegate>

@property (strong, nonatomic) UIView * noConnectionView;
@property (strong, nonatomic) EGORefreshTableHeaderView *refreshHeaderView;
@property (strong, nonatomic) UIView * noChangesView;

@property NSArray *plan;
@property Reachability *reach;
@property BOOL refreshing;
@end
