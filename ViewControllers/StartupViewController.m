//
//  StartupViewController.m
//  Flickr
//
//  Created by Dmitry Preobrazhenskiy on 08/02/16.
//  Copyright © 2016 Dmitry Preobrazhenskiy. All rights reserved.
//

#import "StartupViewController.h"
#import "HUDHelper.h"
#import "APIClient.h"

@interface StartupViewController ()

@end

@implementation StartupViewController

#pragma mark - Initialisation

#pragma mark - Public methods

#pragma mark - Private methods

- (void)processStartup {
    [HUDHelper showHUDWithText:@"Processing" forView:self.view];

    //Give some time the client to get the network status and maybe some additional loading if needed
    [APIClient sharedClient];

    __weak __typeof(&*self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [HUDHelper hideAllHUDForView:weakSelf.view];
        [weakSelf performSegueWithIdentifier:@"ShowMainViewController" sender:nil];
    });
}

#pragma mark - System Stuff

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self processStartup];
}

@end
