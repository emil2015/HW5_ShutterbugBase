//
//  LocationTVC.m
//  Shutterbug
//
//  Created by emil on 12/7/14.
//  Copyright (c) 2014 Lehman College. All rights reserved.
//

#import "LocationTVC.h"
#import "FlickrFetcher.h"
#import "ImageViewController.h"

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
    
    //===================================================================================
    /*
    NSURL *urlForPlaces = [FlickrFetcher URLforTopPlaces];
    
    dispatch_queue_t fetchQ = dispatch_queue_create("flickr fetcher", NULL);
    
    dispatch_async(fetchQ, ^{
        
        NSData *placesData = [NSData dataWithContentsOfURL:urlForPlaces];
        
        NSDictionary *placesDict = [NSJSONSerialization
                                    JSONObjectWithData:placesData
                                    options:0
                                    error:NULL];
        //region name
        //photos for place
        
        NSMutableArray *tempPlacesArray = [placesDict valueForKeyPath:FLICKR_RESULTS_PLACES];
        
        NSMutableArray *tempPlacesID = [tempPlacesArray valueForKeyPath:FLICKR_PLACE_ID];
        
        self.places = tempPlacesID;
        NSMutableArray *photoTemp = [[NSMutableArray alloc] init];
        
        for (id place in tempPlacesID){
            NSArray
        }
    
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
            //self.photos = photos;
            //self.places = places;
        });
    });
    */
    //===================================================================================
    
    
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
        
        //==============================================================================================================================
        NSURL *superMeh = [FlickrFetcher URLforInformationAboutPlace:[[places firstObject] valueForKeyPath:FLICKR_PLACE_ID]];
        
        NSData *mehPlaces = [NSData dataWithContentsOfURL:superMeh];
        
        NSDictionary *mehDict = [NSJSONSerialization
                                      JSONObjectWithData:mehPlaces
                                      options:0
                                      error:NULL];
        
        NSLog(@"%@", [FlickrFetcher extractRegionNameFromPlaceInformation:mehDict]);
        
        
        //NSLog(@"%@", [FlickrFetcher extractNameOfPlace:@"jXYpNeRUVL4aQe545A" fromPlaceInformation:mehDict]);
        
        //NSString *tempMeh = [[places firstObject] valueForKeyPath:FLICKR_PLACE_ID];
        //NSLog(@"%@", [FlickrFetcher extractNameOfPlace:tempMeh fromPlaceInformation:mehDict]);
        //==============================================================================================================================
        
        //NSLog(@"%@", locationDict);
        
        //NSLog(@"%@", [NSData dataWithContentsOfURL:[FlickrFetcher URLforRecentGeoreferencedPhotos]]);
        
        NSData *jsonResults = [NSData dataWithContentsOfURL:[FlickrFetcher URLforPhotosInPlace:@"jXYpNeRUVL4aQe545A" maxResults:10]];
        //NSData *jsonResults = [NSData dataWithContentsOfURL:placesURL];

                //NSData *jsonResults = [NSData dataWithContentsOfURL:[FlickrFetcher URLforPhotosInPlace:[locationDict valueForKeyPath:FLICKR_RESULTS_PLACES] maxResults:10]];
        
        //Array of dictionaries

        
        //NSLog(@"%@", places);
        
        NSDictionary *propertyListResults = [NSJSONSerialization
                                             JSONObjectWithData:jsonResults
                                             options:0
                                             error:NULL];

        NSMutableArray *tempCities = [[NSMutableArray alloc] init];
        NSMutableArray *tempCountries = [[NSMutableArray alloc] init];
        NSMutableArray *tempPlaces = [[NSMutableArray alloc] init];

        
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
        }
        self.places = [tempPlaces copy];
        self.cities = [tempCities copy];
        self.countries = [tempCountries copy];

        //------------------
        NSMutableDictionary *placesDictionary = [[NSMutableDictionary alloc] init];
        for (int i = 0; i < self.countries.count; i++){
            [placesDictionary setObject:[self.cities objectAtIndex:i] forKey:[self.countries objectAtIndex:i]];
            [placesDictionary setObject:[self.places objectAtIndex:i] forKey:[self.countries objectAtIndex:i]];
        }
        //NSLog(@"My dict: %@", [placesDictionary description]);

        //-----------------
        NSLog(@"%@#", [FlickrFetcher extractNameOfPlace:[tempPlaces firstObject] fromPlaceInformation:locationDict]);
        
        NSMutableArray *tempPlacePhoto = [[NSMutableArray alloc] init];
        for (id meh in tempPlaces){
            //need to do something to get the photos from places into an array somehow and pass it so it populates the sections.
        }
        
        //Outputs the json data to console
        
        //NSLog(@"Flickr Result = %@", propertyListResults);
        
        //creats an array or photos from the dictionary using the key
        
        NSArray *photos = [propertyListResults valueForKeyPath:FLICKR_RESULTS_PHOTOS];
        //NSArray *places = [locationDict valueForKeyPath:FLICKR_RESULTS_PLACES];
        
        //photos = [FlickrFetcher URLforPhotosInPlace:places maxResults:10];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
            self.photos = photos;
            //self.places = places;
        });
    });
    //[self orginizeDictionary];
    /*
    NSMutableDictionary *placesDictionary = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < self.countries.count; i++){
        [placesDictionary setObject:[self.cities objectAtIndex:i] forKey:[self.countries objectAtIndex:i]];
        [placesDictionary setObject:[self.places objectAtIndex:i] forKey:[self.countries objectAtIndex:i]];
    }
    NSLog(@"My dict: %@", [placesDictionary description]);
     */
}

- (void)orginizeDictionary{
    NSMutableDictionary *placesDictionary = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < self.countries.count; i++){
        [placesDictionary setObject:[self.cities objectAtIndex:i] forKey:[self.countries objectAtIndex:i]];
        [placesDictionary setObject:[self.places objectAtIndex:i] forKey:[self.countries objectAtIndex:i]];
    }
    NSLog(@"My dict: %@", [placesDictionary description]);
}



//--------------------------------------------
/*

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.places count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Flickr Photo Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary *photo = self.places[indexPath.row];
    cell.textLabel.text = [photo valueForKeyPath:FLICKR_PHOTO_TITLE];
    cell.detailTextLabel.text = [photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    \
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.identifier isEqualToString:@"Display Photo"]) {
                if ([segue.destinationViewController isKindOfClass:[ImageViewController class   ]]) {
                    [self prepareImageViewController:segue.destinationViewController toDisplayPhoto:self.photos[indexPath.row]];
                }
            }
        }
    }
    
}

- (void)prepareImageViewController:(ImageViewController *)ivc
                    toDisplayPhoto:(NSDictionary *)photo
{
    ivc.imageURL = [FlickrFetcher URLforPhoto:photo format:FlickrPhotoFormatLarge];
    ivc.title = [photo valueForKeyPath:FLICKR_PHOTO_TITLE];
*/
@end
