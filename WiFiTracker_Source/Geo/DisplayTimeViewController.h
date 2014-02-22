//
//  DisplayTimeViewController.h
//  Geo
//
//  Created by vishal Khatri on 1/30/14.
//  Copyright (c) 2014 vishal khatri - AgileInfoWays. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ODRefreshControl.h"
#import <CoreLocation/CoreLocation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <CFNetwork/CFNetwork.h>

#import <SystemConfiguration/CaptiveNetwork.h>
#import "Stumbler.h"


@class AppDelegate;


@interface DisplayTimeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MKMapViewDelegate,CLLocationManagerDelegate>
{

    IBOutlet UITableView *tblView;
    IBOutlet UIView *viewFooter;
    IBOutlet MKMapView *mapVw;
    AppDelegate *app;
    IBOutlet UILabel *lblTotal;
    CLLocationManager *locationManager;
    
    double totalCnt;
    int totalMnt;
    UIButton *a1;
    
    Stumbler *stumbler;
}
-(void)refreshView;


@property (nonatomic,retain) NSMutableArray *arrStartTime;
@property (nonatomic,retain) NSMutableArray *arrEndTime;

@end
