//
//  AppSendr.m
//  AppSendr-iOS-SDK
//
//  Created by Jeremy GRENIER on 29/06/2014.
//  Copyright (c) 2014 Jeremy Grenier. All rights reserved.
//

#import "AppSendr.h"

NSString * const ParseBaseAPIURL = @"https://api.parse.com/1/";

@interface AppSendr ()

@property (nonatomic, strong) NSString *applicationId;
@property (nonatomic, strong) NSString *restKey;

+ (instancetype)sharedInstance;

@end

@implementation AppSendr

#pragma mark - Object life

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    if ( !sharedInstance ) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedInstance = [[super allocWithZone:NULL] init];
        });
    }
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedInstance];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

#pragma mark - Custom Method

+ (void)setApplicationId:(NSString *)applicationId restKey:(NSString *)restKey
{
    [AppSendr sharedInstance].applicationId = applicationId;
    [AppSendr sharedInstance].restKey = restKey;
}

+ (void)checkUpdate
{
#if !DEBUG
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary *application = [[AppSendr sharedInstance] getApplication];
        
        if ( !application ) {
            NSLog(@"You haven't upload an app with bundle Id: %@", [[NSBundle mainBundle] bundleIdentifier]);
        }
        else {
            NSDictionary *bundle = [[AppSendr sharedInstance] getLastBundleForApplication:application];
            
            if ( !bundle ) {
                NSLog(@"Impossible to find a bundle with bundle Id: %@", [[NSBundle mainBundle] bundleIdentifier]);
            }
            else {
                if ( [bundle[@"version"] isEqual:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]] )
                    NSLog(@"You have the latest version.");
                else {
                    // Format: itms-services://?action=download-manifest&url=https://ota.io/otaId/manifest
                    
                    NSString *urlString = [NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@/manifest", bundle[@"otaURL"]];
                    NSURL *url = [NSURL URLWithString:urlString];
                    [[UIApplication sharedApplication] openURL:url];
                }
            }
        }
    });
#endif
}

- (NSDictionary *)getApplication
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@", ParseBaseAPIURL, @"classes/App"];
    NSString *query = [NSString stringWithFormat:@"?where={\"identifier\":\"%@\"}", [[NSBundle mainBundle] bundleIdentifier]];
    urlString = [urlString stringByAppendingString:[query stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:[AppSendr sharedInstance].applicationId  forHTTPHeaderField:@"X-Parse-Application-Id"];
    [request setValue:[AppSendr sharedInstance].restKey forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    if ( data ) {
        NSError *error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        if ( json ) {
            NSArray *results = json[@"results"];
            
            if ( results.count )
                return  [results firstObject];
        }
    }
    return nil;
}

- (NSDictionary *)getLastBundleForApplication:(NSDictionary *)app
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@", ParseBaseAPIURL, @"classes/Bundle"];
    
    NSMutableString *query = [NSMutableString stringWithString:@"?"];
    [query appendString:@"limit=1&"];
    [query appendString:@"order=-updatedAt&"];
    [query appendString:[NSString stringWithFormat:@"where={\"$relatedTo\":{\"object\":{\"__type\":\"Pointer\",\"className\":\"App\",\"objectId\":\"%@\"},\"key\":\"bundles\"}}", app[@"objectId"]]];
    urlString = [urlString stringByAppendingString:[query stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:[AppSendr sharedInstance].applicationId  forHTTPHeaderField:@"X-Parse-Application-Id"];
    [request setValue:[AppSendr sharedInstance].restKey forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    if ( data ) {
        NSError *error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        if ( json ) {
            NSArray *results = json[@"results"];
            
            if ( results.count )
                return  [results firstObject];
        }
    }
    return nil;
}

@end
