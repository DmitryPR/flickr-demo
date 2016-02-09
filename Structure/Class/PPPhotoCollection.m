//
//  PPPhotoCollection.m
//  Flickr
//
//  Created by Dmitry Preobrazhenskiy on 08/02/16.
//  Copyright © 2016 Dmitry Preobrazhenskiy. All rights reserved.
//

#import "PPPhotoCollection.h"
#import "NSDictionary+NullAdditions.h"
#import "PPPhotoItem.h"
#import "KZAsserts.h"

NSString *const PPPhotoCurrentKey = @"perpage";
NSString *const PPPhotoKey = @"photo";
NSString *const PPPhotoMaxPagesKey = @"pages";

@interface PPPhotoCollection ()
@property(nullable, nonatomic, strong) NSArray *photos;
@end

@implementation PPPhotoCollection

#pragma mark - Initialisation

- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super initWithAttributes:attributes];
    if(self) {
        [self parsePhotos];
    }
    return self;
}

#pragma mark - Public methods

- (void)mergeCollections:(PPPhotoCollection *)collectionToMerge {
    AssertTrueOrReturn(collectionToMerge != nil && collectionToMerge.photos.count > 0);
    NSMutableArray *currentArray = [self.photos mutableCopy];
    [currentArray addObjectsFromArray:collectionToMerge.photos];
    self.photos = currentArray;
}

#pragma mark - Private methods

- (void)parsePhotos {
    NSArray *resultItems = [self.attributes objectForKeyNotNull:PPPhotoKey];
    NSMutableArray *photoItems = [NSMutableArray array];

    for (NSDictionary *attributes in resultItems) {
        PPPhotoItem *item = [PPPhotoItem itemWithAttributes:attributes];
        if(item != nil) [photoItems addObject:item];
    }

    self.photos = photoItems;
}

#pragma mark - System Stuff

@end
