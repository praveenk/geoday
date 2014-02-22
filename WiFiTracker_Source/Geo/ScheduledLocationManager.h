//
//  ScheduledLocationManager.h
//  BackgroundTaskExample
//
//  Created by agilepc97 on 12/9/13.
//  Copyright (c) 2013 Agile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "ScheduledLocationManager.h"

@protocol ScheduledLocationManagerDelegate <NSObject>

-(void)popupcalled;

@end


@interface ScheduledLocationManager : NSObject<CLLocationManagerDelegate,UIApplicationDelegate>
{
    BOOL FirstTime;
    id<ScheduledLocationManagerDelegate>delegate;
}

@property(nonatomic,strong)UIApplication *application;
@property(nonatomic,strong)id<ScheduledLocationManagerDelegate>delegate;

-(void)getUserLocationWithInterval:(int ) interval ;

@end