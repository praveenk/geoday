//
//  SearchLocationViewController.m
//  Geo
//
//  Created by vishal Khatri on 1/30/14.
//  Copyright (c) 2014 vishal khatri - AgileInfoWays. All rights reserved.
//

#import "SearchLocationViewController.h"
#import "locationNameViewController.h"


@interface SearchLocationViewController ()

@end

@implementation SearchLocationViewController

@synthesize mapView;
@synthesize locationManager;
@synthesize location;
@synthesize isCancelButtonNeed;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - viewDid load
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"Add a Location";
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    
    //Long Gesture for Dropping Pin
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                                   action:@selector(handleLongPressGesture:)];
    [self.mapView addGestureRecognizer:longPressGesture];
    
    
    UIBarButtonItem *rightBarbutton=[[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(nextButton)];
    
    rightBarbutton.tintColor=[UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem=rightBarbutton;

    
    
    
    if (self.isCancelButtonNeed)
    {
        UIBarButtonItem *leftBarbutton=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissTheView)];
        
        leftBarbutton.tintColor=[UIColor whiteColor];
        
        self.navigationItem.leftBarButtonItem=leftBarbutton;
        
    }
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    if (screenSize.height > 480.0f)
    {
        /*Do iPhone 5 stuff here.*/
    } else
    {
        [self.view bringSubviewToFront:viewBottom];
        viewBottom.frame=CGRectMake(0,372, 320, 44);
        btnloc.frame=CGRectMake(5, 377, 120, 35);
        [self.view bringSubviewToFront:btnloc];
       // [viewBottom addSubview:btnloc];
      //  btnloc.frame=CGRectMake(10, 5, 120, 35);
      //  [viewBottom bringSubviewToFront:btnloc];
        /*Do iPhone Classic stuff here.*/
    }
    
    
}

// Dropped Pin Method

-(void)handleLongPressGesture:(UIGestureRecognizer*)sender {
    // This is important if you only want to receive one tap and hold event
    if (sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateChanged)
    {
        return;
        [self.mapView removeGestureRecognizer:sender];
    }
    else
    {
        // Here we get the CGPoint for the touch and convert it to latitude and longitude coordinates to display on the map
        [self showTheHud];
        
        float spanX = 0.00725;
        float spanY = 0.00725;

        CGPoint point = [sender locationInView:self.mapView];
        
        CLLocationCoordinate2D locCoord = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
        CLLocation *savedlocation = [[CLLocation alloc] initWithLatitude:locCoord.latitude longitude:locCoord.longitude];
        MKCoordinateRegion region;
        region.center.latitude = locCoord.latitude;
        region.center.longitude = locCoord.longitude;
        region.span = MKCoordinateSpanMake(spanX, spanY);
        [self.mapView setRegion:region animated:YES];

        [self reverseGeocode:savedlocation];

        
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Next Button

-(void)nextButton
{
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"LOCATION_LAT"])
    {
    locationNameViewController *loc=[[locationNameViewController alloc]initWithNibName:@"locationNameViewController" bundle:Nil];
    
    [self.navigationController pushViewController:loc animated:YES];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"GeoDay" message:@"Please select location." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        
    
    }
}

#pragma mark - MyLocation

- (IBAction)myLocation:(UIButton *)sender
{
    [self showTheHud];
    
    float spanX = 0.00725;
    float spanY = 0.00725;
    self.location = self.locationManager.location;
    MKCoordinateRegion region;
    region.center.latitude = self.locationManager.location.coordinate.latitude;
    region.center.longitude = self.locationManager.location.coordinate.longitude;
    region.span = MKCoordinateSpanMake(spanX, spanY);
    [self.mapView setRegion:region animated:YES];

    [self reverseGeocode:self.location];
}

