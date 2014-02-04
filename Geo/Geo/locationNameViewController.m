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
    
    self.title=@"Name This Location";
    
    [self.txtField becomeFirstResponder];
    
    app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    UIBarButtonItem *rightBarbutton=[[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveButton)];
    
    self.navigationItem.rightBarButtonItem=rightBarbutton;
    
}

-(void)saveButton
{
    if (self.txtField.text.length!=0)
    {
        [[NSUserDefaults standardUserDefaults]setObject:self.txtField.text forKey:@"PLACE_NAME"];
        [[NSUserDefaults standardUserDefaults]synchronize];

        
//        DisplayTimeViewController *dvc=[[DisplayTimeViewController alloc]initWithNibName:@"DisplayTimeViewController" bundle:Nil];
//        
//        [self.navigationController pushViewController:dvc animated:YES];
        
        
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
        
        // after save . get the LocationId
        // *******************************
    
        int loacationId = [[app.skOject lookupColForSQL:@"select max(locationId) from locationInfo"] integerValue];
        
        [[NSUserDefaults standardUserDefaults]setInteger:loacationId forKey:@"LOCATION_ID"];
        
        [self dismissViewControllerAnimated:YES completion:Nil];


        }
    else
    {
        UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"GeoDay" message:@"Please add place name." delegate:Nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [al show];
    }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
