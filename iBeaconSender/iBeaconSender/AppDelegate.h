//
//  AppDelegate.h
//  iBeaconSender
//
//  Created by henit.nathvani on 2/12/14.
//  Copyright (c) 2014 agilepc-105. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigureViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) ConfigureViewController *configure;
@property (nonatomic,strong) UINavigationController *navigationView;
@property (nonatomic,strong) NSTimer *backgroundTimer;

@property (nonatomic,strong) CLLocationManager *locationManager;

-(void)setAppearanceOfNavigationBar:(UINavigationController*)navCont;

@end
