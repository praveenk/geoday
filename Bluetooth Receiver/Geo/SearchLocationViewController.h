//
//  SearchLocationViewController.h
//  Geo
//
//  Created by vishal Khatri on 1/30/14.
//  Copyright (c) 2014 vishal khatri - AgileInfoWays. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "GeoQueryAnnotation.h"
#import <AddressBook/ABAddressBook.h>
#import <AddressBook/AddressBook.h>

#import <AddressBookUI/AddressBookUI.h>

#import "MBProgressHUD.h"

@interface SearchLocationViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate,UISearchBarDelegate,MBProgressHUDDelegate>
{
    
    MBProgressHUD *HUD;
    
    IBOutlet UIView *viewBottom;
    IBOutlet UIButton *btnloc;
    BOOL  isCancelButtonNeed;
    
    
    
}
@property (retain, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *myAddress;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBarLac;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;
@property (nonatomic,readwrite) BOOL  isCancelButtonNeed;


- (IBAction)myLocation:(UIButton *)sender;

@end
