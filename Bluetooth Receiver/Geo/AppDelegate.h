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
//#import "DisplayTimeViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@class DisplayTimeViewController;


// Create The Delegate Mehtods
//-------------------------------
@protocol iBeaconDeviceDetailsDelegate<NSObject>

-(void)getiBeaconDeviceDetails :(NSArray *)arrDetails;

@end
//-------------------------------



@interface AppDelegate : UIResponder <UIApplicationDelegate,SKDatabaseDelegate,CLLocationManagerDelegate,MBProgressHUDDelegate>
{

    // Map View
    // -----------------------------
    NSString *latitude;
    NSString *longitude;
    NSString *radius;
    NSArray *dataArray;
    int flagVal;
    // -----------------------------
    
    MBProgressHUD *HUD;
    
    UIBackgroundTaskIdentifier bgTask;
    BOOL isEventRanged;
    BOOL isNortificationDisplayed;
    int intValueForImmeadiateNearFarUnknown;

    
}
// ---------------------
// For locating and Api Calling
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) NSString *radius;
@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) CLLocationManager *lm;

// ---------------------

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,retain) UINavigationController *navigationView;

@property (nonatomic,retain)DisplayTimeViewController *dvc;

@property ( nonatomic,retain) SKDatabase *skOject;


-(void)setAppearanceOfNavigationBar:(UINavigationController*)navCont;

-(void)CheckTheLatlog :(BOOL)isHudNeeded;

// *******************************************************
@property NSMutableDictionary *rangedRegions; // for store multipul UUID
-(void)startTheFetchingBlueToothDevices;
@property (nonatomic,retain) CLLocationManager *locationManager;
-(void)saveCurrentTimeWhenUserDisconnectedWithBleutoothDevice;
// *******************************************************

// ------------- Custom Delegate --------------

@property(nonatomic,retain)id<iBeaconDeviceDetailsDelegate>delegate;
// --------------------------------------------

@end