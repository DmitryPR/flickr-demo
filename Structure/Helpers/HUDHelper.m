//
//  HUDHelper.m
//  Flickr
//
//  Created by Dmitry Preobrazhenskiy on 08/02/16.
//  Copyright © 2016 Dmitry Preobrazhenskiy. All rights reserved.
//


#import "HUDHelper.h"
#import "MBProgressHUD.h"
#import "VisualisationHelper.h"

@implementation HUDHelper {}

#pragma mark - Initialisation

#pragma mark - Public methods

+ (void)showHUDWithText:(NSString *)text forView:(UIView *)view {
     __weak typeof(view) weakView = view;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (weakView == nil) return;
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:weakView animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = text;
        hud.animationType = MBProgressHUDAnimationFade;
    });
}

+ (void)hideAllHUDForView:(UIView *)view {
    __weak typeof(view) weakView = view;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (weakView == nil) return;
        [MBProgressHUD hideAllHUDsForView:weakView animated:YES];
    });
}

#pragma mark - Private methods

#pragma mark - System Stuff

@end