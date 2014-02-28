//
//  AppDelegate.m
//  Geo
//
//  Created by vishal Khatri on 1/30/14.
//  Copyright (c) 2014 vishal khatri - AgileInfoWays. All rights reserved.
//

#import "AppDelegate.h"
#import "SearchLocationViewController.h"
#import "DisplayTimeViewController.h"

static NSString * const kUUID = @"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0";
static NSString * const kIdentifier = @"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0";

@implementation AppDelegate

@synthesize  dvc;
@synthesize navigationView;
@synthesize skOject;
@synthesize latitude,longitude,lm,radius,dataArray;
@synthesize locationManager;
@synthesize rangedRegions;
@synthesize delegate;
#pragma mark -  didFinishLaunchingWithOptions

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"STAR_TIME_SAVED"];
    // ********************
    self.skOject = [[SKDatabase alloc]initWithFile:@"GEODay.sqlite"];
    [self.skOject setDelegate:self];
    // ********************

    
    // ********************
    // No Need Of this timer, Now app can run in BackGround Also. . . . .
    // [NSTimer timerWithTimeInterval:150.f target:self selector:@selector(CheckTheLatlog:) userInfo:Nil repeats:YES];
    
    // if the UUID is alredy There
    // *************************************************
       isEventRanged=NO;
       isNortificationDisplayed=NO;
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"LOCATION_LAT"])
    {
        [self startTheFetchingBlueToothDevices];
     
    }
    // **************************************************
    
    self.dvc=[[DisplayTimeViewController alloc]initWithNibName:@"DisplayTimeViewController" bundle:Nil];
    
    self.navigationView=[[UINavigationController alloc]initWithRootViewController:self.dvc];
    
    [self.window setRootViewController:self.navigationView];
    
    [self setAppearanceOfNavigationBar:self.navigationView];
    
    // *************************************************
    
    if (![[NSUserDefaults standardUserDefaults]valueForKey:@"VALUE_A"])
    {
        [[NSUserDefaults standardUserDefaults]setObject:@"Near" forKey:@"VALUE_A"];
        
    }
    if (![[NSUserDefaults standardUserDefaults]valueForKey:@"VALUE_B"])
    {
        
        [[NSUserDefaults standardUserDefaults]setObject:@"Unknown" forKey:@"VALUE_B"];
        
    }

    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES      frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
  
    isEventRanged=NO;
    [self.dvc refreshView];
}
- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    BOOL isInBackground = NO;
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground)
    {
        isInBackground = YES;
    }
    if (isInBackground)
    {
        [self saveCurrentTimeWhenUserDisconnectedWithBleutoothDeviceInBackground];
    }
    else
    {
        [self saveCurrentTimeWhenUserDisconnectedWithBleutoothDevice];
    }
   
}
#pragma mark - Set The Navigation Controller.
-(void)setAppearanceOfNavigationBar:(UINavigationController*)navCont
{
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];

    //    [UIBarButtonItem.appearance setBackButtonBackgroundImage:[UIImage imageNamed:@"blankTransparent.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    //    [UIBarButtonItem.appearance setBackButtonTitlePositionAdjustment:UIOffsetMake(-100, -100) forBarMetrics:
    //     UIBarMetricsDefault];
    
    //
    // navCont.navigationItem.hidesBackButton = YES;
    //  navCont.navigationItem.title = @"DiamConnect";
    NSArray *ver = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    
    if ([[ver objectAtIndex:0] intValue] >= 7)
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

        navCont.navigationBar.barStyle=UIBarStyleBlack;
        
        //navCont.navigationBar.barTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navBar.png"]];
        // navCont.navigationBar.barTintColor = [UIColor colorWithRed:110/255.0f green:155.0/255.0f blue:235./255.0f alpha:1.0f];
        navCont.navigationBar.barTintColor = [UIColor colorWithRed:37.0/255.0f green:86.0/255.0f blue:150.0/255.0f alpha:1.0f];
        navCont.navigationBar.translucent = NO;
        NSMutableDictionary *textAttributes = [[NSMutableDictionary alloc] initWithDictionary:navCont.navigationBar.titleTextAttributes];
        [textAttributes setValue:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
        [textAttributes setValue:[UIFont fontWithName:@"OpenSans-Semibold" size:19.0] forKey:UITextAttributeFont];
        [textAttributes setValue:[UIColor whiteColor] forKey:UITextAttributeTextColor];
        
        navCont.navigationBar.titleTextAttributes = textAttributes;
        
        
        [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor,
                                                              //                                                              [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0],UITextAttributeTextShadowColor,
                                                              [NSValue valueWithUIOffset:UIOffsetMake(0, 1)],
                                                              UITextAttributeTextColor,
                                                              [UIFont fontWithName:@"OpenSans-Semibold" size:15.0], UITextAttributeFont, nil] forState:UIControlStateNormal];
    }
    else
    {
        UIImage *navBackgroundImage = [UIImage imageNamed:@"navigationBar.png"];
       // [[UINavigationBar appearance] setBackgroundImage:navBackgroundImage forBarMetrics:UIBarMetricsDefault];
        
        [[UINavigationBar appearance] setBackgroundColor:[UIColor colorWithRed:37.0/255.0f green:86.0/255.0f blue:150.0/255.0f alpha:1.0f]];
        
         
        [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0], UITextAttributeTextColor,
                                                               [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0],UITextAttributeTextShadowColor,
                                                               [NSValue valueWithUIOffset:UIOffsetMake(0, 1)],
                                                               UITextAttributeTextColor,
                                                               [UIFont fontWithName:@"OpenSans-Semibold" size:10.0], UITextAttributeFont, nil]];
        
        [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], UITextAttributeTextColor,
                                                              //                                                              [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0],UITextAttributeTextShadowColor,
                                                              [NSValue valueWithUIOffset:UIOffsetMake(0, 1)],
                                                              UITextAttributeTextColor,
                                                              [UIFont fontWithName:@"OpenSans-Semibold" size:15.0], UITextAttributeFont, nil] forState:UIControlStateNormal];
    }
    
}
#pragma mark - LocationManager

