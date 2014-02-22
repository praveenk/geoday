//
//  AppDelegate.m
//  Geo
//
//  Created by vishal Khatri on 1/30/14.
//  Copyright (c) 2014 vishal khatri - AgileInfoWays. All rights reserved.
//

#import "AppDelegate.h"


@implementation AppDelegate

@synthesize  dvc;
@synthesize navigationView;
@synthesize skOject;
@synthesize latitude,longitude,lm,radius,dataArray;
@synthesize  sch;
@synthesize backgroundTimer;

#pragma  - did

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
//    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"START_TIME_SAVED"];
    // ********************
    @try
    {
        self.skOject = [[SKDatabase alloc]initWithFile:@"GEODay.sqlite"];
        [self.skOject setDelegate:self];
        
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception in creating DB == %@",[exception userInfo]);
    }
    // ********************
    
    

    // Implementiong the reachability class
    Reachability* reachability = [Reachability reachabilityWithHostname:@"www.apple.com"];
    
    NetworkStatus remote = [reachability currentReachabilityStatus];
    
    if(remote == NotReachable)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"GeoDay!" message:@"Internet Connection not available currently. Please check your internet connectivity and try again after sometime." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        [self fetchSSIDInfo:NO];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object: nil];
    remoteHost = [Reachability reachabilityWithHostname:@"www.google.com"];
    [remoteHost startNotifier];

    
    // ***********************************************
    // start updating backgound
    self.sch  = [[ScheduledLocationManager alloc] init];
    self.sch.delegate = self;
    [self.sch getUserLocationWithInterval:160];
    
    // *************************************************

    self.dvc=[[DisplayTimeViewController alloc]initWithNibName:@"DisplayTimeViewController" bundle:Nil];
    self.navigationView=[[UINavigationController alloc]initWithRootViewController:self.dvc];
    
    [self.window setRootViewController:self.navigationView];
    
    [self setAppearanceOfNavigationBar:self.navigationView];
    
    // *************************************************
    
    
    
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

    self.backgroundTimer = [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(backgroundTimerCalled:) userInfo:nil repeats:YES];
    [self.lm startUpdatingLocation];
//    [self.lm startMonitoringSignificantLocationChanges];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [self.backgroundTimer invalidate];
    [self.lm stopUpdatingLocation];
        [self.dvc refreshView];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

    
    //    [self.lm  stopMonitoringSignificantLocationChanges];


    
   
//    [self.lm  startUpdatingLocation];
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    /*
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"START_TIME_SAVED"])
    {
        
        // -----------------------------
        NSDateFormatter *f2 = [[NSDateFormatter alloc] init];
        [f2 setDateFormat:@"HH:mm"];
        NSString *CurrentTime = [f2 stringFromDate:[NSDate date]];
        // -----------------------------
        NSDateFormatter *df = [[NSDateFormatter alloc] init] ;
        [df setDateFormat:@"HH:mm"];
        NSDate *dateWithTime = [df dateFromString:CurrentTime];
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
        
        [self.dvc refreshView];
        
        [self.lm stopUpdatingLocation];
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
     */
}

#pragma mark - SSID methods

- (void)fetchSSIDInfo:(BOOL)endSession
{
    NSArray *ifs = (__bridge id)CNCopySupportedInterfaces();
    //NSLog(@"%s: Supported interfaces: %@", __func__, ifs);
    id info = nil;
    
    NSString *strWiFiName = [info valueForKey:(NSString *)kCNNetworkInfoKeySSID];
    
    for (NSString *ifnam in ifs) {
        info = (__bridge id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
//        NSLog(@"%s: %@ => %@", __func__, ifnam, info);
//        NSLog(@"network == %@",ifnam);
//        NSLog(@"network == %@",info);
        strWiFiName = [info valueForKey:(NSString *)kCNNetworkInfoKeySSID];
   //     NSLog(@"name == %@",[info valueForKey:(NSString *)kCNNetworkInfoKeySSID]);
        if (info && [info count]) {
            break;
        }
    }
    
    [[NSUserDefaults standardUserDefaults]setValue:strWiFiName forKey:@"WIFI_NAME"];
    NSLog(@"currentWifi Name :: %@",strWiFiName);
    
    BOOL isInBackground = NO;
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground)
    {
        isInBackground = YES;
    }
    if (isInBackground)
    {
        [self performSelector:@selector(checkWifiNameIsEqualOrNotInBackgound) onThread:[NSThread currentThread] withObject:nil waitUntilDone:YES];

//        [self checkWifiNameIsEqualOrNotInBackgound];
    }
    else
    {
        [self performSelector:@selector(checkWifiNameIsEqualOrNot:) onThread:[NSThread currentThread] withObject:nil waitUntilDone:YES];
//        [self checkWifiNameIsEqualOrNot:YES];
    }
}

