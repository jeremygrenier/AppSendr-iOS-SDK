//
//  ASAppTableViewCell.h
//  AppSendr-iOS-Demo
//
//  Created by Jeremy GRENIER on 29/06/2014.
//  Copyright (c) 2014 Jeremy Grenier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASAppTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet PFImageView *icon;

@property (nonatomic, weak) IBOutlet UILabel *title;
@property (nonatomic, weak) IBOutlet UILabel *bundleId;
@property (nonatomic, weak) IBOutlet UILabel *updateAt;

@end
