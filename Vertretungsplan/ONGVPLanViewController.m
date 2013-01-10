//
//  ONGVPLanViewController.m
//  Vertretungsplan
//
//  Created by Carl Ambroselli on 01.10.12.
//  Copyright (c) 2012 Carl Ambroselli. All rights reserved.
//

#import "ONGVPLanViewController.h"
#import "LeftViewController.h"

@interface ONGVPLanViewController ()

@end

@implementation ONGVPLanViewController

@synthesize plan;
@synthesize reach;
@synthesize noConnectionView = _noConnectionView;
@synthesize refreshHeaderView = _refreshHeaderView;
@synthesize noChangesView = _noChangesView;

- (UIView *) noChangesView {
    if (_noChangesView == nil) {
        _noChangesView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
        _noChangesView.center = self.tableView.center;
        
        _noChangesView.backgroundColor = [UIColor clearColor];
        
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.text = @"Keine Änderungen vorhanden!";
        titleLabel.numberOfLines = 1;
        titleLabel.lineBreakMode = UILineBreakModeWordWrap;
        [_noChangesView addSubview:titleLabel];
    }
    
    return _noChangesView;
}

- (UIView *) noConnectionView {
    if (_noConnectionView == nil) {
        _noConnectionView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen]  applicationFrame]];
        _noConnectionView.center = self.tableView.center;
        
        _noConnectionView.backgroundColor = [UIColor clearColor];
        
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 320, 80)];
        titleLabel.backgroundColor = [UIColor whiteColor];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"Keine Internetverbindung.";
        titleLabel.numberOfLines = 1;
        [_noConnectionView addSubview:titleLabel];
    }
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    return _noConnectionView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.refreshing = TRUE;
    //Add the slide icon on the left
    UIImage *slideButtonImage = [UIImage imageNamed:@"menu"];
    UIBarButtonItem *slideButton = [[UIBarButtonItem alloc] initWithImage:slideButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(loadSidebar:)];
    self.navigationItem.leftBarButtonItem = slideButton;
    self.title = [[NSUserDefaults standardUserDefaults] objectForKey:@"class"];
    
    LeftViewController *left = [[LeftViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.revealSideViewController preloadViewController:left forSide:PPRevealSideDirectionLeft];
    [self.revealSideViewController setDirectionsToShowBounce:PPRevealSideDirectionLeft];
    
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Defaults"]];
    self.reach = [Reachability reachabilityWithHostName:@"ongvertretungsplan.herokuapp.com"];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Vertretungsplan wird geladen";
    [hud show:NO];
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    
    //Show the Pull to refresh bar
    if (_refreshHeaderView == nil) {
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
        
        //Background of the refresh header
        view.backgroundColor = [UIColor colorWithRed:210/255.f green:220/255.f blue:227/255.f alpha:1.000];
        
		[self.tableView addSubview:view];
		_refreshHeaderView = view;
	}
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
    [self performSelector:@selector(reloadData) withObject:nil afterDelay:0.0];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loadSidebar:(id)sender
{
    [self.revealSideViewController pushOldViewControllerOnDirection:PPRevealSideDirectionLeft animated:YES];
    
}

-(void)reloadData
{
    NSString *suchKlasse = [[NSUserDefaults standardUserDefaults] objectForKey:@"class"];
    
    if(![self.reach isReachable])
    {
        NSLog(@"No Network");
        [self.tableView setSeparatorColor:[UIColor clearColor]];
        [self doneLoadingTableViewData];
        self.view.backgroundColor = [UIColor whiteColor];
        return;
    }
    
    NSLog(suchKlasse);
    
    NSMutableArray *tmpPlan = [[NSMutableArray alloc] init];
    NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://ongvertretungsplan.herokuapp.com/vplan.php"]];
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    NSArray *infos = [NSArray alloc];
    NSMutableArray *json = [NSMutableArray arrayWithArray:[jsonObjects allObjects]];
    @try {
    for (NSDictionary *klasse in [json objectAtIndex:0]) {
        if([[klasse objectForKey:@"klasse"] isEqualToString:suchKlasse] || [[NSString stringWithFormat:@"%c", [[klasse objectForKey:@"klasse"] characterAtIndex:0]] isEqualToString:suchKlasse] || [[NSString stringWithFormat:@"W %c", [[klasse objectForKey:@"klasse"] characterAtIndex:0]] isEqualToString:suchKlasse] || [[NSString stringWithFormat:@"%cIG", [[klasse objectForKey:@"klasse"] characterAtIndex:0]] isEqualToString:suchKlasse] || [[klasse objectForKey:@"klasse"] isEqualToString:@"Sonderinfos"]){
            NSArray *keys = [[klasse objectForKey:@"daten"] allKeys];
           
            for (NSString *key in keys){
                [tmpPlan addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                        [[[klasse objectForKey:@"daten"] objectForKey:key] objectForKey:@"stunde"], @"stunde",
                        [[[klasse objectForKey:@"daten"] objectForKey:key] objectForKey:@"info"], @"info",
                         nil]];

            }
        }
    }
    }
    @catch (NSException *exception) {
        NSLog(@"Server offline?");
    }
    @try {
        for (NSDictionary *klasse in [json objectAtIndex:1]) {
            if([[klasse objectForKey:@"klasse"] isEqualToString:suchKlasse] || [[NSString stringWithFormat:@"%c", [[klasse objectForKey:@"klasse"] characterAtIndex:0]] isEqualToString:suchKlasse] || [[NSString stringWithFormat:@"W %c", [[klasse objectForKey:@"klasse"] characterAtIndex:0]] isEqualToString:suchKlasse] || [[NSString stringWithFormat:@"%cIG", [[klasse objectForKey:@"klasse"] characterAtIndex:0]] isEqualToString:suchKlasse] || [[klasse objectForKey:@"klasse"] isEqualToString:@"Sonderinfos"]){
                NSArray *keys = [[klasse objectForKey:@"daten"] allKeys];
                
                for (NSString *key in keys){
                    [tmpPlan addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [[[klasse objectForKey:@"daten"] objectForKey:key] objectForKey:@"stunde"], @"stunde",
                                        [[[klasse objectForKey:@"daten"] objectForKey:key] objectForKey:@"info"], @"info",
                                        nil]];
                    
                }
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Only today is available, sry.");
    }
    

    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"stunde"
                                                  ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    
    self.plan = [NSArray arrayWithArray:[tmpPlan sortedArrayUsingDescriptors:sortDescriptors]];
    [self.tableView setSeparatorColor:[UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0]];
    self.refreshing = FALSE;
    [self.tableView reloadData];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView.separatorColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"separator.png"]];
    [self doneLoadingTableViewData];
  
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
     
     if ([self.plan count] == 0 && !self.refreshing) {
     [self.view addSubview:self.noChangesView];
     }
     else {
     if (_noChangesView) {
     [self.noChangesView removeFromSuperview];
     self.noChangesView = nil;
     }
     }
     
    if (![self.reach isReachable]) {
        [self.view addSubview:self.noConnectionView];
    }
    else {
        if (_noConnectionView) {
            [self.noConnectionView removeFromSuperview];
            self.noConnectionView = nil;
        }
    }
    
    return [self.plan count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self.plan objectAtIndex:section] objectForKey:@"info"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *alt = [[[[self.plan objectAtIndex:indexPath.section] objectForKey:@"info"] objectAtIndex:indexPath.row] objectForKey:@"alt"];
    NSString *neu = [[[[self.plan objectAtIndex:indexPath.section] objectForKey:@"info"] objectAtIndex:indexPath.row] objectForKey:@"neu"];
    UITableViewCell *cell = [[ONGVLpanListCell alloc] initWithText:alt neu:neu];
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
        return 25;
}