- (void)reverseGeocode:(CLLocation *)location
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Finding address");
        if (error)
        {
            NSLog(@"Error %@", error.description);
            
            [HUD hide:YES];
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"GeoDay" message:@"location not found. please try again" delegate:Nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
            [alertView show];
            
        } else
        {
            CLPlacemark *placemark = [placemarks lastObject];
            
            // Store the location
            // **************************************************
            [[NSUserDefaults standardUserDefaults] setDouble:placemark.location.coordinate.latitude forKey:@"LOCATION_LAT"];
            [[NSUserDefaults standardUserDefaults] setDouble:placemark.location.coordinate.longitude forKey:@"LOCATION_LNG"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            // **************************************************
            
            
            for (id <MKAnnotation> annotation in self.mapView.annotations)
            {
                if ([annotation isKindOfClass:[MKPlacemark class]])
                {
                    [self.mapView removeAnnotation:annotation];
                }
                
            }

            MKPlacemark *placemarkMk = [[MKPlacemark alloc] initWithPlacemark:placemark];
            [self.mapView addAnnotation:placemarkMk];
            
            NSLog(@"placemark.addressDictionary :: %@",placemark.addressDictionary);
            
            self.myAddress.text = [NSString stringWithFormat:@"%@", ABCreateStringWithAddressDictionary(placemark.addressDictionary, NO)];
           
            self.searchBarLac.text =[NSString stringWithFormat:@"%@", ABCreateStringWithAddressDictionary(placemark.addressDictionary, NO)];
            NSLog(@"%@", ABCreateStringWithAddressDictionary(placemark.addressDictionary, NO));
            // now hide the hud
            HUD.labelText=@"Completed";
            HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
            HUD.mode = MBProgressHUDModeCustomView;
            
            [HUD hide:YES afterDelay:0.9];
        }
    }];
}

#pragma mark - SearchBar Deleagate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    self.searchBarLac.showsCancelButton=NO;
    
    [self showTheHud];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:searchBar.text completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (error)
         {
             NSLog(@"No found , please check");
             NSLog(@"%@", error);
            [HUD hide:YES];
            
             UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"GeoDay" message:@"No Place found. please try again" delegate:Nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
            [alertView show];
         }
         
         else
         {
             NSLog(@"placemarks ::%@",placemarks);
             CLPlacemark *placemark = [placemarks lastObject];
             
             // Store the location
             // **************************************************
             [[NSUserDefaults standardUserDefaults] setDouble:placemark.location.coordinate.latitude forKey:@"LOCATION_LAT"];
             [[NSUserDefaults standardUserDefaults] setDouble:placemark.location.coordinate.longitude forKey:@"LOCATION_LNG"];
             [[NSUserDefaults standardUserDefaults]synchronize];
             // **************************************************
             
             float spanX = 0.00725;
             float spanY = 0.00725;
             
             MKCoordinateRegion region;
             region.center.latitude = placemark.location.coordinate.latitude;
             region.center.longitude = placemark.location.coordinate.longitude;
             region.span = MKCoordinateSpanMake(spanX, spanY);
             
             [self.mapView setRegion:region animated:YES];
             
             NSString *strVal=ABCreateStringWithAddressDictionary(placemark.addressDictionary, NO);
             
             NSLog(@"%@", strVal);
             
            // UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"GeoDay" message:strVal delegate:Nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
           //  [alertView show];
             for (id <MKAnnotation> annotation in self.mapView.annotations)
             {
                 if ([annotation isKindOfClass:[MKPlacemark class]])
                 {
                     [self.mapView removeAnnotation:annotation];
                 }
                 
             }

             MKPlacemark *placemarkMk = [[MKPlacemark alloc] initWithPlacemark:placemark];
           
             [self.mapView addAnnotation:placemarkMk];
             
             
             // now hide the hud
             HUD.labelText=@"Completed";
             HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
             HUD.mode = MBProgressHUDModeCustomView;
             
             [HUD hide:YES afterDelay:0.9];
             
         }
     }];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [self.searchBarLac resignFirstResponder];

    self.searchBarLac.showsCancelButton=NO;
    
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    self.searchBarLac.showsCancelButton=YES;
    return YES;
}

#pragma mark - MBprogess HUD
-(void)showTheHud
{
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	
	[self.navigationController.view addSubview:HUD];
	
    HUD.dimBackground=YES;
    
	// Set determinate bar mode
	HUD.mode = MBProgressHUDModeIndeterminate;
	
	HUD.delegate = self;
	
	[HUD show:YES];

	HUD.labelText=@"Searching...";
}
-(void)dismissTheView
{

    
    [self dismissViewControllerAnimated:YES completion:nil];

}
@end
