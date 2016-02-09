//
//  PPResultItem.h
//  Flickr
//
//  Created by Dmitry Preobrazhenskiy on 08/02/16.
//  Copyright © 2016 Dmitry Preobrazhenskiy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPResultItem : NSObject

@property(nonatomic, readonly, nullable) NSDictionary *attributes;

+ (nonnull instancetype)itemWithAttributes:(nonnull NSDictionary *)attributes;

- (nullable id)initWithAttributes:(nonnull NSDictionary *)attributes;

@end
