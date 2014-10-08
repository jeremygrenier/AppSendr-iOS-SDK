//
//  ASBundleTableViewCell.m
//  AppSendr-iOS-Demo
//
//  Created by Jeremy GRENIER on 29/06/2014.
//  Copyright (c) 2014 Jeremy Grenier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASBundleTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *version;
@property (nonatomic, weak) IBOutlet UILabel *otaURL;
@property (nonatomic, weak) IBOutlet UILabel *createdAt;

@end
