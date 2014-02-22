//
//  ScheduledLocationManager.m
//  BackgroundTaskExample
//
//  Created by agilepc97 on 12/9/13.
//  Copyright (c) 2013 Agile. All rights reserved.
//

#import "ScheduledLocationManager.h"



int const kMaxBGTime = 170; //3 min - 10 seconds (as bg task is killed faster)
int const kTimeToGetLocations = 3;

@implementation ScheduledLocationManager{
    UIBackgroundTaskIdentifier bgTask;
    CLLocationManager *locationManager;
    NSTimer *checkLocationTimer;
    int checkLocationInterval;
    NSTimer *waitForLocationUpdatesTimer;
    
    CLLocation *CurrentLocation;
}

@synthesize application;
@synthesize delegate;

- (id)init
{
    self = [super init];
    if (self) {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground1:) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive1:) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    return self;
}

-(void)getUserLocationWithInterval:(int ) interval
{
    checkLocationInterval = (interval > kMaxBGTime)? kMaxBGTime : interval;
    
    FirstTime = NO;

    NSLog(@"checkLocationInterval : %d",checkLocationInterval);
    
    [locationManager startUpdatingLocation];
}

- (void)timerEvent:(NSTimer*)theTimer
{
    [self stopCheckLocationTimer];
    [locationManager startUpdatingLocation];
    
    // in iOS 7 we need to stop background task with delay, otherwise location service won't start
    [self performSelector:@selector(stopBackgroundTask) withObject:nil afterDelay:1];
}

-(void)startCheckLocationTimer
{
    [self stopCheckLocationTimer];
    checkLocationTimer = [NSTimer scheduledTimerWithTimeInterval:checkLocationInterval target:self selector:@selector(timerEvent:) userInfo:NULL repeats:NO];
}

-(void)stopCheckLocationTimer
{
    if(checkLocationTimer){
        [checkLocationTimer invalidate];
        checkLocationTimer=nil;
    }
}

-(void)startBackgroundTask
{
    [self stopBackgroundTask];
    bgTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        //in case bg task is killed faster than expected, try to start Location Service
        [self timerEvent:checkLocationTimer];
    }];
}

-(void)stopBackgroundTask
{
    if(bgTask!=UIBackgroundTaskInvalid){
        [[UIApplication sharedApplication] endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }
}

-(void)stopWaitForLocationUpdatesTimer
{
    if(waitForLocationUpdatesTimer){
        [waitForLocationUpdatesTimer invalidate];
        waitForLocationUpdatesTimer =nil;
    }
}

-(void)startWaitForLocationUpdatesTimer
{
    [self stopWaitForLocationUpdatesTimer];
    waitForLocationUpdatesTimer = [NSTimer scheduledTimerWithTimeInterval:kTimeToGetLocations target:self selector:@selector(waitForLoactions:) userInfo:NULL repeats:NO];
}

- (void)waitForLoactions:(NSTimer*)theTimer
{
    [self stopWaitForLocationUpdatesTimer];
    
    if(([[UIApplication sharedApplication ]applicationState]==UIApplicationStateBackground ||
        [[UIApplication sharedApplication ]applicationState]==UIApplicationStateInactive) &&
       bgTask==UIBackgroundTaskInvalid){
        [self startBackgroundTask];
    }
    
    [self startCheckLocationTimer];
    [locationManager stopUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if(checkLocationTimer){
        //sometimes it happens that location manager does not stop even after stopUpdationLocations
        return;
    }
    
    //TODO: save locations
    CurrentLocation = [locations lastObject];
    
    float gpsSpeed = CurrentLocation.speed;
    
    if(!FirstTime)
    {
        
        
        NSLog(@"Call scheduleNotification..");
        Class cls = NSClassFromString(@"UILocalNotification");
        
        if (cls != nil)
        {
            UILocalNotification *notif = [[cls alloc] init];
            notif.fireDate = [NSDate date];
            
            notif.alertBody = [NSString stringWithFormat:@"Speed is : %f",gpsSpeed];
            notif.alertAction = @"Launch";
            notif.soundName = UILocalNotificationDefaultSoundName;
            
            NSDictionary *userDict = [NSDictionary dictionaryWithObject:@"Syncronizing Data" forKey:@"kRemindMeNotificationDataKey"];
            notif.userInfo = userDict;
            
    //        [[UIApplication sharedApplication] scheduleLocalNotification:notif];
            
            if([delegate respondsToSelector:@selector(popupcalled)])
            {
                NSLog(@"Scheduled Manager : popup");
                [delegate popupcalled];
            }
            
            if(waitForLocationUpdatesTimer==nil){
                [self startWaitForLocationUpdatesTimer];
            }
        }
        
        
        UIApplicationState state = [[UIApplication sharedApplication] applicationState];
        
        if (state == UIApplicationStateActive)
        {
            NSLog(@"Scheduled manager : Active");

            // Nothing to do if applicationState is Inactive, the iOS already displayed an alert view.
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Background task" message:[NSString stringWithFormat:@"Speed is : %f",gpsSpeed] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alertView show];
        }
        //manage BOOL
        FirstTime = YES;
        [self performSelector:@selector(enableBOOL) withObject:nil afterDelay:4.0];
    }
}

-(void)enableBOOL{
    FirstTime = NO;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //TODO: handle error
}

#pragma mark - UIAplicatin notifications

- (void)applicationDidEnterBackground1:(NSNotification *) notification
{
    if([self isLocationServiceAvailable]==YES){
        [self startBackgroundTask];
    }
}

- (void)applicationDidBecomeActive1:(NSNotification *) notification
{
    [self stopBackgroundTask];
    
    if([self isLocationServiceAvailable]==NO){
        //TODO: handle error
    }
}

#pragma mark - Helpers

-(BOOL)isLocationServiceAvailable
{
    if([CLLocationManager locationServicesEnabled]==NO ||
       [CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied ||
       [CLLocationManager authorizationStatus]==kCLAuthorizationStatusRestricted){
        return NO;
    }else{
        return YES;
    }
}

@end
