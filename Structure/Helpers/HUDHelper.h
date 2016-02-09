//
//  HUDHelper.h
//  Flickr
//
//  Created by Dmitry Preobrazhenskiy on 08/02/16.
//  Copyright © 2016 Dmitry Preobrazhenskiy. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface HUDHelper : NSObject


+ (void)showHUDWithText:(NSString *)text forView:(UIView *)view;

+ (void)hideAllHUDForView:(UIView *)view;

@end