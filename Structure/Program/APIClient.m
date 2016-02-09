//
//  APIClient.m
//  Flickr
//
//  Created by Dmitry Preobrazhenskiy on 08/02/16.
//  Copyright © 2016 Dmitry Preobrazhenskiy. All rights reserved.
//
//

#import "APIClient.h"
#import "SharedConfiguration.h"

static NSString *serverURL = @"";

@implementation APIClient

+ (APIClient *)sharedClient {
    static APIClient *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *URLString = serverURL;
        sharedClient = [[APIClient alloc] initWithBaseURL:[NSURL URLWithString:URLString]];
    });

    return sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if(!self) {
        return nil;
    }

    self.requestSerializer = [AFHTTPRequestSerializer serializer];
    self.responseSerializer = [AFHTTPResponseSerializer serializer];

    [self.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {

        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                DDLogDebug(@"internet changed to Unknown");
                [SharedConfiguration sharedInstance].isConnectionAvailable = NO;
                break;

            case AFNetworkReachabilityStatusNotReachable:
                DDLogDebug(@"internet changed to Not Reachable");
                [SharedConfiguration sharedInstance].isConnectionAvailable = NO;
                break;

            case AFNetworkReachabilityStatusReachableViaWWAN:
                DDLogDebug(@"internet changed to EDGE/3G");
                [SharedConfiguration sharedInstance].isConnectionAvailable = YES;
                break;

            case AFNetworkReachabilityStatusReachableViaWiFi:
                DDLogDebug(@"internet changed to WIFI");
                [SharedConfiguration sharedInstance].isConnectionAvailable = YES;
                break;

            default:
                DDLogDebug(@"internet changed to Bad");
                [SharedConfiguration sharedInstance].isConnectionAvailable = NO;
                break;
        }

        [[NSNotificationCenter defaultCenter] postNotificationName:connectionChangedNotification object:nil];
    }];

    [self.reachabilityManager startMonitoring];

    return self;
}

#pragma mark - Public methods

#pragma mark - System Stuff

- (void)dealloc {
    [self.reachabilityManager startMonitoring];
}

@end
