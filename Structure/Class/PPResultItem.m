//
//  PPResultItem.m
//  Flickr
//
//  Created by Dmitry Preobrazhenskiy on 08/02/16.
//  Copyright © 2016 Dmitry Preobrazhenskiy. All rights reserved.
//

#import "PPResultItem.h"
#import "KZAsserts.h"

NSString *const PPPhotosKey = @"photos";

@interface PPResultItem ()
@property(nonatomic, strong, nullable) NSDictionary *attributes;
@end

@implementation PPResultItem

+ (instancetype)itemWithAttributes:(NSDictionary *)attributes {
    return [[self alloc] initWithAttributes:attributes];
}

- (id)initWithAttributes:(NSDictionary *)attributes {
    AssertTrueOrReturnNil(attributes != nil && attributes.allKeys.count > 0);
    self = [super init];
    if(self) {
        self.attributes = attributes;
    }

    return self;
}

@end
