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
 
     #import <PVFoundation/PVLogger.h>
 
 to your Prefix.pch file.
 
 For simple logging you can use
 
     PVLogInfo(@"Any NSString")
 
 or
 
     PVLogInfo([NSString @"Any %@ NSString", @"format"])
 
 If you wish to time parts of the code, you may want to use on of TagTimerStart and TagTimerEnd pairs.
 
     PVLogInfoTagTimerStart(@"Tag for sort operation", @"starting sort")
     for (...) {
         // Do very long sort
     }
     PVLogInfoTagTimerEnd(@"Tag for sort operation", @"done sorting")
 
 Note:  If two successive TimerStarts are logged with same Tag name, then both TimerStart and TimerEnd semantics
 will be applied, meaning that the second TimerStart will be interpreted as the TimerEnd of the previous TimerStart,
 and a TimerStart of a new elapsed time calculation will kickoff.
 
 Note 2: If TimerEnd is used without preious TimerStart for given tag, log request will be ignored.
 */

#define AI_Log(...)   PVActivityLog(__FILE__, __PRETTY_FUNCTION__, __LINE__, @"Info", @"NO TAG", YES, __VA_ARGS__)
#define AI_LogTag(tag, ...) PVActivityLog(__FILE__, __PRETTY_FUNCTION__, __LINE__, @"Info", tag, YES, __VA_ARGS__)
#define AI_StopTagTimer(tag) PVActivityLog(__FILE__, __PRETTY_FUNCTION__, __LINE__, @"Info", tag, NO, __VA_ARGS__)