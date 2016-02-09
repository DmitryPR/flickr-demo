//
//  PPPhotoCollection.h
//  Flickr
//
//  Created by Dmitry Preobrazhenskiy on 08/02/16.
//  Copyright © 2016 Dmitry Preobrazhenskiy. All rights reserved.
//

#import "PPResultItem.h"

@interface PPPhotoCollection : PPResultItem

@property(nullable, nonatomic, readonly) NSArray *photos;

- (void)mergeCollections:(nonnull PPPhotoCollection *)collectionToMerge;

@end
