/*
 DSLCalendarRange.m
 
 Copyright (c) 2012 Dative Studios. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 * Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 
 * Neither the name of the author nor the names of its contributors may be used
 to endorse or promote products derived from this software without specific
 prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */


#import "DSLCalendarRange.h"


@interface DSLCalendarRange ()

@end


@implementation DSLCalendarRange {
    __strong NSDate *_startDate;
    __strong NSDate *_endDate;
    
}
@synthesize strStart,strEnd;

#pragma mark - Memory management



#pragma mark - Initialisation

// Designated initialiser
- (id)initWithStartDay:(NSDateComponents *)start endDay:(NSDateComponents *)end {
    NSParameterAssert(start);
    NSParameterAssert(end);
    NSLog(@"%@",[self convertTimeToFormate:[start date]]);
    NSLog(@"%@",[end date]);
    
    

    self = [super init];
    if (self != nil) {
        // Initialise properties
        _startDay = [start copy];
        _startDate = [start date];
        strStart=[self convertTimeToFormate:[start date]];
        strEnd=[self convertTimeToFormate:[end date]];
        _endDay = [end copy];
        _endDate = [end date];
    }

    return self;
}

-(NSString *)convertTimeToFormate:(NSDate *)strDate
{
   
    /*
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *gmtDateString = [dateFormatter stringFromDate:strDate];
    
    // CONVERT TIME TO SERVER TIME
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //Create a date string in the local timezone
    NSDate *date = [df dateFromString:gmtDateString];
    //Create the date assuming the given string is in GMT (SERVER TIME HERE)
    [df setDateFormat:@"EEE, MMM dd, yyyy"];
    NSString *serverDateString = [df stringFromDate:date];
    
    */
    NSString *strTimeStanp=[NSString stringWithFormat:@"%f",[strDate timeIntervalSince1970]];
    
    
    
    return strTimeStanp;
    
}

#pragma mark - Properties

- (void)setStartDay:(NSDateComponents *)startDay {
    NSParameterAssert(startDay);
    _startDay = [startDay copy];
}

- (void)setEndDay:(NSDateComponents *)endDay {
    NSParameterAssert(endDay);
    _endDay = [endDay copy];
}


#pragma mark

- (BOOL)containsDay:(NSDateComponents*)day {
    return [self containsDate:day.date];
}

- (BOOL)containsDate:(NSDate*)date {
    if ([_startDate compare:date] == NSOrderedDescending) {
        return NO;
    }
    else if ([_endDate compare:date] == NSOrderedAscending) {
        return NO;
    }
    
    return YES;
}

@end
