//
//  PVLogger.h
//  PVFoundation
//
//  Created by Akbar Nurlybayev on 2013-05-29.
//  Copyright (c) 2013 Akbar Nurlybayev. All rights reserved.
//

FOUNDATION_EXPORT void PVActivityLog(const char* file, const char* function, NSUInteger line, NSString* type, NSString *tag, BOOL shouldStartTimer, NSString* message, ...);

/**
 After drag and dropping PVLogger.framework to your project add
 
     #import <AppInsight/AppInsight.h>
 
 to your Prefix.pch file.
 
 For simple logging you can use
 
     AI_Log(@"Any NSString")
 
 or
 
     AI_Log([NSString @"Any %@ NSString", @"format"])
 
 If you wish to time parts of the code, you may want to use AI_LogTag and AI_StopTagTimer.
 
     AI_LogTag(@"Bubble sort algorithm", @"custom message")
     for (...) {
         // Do very long sort
     }
     AI_LogTagStopTimer(@"Bubble sort algorithm")
 
 Note:  If two successive AI_LogTag are logged with same tag, then the second AI_LogTag will be interpreted 
 as the AI_LogTagStopTimer of the previous AI_LogTag, and a AI_LogTag of a new elapsed time calculation will kickoff.
 
 Note 2: If AI_LogStopTagTimer is used without preious AI_LogTag for given tag, log request will be ignored.

 */

#define AI_Log(...)   PVActivityLog(__FILE__, __PRETTY_FUNCTION__, __LINE__, @"Info", @"NO TAG", YES, __VA_ARGS__)
#define AI_LogTag(tag, ...) PVActivityLog(__FILE__, __PRETTY_FUNCTION__, __LINE__, @"Info", tag, YES, __VA_ARGS__)
#define AI_LogTagStopTimer(tag) PVActivityLog(__FILE__, __PRETTY_FUNCTION__, __LINE__, @"Info", tag, NO, @"")