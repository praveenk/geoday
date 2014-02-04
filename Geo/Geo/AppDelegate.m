//
//  AppDelegate.m
//  Geo
//
//  Created by vishal Khatri on 1/30/14.
//  Copyright (c) 2014 vishal khatri - AgileInfoWays. All rights reserved.
//

#import "AppDelegate.h"
#import "SearchLocationViewController.h"

@implementation AppDelegate

@synthesize  dvc;
@synthesize navigationView;
@synthesize skOject;
@synthesize latitude,longitude,lm,radius,dataArray;

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
    
    
    
    [NSTimer timerWithTimeInterval:150.f target:self selector:@selector(CheckTheLatlog:) userInfo:Nil repeats:YES];
    

    
    
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
    [self.lm startMonitoringSignificantLocationChanges];
    
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self.lm  stopMonitoringSignificantLocationChanges];

    [self.dvc refreshView];
    
   
//    [self.lm  startUpdatingLocation];
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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
        double valTime=[dateWithTime timeIntervalSince1970];
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
        NSLog(@"latitude :: %@",self.latitude);
        NSLog(@"longitude :: %@",self.longitude);
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
    // now hide the hud
    if (HUD)
    {
       // HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
       // HUD.labelText=@"";
        
       // HUD.mode = MBProgressHUDModeCustomView;
        
       // [HUD hide:YES afterDelay:1.0f];
//        [HUD hide:YES];
//        
//        HUD=Nil;
        
    }

    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"LOCATION_LAT"])
    {
 
        // old
    // ********************
   
    /*
    CLLocationDegrees lat = [[NSUserDefaults standardUserDefaults] doubleForKey:@"LOCATION_LAT"];
    
    CLLocationDegrees lng = [[NSUserDefaults standardUserDefaults] doubleForKey:@"LOCATION_LNG"];
    
    CLLocation *savedlocation = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
    
    CLLocationDistance distance = [savedlocation distanceFromLocation:locObject];
    */
        
    // ********************
        
    NSString *strQueryForEnableLoc=[NSString stringWithFormat:@"SELECT * FROM locationInfo"];
        
    NSArray *arrCheck= [self.skOject lookupAllForSQL:strQueryForEnableLoc];
    
    BOOL isLocationIn20Miles=FALSE;
        
    int loationid =0;
        
    for (int i =0; i<arrCheck.count; i++)
    {
            // get the value . .
            BOOL isEnableLoc=[[[arrCheck objectAtIndex:i]valueForKey:@"locationEnable"]boolValue];
            
            if (!isEnableLoc)
            {
                continue;
            }

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

#pragma mark - Save in Background
-(void)checkingUserLocationWithPlaceInBackgound :(CLLocation *)locObject
{

    bgTask = [[UIApplication sharedApplication]
              beginBackgroundTaskWithExpirationHandler:
              ^{
                  [[UIApplication sharedApplication] endBackgroundTask:bgTask];
                  
              }];
    // **************************************
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"LOCATION_LAT"])
    {
        
        // old
        // ********************
        
        /*
         CLLocationDegrees lat = [[NSUserDefaults standardUserDefaults] doubleForKey:@"LOCATION_LAT"];
         
         CLLocationDegrees lng = [[NSUserDefaults standardUserDefaults] doubleForKey:@"LOCATION_LNG"];
         
         CLLocation *savedlocation = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
         
         CLLocationDistance distance = [savedlocation distanceFromLocation:locObject];
         */
        
        // ********************
        
        NSString *strQueryForEnableLoc=[NSString stringWithFormat:@"SELECT * FROM locationInfo"];
        
        NSArray *arrCheck= [self.skOject lookupAllForSQL:strQueryForEnableLoc];
        
        BOOL isLocationIn20Miles=FALSE;
        
        int loationid =0;
        
        for (int i =0; i<arrCheck.count; i++)
        {
            // get the value . .
            BOOL isEnableLoc=[[[arrCheck objectAtIndex:i]valueForKey:@"locationEnable"]boolValue];
            
            if (!isEnableLoc)
            {
                continue;
            }
            
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

@end
