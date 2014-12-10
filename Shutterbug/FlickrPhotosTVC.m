//
//  FlickrPhotosTVC.m
//  Shutterbug
//
//  Created by Sameh Fakhouri on 11/24/14.
//  Copyright (c) 2014 Lehman College. All rights reserved.
//

#import "FlickrPhotosTVC.h"
#import "FlickrFetcher.h"
#import "ImageViewController.h"

@interface FlickrPhotosTVC ()


@end

@implementation FlickrPhotosTVC

#define XXYYZ 3

- (void)setPlacesDictionary:(NSMutableDictionary *)placesDictionary{
    _placesDictionary = placesDictionary;
    [self.tableView reloadData];
}

- (void)setPlaces:(NSArray *)places{
    _places = places;
    [self.tableView reloadData];
}

- (void)setCountries:(NSArray *)countries{
    _countries = countries;
    [self.tableView reloadData];
}

- (void)setCities:(NSArray *)cities{
    _cities = cities;
    [self.tableView reloadData];
}

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    [self.tableView reloadData];
}
/*
- (void)setPlaces:(NSArray *)places
{
    _places = places;
    [self.tableView reloadData];
}
*/

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.countries count];
    //return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //?
    return [self.countries objectAtIndex:section];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return XXYYZ;//[self.photos count] / [self.countries count];
    //return [self.cities count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Flickr Photo Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    NSDictionary *photo = self.photos[indexPath.row + (indexPath.section * XXYYZ)];
    cell.textLabel.text = [photo valueForKeyPath:FLICKR_PHOTO_TITLE];
    cell.detailTextLabel.text = self.cities[indexPath.row + (indexPath.section * XXYYZ)];
    
    
    //cell.textLabel.text = self.cities[indexPath.row + (indexPath.section * XXYYZ)];
    //cell.detailTextLabel.text = @"";
    
    
    
    //cell.detailTextLabel.text = self.cities[indexPath.section];
    //cell.detailTextLabel.text = [photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    
    //NSString *cities = self.cities[indexPath.row];
    //cell.textLabel.text = cities;//[cities valueForKeyPath:FLICKR_PLACE_NAME];
    //cell.detailTextLabel.text = [cities valueForKeyPath:FLICKR_PLACE_ID];
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id detail = self.splitViewController.viewControllers[1];
    
    if ([detail isKindOfClass:[UINavigationController class]]) {
        detail = [((UINavigationController *)detail).viewControllers firstObject];
    }
    
    
    if ([detail isKindOfClass:[ImageViewController class]]) {
        [self prepareImageViewController:detail toDisplayPhoto:self.photos[indexPath.row + (indexPath.section * XXYYZ)]];
    }
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.identifier isEqualToString:@"Display Photo"]) {
                if ([segue.destinationViewController isKindOfClass:[ImageViewController class   ]]) {
                    [self prepareImageViewController:segue.destinationViewController toDisplayPhoto:self.photos[indexPath.row + (indexPath.section * XXYYZ)]];
                    
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
}






@end
