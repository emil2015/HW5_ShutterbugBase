//
//  LocationTVC.m
//  Shutterbug
//
//  Created by emil on 12/7/14.
//  Copyright (c) 2014 Lehman College. All rights reserved.
//

#import "LocationTVC.h"
#import "FlickrFetcher.h"

@interface LocationTVC ()

@end

@implementation LocationTVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self fetchPhotos];
}


- (IBAction)fetchPhotos
{
    [self.refreshControl beginRefreshing];
    
    //Get's the URL for the recent georeferenced photos and stores it in the NSURL url
    NSURL *url = [FlickrFetcher URLforTopPlaces];
    //creates and stores a queue in fetchQ for clickr fetcher
    dispatch_queue_t fetchQ = dispatch_queue_create("flickr fetcher", NULL);
    //Dispatch.... ? then passes in a block of code
    dispatch_async(fetchQ, ^{
        //Stores the json data from url in jsonResults
        NSData *jsonResults = [NSData dataWithContentsOfURL:url];
        //creates a dictionary of property list results
        NSDictionary *placesResults = [NSJSONSerialization
                                             JSONObjectWithData:jsonResults
                                             options:0
                                             error:NULL];
        //Outputs the json data to console
        NSLog(@"Flickr Result = %@", placesResults);
        //creats an array or photos from the dictionary using the key
        NSArray *photos = [placesResults valueForKeyPath:FLICKR_RESULTS_PLACES];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
            self.photos = photos;
        });
    });
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
