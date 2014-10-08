//
//  AppSendr.h
//  AppSendr-iOS-SDK
//
//  Created by Jeremy GRENIER on 29/06/2014.
//  Copyright (c) 2014 Jeremy Grenier. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppSendr : NSObject

+ (void)setApplicationId:(NSString *)applicationId restKey:(NSString *)restKey;

+ (void)checkUpdate;

@end
