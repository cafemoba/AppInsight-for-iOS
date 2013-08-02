//
//  FlickrPhotoViewController.m
//  Flickr Search
//
//  Copyright (c) 2013, pVelocity Inc.
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  * Redistributions of source code must retain the above copyright notice,
//    this list of conditions and the following disclaimer.
//
//  * Redistributions in binary form must reproduce the above copyright notice,
//    this list of conditions and the following disclaimer in the documentation
//    and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.
//

#import "FlickrPhotoViewController.h"
#import "FlickrHTTPClient.h"
#import "FlickrPhoto.h"

@interface FlickrPhotoViewController ()
@property(weak) IBOutlet UIImageView *imageView;
- (IBAction)done:(id) sender;
@end

@implementation FlickrPhotoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    AI_LogTagStopTimer(@"Displaying Dashboard", @"");
    AI_LogTag(@"Displaying Photo in Fullscreen", [[self.flickrPhoto flickrPhotoURLWithSize:@"b"] absoluteString]);
    
    if(self.flickrPhoto.largeImage)
    {
        self.imageView.image = self.flickrPhoto.largeImage;
    }
    else
    {
        self.imageView.image = self.flickrPhoto.thumbnail;
        __typeof__(self) __weak wself = self;
        [[FlickrHTTPClient sharedFlickerClient] loadImageForPhotoURL:[self.flickrPhoto flickrPhotoURLWithSize:@"b"]
                                                     completionBlock:^(UIImage *photoImage, NSError *error) {
                                                         wself.flickrPhoto.largeImage = photoImage;
                                                         wself.imageView.image = wself.flickrPhoto.largeImage;
                                                     }];
    }
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    AI_LogTagStopTimer(@"Displaying Photo in Fullscreen", [[self.flickrPhoto flickrPhotoURLWithSize:@"b"] absoluteString]);
}


- (void)done:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
    AI_LogTag(@"Displaying Dashboard", @"");
}

@end
