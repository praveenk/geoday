//
//  locationNameViewController.h
//  Geo
//
//  Created by vishal Khatri on 1/30/14.
//  Copyright (c) 2014 vishal khatri - AgileInfoWays. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@import CoreLocation;
@class AppDelegate;

@interface locationNameViewController : UIViewController<CLLocationManagerDelegate>
{
    AppDelegate *app;
    
    IBOutlet UIActivityIndicatorView  *activity;
    
    
    NSString *strDeviceUUID;
    
    
}

@property (retain, nonatomic) IBOutlet UITextField *txtField;


@property (nonatomic,retain)IBOutlet UITableView *tblView;

@property NSMutableDictionary *beacons;
@property CLLocationManager *locationManager;
@property NSMutableDictionary *rangedRegions;
@property (nonatomic,readwrite) BOOL  isCancelButtonNeed;

@end