-(void)fetchSSIDInfoInBackground
{
    
    bgTask = [[UIApplication sharedApplication]
              beginBackgroundTaskWithExpirationHandler:
              ^{
                  [[UIApplication sharedApplication] endBackgroundTask:bgTask];
                  
              }];
    // **************************************

    NSArray *ifs = (__bridge id)CNCopySupportedInterfaces();
    //NSLog(@"%s: Supported interfaces: %@", __func__, ifs);
    id info = nil;
    
    NSString *strWiFiName = [info valueForKey:(NSString *)kCNNetworkInfoKeySSID];
    
    for (NSString *ifnam in ifs) {
        info = (__bridge id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        //        NSLog(@"%s: %@ => %@", __func__, ifnam, info);
        //        NSLog(@"network == %@",ifnam);
        //        NSLog(@"network == %@",info);
        strWiFiName = [info valueForKey:(NSString *)kCNNetworkInfoKeySSID];
        //     NSLog(@"name == %@",[info valueForKey:(NSString *)kCNNetworkInfoKeySSID]);
        if (info && [info count]) {
            break;
        }
    }
    
    [[NSUserDefaults standardUserDefaults]setValue:strWiFiName forKey:@"WIFI_NAME"];
    NSLog(@"currentWifi Name :: %@",strWiFiName);
    
    BOOL isInBackground = NO;
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground)
    {
        isInBackground = YES;
    }
    if (isInBackground)
    {
        [self checkWifiNameIsEqualOrNotInBackgound];
    }
    else
    {
        [self checkWifiNameIsEqualOrNot:YES];
    }

    if (bgTask != UIBackgroundTaskInvalid)
    {
        [[UIApplication sharedApplication] endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }
}

-(void)checkWifiNameIsEqualOrNot:(BOOL)endSession
{
    
    
    NSString *strWiFiName = [[NSUserDefaults standardUserDefaults]stringForKey:@"WIFI_NAME"];
    BOOL isWifINameSame = NO;
    int locationId = 0;
    
    NSString *strWiFiNamesQuery = [NSString stringWithFormat:@"select * from locationInfo"];
    
    NSArray *wiFiNames = [self.skOject lookupAllForSQL:strWiFiNamesQuery];
    
    for(int i=0;i<wiFiNames.count;i++)
    {
        BOOL isEnableLoc=[[[wiFiNames objectAtIndex:i]valueForKey:@"locationEnable"]boolValue];
        
        if (!isEnableLoc)
        {
            continue;
        }

        if([[[wiFiNames objectAtIndex:i] valueForKey:@"locationName"]isEqualToString:strWiFiName])
        {
            isWifINameSame = YES;
            locationId = [[[wiFiNames objectAtIndex:i]valueForKey:@"locationId"]integerValue];
            break;
        }
    }
    
    
    
    ///////////////////////////////////
    if(isWifINameSame)
    {
        if(![[NSUserDefaults standardUserDefaults]boolForKey:@"START_TIME_SAVED"])
        {
            NSDateFormatter *f2 = [[NSDateFormatter alloc] init];
            [f2 setDateFormat:@"dd-MM-YYYY"];
            NSString *CurrentTime = [f2 stringFromDate:[NSDate date]];
            // -----------------------------
//            NSDateFormatter *df = [[NSDateFormatter alloc] init] ;
//            [df setDateFormat:@"HH:mm"];
//            NSDate *dateWithTime = [df dateFromString:CurrentTime];
            // -----------------------------
            double valTime=[[NSDate date] timeIntervalSince1970];
            NSString *time= [NSString stringWithFormat:@"%f",valTime];
            NSLog(@"time :: %@",time);
            // ------------------------------
            
//            NSString *strQ=[NSString stringWithFormat:@"INSERT INTO locationInfo (locationName, lat, long, locationEnable) VALUES('%@', '%@','%@','%@')",strWiFiName,strLat,strLon,strIsEnable];
//            
//            [self.skOject lookupAllForSQL:strQ];
//            
//            int loacationId = [[self.skOject lookupColForSQL:@"select max(locationId) from locationInfo"] integerValue];
            
            
            
            NSString *strQuerySessions=[NSString stringWithFormat:@"INSERT INTO sessions (starttime, endtime, locationId,startdate) VALUES('%@', '',%d,'%@')",time,locationId,CurrentTime];
            
            [self.skOject lookupAllForSQL:strQuerySessions];
            
            int sessionId = [[self.skOject lookupColForSQL:@"select max(sessionid) from sessions"] integerValue];
            
            [[NSUserDefaults standardUserDefaults]setInteger:sessionId forKey:@"CURRENT_SESSION_ID"];
            
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"START_TIME_SAVED"];
            
            //  *********************************************
            // save the current wifi name in ndsuserDefault
            
            [[NSUserDefaults standardUserDefaults]setObject:strWiFiName forKey:@"MY_CURRENT_SESSION_WIFI"];

            [self.dvc refreshView];
            
            [self.lm stopUpdatingLocation];
            
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);

        }
        else if (![strWiFiName isEqualToString:[[NSUserDefaults standardUserDefaults]valueForKey:@"MY_CURRENT_SESSION_WIFI"]])
        {
            
            
            //            NSDateFormatter *f2 = [[NSDateFormatter alloc] init];
            //            [f2 setDateFormat:@"HH:mm"];
            //            NSString *CurrentTime = [f2 stringFromDate:[NSDate date]];
            // -----------------------------
            // -----------------------------
            double valTime=[[NSDate date] timeIntervalSince1970];
            NSString *time= [NSString stringWithFormat:@"%f",valTime];
            // ------------------------------
            
            // *******************************
            int sessioId=[[NSUserDefaults standardUserDefaults]integerForKey:@"CURRENT_SESSION_ID"];
            // *******************************
            
            NSString *strQuery=[NSString stringWithFormat:@"Update sessions set endtime='%@' where sessionid=%d",time,sessioId];
            
            [self.skOject lookupAllForSQL:strQuery];
            
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"START_TIME_SAVED"];
            
            
            [self checkWifiNameIsEqualOrNot:NO];
            
            
        }

    }
    else
    {
        if([[NSUserDefaults standardUserDefaults]boolForKey:@"START_TIME_SAVED"])
        {
//            NSDateFormatter *f2 = [[NSDateFormatter alloc] init];
//            [f2 setDateFormat:@"HH:mm"];
//            NSString *CurrentTime = [f2 stringFromDate:[NSDate date]];
            // -----------------------------
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
            
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"START_TIME_SAVED"];
        }
    }
}