-(void)CheckTheLatlog :(BOOL)isHudNeeded;
{
//    if (isHudNeeded)
//    {
//        [self showProgressHUD];
//    }
//    
//    if (!self.lm)
//    {
//        
//    self.lm = [[CLLocationManager alloc] init];
//    self.lm.delegate = self;
//    self.lm.desiredAccuracy = kCLLocationAccuracyBest;
//    // only update location when user moves specified distance (meters)
//    self.lm.distanceFilter =kCLDistanceFilterNone;
//    
//    }
//    
//    // start monitoring location changes
//    [self.lm startUpdatingLocation];

}

#pragma  mark - Start Searching
-(void)startTheFetchingBlueToothDevices
{
    if (!self.locationManager)
    {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        self.locationManager.delegate = self;
    }
    
    // set the iBeacons Region
    // **********************************************
    // old
    //  NSUUID *uuid=[[NSUUID alloc] initWithUUIDString:kUUID];
    //  CLBeaconRegion *region;
    // region =[[CLBeaconRegion alloc]initWithProximityUUID:uuid identifier:kIdentifier];
    // _______________________________________________________
    
    
    // Populate the regions we will range once.
    // ----------------------------------------------------------------
    self.rangedRegions = [[NSMutableDictionary alloc] init];
   
    NSArray *supportedProximityUUIDs = @[[[NSUUID alloc] initWithUUIDString:@"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"],[[NSUUID alloc] initWithUUIDString:@"5A4BCFCE-174E-4BAC-A814-092E77F6B7E5"],[[NSUUID alloc] initWithUUIDString:@"74278BDA-B644-4520-8F0C-720EAF059935"]];
    
    // ----------------------------------------------------------------
    for (NSUUID *uuid in supportedProximityUUIDs)
    {
        CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:[uuid UUIDString]];
        
        region.notifyOnEntry = YES;
        region.notifyOnExit = YES;
        region.notifyEntryStateOnDisplay = YES;
        
        self.rangedRegions[region] = [NSArray array];
    }
    // ----------------------------------------------------------------
    NSLog(@"self.rangedRegions :: %@",self.rangedRegions);
    
    
    // Start Searching iBeacon Devices
    // -----------------------------------------------
    for (CLBeaconRegion *region in self.rangedRegions)
    {
        [self.locationManager startRangingBeaconsInRegion:region];
        
        //[self.locationManager startMonitoringForRegion:region desiredAccuracy:1000];
        
        [self.locationManager startMonitoringForRegion:region];
    }
    // -----------------------------------------------
 
    
