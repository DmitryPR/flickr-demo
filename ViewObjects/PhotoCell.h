//
//  PhotoCell.h
//  Flickr
//
//  Created by Dmitry Preobrazhenskiy on 08/02/16.
//  Copyright © 2016 Dmitry Preobrazhenskiy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PPPhotoItem;

@interface PhotoCell : UICollectionViewCell

@property(weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property(weak, nonatomic) IBOutlet UILabel *photoTitleLabel;

- (void)updateWithPhoto:(PPPhotoItem *)photo;

@end
