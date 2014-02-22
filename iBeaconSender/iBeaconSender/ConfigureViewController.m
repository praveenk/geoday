//
//  ConfigureViewController.m
//  iBeaconSender
//
//  Created by henit.nathvani on 2/12/14.
//  Copyright (c) 2014 agilepc-105. All rights reserved.
//

#import "ConfigureViewController.h"

#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>

#import "AppDelegate.h"
#import "APLUUIDViewController.h"
CBPeripheralManager *peripheralManager = nil;
CLBeaconRegion *region = nil;
NSNumber *power = nil;

NSString *BeaconIdentifier = @"com.example.apple-samplecode.AirLocate";

static NSString * const kUUID = @"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0";
static NSString * const kIdentifier = @"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0";


@interface ConfigureViewController ()<CBPeripheralManagerDelegate, UIAlertViewDelegate, UITextFieldDelegate>
{
    AppDelegate *appDelegate;
}


@property (nonatomic, weak) IBOutlet UISwitch *enabledSwitch;
@property (nonatomic, weak) IBOutlet UITextField *uuidTextField;

@property (nonatomic, weak) IBOutlet UITextField *majorTextField;
@property (nonatomic, weak) IBOutlet UITextField *minorTextField;
@property (nonatomic, weak) IBOutlet UITextField *powerTextField;

@property BOOL enabled;
@property NSUUID *uuid;
@property NSNumber *major;
@property NSNumber *minor;

@property UIBarButtonItem *doneButton;

@property NSNumberFormatter *numberFormatter;


@end

@implementation ConfigureViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Sender";
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    self.doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneEditing:)];
    

    
    if(region)
    {
        self.uuid = region.proximityUUID;
//        self.major = region.major;
//        self.minor = region.minor;
        self.major = [NSNumber numberWithInt:1];
        self.minor = [NSNumber numberWithInt:101];
    }
    else
    {
//        @[[[NSUUID alloc] initWithUUIDString:@"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"],
//          [[NSUUID alloc] initWithUUIDString:@"5A4BCFCE-174E-4BAC-A814-092E77F6B7E5"],
//          [[NSUUID alloc] initWithUUIDString:@"74278BDA-B644-4520-8F0C-720EAF059935"]];
        self.uuid = [[NSUUID new]initWithUUIDString:kUUID];
        self.major = [NSNumber numberWithInt:1];
        self.minor = [NSNumber numberWithInt:101];
    }
    
    if(!power)
    {
        power = [NSNumber numberWithInt:-59];
    }
    
    [appDelegate setAppearanceOfNavigationBar:self.navigationController];
    self.numberFormatter = [[NSNumberFormatter alloc] init];
    self.numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!peripheralManager)
    {
        peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    }
    else
    {
        peripheralManager.delegate = self;
    }
    
    // Refresh the enabled switch.
    self.enabled = self.enabledSwitch.on = peripheralManager.isAdvertising;
    self.enabled = YES;
    
    self.uuidTextField.text = [self.uuid UUIDString];
    
    self.majorTextField.text = [self.major stringValue];
    self.minorTextField.text = [self.minor stringValue];
    self.powerTextField.text = [power stringValue];
    
    
    // [self updateAdvertisedRegion];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    peripheralManager.delegate = nil;
}
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    
}

#pragma mark - Text editing

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField == self.uuidTextField)
    {
//        [self performSegueWithIdentifier:@"selectUUID" sender:self];
        return NO;
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.navigationItem.rightBarButtonItem = self.doneButton;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == self.majorTextField)
    {
        self.major = [self.numberFormatter numberFromString:textField.text];
    }
    else if(textField == self.minorTextField)
    {
        self.minor = [self.numberFormatter numberFromString:textField.text];
    }
    else if(textField == self.powerTextField)
    {
        power = [self.numberFormatter numberFromString:textField.text];
        
        // ensure the power is negative
        if([power intValue] > 0)
        {
            power = [NSNumber numberWithInt:-[power intValue]];
            textField.text = [power stringValue];
        }
    }
    
    self.navigationItem.rightBarButtonItem = nil;
    
    [self updateAdvertisedRegion];
}


- (IBAction)toggleEnabled:(UISwitch *)sender
{
    self.enabled = sender.on;
    [self updateAdvertisedRegion];
}


- (IBAction)doneEditing:(id)sender
{
    [self.majorTextField resignFirstResponder];
    [self.minorTextField resignFirstResponder];
    [self.powerTextField resignFirstResponder];
    
    [self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    if([[segue identifier] isEqualToString:@"selectUUID"])
//    {
        APLUUIDViewController *uuidSelector = [segue destinationViewController];
        
        uuidSelector.uuid = self.uuid;
//    }
}

- (IBAction)unwindUUIDSelector:(UIStoryboardSegue*)sender
{
    APLUUIDViewController *uuidSelector = [sender sourceViewController];
    
    NSLog(@"uuidSelector.uuid :: %@",uuidSelector.uuid);
    
    
    self.uuid = uuidSelector.uuid;
   
    
    
   // [self updateAdvertisedRegion];
}

- (void)updateAdvertisedRegion
{
    NSLog(@"updateAdvertisedRegion");
    
    if(peripheralManager.state < CBPeripheralManagerStatePoweredOn)
    {
        
        NSString *title = NSLocalizedString(@"Bluetooth must be enabled", @"");
        NSString *message = NSLocalizedString(@"To configure your device as a beacon", @"");
        NSString *cancelButtonTitle = NSLocalizedString(@"OK", @"Cancel button title in configuration Save Changes");
        if([UIApplication sharedApplication].applicationState == UIApplicationStateBackground)
        {
            NSLog(@"Bluetooth is powered off");
            AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
            /*
            NSDate *alertTime = [[NSDate date]dateByAddingTimeInterval:10];
            UIApplication* app = [UIApplication sharedApplication];
            UILocalNotification* notifyAlarm = [[UILocalNotification alloc]init];
            if (notifyAlarm)
            {
                notifyAlarm.fireDate = alertTime;
                notifyAlarm.timeZone = [NSTimeZone defaultTimeZone];
                notifyAlarm.repeatInterval = 0;
//                notifyAlarm.soundName = @"Glass.aiff";
                notifyAlarm.alertBody = @"Staff meeting in 30 minutes";
                [app scheduleLocalNotification:notifyAlarm];
            }
             */
        }
        else
        {
            UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
            [errorAlert show];
        }
        return;
    }
    
	[peripheralManager stopAdvertising];
    
    NSLog(@"self.enabled :: %d",self.enabled);
    
    if(self.enabled)
    {
        NSLog(@"Advertisement started");
        // We must construct a CLBeaconRegion that represents the payload we want the device to beacon.
        NSDictionary *peripheralData = nil;
        
        region = [[CLBeaconRegion alloc] initWithProximityUUID:self.uuid major:[self.major shortValue] minor:[self.minor shortValue] identifier:kIdentifier];
        
        
        peripheralData = [region peripheralDataWithMeasuredPower:power];
        
        // The region's peripheral data contains the CoreBluetooth-specific data we need to advertise.
        
        if(peripheralData)
        {
            [peripheralManager startAdvertising:peripheralData];
        }
    }
}
@end
