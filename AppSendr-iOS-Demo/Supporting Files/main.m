//
//  main.m
//  AppSendr-iOS-Demo
//
//  Created by Jeremy GRENIER on 29/06/2014.
//  Copyright (c) 2014 Jeremy Grenier. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ASAppDelegate.h"
#import <QTouchposeApplication.h>

int main(int argc, char * argv[])
{
    @autoreleasepool {
        return UIApplicationMain(argc, argv, NSStringFromClass([QTouchposeApplication class]), NSStringFromClass([ASAppDelegate class]));
    }
}
