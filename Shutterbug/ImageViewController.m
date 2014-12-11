//
//  ImageViewController.m
//  Imaginarium
//
//  Created by Sameh Fakhouri on 11/11/14.
//  Copyright (c) 2014 CUNY Lehman College. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController () <UIScrollViewDelegate, UISplitViewControllerDelegate>
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@end

@implementation ImageViewController



- (void)setScrollView:(UIScrollView *)scrollView
{

    _scrollView = scrollView;
    _scrollView.delegate = self;
    _scrollView.minimumZoomScale = 0.2;
    _scrollView.maximumZoomScale = 2.0;
    _scrollView.zoomScale = 1.0;
    self.scrollView.contentSize = self.image ? self.image.size : CGSizeZero;
}



- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}



- (void)setImageURL:(NSURL *)imageURL
{
    _imageURL = imageURL;

    // starts out like this
    // self.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.imageURL]];
    
    [self startDownloadingImage];
}



- (void)startDownloadingImage
{
    self.image = nil;
    if (self.imageURL) {
        
        // add this for spinner start
        [self.spinner startAnimating];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:self.imageURL];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];

        // double click the completionHandler argument to insert the code.
        // change the location argument to localfile (more appropriate name)
        NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request
             completionHandler:^(NSURL *localFile, NSURLResponse *response, NSError *error) {
                 // make sure there is no error
                 // you may want to display a message "URL Not Found" or "Download Error"
                 if (!error) {
                     // this download could take a while
                     // Say it took 10 minutes, the user could have lost interest
                     // and chose a different image, or multiple images
                     // now we need to make sure that this download corresponds with
                     // what the app currently thinks is happening
                     if ([request.URL isEqual:self.imageURL]) {
                         UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:localFile]];
                         // add this block to the end of the main queue
                         // it will get executed when the main queue
                         // has time and all the other blocks in front
                         // of it have completed execution
                         [self performSelectorOnMainThread:@selector(setImage:)
                                                withObject:image
                                             waitUntilDone:NO];
                     }
                 }
             }];
        [task resume];
    }
}


#pragma mark - UISplitViewControllerDelegate

- (void)awakeFromNib
{
    self.splitViewController.delegate = self;
}


- (BOOL)splitViewController:(UISplitViewController *)svc
   shouldHideViewController:(UIViewController *)vc
              inOrientation:(UIInterfaceOrientation)orientation
{
    return UIInterfaceOrientationIsPortrait(orientation);
}



- (void)splitViewController:(UISplitViewController *)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)pc
{
    barButtonItem.title = aViewController.title;
    self.navigationItem.leftBarButtonItem = barButtonItem;
}


- (void)splitViewController:(UISplitViewController *)svc
     willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    self.navigationItem.leftBarButtonItem = nil;
}

- (UIImageView *)imageView
{
    if(!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}



- (UIImage *)image
{
    return self.imageView.image;
}



- (void)setImage:(UIImage *)image
{
    self.imageView.frame = CGRectMake(0., 0, image.size.width, image.size.height);
    
    self.scrollView.zoomScale = 1.0;
    
    self.imageView.image = image;

    
    
    
    [self.imageView sizeToFit];

    // add this for scroll view
    self.scrollView.contentSize = self.image ? self.image.size : CGSizeZero;
    
    // add this for the spinner stop
    [self.spinner stopAnimating];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // starts out like this
    // [self.imageView addSubview:self.imageView];
    
    // becomes this
    [self.scrollView  addSubview:self.imageView];
}

@end