// OLD
//    [self.locationManager startRangingBeaconsInRegion:region];
//    [self.locationManager startMonitoringForRegion:region];
    
    //[_locationManager stopRangingBeaconsInRegion:region];
    // **********************************************
}
#pragma mark - CLLocationManager + CLBeaconRegion Delegate

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    if(state == CLRegionStateInside)
    {
        NSLog(@"locationManager didDetermineState INSIDE for %@", region.identifier);
        
    }
    else if(state == CLRegionStateOutside)
    {
        NSLog(@"locationManager didDetermineState OUTSIDE for %@", region.identifier);
    }
    else
    {
        NSLog(@"locationManager didDetermineState OTHER for %@", region.identifier);
    }
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    // *******************************************************************
    NSLog(@"Beacons Count ======>> %d",beacons.count);
    // first check the , is there any beacons found or not
    // *****************************************************
    if (beacons.count == 0 ) //|| isEventRanged
    { // breakpoint set here for testing
        return;
    }
   
  
    // ***************************************************************
    // now add the Beacons in the Key value pair, in found any beacons
    // ***************************************************************
    self.rangedRegions[region] = beacons;
    // now we have added the result in AllBeacons
 
    NSMutableArray *allBeacons = [NSMutableArray array];
    
    for (NSArray *regionResult in [self.rangedRegions allValues])
    {
        [allBeacons addObjectsFromArray:regionResult];
    }
    
    // Now get the Enable UUID from device, check "Is it Same..?" if Same than StartTime
    // *******************************************************************
    BOOL isDeviceUUIDSameAsTrackingUUID = NO;
    // *******************************************************************
    
    NSString *strTrackUUID=[self GetEnableUUIDFromDataBase];
    
    if (!strTrackUUID)
        return;
    
    
    for (CLBeaconRegion *region in beacons)
    {
            NSString *strUUID= [region.proximityUUID UUIDString];
        
            NSLog(@"MY database Device   :: %@",strTrackUUID);
            NSLog(@"Find nearest proximityUUID  :: %@",strUUID);

            NSLog(@"region  ----> %@", region );
        
        if ([strUUID isEqualToString:strTrackUUID])
        {
            isDeviceUUIDSameAsTrackingUUID = YES;

            CLBeacon *CurretConnect= (CLBeacon *)region;
           
            
            intValueForImmeadiateNearFarUnknown=CurretConnect.proximity;
             NSLog(@"intValueForImmeadiateNearFarUnknown  ----> %d", intValueForImmeadiateNearFarUnknown);
           
            [[NSUserDefaults standardUserDefaults]setObject:strTrackUUID forKey:@"CURRENT_UUID_TRACK"];
            
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            
            // **************************************************
            NSString *strAccuracy=[NSString stringWithFormat:@"%.2fm",CurretConnect.accuracy];
            
            NSString *proximity;
            
            switch (CurretConnect.proximity)
            {
                case CLProximityNear:
                    proximity = @"Near";
                    break;
                case CLProximityImmediate:
                    proximity = @"Immediate";
                    break;
                case CLProximityFar:
                    proximity = @"Far";
                    break;
                case CLProximityUnknown:
                default:
                    proximity = @"Unknown";
                    break;
            }
           
            NSArray *arrDetials=[[NSArray alloc]initWithObjects:[CurretConnect.proximityUUID UUIDString],[CurretConnect.major stringValue],[CurretConnect.minor stringValue],proximity,strAccuracy, nil];
            

            // **************************************************
            
            if([delegate respondsToSelector:@selector(getiBeaconDeviceDetails:)])
            {
                [delegate getiBeaconDeviceDetails:arrDetials];
            }

            
            break;
        }
    }
    // *****************************************************
    
