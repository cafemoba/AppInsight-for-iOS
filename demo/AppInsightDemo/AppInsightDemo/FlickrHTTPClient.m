//
//  FlickrHTTPClient.m
//  AppInsightDemo
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

#import "AFNetworking.h"
#import "FlickrHTTPClient.h"
#import "FlickrPhoto.h"

NSString *const kFlickrApiKey = @"d9895fbb3ef8d413ff36890bc97b8a33";
NSString *const kFlickrBaseURL = @"http://api.flickr.com";

typedef void (^HandleNetworkStatusChange)(AFNetworkReachabilityStatus);

@interface FlickrHTTPClient()

@property(nonatomic, strong) NSMutableDictionary *apiParams;

- (void)networkStatusChanged:(AFNetworkReachabilityStatus)status;

@end

@implementation FlickrHTTPClient

+ (instancetype)sharedFlickerClient
{
    static FlickrHTTPClient *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kFlickrBaseURL]];
    });
    return sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setDefaultHeader:@"Accept" value:@"application/json"];
        
        [self networkStatusChanged:self.networkReachabilityStatus];
        __typeof__(self) __weak wself = self;
        [self setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            [wself networkStatusChanged:status];
        }];
    }
    return self;
}

- (void)searchFlickrForTerm:(NSString *)term completionBlock:(FlickrSearchCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[self apiParams] mutableCopy];
    [params setObject:term forKey:@"text"];
    
    AI_LogTag(@"Searching", term);
    [self getPath:@"/services/rest/"
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id json) {
              NSDictionary *searchResultsDict = json;
              NSString * status = searchResultsDict[@"stat"];
              if ([status isEqualToString:@"fail"]) {
                  NSError * error = [[NSError alloc] initWithDomain:@"com.cafemoba.AppInsightDemo"
                                                               code:0
                                                           userInfo:@{NSLocalizedFailureReasonErrorKey: searchResultsDict[@"message"]}];
                  completionBlock(term, nil, error);
              } else {
                  NSArray *objPhotos = searchResultsDict[@"photos"][@"photo"];
                  NSMutableArray *flickrPhotos = [@[] mutableCopy];
                  for(NSMutableDictionary *objPhoto in objPhotos)
                  {
                      FlickrPhoto *photo = [[FlickrPhoto alloc] initWithMeta:objPhoto];
                      [flickrPhotos addObject:photo];
                  }
                  
                  completionBlock(term, flickrPhotos, nil);
                  AI_LogTagStopTimer(@"Searching", term);
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              completionBlock(term, nil, error);
              AI_LogTagStopTimer(@"Searching", term);
          }];
}

- (void)loadImageForPhotoURL:(NSURL *)photoURL completionBlock:(FlickrPhotoCompletionBlock) completionBlock
{
    AI_LogTag(@"Fetching Photo", [photoURL absoluteString]);
    NSURLRequest *photoRequest = [NSURLRequest requestWithURL:photoURL];
    AFImageRequestOperation *operation = [AFImageRequestOperation
                                          imageRequestOperationWithRequest:photoRequest
                                          imageProcessingBlock:NULL
                                          success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                              completionBlock(image, nil);
                                              AI_LogTagStopTimer(@"Fetching Photo", [photoURL absoluteString]);
                                          } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                              completionBlock(nil, error);
                                              AI_LogTagStopTimer(@"Fetching Photo", [photoURL absoluteString]);
                                          }];
    [self enqueueHTTPRequestOperation:operation];
}

- (NSMutableDictionary *)apiParams
{
    if (!_apiParams) {
        _apiParams = [[NSMutableDictionary alloc] init];
        [_apiParams setObject:@"flickr.photos.search" forKey:@"method"];
        [_apiParams setObject:kFlickrApiKey forKey:@"api_key"];
        [_apiParams setObject:@"20" forKey:@"per_page"];
        [_apiParams setObject:@"json" forKey:@"format"];
        [_apiParams setObject:@"1" forKey:@"nojsoncallback"];
        [_apiParams setObject:@"interestingness-desc" forKey:@"sort"];
    }
    return _apiParams;
}

- (void)networkStatusChanged:(AFNetworkReachabilityStatus)status
{
    switch (status) {
        case AFNetworkReachabilityStatusReachableViaWWAN:
            AI_LogTag(@"Detecting Network", @"Mobile");
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            AI_LogTag(@"Detecting Network", @"WiFi");
            break;
        default:
            break;
    }
}

@end
