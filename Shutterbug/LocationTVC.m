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
    
    NSURL *placesURL    = [FlickrFetcher URLforTopPlaces];

    NSURL *url          = [FlickrFetcher URLforRecentGeoreferencedPhotos];


    dispatch_queue_t fetchQ = dispatch_queue_create("flickr fetcher", NULL);

    dispatch_async(fetchQ, ^{
        
        NSData *jsonPLaces = [NSData dataWithContentsOfURL:placesURL];

        NSDictionary *locationDict = [NSJSONSerialization
                                      JSONObjectWithData:jsonPLaces
                                      options:0
                                      error:NULL];
        //NSLog(@"%@", locationDict);
        
        //NSLog(@"%@", [NSData dataWithContentsOfURL:[FlickrFetcher URLforRecentGeoreferencedPhotos]]);
        
        NSData *jsonResults = [NSData dataWithContentsOfURL:[FlickrFetcher URLforPhotosInPlace:@"jXYpNeRUVL4aQe545A" maxResults:10]];
        //NSData *jsonResults = [NSData dataWithContentsOfURL:url];

                //NSData *jsonResults = [NSData dataWithContentsOfURL:[FlickrFetcher URLforPhotosInPlace:[locationDict valueForKeyPath:FLICKR_RESULTS_PLACES] maxResults:10]];
        
        //Array of dictionaries
        NSArray *places = [locationDict valueForKeyPath:@"places.place"];
        
        NSLog(@"%@", places);
        
        NSDictionary *propertyListResults = [NSJSONSerialization
                                             JSONObjectWithData:jsonResults
                                             options:0
                                             error:NULL];

        NSMutableArray *tempCities = [[NSMutableArray alloc] init];
        NSMutableArray *tempCountries = [[NSMutableArray alloc] init];
        
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
            
        }
        
        self.countries = [tempCountries copy];
        

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
