//
//  DispatchHelper.h
//  Flickr
//
//  Created by Dmitry Preobrazhenskiy on 08/02/16.
//  Copyright © 2016 Dmitry Preobrazhenskiy. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface DispatchHelper : NSObject

void dispatch_after_delay(float delayInSeconds, dispatch_queue_t queue, dispatch_block_t block);

void dispatch_after_delay_on_main_queue(float delayInSeconds, dispatch_block_t block);

void dispatch_async_on_high_priority_queue(dispatch_block_t block);

void dispatch_async_on_background_queue(dispatch_block_t block);

void dispatch_async_on_main_queue(dispatch_block_t block);

@end
