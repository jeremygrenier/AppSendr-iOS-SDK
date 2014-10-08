//
//  ASBundlesListViewController.m
//  AppSendr-iOS-Demo
//
//  Created by Jeremy GRENIER on 29/06/2014.
//  Copyright (c) 2014 Jeremy Grenier. All rights reserved.
//

#import "ASBundlesListViewController.h"

#import "ASBundleTableViewCell.h"

@interface ASBundlesListViewController ()

@end

@implementation ASBundlesListViewController

- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self) {
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
    
    self.navigationItem.title = self.app[@"name"];
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
    if ( !self.app )
        return nil;
    
    PFQuery *query = [self.app relationForKey:@"bundles"].query;
    
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
    ASBundleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BundleCell" forIndexPath:indexPath];
    
    cell.version.text = [NSString stringWithFormat:@"Version: %@", object[@"version"]];
    
    cell.otaURL.text = [NSString stringWithFormat:@"Version: %@", object[@"otaURL"]];
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    cell.createdAt.text = [NSString stringWithFormat:@"Created: %@", [formatter stringFromDate:object.createdAt]];

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

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *urlString = [NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@/manifest", self.objects[indexPath.row][@"otaURL"]];
    NSURL *url = [NSURL URLWithString:urlString];
    [[UIApplication sharedApplication] openURL:url];
}

@end