#define PADDING 7.0f
- (CGFloat)tableView:(UITableView *)t heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *alt = [[[[self.plan objectAtIndex:indexPath.section] objectForKey:@"info"] objectAtIndex:indexPath.row] objectForKey:@"alt"];
    NSString *neu = [[[[self.plan objectAtIndex:indexPath.section] objectForKey:@"info"] objectAtIndex:indexPath.row] objectForKey:@"neu"];
    
    NSString *text = [NSString stringWithFormat:@"%@ -> %@", alt, neu];
    CGSize textSize = [text sizeWithFont:[UIFont fontWithName:@"Signika Negative" size:18.0f] constrainedToSize:CGSizeMake(self.tableView.frame.size.width - PADDING * 3, 1000.0f)];
    
    return textSize.height + PADDING * 3;
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{    
    UIImageView * header = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 25)];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(8, 3, 310, 20)];
    
    label.text = [[self.plan objectAtIndex:section] objectForKey:@"stunde"];
    label.font = [UIFont fontWithName:@"Futura" size:12.0f];
    label.backgroundColor = [UIColor clearColor];
    [header addSubview:label];
    header.backgroundColor = [UIColor colorWithRed:152.0f/255.0f green:164.0f/255.0f blue:175.0f/255.0f alpha:0.8f];;
    return header;
}


#pragma mark - Table view delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return;
}

#pragma mark Pull To Refresh Delegate

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	[self performSelector:@selector(reloadData) withObject:nil afterDelay:0.0];
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
	return [NSDate date]; // should return date data source was last changed
}

@end