-(void)checkWifiNameIsEqualOrNotInBackgound
{
    
    NSLog(@"checkWifiNameIsEqualOrNotInBackgound");
    
    bgTask = [[UIApplication sharedApplication]
              beginBackgroundTaskWithExpirationHandler:
              ^{
                  [[UIApplication sharedApplication] endBackgroundTask:bgTask];
                  
              }];
    // **************************************
    
    
    NSString *strWiFiName = [[NSUserDefaults standardUserDefaults]stringForKey:@"WIFI_NAME"];
    NSLog(@"strWiFiName %@",strWiFiName);
    BOOL isWifINameSame = NO;
    int locationId = 0;
    
    NSString *strWiFiNamesQuery = [NSString stringWithFormat:@"select * from locationInfo"];
    
    NSArray *wiFiNames = [self.skOject lookupAllForSQL:strWiFiNamesQuery];
    NSLog(@"All WiFiNames %@",wiFiNames);
    
    for(int i=0;i<wiFiNames.count;i++)
    {
        NSLog(@"In For loop");
        BOOL isEnableLoc=[[[wiFiNames objectAtIndex:i]valueForKey:@"locationEnable"]boolValue];
        
        if (!isEnableLoc)
        {
            continue;
        }
        if([[[wiFiNames objectAtIndex:i] valueForKey:@"locationName"]isEqualToString:strWiFiName])
        {
            NSLog(@"DB wi-fi name : %@",[[wiFiNames objectAtIndex:i] valueForKey:@"locationName"]);
            NSLog(@"isWiFiNameSame : YES");
            isWifINameSame = YES;
            locationId = [[[wiFiNames objectAtIndex:i]valueForKey:@"locationId"]integerValue];
            break;
        }
    }
    
    
    
    ///////////////////////////////////
    if(isWifINameSame)
    {
        NSLog(@"Inside isWiFiNameSame : YES");
        if(![[NSUserDefaults standardUserDefaults]boolForKey:@"START_TIME_SAVED"])
        {
            NSLog(@"No value : START_TIME_SAVED");
            NSDateFormatter *f2 = [[NSDateFormatter alloc] init];
            [f2 setDateFormat:@"dd-MM-YYYY"];
            NSString *CurrentTime = [f2 stringFromDate:[NSDate date]];
            double valTime=[[NSDate date] timeIntervalSince1970];
            NSString *time= [NSString stringWithFormat:@"%f",valTime];
            NSLog(@"time :: %@",time);
            // ------------------------------
            
            //            NSString *strQ=[NSString stringWithFormat:@"INSERT INTO locationInfo (locationName, lat, long, locationEnable) VALUES('%@', '%@','%@','%@')",strWiFiName,strLat,strLon,strIsEnable];
            //
            //            [self.skOject lookupAllForSQL:strQ];
            //
            //            int loacationId = [[self.skOject lookupColForSQL:@"select max(locationId) from locationInfo"] integerValue];
            
            
            
            NSString *strQuerySessions=[NSString stringWithFormat:@"INSERT INTO sessions (starttime, endtime, locationId,startdate) VALUES('%@', '',%d,'%@')",time,locationId,CurrentTime];
            
            [self.skOject lookupAllForSQL:strQuerySessions];
            
            int sessionId = [[self.skOject lookupColForSQL:@"select max(sessionid) from sessions"] integerValue];
            
            [[NSUserDefaults standardUserDefaults]setInteger:sessionId forKey:@"CURRENT_SESSION_ID"];
            
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"START_TIME_SAVED"];
            
            //  *********************************************
            // save the current wifi name in ndsuserDefault
            
            [[NSUserDefaults standardUserDefaults]setObject:strWiFiName forKey:@"MY_CURRENT_SESSION_WIFI"];
            
            // *********************************************
            
            
            [self.dvc refreshView];
            
            [self.lm stopUpdatingLocation];
            
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            
        }
        else if (![strWiFiName isEqualToString:[[NSUserDefaults standardUserDefaults]valueForKey:@"MY_CURRENT_SESSION_WIFI"]])
        {
            NSLog(@"MY_CURRENT_SESSION");
        
          
                //            NSDateFormatter *f2 = [[NSDateFormatter alloc] init];
                //            [f2 setDateFormat:@"HH:mm"];
                //            NSString *CurrentTime = [f2 stringFromDate:[NSDate date]];
                // -----------------------------
                // -----------------------------
                double valTime=[[NSDate date] timeIntervalSince1970];
                NSString *time= [NSString stringWithFormat:@"%f",valTime];
                // ------------------------------
                
                // *******************************
                int sessioId=[[NSUserDefaults standardUserDefaults]integerForKey:@"CURRENT_SESSION_ID"];
                // *******************************
                
                NSString *strQuery=[NSString stringWithFormat:@"Update sessions set endtime='%@' where sessionid=%d",time,sessioId];
                
                [self.skOject lookupAllForSQL:strQuery];
                
                [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"START_TIME_SAVED"];
            
            
                [self performSelector:@selector(checkWifiNameIsEqualOrNotInBackgound) withObject:nil afterDelay:2.0f];
            
        
        }
  
    }
    else
    {
        NSLog(@"Inside isWiFiNameSame : NO");

        if([[NSUserDefaults standardUserDefaults]boolForKey:@"START_TIME_SAVED"])
        {
            NSLog(@"START_TIME_SAVED");
            //            NSDateFormatter *f2 = [[NSDateFormatter alloc] init];
            //            [f2 setDateFormat:@"HH:mm"];
            //            NSString *CurrentTime = [f2 stringFromDate:[NSDate date]];
            // -----------------------------
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
            
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"START_TIME_SAVED"];
        }
    }
    
    
    // ****************************************
    if (bgTask != UIBackgroundTaskInvalid)
    {
        
        [[UIApplication sharedApplication] endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
        
    }

}

