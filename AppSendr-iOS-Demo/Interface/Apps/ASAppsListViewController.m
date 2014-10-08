//
//  ASAppsListViewController.m
//  AppSendr-iOS-Demo
//
//  Created by Jeremy GRENIER on 29/06/2014.
//  Copyright (c) 2014 Jeremy Grenier. All rights reserved.
//

#import "ASAppsListViewController.h"

#import "ASAppTableViewCell.h"
#import "ASBundlesListViewController.h"

@interface ASAppsListViewController ()

@end

@implementation ASAppsListViewController

- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self) {
        // Custom the table
        
        // The className to query on
        self.parseClassName = @"App";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = NO;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Apps";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self loadObjects];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
     ASBundlesListViewController *vc = [segue destinationViewController];
     NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
     vc.app = self.objects[indexPath.row];
 }

#pragma mark - PFQueryTableViewController

- (void)objectsWillLoad
{
    [super objectsWillLoad];
}

- (void)objectsDidLoad:(NSError *)error
{
    [super objectsDidLoad:error];
}

// Override to customize what kind of query to perform on the class. The default is to query for
// all objects ordered by createdAt descending.
- (PFQuery *)queryForTable
{
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    
    // If Pull To Refresh is enabled, query against the network by default.
    if ( self.pullToRefreshEnabled ) {
        query.cachePolicy = kPFCachePolicyNetworkOnly;
        query.limit =  self.objectsPerPage;
    }
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if ( self.objects.count == 0 ) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
        
    [query orderByDescending:@"createdAt"];
    
    return query;
}

// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the textKey in the object,
// and the imageView being the imageKey in the object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    ASAppTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AppCell" forIndexPath:indexPath];
    
    cell.title.text = object[@"name"];
    cell.bundleId.text = object[@"identifier"];
    
    [cell.icon setImage:[UIImage imageNamed:@"app"]];
    cell.icon.file = object[@"icon"];
    [cell.icon loadInBackground];
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    cell.updateAt.text = [NSString stringWithFormat:@"Updated at %@", [formatter stringFromDate:object.updatedAt]];

    return cell;
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

@end
