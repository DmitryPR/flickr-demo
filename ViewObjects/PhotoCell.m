//
//  PhotoCell.m
//  Flickr
//
//  Created by Dmitry Preobrazhenskiy on 08/02/16.
//  Copyright © 2016 Dmitry Preobrazhenskiy. All rights reserved.
//

#import "PhotoCell.h"
#import "PPPhotoItem.h"
#import "NSDictionary+NullAdditions.h"
#import <FlickrKit/FlickrKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "KZAsserts.h"

@implementation PhotoCell

#pragma mark - Initialisation

#pragma mark - Public methods

- (void)updateWithPhoto:(PPPhotoItem *)photo {
    AssertTrueOrReturn(photo != nil);

    NSURL *url = [[FlickrKit sharedFlickrKit] photoURLForSize:FKPhotoSizeThumbnail100 fromPhotoDictionary:photo.attributes];
    [self.photoImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"template"] options:SDWebImageHighPriority | SDWebImageRetryFailed];
    self.photoTitleLabel.text = [photo.attributes objectForKeyNotNull:PPTitleKey];
}

#pragma mark - Private methods

#pragma mark - System Stuff

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.photoImageView sd_cancelCurrentImageLoad];
}

- (void)dealloc {
    [self.photoImageView sd_cancelCurrentImageLoad];
}

@end