#pragma mark - Reachability methods

- (void) reachabilityChanged:(NSNotification* )note
{
    Reachability* curReach = [note object];
    [self updateNetwork:curReach];
}

- (void)updateNetwork:(Reachability*)curReach {
    
    NetworkStatus connection = [curReach currentReachabilityStatus];
    
    if(curReach == remoteHost){
        
        switch (connection)
        {
//            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"START_TIME_SAVED"];
            case NotReachable:
            {
                [self performSelector:@selector(fetchSSIDInfo:) onThread:[NSThread currentThread] withObject:nil waitUntilDone:YES];
                NSLog(@"Reachability - Not Reachable");
                remoteHostStatus = 0;
                break;
            }
            case ReachableViaWWAN:
            {
                [self performSelector:@selector(fetchSSIDInfo:) onThread:[NSThread currentThread] withObject:nil waitUntilDone:YES];
                NSLog(@"Reachability via WAN");
                remoteHostStatus = 1;
                break;
            }
            case ReachableViaWiFi:
            {
//                [self fetchSSIDInfo:YES];
                [self performSelector:@selector(fetchSSIDInfo:) onThread:[NSThread currentThread] withObject:nil waitUntilDone:YES];
                NSLog(@"Reachability : Wi-Fi");
                remoteHostStatus = 2;
                break;
            }
        }
        if(remoteHostStatus != 0)
        {
            //            self.window.rootViewController.view=nav.view;
            
        } else
        {
            NSLog(@"Reachability : Not reachable");

//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"GeoDay!" message:@"Internet Connection not available currently. Please check your internet connectivity and try again after sometime."delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alert show];
        }
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
//        UIImage *navBackgroundImage = [UIImage imageNamed:@"navigationBar.png"];
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

/*

-(void)CheckTheLatlog :(BOOL)isHudNeeded;
{
    if (isHudNeeded)
    {
        [self showProgressHUD];
    }
    
    if (!self.lm)
    {
        
    self.lm = [[CLLocationManager alloc] init];
    self.lm.delegate = self;
    self.lm.desiredAccuracy = kCLLocationAccuracyBest;
    // only update location when user moves specified distance (meters)
    self.lm.distanceFilter =kCLDistanceFilterNone;
    
    }
    
    // start monitoring location changes
    [self.lm startUpdatingLocation];

}

#pragma mark - CLLocationManager Delegate

- (void)locationManager:(CLLocationManager *)manager
	 didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    
    self.latitude = [[NSString alloc] initWithFormat:@"%f", location.coordinate.latitude];
    self.longitude = [[NSString alloc] initWithFormat:@"%f", location.coordinate.longitude];
  
    
    BOOL isInBackground = NO;
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground)
    {
        isInBackground = YES;
    }
    if (isInBackground)
    {
        NSLog(@"Blatitude :: %@",self.latitude);
        NSLog(@"Blongitude :: %@",self.longitude);
        [self checkingUserLocationWithPlaceInBackgound:location];
    }
    else
    {
//        NSLog(@"latitude :: %@",self.latitude);
//        NSLog(@"longitude :: %@",self.longitude);
        [self checkingUserLocationWithPlace:location];
    }

}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	// Handle error
    NSLog(@"didFailWithError :: %@",error);
    
}

#pragma mark -  Check the meter

-(void)checkingUserLocationWithPlace :(CLLocation *)locObject
{


    NSString *strQueryForEnableLoc=[NSString stringWithFormat:@"SELECT * FROM locationInfo"];
        
    NSArray *arrCheck= [self.skOject lookupAllForSQL:strQueryForEnableLoc];
    
    BOOL isLocationIn20Miles=FALSE; // isSameWifi
        
    int loationid =0;
        
    for (int i =0; i<arrCheck.count; i++)
    {
            // get the value . .
            BOOL isEnableLoc=[[[arrCheck objectAtIndex:i]valueForKey:@"locationEnable"]boolValue];
            
            if (!isEnableLoc)
            {
                continue;
            }
// start here
        
            double valLat=[[[arrCheck objectAtIndex:i]valueForKey:@"lat"]doubleValue];
            double valLang=[[[arrCheck objectAtIndex:i]valueForKey:@"long"]doubleValue];
         
            CLLocationDegrees locLat =(CLLocationDegrees)valLat;
            CLLocationDegrees locLang = (CLLocationDegrees)valLang;
            
            CLLocation *savedlocation = [[CLLocation alloc] initWithLatitude:locLat longitude:locLang];
        
            CLLocationDistance distanceVal = [savedlocation distanceFromLocation:locObject];
        
            NSLog(@"distance ::%f",distanceVal);
        
            
            if (distanceVal<20.0f)
            {
                isLocationIn20Miles=TRUE;
                loationid=[[[arrCheck objectAtIndex:i]valueForKey:@"locationId"]integerValue];
                break ;
                
            }
   
        
    if (isLocationIn20Miles)
    {
        if (![[NSUserDefaults standardUserDefaults]boolForKey:@"START_TIME_SAVED"])
        {

            // -----------------------------
            NSDateFormatter *f2 = [[NSDateFormatter alloc] init];
            [f2 setDateFormat:@"dd-MM-YYYY"];
            NSString *CurrentTime = [f2 stringFromDate:[NSDate date]];
            // -----------------------------
            NSDateFormatter *df = [[NSDateFormatter alloc] init] ;
            [df setDateFormat:@"HH:mm"];
            NSDate *dateWithTime = [df dateFromString:CurrentTime];
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
            
            [self.lm stopUpdatingLocation];
            
             AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            
            [self performSelector:@selector(CheckTheLatlog:) withObject:Nil afterDelay:30.f];
        }
    }
    else
    {
        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"START_TIME_SAVED"])
        {
            
            // -----------------------------
            NSDateFormatter *f2 = [[NSDateFormatter alloc] init];
            [f2 setDateFormat:@"HH:mm"];
            NSString *CurrentTime = [f2 stringFromDate:[NSDate date]];
            // -----------------------------
            NSDateFormatter *df = [[NSDateFormatter alloc] init] ;
            [df setDateFormat:@"HH:mm"];
            NSDate *dateWithTime = [df dateFromString:CurrentTime];
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
            
            [self.dvc refreshView];
            
            [self.lm stopUpdatingLocation];
            
             AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            
            [self performSelector:@selector(CheckTheLatlog:) withObject:Nil afterDelay:30.f];
        }
    }
 }
}

*/

#pragma mark - Save in Background

-(void)checkingUserLocationWithPlaceInBackgound :(CLLocation *)locObject
{

    bgTask = [[UIApplication sharedApplication]
              beginBackgroundTaskWithExpirationHandler:
              ^{
                  [[UIApplication sharedApplication] endBackgroundTask:bgTask];
                  
              }];
    // **************************************

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

-(void)backgroundTimerCalled:(NSTimer *)timer
{
    NSLog(@"Background Timer Called");
    [self performSelector:@selector(fetchSSIDInfo:) onThread:[NSThread currentThread] withObject:nil waitUntilDone:YES];
}

@end
