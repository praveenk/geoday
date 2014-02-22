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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title=@"Add Network";
    
    
    [self.txtField becomeFirstResponder];
    
    app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    UIBarButtonItem *rightBarbutton=[[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveButton)];
    
    self.navigationItem.rightBarButtonItem=rightBarbutton;
    if (self.isCancelButtonNeeded)
    {
        UIBarButtonItem *leftBarbutton=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissTheView)];
        
        leftBarbutton.tintColor=[UIColor whiteColor];
        
        self.navigationItem.leftBarButtonItem=leftBarbutton;
        
    }
    buttonSave.hidden = YES;
    self.labelCurrentWiFi.frame = CGRectMake(self.labelCurrentWiFi.frame.origin.x, self.labelCurrentWiFi.frame.origin.y, 320, self.labelCurrentWiFi.frame.size.height);
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSString *strCurrentWiFi = [[NSUserDefaults standardUserDefaults]stringForKey:@"WIFI_NAME"];
    if(strCurrentWiFi.length>0)
    {
        self.labelCurrentWiFi.text = [NSString stringWithFormat:@"Current Wi-Fi : %@", strCurrentWiFi];
        buttonSave.hidden = YES;
    }
    else
    {
        self.labelCurrentWiFi.text=@"";
        self.labelCurrentWiFi.hidden = YES;
    }
}

-(void)saveButton
{
    /*
     
    if (![self.txtField.text isEqualToString:[[NSUserDefaults standardUserDefaults]stringForKey:@"WIFI_NAME"]])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"GEODay!" message:@"Enter correct Wi-Fi Name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    */

    if (self.txtField.text.length!=0)
    {
    
        // ===================
        // ********************************************
        // save value in database
        NSString *strLat = [NSString stringWithFormat:@"%f",[[NSUserDefaults standardUserDefaults] doubleForKey:@"LOCATION_LAT"]];
        NSString *strLong = [NSString stringWithFormat:@"%f",[[NSUserDefaults standardUserDefaults] doubleForKey:@"LOCATION_LNG"]];
        NSString *strPlaceName =self.txtField.text;
        NSString *strIsEnable=@"1";

        // save this value in the database
        // ********************************
        
        
        NSString *strQ=[NSString stringWithFormat:@"INSERT INTO locationInfo (locationName, lat, long, locationEnable) VALUES('%@', '%@','%@','%@')",strPlaceName,strLat,strLong,strIsEnable];

        [app.skOject lookupAllForSQL:strQ];
     
        
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"IS_WIFI_NAME_ADDED"];
        [self dismissViewControllerAnimated:YES completion:Nil];
        
  /*
        
        // after save . get the LocationId
        // *******************************
    
        int loacationId = [[app.skOject lookupColForSQL:@"select max(locationId) from locationInfo"] integerValue];
        
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"START_TIME_SAVED"];
        
        [[NSUserDefaults standardUserDefaults]setInteger:loacationId forKey:@"LOCATION_ID"];
        
        
        
        // Initializing the session
        
        NSDateFormatter *f2 = [[NSDateFormatter alloc] init];
        [f2 setDateFormat:@"dd-MM-YYYY"];
        NSString *CurrentTime = [f2 stringFromDate:[NSDate date]];
        // -----------------------------
        NSDateFormatter *df = [[NSDateFormatter alloc] init] ;
        [df setDateFormat:@"HH:mm"];
        NSDate *dateWithTime = [df dateFromString:CurrentTime];
        // -----------------------------
        double valTime=[[NSDate date] timeIntervalSince1970];
        NSString *time= [NSString stringWithFormat:@"%f",valTime];
        NSLog(@"time :: %@",time);
        // ------------------------------
        
        
        NSString *strQ1=[NSString stringWithFormat:@"INSERT INTO sessions (starttime, endtime, locationId,startdate) VALUES('%@', '',%d,'%@')",time,loacationId,CurrentTime];
        
        [app.skOject lookupAllForSQL:strQ1];
        
        int sessionId = [[app.skOject lookupColForSQL:@"select max(sessionid) from sessions"] integerValue];
        
        [[NSUserDefaults standardUserDefaults]setInteger:sessionId forKey:@"CURRENT_SESSION_ID"];
        
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"START_TIME_SAVED"];

        
        
        */
        
    

    }
    else
    {
        UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"GeoDay" message:@"Please add Wi-Fi SSID." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [al show];
    }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonSaveCurrentWiFi:(id)sender
{
    NSString *strLat = [NSString stringWithFormat:@"%f",[[NSUserDefaults standardUserDefaults] doubleForKey:@"LOCATION_LAT"]];
    NSString *strLong = [NSString stringWithFormat:@"%f",[[NSUserDefaults standardUserDefaults] doubleForKey:@"LOCATION_LNG"]];
    NSString *strPlaceName =[[NSUserDefaults standardUserDefaults] stringForKey:@"WIFI_NAME"];
    NSString *strIsEnable=@"1";
    
    // save this value in the database
    // ********************************
    NSDateFormatter *f2 = [[NSDateFormatter alloc] init];
    [f2 setDateFormat:@"HH:mm"];
    NSString *CurrentTime = [f2 stringFromDate:[NSDate date]];

    double valTime=[[NSDate date] timeIntervalSince1970];
    NSString *time= [NSString stringWithFormat:@"%f",valTime];
    NSLog(@"time :: %@",time);

    
    NSString *strQ=[NSString stringWithFormat:@"INSERT INTO locationInfo (locationName, lat, long, locationEnable) VALUES('%@', '%@','%@','%@')",strPlaceName,strLat,strLong,strIsEnable];
    
    [app.skOject lookupAllForSQL:strQ];
    
    int loacationId = [[app.skOject lookupColForSQL:@"select max(locationId) from locationInfo"] integerValue];
    
    [[NSUserDefaults standardUserDefaults]setInteger:loacationId forKey:@"LOCATION_ID"];
    
    NSString *strQuerySessions=[NSString stringWithFormat:@"INSERT INTO sessions (starttime, endtime, locationId,startdate) VALUES('%@', '',%d,'%@')",time,loacationId,CurrentTime];
    
    [app.skOject lookupAllForSQL:strQuerySessions];
    
    int sessionId = [[app.skOject lookupColForSQL:@"select max(sessionid) from sessions"] integerValue];
    
    [[NSUserDefaults standardUserDefaults]setInteger:sessionId forKey:@"CURRENT_SESSION_ID"];
    
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"START_TIME_SAVED"];

    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"IS_WIFI_NAME_ADDED"];
    [self dismissViewControllerAnimated:YES completion:Nil];

}

-(void)dismissTheView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
