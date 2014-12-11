//
//  placesTVC.m
//  Shutterbug
//
//  Created by David Gross on 12/10/14.
//  Copyright (c) 2014 Lehman College. All rights reserved.
//

#import "placesTVC.h"
#import "FlickrFetcher.h"
#import "LocationTVC.h"
#import "newHistoryTVCViewController.h"

@interface placesTVC ()
@property (nonatomic, strong)  NSArray *localPlaces;



@end

@implementation placesTVC

@synthesize historyOfPlaces = _historyOfPlaces;

- (NSMutableArray *)historyOfPlaces{
    if (!_historyOfPlaces){
        _historyOfPlaces = [[NSMutableArray alloc] init];
    }
    return _historyOfPlaces;
}

- (void)setHistoryOfPlaces:(NSMutableArray *)historyOfPlaces{
    if(!_historyOfPlaces){
        _historyOfPlaces = historyOfPlaces;
    }
    [self.tableView reloadData];
}

- (void)setLocalPlaces:(NSArray *)localPlaces{
    if (!_localPlaces){
        _localPlaces = localPlaces;
    }
    [self.tableView reloadData];
}

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
        //NSLog(@"%@", locationDict);
        
        NSArray *places = [locationDict valueForKeyPath:@"places.place"];
        
        NSMutableArray *tempCities = [[NSMutableArray alloc] init];
        NSMutableArray *tempCountries = [[NSMutableArray alloc] init];
        NSMutableArray *tempPlaces = [[NSMutableArray alloc] init];
        NSMutableArray *photos = [[NSMutableArray alloc] init];
        
        /*
        NSArray *sortedArray;
        sortedArray = [places sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            NSString *first  =  [a valueForKeyPath:[FlickrFetcher extractRegionNameFromPlaceInformation:a]];
            NSString *second =  [b valueForKeyPath:[FlickrFetcher extractRegionNameFromPlaceInformation:b]];
            return [first compare:second];
        }];
        places = sortedArray;
        */
        
        
        //sort by city
        /*
        NSArray *sortedArray2;
        sortedArray2 = [places sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            NSString *first = [a valueForKeyPath:FLICKR_PLACE_NAME];
            NSString *second = [b valueForKeyPath:FLICKR_PLACE_NAME];
            return [first compare:second];
        }];
        */
        
        //places = [sortedArray2 copy];
        //sorts by country
        NSArray *sortedArray;
        sortedArray = [places sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            NSArray *firstA = [[a valueForKeyPath:FLICKR_PLACE_NAME] componentsSeparatedByString:@","];
            NSString *first = [firstA lastObject];
            NSArray *secondB = [[b valueForKeyPath:FLICKR_PLACE_NAME] componentsSeparatedByString:@","];
            NSString *second = [secondB lastObject];
            return [first compare:second];
        }];
        places = [sortedArray copy];
        
        /*
         NSSortDescriptor *gradeSorter = [[NSSortDescriptor alloc] initWithKey:@"grade" ascending:YES];
         NSSortDescriptor *nameSorter = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
         
         [personList sortUsingDescriptors:[NSArray arrayWithObjects:gradeSorter, nameSorter, nil]];
         */
        


        
        
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
            //Connect places and cities
            /*
            
            
            NSData *jsonResults = [NSData dataWithContentsOfURL:[FlickrFetcher URLforPhotosInPlace:placeID maxResults:3]];
            NSDictionary *propertyListResults = [NSJSONSerialization
                                                 JSONObjectWithData:jsonResults
                                                 options:0
                                                 error:NULL];
            [photos addObjectsFromArray:[propertyListResults valueForKeyPath:FLICKR_RESULTS_PHOTOS]];
            */
            

            
        }
        self.places = [tempPlaces copy];
        self.cities = [tempCities copy];
        self.countries = [tempCountries copy];
        self.localPlaces = [tempPlaces copy];
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
            self.photos = photos;
            

            
            /*
            NSMutableArray *temp = [[NSMutableArray alloc] init];

            for (id meh in photos){
                [temp addObject:[FlickrFetcher extractRegionNameFromPlaceInformation:meh]];
                
            }
            self.cities = [temp copy];
            */
            //self.localPlaces = places;
        });
    });
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Flickr Photo Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    //NSDictionary *photo = self.photos[indexPath.row + (indexPath.section * XXYYZ)];
    //cell.textLabel.text = [photo valueForKeyPath:FLICKR_PHOTO_TITLE];
    //cell.detailTextLabel.text = self.cities[indexPath.row + (indexPath.section * XXYYZ)];
    
    
    cell.textLabel.text = self.cities[indexPath.row + (indexPath.section * 3)];
    cell.detailTextLabel.text = @"";
    
    
    
    //cell.detailTextLabel.text = self.cities[indexPath.section];
    //cell.detailTextLabel.text = [photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    
    //NSString *cities = self.cities[indexPath.row];
    //cell.textLabel.text = cities;//[cities valueForKeyPath:FLICKR_PLACE_NAME];
    //cell.detailTextLabel.text = [cities valueForKeyPath:FLICKR_PLACE_ID];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.identifier isEqualToString:@"location"]) {
                if ([segue.destinationViewController isKindOfClass:[LocationTVC class   ]]) {
                    //[self prepareImageViewController:segue.destinationViewController toDisplayPhoto:self.photos[indexPath.row + (indexPath.section * XXYYZ)]];
                    LocationTVC *dest = (LocationTVC *)segue.destinationViewController;
                    dest.thePlace = self.localPlaces[indexPath.row + indexPath.section * 3];
                    dest.biggerPlace = self.countries[indexPath.row + indexPath.section * 3];
                    //--
                    [self.historyOfPlaces addObject:self.localPlaces[indexPath.row + indexPath.section * 3]];
                    //newHistoryTVCViewController *his = (newHistoryTVCViewController *)segue.destinationViewController;
                    //his.history = [self.historyOfPlaces copy];
                    
                }
            }
        }
    }
    
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
