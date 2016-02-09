//
//  MainViewController.h
//  Flickr
//
//  Created by Dmitry Preobrazhenskiy on 08/02/16.
//  Copyright © 2016 Dmitry Preobrazhenskiy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController

@property(weak, nonatomic) IBOutlet UILabel *statusLabel;
@property(weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property(weak, nonatomic) IBOutlet UILabel *countLabel;
@property(weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property(weak, nonatomic) IBOutlet UIButton *refreshButton;

- (IBAction)refreshButtonTapped:(id)sender;

@end
