//
//  DisplayTimeViewController.h
//  Geo
//
//  Created by vishal Khatri on 1/30/14.
//  Copyright (c) 2014 vishal khatri - AgileInfoWays. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ODRefreshControl.h"
#import <CoreLocation/CoreLocation.h>
#import "locationNameViewController.h"
#import "AppDelegate.h"

@class AppDelegate;

@interface DisplayTimeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MKMapViewDelegate,CLLocationManagerDelegate,iBeaconDeviceDetailsDelegate>
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
    
    
    IBOutlet UILabel *lblDeviceUUID;
    IBOutlet UILabel *lblDeviceDetails;
    


}
-(void)refreshView;


@property (nonatomic,retain) NSMutableArray *arrStartTime;
@property (nonatomic,retain) NSMutableArray *arrEndTime;

@end
