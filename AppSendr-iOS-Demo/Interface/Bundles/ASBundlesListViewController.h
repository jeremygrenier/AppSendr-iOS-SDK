//
//  ASBundlesListViewController.h
//  AppSendr-iOS-Demo
//
//  Created by Jeremy GRENIER on 29/06/2014.
//  Copyright (c) 2014 Jeremy Grenier. All rights reserved.
//

#import <Parse/Parse.h>

@interface ASBundlesListViewController : PFQueryTableViewController

@property (nonatomic, strong) PFObject *app;

@end
