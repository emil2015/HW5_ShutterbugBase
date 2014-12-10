//
//  historyTVCViewController.m
//  Shutterbug
//
//  Created by David Gross on 12/10/14.
//  Copyright (c) 2014 Lehman College. All rights reserved.
//

#import "historyTVCViewController.h"
#import "FlickrFetcher.h"

@interface historyTVCViewController ()



@end

@implementation historyTVCViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self fetchPhotos];
    
}

- (IBAction)fetchPhotos
{
    [self.refreshControl beginRefreshing];

NSURL *placesURL    = [FlickrFetcher URLforTopPlaces];

//NSURL *url          = [FlickrFetcher URLforRecentGeoreferencedPhotos];


dispatch_queue_t fetchQ = dispatch_queue_create("flickr fetcher", NULL);

dispatch_async(fetchQ, ^{
    
    NSData *jsonPLaces = [NSData dataWithContentsOfURL:placesURL];
    
    NSDictionary *locationDict = [NSJSONSerialization
                                  JSONObjectWithData:jsonPLaces
                                  options:0
                                  error:NULL];
    NSArray *places = [locationDict valueForKeyPath:@"places.place"];

    NSMutableArray *tempCities = [[NSMutableArray alloc] init];
    NSMutableArray *tempCountries = [[NSMutableArray alloc] init];
    NSMutableArray *tempPlaces = [[NSMutableArray alloc] init];
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    
    
    for (id place in places){
        NSString *placeID = [place valueForKeyPath:FLICKR_PLACE_ID];
        //Pulls out the place name
        NSString *placeName = [place valueForKeyPath:FLICKR_PLACE_NAME];
        //Now you need to seperate out the data needed, like city and state
        //city name, proince, country name
        NSArray *stringCutter = [placeName componentsSeparatedByString:@","];
        //Element 1 is the city
        //Element 2 is the province
        //Element 3 is the country
        
        if (![tempCountries containsObject:[stringCutter lastObject]]){
            [tempCountries addObject:[stringCutter lastObject]];
        }
        
        [tempCities addObject:[stringCutter firstObject]];
        
        //Connect places and cities
        [tempPlaces addObject:placeID];
        
        NSData *jsonResults = [NSData dataWithContentsOfURL:[FlickrFetcher URLforPhotosInPlace:placeID maxResults:3]];
        NSDictionary *propertyListResults = [NSJSONSerialization
                                             JSONObjectWithData:jsonResults
                                             options:0
                                             error:NULL];
        [photos addObjectsFromArray:[propertyListResults valueForKeyPath:FLICKR_RESULTS_PHOTOS]];
        
        
    }
    self.places = [tempPlaces copy];
    self.cities = [tempCities copy];
    self.countries = [tempCountries copy];


    dispatch_async(dispatch_get_main_queue(), ^{
        [self.refreshControl endRefreshing];
        self.photos = photos;
        //self.places = places;
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
