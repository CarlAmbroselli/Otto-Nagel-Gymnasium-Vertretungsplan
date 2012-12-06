//
//  LeftViewController.m
//  EasySample
//
//  Created by Marian PAUL on 12/06/12.
//  Copyright (c) 2012 Marian PAUL aka ipodishima — iPuP SARL. All rights reserved.
//

#import "LeftViewController.h"

@interface LeftViewController ()

@end

@implementation LeftViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor darkGrayColor];
    self.tableView.separatorColor = [UIColor colorWithRed:66/255.f green:66/255.f blue:66/255.f alpha:1.000];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Klasse 5.1";
            break;
        case 1:
            cell.textLabel.text = @"Klasse 5.2";
            break;
        case 2:
            cell.textLabel.text = @"Klasse 5.3";
            break;
        case 3:
            cell.textLabel.text = @"1. Semester";
            break;
            
        default:
            break;
    }
    
    cell.textLabel.textColor = [UIColor lightGrayColor];
    
    UIImage *accessoryImage = [UIImage imageNamed:@"accessory_disclosure.png"];
    UIImageView *accImageView = [[UIImageView alloc] initWithImage:accessoryImage];
    [accImageView setFrame:CGRectMake(20, 0, 90, 28)];
    accImageView.backgroundColor = [UIColor clearColor];
    accImageView.userInteractionEnabled = YES;
    cell.accessoryView = accImageView;
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor blackColor];
    cell.selectedBackgroundView = v;
    
    
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    



    
    switch (indexPath.row) {
        case 0:
            [userDefaults setObject:@"5.1" forKey:@"class"];
            break;
        case 1:
            [userDefaults setObject:@"5.2" forKey:@"class"];
            break;
        case 2:
            [userDefaults setObject:@"5.3" forKey:@"class"];
            break;
        case 3:
            [userDefaults setObject:@"1. Semester" forKey:@"class"];
            break;
            
        default:
            break;
    }
    
        [userDefaults synchronize];
    //Push view
    UIViewController * viewController = [[ONGVPLanViewController alloc] init];
    UINavigationController *n = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self.revealSideViewController popViewControllerWithNewCenterController:n animated:YES];
    
}

@end
