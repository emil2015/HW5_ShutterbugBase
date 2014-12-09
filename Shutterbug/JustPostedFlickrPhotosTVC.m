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
    //[self fetchPhotos];
}



- (IBAction)fetchPhotos
{
    [self.refreshControl beginRefreshing];
    
    //Get's the URL for the recent georeferenced photos and stores it in the NSURL url
    NSURL *url = [FlickrFetcher URLforRecentGeoreferencedPhotos];
    //creates and stores a queue in fetchQ for clickr fetcher
    dispatch_queue_t fetchQ = dispatch_queue_create("flickr fetcher", NULL);
    //Dispatch.... ? then passes in a block of code
    dispatch_async(fetchQ, ^{
        //Stores the json data from url in jsonResults
        NSData *jsonResults = [NSData dataWithContentsOfURL:url];
        //creates a dictionary of property list results
        NSDictionary *propertyListResults = [NSJSONSerialization
                                             JSONObjectWithData:jsonResults
                                             options:0
                                             error:NULL];
        //Outputs the json data to console
        
        //NSLog(@"Flickr Result = %@", propertyListResults);
        
        //creats an array or photos from the dictionary using the key
        NSArray *photos = [propertyListResults valueForKeyPath:FLICKR_RESULTS_PHOTOS];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
            self.photos = photos;
        });
    });
    
}


@end