//    NSLog(@"locationManager didRangeBeacons");
//    NSLog(@"lastObject :: %@",[beacons lastObject]);

    
    if (!isDeviceUUIDSameAsTrackingUUID)
        return;
    
    
    BOOL isInBackground = NO;
    
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground)
    {
        isInBackground = YES;
    }
   
    
    if (isInBackground && !isNortificationDisplayed)
    {
        
        // this is set in the EnterBackground/Foreground delegate calls
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.alertBody = [NSString stringWithFormat:@"%@ Device in Connected!",[[NSUserDefaults standardUserDefaults]objectForKey:@"PLACE_NAME"]];
        notification.soundName = UILocalNotificationDefaultSoundName;
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    }
    
    isNortificationDisplayed=YES;
    
    
    if (intValueForImmeadiateNearFarUnknown==3)
    {
        NSString *strState = [[NSUserDefaults standardUserDefaults]valueForKey:@"VALUE_B"];
        
        if ([strState isEqualToString:@"Far"])
        {
            
            NSLog(@" Far Far Far Far Far Far Far Far");
            
            if ([[NSUserDefaults standardUserDefaults]boolForKey:@"START_TIME_SAVED"])
            {
                isEventRanged=NO;
                
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"IS_EXIT"];
                [[NSUserDefaults standardUserDefaults]synchronize];
            }
        }
        
        return;
        
        
    }
    
    if (intValueForImmeadiateNearFarUnknown==0)
    {
        
        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"START_TIME_SAVED"])
        {
            isEventRanged=NO;
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"IS_EXIT"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        
        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"STOP_TRACKING_TIME"])
        {
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"STOP_TRACKING_TIME"];
        }
        
       // isEventRanged=NO;
        
        return;        
    }

    
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"STOP_TRACKING_TIME"])
    {
        return;
    }

    if (isEventRanged)
    {
        return;
        
    }
    
    
    
    
    if (isInBackground)
    {
        //[self checkingUserLocationWithPlaceInBackgound:location];
        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"IS_EXIT"])
        {
            [self saveCurrentTimeWhenUserDisconnectedWithBleutoothDeviceInBackground];
            isEventRanged=NO;
           // [self stopRangingDevices];
           // [self performSelector:@selector(startTheFetchingBlueToothDevices) withObject:nil afterDelay:30.f];
            
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"STOP_TRACKING_TIME"];
            
        }
        else
        {
            [self saveCurrentTimeWhenUserConnectedWithBleutoothDeviceInBackground];
            isEventRanged=YES;
        }
    }
    else
    {
        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"IS_EXIT"])
        {
            [self saveCurrentTimeWhenUserDisconnectedWithBleutoothDevice];
            isEventRanged=NO;
            //[self stopRangingDevices];
           // [self performSelector:@selector(startTheFetchingBlueToothDevices) withObject:nil afterDelay:30.f];
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"STOP_TRACKING_TIME"];
        }
        else
        {
            [self saveCurrentTimeWhenUserConnectedWithBleutoothDevice];
            isEventRanged=YES;
        }
    }
    
    
    // *****************************************************
}

