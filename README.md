AppInsight-for-iOS
==================

[Cafe moba for App Insight](http://appinsight.cafemoba.com) is a lightweight logging & tracking library that provides app developers a customizable way to access, analyze, and visualize the ways users interact with their apps

Registration
============

Visit [https://appinsight.cafemoba.com](https://appinsight.cafemoba.com) and register an account. This will give you access to an API Key. You will need this later.

Installation
============

### From CocoaPods

If you don't have CocoaPods installed already (see [http://cocoapods.org/] (http://cocoapods.org/) for how to get started), do

    [sudo] gem install cocoapods
    pod setup

then perform the following steps:

* Add `pod AppInsight` and `pod AFNetworking` to your Podfile. The following is a sample Podfile that you can use:

```
platform :ios, '6.0'
pod 'AFNetworking', '= 1.3.1'
pod 'AppInsight',   '>= 0.0.8'
```

* Add [cafemoba specs repo](https://github.com/cafemoba/Specs.git) by running `pod repo add cafemoba https://github.com/cafemoba/Specs.git` in Terminal
* Do `pod install`
* Add `#import <AppInsight/AppInsight.h>` to your _Prefix.pch_
* Modify the project's Info.plist by adding a new key value pair of 'AppInsight' and the API Key provided upon registration. If you are trying out the AppInsightDemo then just change the value of the 'AppInsight' key.

### Manually

* Drag **AppInsight.framework** to your Frameworks grouping within XCode.
* Add `#import <AppInsight/AppInsight.h>` to your _Prefix.pch_
* Modify the project's Info.plist by adding a new key value pair of 'AppInsight' and the API Key provided upon registration. If you are trying out AppInsightDemo then just change the value of the 'AppInsight' key.

Sample Usage
============

You can see and play with sample log messages we have setup in the AppInsightDemo Xcode project. You'll need to register with [AppInsight](https://appinsight.cafemoba.com) and obtain API Key. After you do, replace the value of **AppInsight** key in _AppInsightDemo-Info.plist_.

You should be able to build and run the demo project in XCode simulator now.


Essentially there are three ways to log.

### Simple logging

For example, to log network status change with [AFNetworking](https://github.com/AFNetworking/AFNetworking) you would do something like:

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

### Grouping and Timers

Grouping of log messages can be accomplished by taking advantage of the tagging feature. To time parts of your code, you should use both `AI_LogTag(tag, ...)` and `AI_LogTagStopTimer(tag, ...)`.

If you want to time how long it takes to fetch images you could do:

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

**NOTE:** If two successive `AI_LogTag(tag, ...)` are logged with the same Tag name, then second call is interpreted as `AI_LogTagStopTimer(tag, ...)` for the first call before it's sent out. The count and elapsed time stats will reflect that appropriately.

**NOTE:** If `AI_LogTagStopTimer(tag, ...)` is used without a previous `AI_LogTag(tag, ...)` for a given tag then the log request will be ignored.
