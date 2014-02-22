//
//  AppDelegate.m
//  iBeaconSender
//
//  Created by henit.nathvani on 2/12/14.
//  Copyright (c) 2014 agilepc-105. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate
@synthesize configure;
@synthesize navigationView;
@synthesize backgroundTimer;
@synthesize locationManager;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                
    self.configure = [storyBoard instantiateViewControllerWithIdentifier:NSStringFromClass([ConfigureViewController class])];
    
    self.navigationView=[[UINavigationController alloc]initWithRootViewController:self.configure];
    
    [self.window setRootViewController:self.navigationView];
    
    
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
//    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];

    
    [self setAppearanceOfNavigationBar:self.navigationView];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    self.backgroundTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(backgroundTimerCalled:) userInfo:nil repeats:YES];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
   
     [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    [self.backgroundTimer invalidate];
    [self.locationManager stopUpdatingLocation];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
     [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

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


-(void)backgroundTimerCalled:(NSTimer *)timer
{
    NSLog(@"backgroundTimerCalled");
    [self.configure updateAdvertisedRegion];
}

@end