- (void)locationManager:(CLLocationManager *)manager
          didExitRegion:(CLRegion *)region
{
    NSLog(@"@@@@@ locationManager didRangeBeacons @@@@@");
    
    NSLog(@"@@@@@ lastObject UUID :: %@ @@@@@",region.identifier);
    
    
   // NSString *strTrackUUID=[self GetEnableUUIDFromDataBase];
    
    NSString *strTrackUUID=[[NSUserDefaults standardUserDefaults]objectForKey:@"CURRENT_UUID_TRACK"];
    
    if (!strTrackUUID)
    {
        return;
        
    }
    
    if ([strTrackUUID isEqualToString:region.identifier])
    {

    BOOL isInBackground = NO;
    
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground)
    {
        isInBackground = YES;
    }

    if (isNortificationDisplayed && isInBackground)
    {
        isNortificationDisplayed=NO;
        
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.alertBody = [NSString stringWithFormat:@"%@ Device no longer connected OR not in range!",[[NSUserDefaults standardUserDefaults]objectForKey:@"PLACE_NAME"]];
        notification.soundName = UILocalNotificationDefaultSoundName;
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    }
    
  
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"START_TIME_SAVED"])
    {
        isEventRanged=NO;
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"IS_EXIT"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
        
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"STOP_TRACKING_TIME"])
    {
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"STOP_TRACKING_TIME"];
    }
    
    if([delegate respondsToSelector:@selector(getiBeaconDeviceDetails:)])
    {
            [delegate getiBeaconDeviceDetails:@[region.identifier]];
    }
        
        
        
        
    }
    
   /*
     if (isInBackground)
     {
    //         [self saveCurrentTimeWhenUserDisconnectedWithBleutoothDeviceInBackground];
         if ([[NSUserDefaults standardUserDefaults]boolForKey:@"START_TIME_SAVED"])
         {
         [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"IS_EXIT"];
         [[NSUserDefaults standardUserDefaults]synchronize];
         }
     }
     else
     {
         
    //       [self saveCurrentTimeWhenUserDisconnectedWithBleutoothDevice];
         if ([[NSUserDefaults standardUserDefaults]boolForKey:@"START_TIME_SAVED"])
         {
         [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"IS_EXIT"];
         [[NSUserDefaults standardUserDefaults]synchronize];
         }
    }
    */
        
    
}

- (void)locationManager:(CLLocationManager *)manager
         didEnterRegion:(CLRegion *)region
{
//    NSLog(@"======== locationManager didRangeBeacons =========");
//    
//    NSLog(@"========= lastObject :: %@  =========",region);
}
// *******************************************************************

