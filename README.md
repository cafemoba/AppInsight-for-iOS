AppInsight-for-iOS
==================

AppInsight is usage, performance, usability tracking library that supplements [Cafe Moba](http://cafemoba.com) analytics and reporting tool.


Installation
============

### From CocoaPods

* Add `pod AppInsight` to your Podfile.
* Add `#import <AppInsight/AppInsight.h>` to your _Prefix.pch_

### Manually

* Drag **AppInsight.framework** to your Frameworks grouping within XCode.
* Add `#import <AppInsight/AppInsight.h>` to your _Prefix.pch_

Usage
=====

(see sample XCode project [AppInsightDemo](https://github.com/cafemoba/AppInsightDemo))

Essentially there are three ways to log.

### Simple logging

    - (IBAction)buy:(UIButton *)sender
    {
        // perform buy operation
        if ([[[sender titleLabel] text] length]) {
            AI_Log("Buy %@", [[sender titleLabel] text]);
        } else {
            AI_Log("Buy");
        }
    }

### Grouping and Timers

Grouping of log messages can be accomplished by taking advantage of the tagging feature. To time parts of your code, you can use `AI_LogTag(tag, ...)` and `AI_LogTagStopTimer(tag, ...)` pairs.

So for example to log network status change you would do something like:

    - (void)networkStatusChanged:(AFNetworkReachabilityStatus)status
    {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
                AI_LogTag(@"Network", @"WWAN");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                AI_LogTag(@"Network", @"WiFi");
                break;
            default:
                break;
        }
    }

or if you want to time how long it takes to fetch images you could do:

    - (void)loadImageForPhotoURL:(NSURL *)photoURL completionBlock:(FlickrPhotoCompletionBlock) completionBlock
    {
        AI_LogTag(@"Photo Name", [photoURL absoluteString]);
        NSURLRequest *photoRequest = [NSURLRequest requestWithURL:photoURL];
        AFImageRequestOperation *operation = [AFImageRequestOperation
                                              imageRequestOperationWithRequest:photoRequest
                                              imageProcessingBlock:NULL
                                              success:
                                              ^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                  completionBlock(image, nil);
                                                  AI_LogTagStopTimer(@"Photo Name", [photoURL absoluteString]);
                                              }
                                              failure:
                                              ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                  completionBlock(nil, error);
                                                  AI_LogTagStopTimer(@"Photo Name", [photoURL absoluteString]);
                                              }];
        [self enqueueHTTPRequestOperation:operation];
    }

**NOTE:** If two successive `AI_LogTag(tag, ...)` are logged with the same Tag name, then both `AI_LogTag(tag, ...)` and `AI_LogTagStopTimer(tag, ...)` semantics  will be applied, meaning that the second `AI_LogTag(tag, ...)` will be interpreted as the `AI_LogTagStopTimer(tag, ...)` of the previous `AI_LogTag(tag, ...)`,  and a `AI_LogTag(tag, ...)` of a new elapsed time calculation will kickoff.

If `AI_LogTagStopTimer(tag, ...)` is used without a previous `AI_LogTag(tag, ...)` for a given tag then the log request will be ignored.
