//
//  AppInsight..h
//  AppInsight
//
//  Created by Akbar Nurlybayev on 2013-05-29.
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

FOUNDATION_EXPORT void PVActivityLog(const char* file, const char* function, NSUInteger line, NSString* type, NSString *tag, BOOL shouldStartTimer, NSString* message, ...);

/**
 After drag and dropping PVLogger.framework to your project add
 
     #import <AppInsight/AppInsight.h>
 
 to your Prefix.pch file.
 
 For simple logging you can use
 
     AI_LogTag(@"Search", @"Search string")
 
 or
 
     AI_LogTag(@"Search", @"%@", @"Search string")
 
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

#define AI_LogTag(tag, ...) PVActivityLog(__FILE__, __PRETTY_FUNCTION__, __LINE__, @"Info", tag, YES, __VA_ARGS__)
#define AI_LogTagStopTimer(tag, ...) PVActivityLog(__FILE__, __PRETTY_FUNCTION__, __LINE__, @"Info", tag, NO, __VA_ARGS__)