//
//  newHistoryTVCViewController.m
//  Shutterbug
//
//  Created by David Gross on 12/10/14.
//  Copyright (c) 2014 Lehman College. All rights reserved.
//

#import "newHistoryTVCViewController.h"
#import "LocationTVC.h"

@interface newHistoryTVCViewController ()

@end

@implementation newHistoryTVCViewController


@synthesize history = _history;

- (NSMutableArray *)historyOfPlaces{
    if (!_history){
        _history = [[NSMutableArray alloc] init];
    }
    return _history;
}

- (void)setHistory:(NSMutableArray *)history{
    if(!_history){
        _history = history;
    }
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:NO];
    [self.tableView reloadData];
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
                    dest.thePlace = self.history[indexPath.row];
                    //dest.biggerPlace = self.countries[indexPath.row + indexPath.section * 3];
                    
                }
            }
        }
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Flickr Photo Cell" forIndexPath:indexPath];
    
    // Configure the cell...
  
    cell.textLabel.text = self.history[indexPath.row];
    cell.detailTextLabel.text = @"";

    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    //return [self.countries count];
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //?
    //return [self.historyOfPlaces objectAtIndex:section];
    return @"holder";
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.history count];//[self.photos count] / [self.countries count];
    //return [self.cities count];
}

@end
