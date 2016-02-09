//
//  Created by Dmitry Preobrazhenskiy on 08/02/16.
//  Copyright © 2016 Dmitry Preobrazhenskiy. All rights reserved.
//

#import "NSDictionary+NullAdditions.h"

@implementation NSDictionary (NullAdditions)

- (id)objectForKeyNotNull:(id)key {
    id object = [self objectForKey:key];
    if(object == [NSNull null]) {
        return nil;
    }

    return object;

}

@end
