//
//  JustPostedFlickrPhotosTVC.m
//  Shutterbug
//
//  Created by Sameh Fakhouri on 11/24/14.
//  Copyright (c) 2014 Lehman College. All rights reserved.
//

#import "JustPostedFlickrPhotosTVC.h"
#import "FlickrFetcher.h"

@interface JustPostedFlickrPhotosTVC ()

@end

@implementation JustPostedFlickrPhotosTVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchPhotos];
}



- (IBAction)fetchPhotos
{
    [self.refreshControl beginRefreshing];
    
    NSURL *url = [FlickrFetcher URLforRecentGeoreferencedPhotos];

    dispatch_queue_t fetchQ = dispatch_queue_create("flickr fetcher", NULL);
    dispatch_async(fetchQ, ^{
        NSData *jsonResults = [NSData dataWithContentsOfURL:url];
        NSDictionary *propertyListResults = [NSJSONSerialization
                                             JSONObjectWithData:jsonResults
                                             options:0
                                             error:NULL];
        
        NSLog(@"Flickr Result = %@", propertyListResults);
        NSArray *photos = [propertyListResults valueForKeyPath:FLICKR_RESULTS_PHOTOS];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
            self.photos = photos;
        });
    });
    
    
    
    
}


@end
