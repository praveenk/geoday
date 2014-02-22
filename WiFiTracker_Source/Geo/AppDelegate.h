//
//  AppDelegate.h
//  Geo
//
//  Created by vishal Khatri on 1/30/14.
//  Copyright (c) 2014 vishal khatri - AgileInfoWays. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchLocationViewController.h"
#import "SKDatabase.h"
#import <CoreLocation/CoreLocation.h>
#import "MBProgressHUD.h"
#import "DisplayTimeViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "Reachability.h"
#import "locationNameViewController.h"
#import "SearchLocationViewController.h"
#import "ScheduledLocationManager.h"

@class DisplayTimeViewController;
@class locationNameViewController;
@class ScheduledLocationManager;

@interface AppDelegate : UIResponder <UIApplicationDelegate,SKDatabaseDelegate,CLLocationManagerDelegate,MBProgressHUDDelegate,ScheduledLocationManagerDelegate>
{

    Reachability *remoteHost;
    
    int remoteHostStatus;

    
    // Map View
    // -----------------------------
    CLLocationManager *lm;
    NSString *latitude;
    NSString *longitude;
    NSString *radius;
    NSArray *dataArray;
    int flagVal;
    // -----------------------------
    
    MBProgressHUD *HUD;
    
    UIBackgroundTaskIdentifier bgTask;

}
// ---------------------
// For locating and Api Calling
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) NSString *radius;
@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) CLLocationManager *lm;
@property (nonatomic,strong) NSTimer *backgroundTimer;
// ---------------------

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,retain) UINavigationController *navigationView;

@property (nonatomic,retain)DisplayTimeViewController *dvc;
@property (nonatomic,retain) locationNameViewController *lvc;

@property(nonatomic,strong)ScheduledLocationManager *sch;

@property ( nonatomic,retain) SKDatabase *skOject;

-(void)setAppearanceOfNavigationBar:(UINavigationController*)navCont;

-(void)CheckTheLatlog :(BOOL)isHudNeeded;
-(void)checkWifiNameIsEqualOrNot:(BOOL)endSession;
- (void)fetchSSIDInfo:(BOOL)endSession;


@end