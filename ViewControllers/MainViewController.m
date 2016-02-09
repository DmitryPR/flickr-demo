//
//  MainViewController.m
//  Flickr
//
//  Created by Dmitry Preobrazhenskiy on 08/02/16.
//  Copyright © 2016 Dmitry Preobrazhenskiy. All rights reserved.
//

#import "MainViewController.h"
#import "FKFlickrPhotosSearch.h"
#import "SharedConfiguration.h"
#import <FlickrKit/FlickrKit.h>
#import "HUDHelper.h"
#import "KZAsserts.h"
#import "PPPhotoCollection.h"
#import "NSDictionary+NullAdditions.h"
#import "PhotoCell.h"

@interface MainViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate>
@property(nullable, nonatomic, strong) NSString *lastSearch;
@property(nonatomic, assign) NSInteger lastPage;
@property(nonatomic, assign) NSInteger currentNumber;
@property(nullable, nonatomic, strong) PPPhotoCollection *collection;
@property(nonatomic, assign) BOOL isLoadingMore;
@end

@implementation MainViewController

#pragma mark - Initialisation

- (void)setUpInitialData {
    self.lastSearch = [[SharedConfiguration sharedInstance] showLastSearchWord];
    self.lastPage = 1;

    self.searchBar.text = self.lastSearch;

    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;

    self.statusLabel.text = @"Flickr";
    self.countLabel.text = @"Please wait, getting the photos";

    self.refreshButton.hidden = YES;
    self.searchBar.delegate = self;
}

#pragma mark - Public methods

#pragma mark - IBActions

- (IBAction)refreshButtonTapped:(id)sender {
    self.searchBar.text = self.lastSearch;
    self.statusLabel.text = @"Flickr";
    self.countLabel.text = @"Please wait, getting the photos";
    self.lastPage = 1;
    self.currentNumber = 0;
    self.refreshButton.hidden = YES;
    [self loadInformation];
}

#pragma mark - Private methods

- (void)loadInformation {
    //In case there is an observer registered to monitor the network connection just remove it and let the loading handle it
    [[NSNotificationCenter defaultCenter] removeObserver:self name:connectionChangedNotification object:nil];

    [HUDHelper showHUDWithText:@"Processing" forView:self.view];
    __weak __typeof(&*self) weakSelf = self;
    FKFlickrPhotosSearch *search = [[FKFlickrPhotosSearch alloc] init];
    search.text = self.lastSearch;
    search.page = [NSString stringWithFormat:@"%lu", (unsigned long) self.lastPage];

    [[FlickrKit sharedFlickrKit] call:search completion:^(NSDictionary *response, NSError *error) {
        [HUDHelper hideAllHUDForView:weakSelf.view];
        if(error != nil) {
            if(![SharedConfiguration sharedInstance].isConnectionAvailable) {
                dispatch_async_on_main_queue(^{
                    [weakSelf handleNoConnection];
                });
            }
            else {
                //Its hard to handle 3rd party errors without knowing if we can retry them or not, so just logging at the moment
                DDLogError(@"%@", error);
            }
        }
        else {
            [weakSelf handleResponse:response];
        }
    }];
}

- (void)handleNoConnection {
    self.refreshButton.hidden = NO;
    self.countLabel.text = @"Oops, seems like something is wrong :(";
    self.searchBar.alpha = 0.3f;
    self.collectionView.alpha = 0.3f;
    self.collectionView.userInteractionEnabled = NO;
    self.searchBar.userInteractionEnabled = NO;
    [[[UIAlertView alloc] initWithTitle:@"Attention"
                                message:@"Please check internet connection and try again."
                               delegate:nil
                      cancelButtonTitle:@"Ok"
                      otherButtonTitles:nil] show];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleActiveConnection) name:connectionChangedNotification object:nil];
}

- (void)handleActiveConnection {
    if(![SharedConfiguration sharedInstance].isConnectionAvailable) return;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:connectionChangedNotification object:nil];
    self.searchBar.alpha = 1.0f;
    self.searchBar.userInteractionEnabled = YES;
    self.collectionView.alpha = 1.0f;
    self.collectionView.userInteractionEnabled = YES;
    self.countLabel.text = @"Seems like everything is good to go :)";

    // Just a simple retry logic
    [self loadInformation];
}

- (void)handleResponse:(NSDictionary *)response {
    AssertTrueOrReturn(response != nil && response.allKeys.count > 0);

    if(RESULTDEBUG) DDLogInfo(@"%@", response);

    PPPhotoCollection *collection = [PPPhotoCollection itemWithAttributes:[response objectForKeyNotNull:PPPhotosKey]];
    AssertTrueOrReturn(collection != nil);

    if(self.isLoadingMore) {
        //This is a simple merge by adding the next items to the current ones. Please note that the actual attributes are not changes, e.g page numbers, max pages and total count.
        [self.collection mergeCollections:collection];
        self.isLoadingMore = NO;
    }
    else {
        self.collection = collection;
    }

    __weak __typeof(&*self) weakSelf = self;
    dispatch_async_on_main_queue(^{
        [weakSelf updateCount];
        [weakSelf updateSearch];
        [weakSelf updateViews];
        [weakSelf.collectionView reloadData];
    });
}

- (void)updateCount {
    self.statusLabel.text = [NSString stringWithFormat:@"%@%@", @"Results for ", self.lastSearch];

    if (self.collection.photos.count == 0) {
        self.countLabel.text = @"Sorry, we could not find anything!";
        self.currentNumber = 0;
        return;
    }

    // The logic is that the json returns per page items and we just multiply it for current page
    NSInteger perPage = [[self.collection.attributes objectForKeyNotNull:PPPhotoCurrentKey] integerValue];
    self.currentNumber = self.lastPage * perPage;

    NSString *total = [self.collection.attributes objectForKeyNotNull:PPPhotoMaxPagesKey];

    self.countLabel.text = [NSString stringWithFormat:@"Showing %@ out of %@", [NSString stringWithFormat:@"%lu", (unsigned long) self.lastPage], total];
}

- (void)updateSearch {
    [[SharedConfiguration sharedInstance] updateConfigurationWithLastSearchWord:self.lastSearch];
    [self.searchBar resignFirstResponder];
}

- (void)updateViews {
    //No big need for animation here, but nice to have
    self.refreshButton.hidden = NO;
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];

    //System search bar does not allow us to make empty queries, no need to check for empty search
    self.lastSearch = searchBar.text;
    [self refreshButtonTapped:nil];
}

#pragma mark - UICollectionViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if([self.searchBar isFirstResponder]) [self.searchBar resignFirstResponder];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if((indexPath.row == self.currentNumber - 1) && (self.lastPage < [[self.collection.attributes objectForKeyNotNull:PPPhotoMaxPagesKey] integerValue])) {
        self.lastPage++;
        self.isLoadingMore = YES;
        [self loadInformation];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.collection.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PPPhotoItem *currentPhoto = self.collection.photos[indexPath.row];
    PhotoCell *photoCell = (PhotoCell *) [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    [photoCell updateWithPhoto:currentPhoto];
    return photoCell;
}

#pragma mark - System Stuff

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadInformation];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpInitialData];
}

@end
