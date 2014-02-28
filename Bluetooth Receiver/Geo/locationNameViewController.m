//
//  locationNameViewController.m
//  Geo
//
//  Created by vishal Khatri on 1/30/14.
//  Copyright (c) 2014 vishal khatri - AgileInfoWays. All rights reserved.
//

#import "locationNameViewController.h"
#import "DisplayTimeViewController.h"

@interface locationNameViewController ()

@end

@implementation locationNameViewController

@synthesize txtField;
@synthesize beacons;
@synthesize locationManager;
@synthesize rangedRegions;
@synthesize tblView;
@synthesize isCancelButtonNeed;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - viewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    

    //----------------------------------------------------------------------
    self.title=@"Configure Device";
    
    [self.txtField becomeFirstResponder];
    
    app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    UIBarButtonItem *rightBarbutton=[[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveButton)];
    
    self.navigationItem.rightBarButtonItem=rightBarbutton;
    
    
    
    if (self.isCancelButtonNeed)
    {
        UIBarButtonItem *leftBarbutton=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissTheView)];
        
        leftBarbutton.tintColor=[UIColor whiteColor];
        
        self.navigationItem.leftBarButtonItem=leftBarbutton;
        
    }

    //----------------------------------------------------------------------
    
    // ************************************************************
    self.beacons = [[NSMutableDictionary alloc] init];
    
    // This location manager will be used to demonstrate how to range beacons.
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    // Populate the regions we will range once.
    self.rangedRegions = [[NSMutableDictionary alloc] init];
    
    
    NSArray *supportedProximityUUIDs = @[[[NSUUID alloc] initWithUUIDString:@"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"],[[NSUUID alloc] initWithUUIDString:@"5A4BCFCE-174E-4BAC-A814-092E77F6B7E5"],[[NSUUID alloc] initWithUUIDString:@"74278BDA-B644-4520-8F0C-720EAF059935"]];
    
    for (NSUUID *uuid in supportedProximityUUIDs)
    {
        CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:[uuid UUIDString]];
        
        region.notifyEntryStateOnDisplay=YES;
        region.notifyOnEntry=YES;
        region.notifyOnExit=YES;
        
        self.rangedRegions[region] = [NSArray array];
    }
    
    NSLog(@"self.rangedRegions :: %@",self.rangedRegions);

    
    
    // ************************************************************
}
-(void)viewWillAppear:(BOOL)animated
{
    // Start ranging when the view appears.
    
    NSLog(@"self.rangedRegions :: %@",self.rangedRegions);
    // ***********************************************************
    for (CLBeaconRegion *region in self.rangedRegions)
    {
        
        [self.locationManager startMonitoringForRegion:region];
        
        [self.locationManager startRangingBeaconsInRegion:region];
    }
    // ***********************************************************

}
-(void)stopRangingDevices
{
    // Stop ranging when the view goes away.
    // -----------------------------------------------------
    for (CLBeaconRegion *region in self.rangedRegions)
    {
        [self.locationManager stopMonitoringForRegion:region];
        [self.locationManager stopRangingBeaconsInRegion:region];
    }
    
    [activity stopAnimating];
    activity.hidesWhenStopped= YES;
    
    self.locationManager=nil;
    
    
    // -----------------------------------------------------
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - location Delegate
- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    /*
    
     CoreLocation will call this delegate method at 1 Hz with updated range information.
     Beacons will be categorized and displayed by proximity.  A beacon can belong to multiple
     regions.  It will be displayed multiple times if that is the case.  If that is not desired,
     use a set instead of an array.
    
     */
    
    self.rangedRegions[region] = beacons;
   
  //  NSLog(@"++++++++++++++ \n Before  self.rangedRegions.count :: %d  \n ++++++++++++++++", self.rangedRegions.count);
   // NSLog(@"@@@@@@@@@@ \n After self.rangedRegions.count :: %@  \n @@@@@@@@@@", self.rangedRegions);
    
    
    [self.beacons removeAllObjects];
    
    NSMutableArray *allBeacons = [NSMutableArray array];
    
    for (NSArray *regionResult in [self.rangedRegions allValues])
    {
        [allBeacons addObjectsFromArray:regionResult];
    }
    
     NSLog(@"@@@@@@@@@@ \n beacons :: %@  \n @@@@@@@@@@", beacons);
     NSLog(@"++++++++++++++ \n allBeacons :: %@  \n ++++++++++++++++", allBeacons);
    
    for (NSNumber *range in @[@(CLProximityUnknown), @(CLProximityImmediate), @(CLProximityNear), @(CLProximityFar)])
    {
        NSArray *proximityBeacons = [allBeacons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"proximity = %d", [range intValue]]];
        if([proximityBeacons count])
        {
            self.beacons[range] = proximityBeacons;
        }
    }
    
    [self.tblView reloadData];
}

- (void)locationManager:(CLLocationManager *)manager
          didExitRegion:(CLRegion *)region
{

    NSLog(@"@@@@@ locationManager didRangeBeacons @@@@@");
    
    NSLog(@"@@@@@ lastObject UUID :: %@ @@@@@",region.identifier);

}
#pragma mark - SaveValues

