//
//  FlickrPhotosTVC.h
//  Shutterbug
//
//  Created by Sameh Fakhouri on 11/24/14.
//  Copyright (c) 2014 Lehman College. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlickrPhotosTVC : UITableViewController
@property (nonatomic, strong) NSArray *photos; // of Flickr photo NSDictionary

//@property (nonatomic, strong) NSArray *places;
@property (nonatomic, strong)NSArray *countries;
@property (nonatomic, strong)NSArray *cities;

@property (nonatomic, strong)NSArray *places;

@property (nonatomic, strong)NSMutableDictionary *placesDictionary;


@end