#pragma mark - SaveThe Values in The DataBase
-(void)saveCurrentTimeWhenUserConnectedWithBleutoothDevice
{
    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"START_TIME_SAVED"])
    {
        // -----------------------------
        NSDateFormatter *f2 = [[NSDateFormatter alloc] init];
        [f2 setDateFormat:@"dd-MM-YYYY"];
        NSString *CurrentTime = [f2 stringFromDate:[NSDate date]];
        // -----------------------------
        
        // -----------------------------
        double valTime=[[NSDate date] timeIntervalSince1970];
        NSString *time= [NSString stringWithFormat:@"%f",valTime];
        NSLog(@"time :: %@",time);
        // ------------------------------
        
        int loationid = [[NSUserDefaults standardUserDefaults] integerForKey:@"LOCATION_ID"];
        
        NSString *strQ=[NSString stringWithFormat:@"INSERT INTO sessions (starttime, endtime, locationId,startdate) VALUES('%@', '',%d,'%@')",time,loationid,CurrentTime];
        
        [self.skOject lookupAllForSQL:strQ];
        
        int sessionId = [[self.skOject lookupColForSQL:@"select max(sessionid) from sessions"] integerValue];
        
        [[NSUserDefaults standardUserDefaults]setInteger:sessionId forKey:@"CURRENT_SESSION_ID"];
        
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"START_TIME_SAVED"];
        
        
        [self.dvc refreshView];
    
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
}
-(void)saveCurrentTimeWhenUserDisconnectedWithBleutoothDevice
{
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"START_TIME_SAVED"])
    {
        // Current Time
        // -----------------------------
        double valTime=[[NSDate date] timeIntervalSince1970];
        NSString *time= [NSString stringWithFormat:@"%f",valTime];
        NSLog(@"time :: %@",time);
        // ------------------------------
        
        // *******************************
        int sessioId=[[NSUserDefaults standardUserDefaults]integerForKey:@"CURRENT_SESSION_ID"];
        // *******************************
        
        NSString *strQuery=[NSString stringWithFormat:@"Update sessions set endtime='%@' where sessionid=%d",time,sessioId];
        
        [self.skOject lookupAllForSQL:strQuery];
        
        // **************************
        
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"START_TIME_SAVED"];
        
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"IS_EXIT"];
        
        [self.dvc refreshView];
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);

    }

}
#pragma mark - Save Data In Background
-(void)saveCurrentTimeWhenUserConnectedWithBleutoothDeviceInBackground
{
    bgTask = [[UIApplication sharedApplication]
              beginBackgroundTaskWithExpirationHandler:
              ^{
                  [[UIApplication sharedApplication] endBackgroundTask:bgTask];
                  
              }];
    // **************************************
    
    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"START_TIME_SAVED"])
    {
        // -----------------------------
        NSDateFormatter *f2 = [[NSDateFormatter alloc] init];
        [f2 setDateFormat:@"dd-MM-YYYY"];
        NSString *CurrentTime = [f2 stringFromDate:[NSDate date]];
        // -----------------------------
        
        // -----------------------------
        double valTime=[[NSDate date] timeIntervalSince1970];
        NSString *time= [NSString stringWithFormat:@"%f",valTime];
        NSLog(@"time :: %@",time);
        // ------------------------------
        
        int loationid = [[NSUserDefaults standardUserDefaults] integerForKey:@"LOCATION_ID"];
        
        NSString *strQ=[NSString stringWithFormat:@"INSERT INTO sessions (starttime, endtime, locationId,startdate) VALUES('%@', '',%d,'%@')",time,loationid,CurrentTime];
        
        [self.skOject lookupAllForSQL:strQ];
        
        int sessionId = [[self.skOject lookupColForSQL:@"select max(sessionid) from sessions"] integerValue];
        
        [[NSUserDefaults standardUserDefaults]setInteger:sessionId forKey:@"CURRENT_SESSION_ID"];
        
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"START_TIME_SAVED"];
      
        
        [[NSUserDefaults standardUserDefaults]synchronize];
        [self.dvc refreshView];
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
    
    // ****************************************
    if (bgTask != UIBackgroundTaskInvalid)
    {
        [[UIApplication sharedApplication] endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }
}
-(void)saveCurrentTimeWhenUserDisconnectedWithBleutoothDeviceInBackground
{
    bgTask = [[UIApplication sharedApplication]
              beginBackgroundTaskWithExpirationHandler:
              ^{
                  [[UIApplication sharedApplication] endBackgroundTask:bgTask];
                  
              }];
    // **************************************
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"START_TIME_SAVED"])
    {
        // Current Time
        // -----------------------------
        double valTime=[[NSDate date] timeIntervalSince1970];
        NSString *time= [NSString stringWithFormat:@"%f",valTime];
        NSLog(@"time :: %@",time);
        // ------------------------------
        
        // *******************************
        int sessioId=[[NSUserDefaults standardUserDefaults]integerForKey:@"CURRENT_SESSION_ID"];
        // *******************************
        
        NSString *strQuery=[NSString stringWithFormat:@"Update sessions set endtime='%@' where sessionid=%d",time,sessioId];
        
        [self.skOject lookupAllForSQL:strQuery];
        
        // **************************
        
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"START_TIME_SAVED"];
        
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"IS_EXIT"];
        
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        [self.dvc refreshView];
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
    }
    // ****************************************
    if (bgTask != UIBackgroundTaskInvalid)
    {
        
        [[UIApplication sharedApplication] endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
        
    }
}
-(void)showProgressHUD
{
    HUD = [[MBProgressHUD alloc] initWithWindow:self.window];
	
	[self.window addSubview:HUD];
	
    HUD.dimBackground=YES;
    
	// Set determinate bar mode
	HUD.mode = MBProgressHUDModeIndeterminate;
	
	HUD.delegate = self;
	
	[HUD show:YES];
    
	HUD.labelText=@"Loading...";
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(NSString *)GetEnableUUIDFromDataBase
{
    NSString *strQueryForEnableLoc=[NSString stringWithFormat:@"SELECT * FROM locationInfo where locationEnable = '1'"];
    
    NSArray *arrCheck= [self.skOject lookupAllForSQL:strQueryForEnableLoc];
    
    if (arrCheck.count!=0)
    {
        
        return [[arrCheck objectAtIndex:0]valueForKey:@"deviceId"];
        
    }
    
    return nil;
}
-(void)stopRangingDevices
{
    // Stop ranging when the view goes away.
    // -----------------------------------------------------
    for (CLBeaconRegion *region in self.rangedRegions)
    {
        [self.locationManager stopMonitoringForRegion:region];
        [self.locationManager stopRangingBeaconsInRegion:region];
    }
    
    self.locationManager=nil;
    
    // -----------------------------------------------------
}




@end