-(void)saveButton
{
    // ********************************************
    
    //strDeviceUUID=@"131232132132132132";
    if (!strDeviceUUID)
    {
        UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"GeoDay" message:@"Please select any iBeacon device." delegate:Nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [al show];
       
        return;
    }
    if (self.txtField.text.length!=0)
    {
        [[NSUserDefaults standardUserDefaults]setObject:self.txtField.text forKey:@"PLACE_NAME"];
        
        [[NSUserDefaults standardUserDefaults] setDouble:1.0f forKey:@"LOCATION_LAT"];
        
        [[NSUserDefaults standardUserDefaults] setDouble:101.0f forKey:@"LOCATION_LNG"];
        
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        // ********************************************
        // save value in database
        NSString *strLat = [NSString stringWithFormat:@"%f",[[NSUserDefaults standardUserDefaults] doubleForKey:@"LOCATION_LAT"]];
        NSString *strLong = [NSString stringWithFormat:@"%f",[[NSUserDefaults standardUserDefaults] doubleForKey:@"LOCATION_LNG"]];
        NSString *strPlaceName =self.txtField.text;
        NSString *strIsEnable=@"1";
        
        // save this value in the database
        // ********************************
        
        NSString *strQ=[NSString stringWithFormat:@"INSERT INTO locationInfo (locationName, lat, long, locationEnable,deviceId) VALUES('%@', '%@','%@','%@','%@')",strPlaceName,strLat,strLong,strIsEnable,strDeviceUUID];
        
        [app.skOject lookupAllForSQL:strQ];
        
        // after save . get the LocationId
        // *******************************
        
        int loacationId = [[app.skOject lookupColForSQL:@"select max(locationId) from locationInfo"] integerValue];
        
        
        [[NSUserDefaults standardUserDefaults]setInteger:loacationId forKey:@"LOCATION_ID"];
        
        
        NSString *strUpdateQuery=[NSString stringWithFormat:@"UPDATE locationInfo SET locationEnable = '0' WHERE locationId <> %d",loacationId];
        
        NSArray *arrWork=[app.skOject lookupAllForSQL:strUpdateQuery];
        
        
        [app startTheFetchingBlueToothDevices];
        
        [self dismissViewControllerAnimated:YES completion:Nil];
    }
    else
    {
        UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"GeoDay" message:@"Please Enter Bluetooth Device name." delegate:Nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [al show];
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.beacons.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *sectionValues = [self.beacons allValues];
    return [sectionValues[section] count];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title;
    NSArray *sectionKeys = [self.beacons allKeys];
    
    // The table view will display beacons by proximity.
    NSNumber *sectionKey = sectionKeys[section];
    
    switch([sectionKey integerValue])
    {
        case CLProximityImmediate:
            title = NSLocalizedString(@"Immediate", @"Immediate section header title");
            break;
            
        case CLProximityNear:
            title = NSLocalizedString(@"Near", @"Near section header title");
            break;
            
        case CLProximityFar:
            title = NSLocalizedString(@"Far", @"Far section header title");
            break;
            
        default:
            title = NSLocalizedString(@"Unknown", @"Unknown section header title");
            break;
    }
    
    return title;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *identifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];

    if (cell==nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.selectionStyle=UITableViewCellEditingStyleNone;
    }
    
    // Display the UUID, major, minor and accuracy for each beacon.
    NSNumber *sectionKey = [self.beacons allKeys][indexPath.section];
    CLBeacon *beacon = self.beacons[sectionKey][indexPath.row];
    cell.textLabel.text = [beacon.proximityUUID UUIDString];
    cell.textLabel.font=[UIFont systemFontOfSize:13];
    
   // NSString *formatString = NSLocalizedString(@"Major: %@, Minor: %@, Acc: %.2fm", @"Format string for ranging table cells.");
    //cell.detailTextLabel.text = [NSString stringWithFormat:formatString, beacon.major, beacon.minor, beacon.accuracy];
    

    cell.detailTextLabel.text = [self detailsStringForBeacon:beacon];
    
    return cell;
}

#pragma  mark - Selection Method.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (strDeviceUUID)
    {
        return;
        
    }
    // here we added the checkMark in the Selected Cell
    // ****************************************************
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    
    NSLog(@"cell.label :: %@",cell.textLabel.text);
    strDeviceUUID=cell.textLabel.text;
    [self stopRangingDevices];
    
        // ****************************************************
        //        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Unitehood" message:@"You can select Maximum 3 Contacts only" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        //
        //
        //        [alert show];
    
}

#pragma - textField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (NSString *)detailsStringForBeacon:(CLBeacon *)beacon
{
    NSString *proximity;
    switch (beacon.proximity)
    {
        case CLProximityNear:
            proximity = @"Near";
            break;
        case CLProximityImmediate:
            proximity = @"Immediate";
            break;
        case CLProximityFar:
            proximity = @"Far";
            break;
        case CLProximityUnknown:
        default:
            proximity = @"Unknown";
            break;
    }
    
    NSString *format = @"Major: %@ • Minor: %@ • %@ • Acc: %.2fm ";
    return [NSString stringWithFormat:format, beacon.major, beacon.minor, proximity, beacon.accuracy];
}
-(void)dismissTheView
{
    [self stopRangingDevices];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end