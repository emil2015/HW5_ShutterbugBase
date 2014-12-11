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
    
    //NSURL *placesURL    = [FlickrFetcher URLforTopPlaces];
    
    //NSURL *url          = [FlickrFetcher URLforRecentGeoreferencedPhotos];
    
    
    dispatch_queue_t fetchQ = dispatch_queue_create("flickr fetcher", NULL);
    
    dispatch_async(fetchQ, ^{
    /*
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
            
            
            [tempPlaces addObject:placeID];
            //This fetches the photos fo the places
            
            NSData *jsonResults = [NSData dataWithContentsOfURL:[FlickrFetcher URLforPhotosInPlace:placeID maxResults:3]];
            NSDictionary *propertyListResults = [NSJSONSerialization
                                                 JSONObjectWithData:jsonResults
                                                 options:0
                                                 error:NULL];
            [photos addObjectsFromArray:[propertyListResults valueForKeyPath:FLICKR_RESULTS_PHOTOS]];
             
            //end photo getting and adding to photo array
            
        }
        self.places = [tempPlaces copy];
        self.cities = [tempCities copy];
        self.countries = [tempCountries copy];
        */
    
    NSData *jsonResults = [NSData dataWithContentsOfURL:[FlickrFetcher URLforPhotosInPlace:self.thePlace maxResults:50]];
    NSDictionary *propertyListResults = [NSJSONSerialization
                                         JSONObjectWithData:jsonResults
                                         options:0
                                         error:NULL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
            self.photos = [propertyListResults valueForKeyPath:FLICKR_RESULTS_PHOTOS];
            
            //NSLog(@"%@", self.photos);
            
            NSArray *sortedArray;
            sortedArray = [self.photos sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                NSString *first = [a valueForKeyPath:FLICKR_PHOTO_TITLE];
                NSString *second = [b valueForKeyPath:FLICKR_PHOTO_TITLE];
                return [first compare:second];
            }];
            self.photos = sortedArray;
            

            
            //self.places = places;
        });
    });
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    //return [self.countries count];
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //?
    return @"Place holder";
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.photos count];
    //return [self.cities count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Flickr Photo Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    NSDictionary *photo = self.photos[indexPath.row];
    cell.textLabel.text = [photo valueForKeyPath:FLICKR_PHOTO_TITLE];
    cell.detailTextLabel.text = [photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    
    
    //cell.textLabel.text = self.cities[indexPath.row + (indexPath.section * XXYYZ)];
    //cell.detailTextLabel.text = @"";
    
    
    
    //cell.detailTextLabel.text = self.cities[indexPath.section];
    //cell.detailTextLabel.text = [photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    
    //NSString *cities = self.cities[indexPath.row];
    //cell.textLabel.text = cities;//[cities valueForKeyPath:FLICKR_PLACE_NAME];
    //cell.detailTextLabel.text = [cities valueForKeyPath:FLICKR_PLACE_ID];
    
    return cell;
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
