//
//  ASAppTableViewCell.m
//  AppSendr-iOS-Demo
//
//  Created by Jeremy GRENIER on 29/06/2014.
//  Copyright (c) 2014 Jeremy Grenier. All rights reserved.
//

#import "ASAppTableViewCell.h"

@implementation ASAppTableViewCell

- (void)layoutSubviews
{
    self.icon.layer.cornerRadius = 15;
    self.icon.clipsToBounds = YES;
}

@end
