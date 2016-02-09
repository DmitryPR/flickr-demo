//
//  SharedConfiguration.m
//  Flickr
//
//  Created by Dmitry Preobrazhenskiy on 08/02/16.
//  Copyright © 2016 Dmitry Preobrazhenskiy. All rights reserved.
//
//

#import "SharedConfiguration.h"

NSString *const PPLastSearchKey = @"lastSearchWord";

@interface SharedConfiguration ()
@property(nonatomic, strong) NSDictionary *configDictionary;
@property(nonatomic, strong) NSUserDefaults *userDefaults;
@end

@implementation SharedConfiguration

#pragma mark - Initialisation

+ (instancetype)sharedInstance {
    static SharedConfiguration *sharedInstance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        sharedInstance = [[SharedConfiguration alloc] init];
    });

    return sharedInstance;
}

- (id)init {
    self = [super init];
    if(self) {
        self.userDefaults = [NSUserDefaults standardUserDefaults];
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *configFilePath = nil;
        if(bundle) {
            configFilePath = [bundle pathForResource:@"SharedConfiguration" ofType:@"plist"];
            self.configDictionary = [NSDictionary dictionaryWithContentsOfFile:configFilePath];
        }
        else {
            DDLogDebug(@"Could not find the bundle");
            return nil;
        }
    }
    return self;
}

#pragma mark - Initialisation

#pragma mark - Public methods

- (void)updateConfigurationWithLastSearchWord:(NSString *)lastSearch {
    [self.userDefaults setObject:lastSearch forKey:PPLastSearchKey];
    [self.userDefaults synchronize];
}

- (NSString *)showLastSearchWord {
    NSString *lastSearch = [self.userDefaults objectForKey:PPLastSearchKey];
    return lastSearch ? lastSearch : self.configDictionary[PPLastSearchKey];
}

#pragma mark - Private methods

#pragma mark - System Stuff

@end