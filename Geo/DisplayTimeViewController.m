//
//  DisplayTimeViewController.m
//  Geo
//
//  Created by vishal Khatri on 1/30/14.
//  Copyright (c) 2014 vishal khatri - AgileInfoWays. All rights reserved.
//

#import "DisplayTimeViewController.h"
#import "SearchLocationViewController.h"
#import "SettingsViewController.h"
#import "CalenderViewController.h"
@interface DisplayTimeViewController ()

@end

@implementation DisplayTimeViewController

@synthesize arrStartTime,arrEndTime;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark - View Did Load

- (void)viewDidLoad
{
    [super viewDidLoad];
    isSearchActive=NO;
    // Do any additional setup after loading the view from its nib.
    app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    totalCnt=0;
    totalMnt=0;
    
    locationManager = [[CLLocationManager alloc]init];
    [mapVw showsUserLocation];
//
    // add refresh contorller
    // **************************************************
    ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:tblView];
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];

    refreshControl.tintColor= [UIColor colorWithRed:37.0/255.0f green:86.0/255.0f blue:150.0/255.0f alpha:1.0f];
    // **************************************************
    // bar button item left
    // **************************************************
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [leftBtn setFrame:CGRectMake(0.0f, 0.0f, 26.0f, 26.0f)];
    
    [leftBtn addTarget:self action:@selector(presentSettingView) forControlEvents:UIControlEventTouchUpInside];
    
    [leftBtn setImage:[UIImage imageNamed:@"setup.png"] forState:UIControlStateNormal];
    
    UIBarButtonItem *leftBarbutton= [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    self.navigationItem.leftBarButtonItem=leftBarbutton;
    // **************************************************
    // bar button item right
    // **************************************************
    a1 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [a1 setFrame:CGRectMake(0.0f, 0.0f, 26.0f, 26.0f)];
    
    [a1 addTarget:self action:@selector(presentCalendarView) forControlEvents:UIControlEventTouchUpInside];
    [a1 setImage:[UIImage imageNamed:@"cal.png"] forState:UIControlStateNormal];
    
    UIBarButtonItem *rightBarbutton= [[UIBarButtonItem alloc] initWithCustomView:a1];
    rightBarbutton.tintColor=[UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem=rightBarbutton;
    // **********************************************

    if (![[NSUserDefaults standardUserDefaults] valueForKey:@"LOCATION_LAT"])
    {
        SearchLocationViewController *seachView=[[SearchLocationViewController alloc]initWithNibName:@"SearchLocationViewController" bundle:nil];
   
        UINavigationController *navView=[[UINavigationController alloc]initWithRootViewController:seachView];
        
        [app setAppearanceOfNavigationBar:navView];
        
        [self presentViewController:navView animated:NO completion:Nil];
                
        return;
    }
    
}
-(void)viewWillAppear:(BOOL)animated
{
    //Check For Iphone Device
    
    if (IS_IPHONE5) {
        
        mapVw.frame = CGRectMake(0, 0, 320, 168);
    }
    else{
        
        mapVw.frame = CGRectMake(0, 0, 320, 135);
        
    }
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"LOCATION_LAT"])
    {
        
        NSDateFormatter *f2 = [[NSDateFormatter alloc] init];
        [f2 setDateFormat:@"EEE, MMM dd, yyyy"];
        NSString *s = [f2 stringFromDate:[NSDate date]];
        self.title=s;
        totalCnt=0;
        totalMnt=0;
        // *****************************
        if (isSearchActive)
        {
            
            lblTotal.text=@"00:00";
            NSArray *arStartTime=[app.skOject lookupAllForSQL:[NSString stringWithFormat:@"select starttime,locationId from sessions where startdate like '%@'",searchDate]];
            
            NSArray *arEndTime=[app.skOject lookupAllForSQL:[NSString stringWithFormat:@"select endtime from sessions where startdate like '%@'",searchDate]];
            
            self.arrStartTime=[[NSMutableArray alloc]initWithArray:arStartTime];
            
            self.arrEndTime=[[NSMutableArray alloc]initWithArray:arEndTime];
            
            [a1 setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
            
            
            
        }
        else
        {
            NSArray *arStartTime=[app.skOject lookupAllForSQL:@"select starttime,locationId from sessions"];
        
            NSArray *arEndTime=[app.skOject lookupAllForSQL:@"select endtime from sessions"];
        
            self.arrStartTime=[[NSMutableArray alloc]initWithArray:arStartTime];
        
            self.arrEndTime=[[NSMutableArray alloc]initWithArray:arEndTime];
         
            [self performSelector:@selector(refreshView) withObject:nil afterDelay:2.0];
            
        }
        tblView.tableHeaderView = mapVw;
        tblView.tableFooterView=viewFooter;
        
        [tblView reloadData];
        
        [app CheckTheLatlog:NO];
        
        
        
    }
}



#pragma mark - MKMapView Delegate Method

- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)aUserLocation {
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.005;
    span.longitudeDelta = 0.005;
    CLLocationCoordinate2D location;
    location.latitude = aUserLocation.coordinate.latitude;
    location.longitude = aUserLocation.coordinate.longitude;
    region.span = span;
    region.center = location;
    [aMapView setRegion:region animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // return the number of rows in the section
 
   // return 0;
    
    return [self.arrStartTime count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil)
//    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.backgroundColor=[UIColor colorWithRed:226.0/255.0f green:226.0/255.0f blue:226.0/255.0f alpha:1.0f];
        cell.selectionStyle=UITableViewCellAccessoryNone;
    
    

    // ***************

    UIImageView *imgPin=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pin1.png"]];
    
    imgPin.frame=CGRectMake(5, 0, 30, 30);
    
    [cell.contentView addSubview:imgPin];
    
    // ***************

    UILabel *lblPlaceName=[[UILabel alloc]initWithFrame:CGRectMake(35, 0, 200, 30)];

    lblPlaceName.backgroundColor=[UIColor clearColor];
    
    //lblPlaceName.text=[[NSUserDefaults standardUserDefaults]valueForKey:@"PLACE_NAME"];
  
    lblPlaceName.text=[self returnPlaceNameFromID:[[[self.arrStartTime objectAtIndex:indexPath.row]valueForKey:@"locationId"]integerValue]];
    
    lblPlaceName.font=[UIFont boldSystemFontOfSize:18];
    
    lblPlaceName.textColor=[UIColor blackColor];
    
    [cell.contentView addSubview:lblPlaceName];
    
    // ***************
    
    UILabel *lblDate=[[UILabel alloc]initWithFrame:CGRectMake(230, 0, 90, 30)];
    
    lblDate.backgroundColor=[UIColor clearColor];
    
    lblDate.text=[self convertTimeStampToDate:[[self.arrStartTime objectAtIndex:indexPath.row]valueForKey:@"starttime"]];
    
    lblDate.font=[UIFont boldSystemFontOfSize:13];
    
    lblDate.textColor=[UIColor blackColor];
    
    //lblDate.textAlignment=NSTextAlignmentRight;
    
    [cell.contentView addSubview:lblDate];
    
    // *******************************
    
    UIImageView *imgBG=[[UIImageView alloc]init];
    
    imgBG.frame=CGRectMake(10, 35, 240, 40);
    
    imgBG.backgroundColor=[UIColor whiteColor];
    
    [cell.contentView addSubview:imgBG];
    
    // ***************
    
    UIImageView *imgBGSide=[[UIImageView alloc]init];
    
    imgBGSide.frame=CGRectMake(240, 35, 60, 40);
    
    imgBGSide.backgroundColor=[UIColor colorWithRed:238.0f/255.0f green:238.0f/255.0f blue:238.0f/255.0f alpha:1.0f];
    
    [cell.contentView addSubview:imgBGSide];
    
    // ***************
    UILabel *lblStartTime=[[UILabel alloc]initWithFrame:CGRectMake(35, 45, 50, 30)];
    
    lblStartTime.backgroundColor=[UIColor clearColor];
    
    lblStartTime.text=[self convertTimeStampToHour:[[self.arrStartTime objectAtIndex:indexPath.row]valueForKey:@"starttime"]];
    
    
    lblStartTime.font=[UIFont boldSystemFontOfSize:15];
    
    lblStartTime.textColor=[UIColor blackColor];
    
    [cell.contentView addSubview:lblStartTime];

    // ***************
    
    // ***************
    UILabel *lblTo=[[UILabel alloc]initWithFrame:CGRectMake(110, 45, 35, 30)];
    
    lblTo.backgroundColor=[UIColor clearColor];
    
    lblTo.text=@"TO";
    
    lblTo.font=[UIFont boldSystemFontOfSize:15];
    
    lblTo.textColor=[UIColor darkGrayColor];
    
    [cell.contentView addSubview:lblTo];
    
    // ***************
    
    UILabel *lblEndTime=[[UILabel alloc]initWithFrame:CGRectMake(170, 45, 80, 30)];
    
    lblEndTime.backgroundColor=[UIColor clearColor];

    NSString *str=[[self.arrEndTime objectAtIndex:indexPath.row]valueForKey:@"endtime"];
    
    if (str.length!=0)
    {
   
        lblEndTime.text=[self convertTimeStampToHour:str];
        
        lblEndTime.textColor=[UIColor blackColor];

    }
    else
    {
        lblEndTime.text=@"NOW";
        
        lblEndTime.textColor=[UIColor darkGrayColor];

    }
    
    
    lblEndTime.font=[UIFont boldSystemFontOfSize:15];
    
    [cell.contentView addSubview:lblEndTime];
    
    // ***************

    
    
    // ***************
    
    UILabel *lblTotalTime=[[UILabel alloc]initWithFrame:CGRectMake(245, 45, 80, 30)];
    
    lblTotalTime.backgroundColor=[UIColor clearColor];
    
    if ( [lblEndTime.text isEqualToString:@"NOW"])
    {
    
    }
    else
    {
    NSString *vl=[self TotalHr:[[self.arrStartTime objectAtIndex:indexPath.row]valueForKey:@"starttime"] endTime:[[self.arrEndTime objectAtIndex:indexPath.row]valueForKey:@"endtime"]];
    
    lblTotalTime.text=[NSString stringWithFormat:@"%@",vl];
    }
    lblTotalTime.font=[UIFont boldSystemFontOfSize:15];
    
    lblTotalTime.textColor=[UIColor blackColor];
    
    [cell.contentView addSubview:lblTotalTime];
    
    // ***************
    return cell;

}

#pragma mark - Present Settingsview
-(void)presentSettingView{

    SettingsViewController *settingsView=[[SettingsViewController alloc]initWithNibName:@"SettingsViewController" bundle:nil];
    
    UINavigationController *navView=[[UINavigationController alloc]initWithRootViewController:settingsView];
    
    [app setAppearanceOfNavigationBar:navView];
    
    [self presentViewController:navView animated:YES completion:Nil];

}

#pragma mark - Present Settingsview
-(void)presentCalendarView
{
    
    if (isSearchActive)
    {
        isSearchActive =NO;
        
        [a1 setImage:[UIImage imageNamed:@"cal.png"] forState:UIControlStateNormal];
    
        [self refreshView];
        
    }
    else
    {
        
    CalenderViewController *calendarView=[[CalenderViewController alloc]initWithNibName:@"CalenderViewController" bundle:nil];
    
    UINavigationController *navView=[[UINavigationController alloc]initWithRootViewController:calendarView];
    
    [app setAppearanceOfNavigationBar:navView];
    
    [self presentViewController:navView animated:YES completion:Nil];
 
    }
}
#pragma mark - Refresh View
-(void)refreshView
{
    totalCnt=0;
    totalMnt=0;
    
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"LOCATION_LAT"])
    {
        
        if (isSearchActive)
        {
            NSArray *arStartTime=[app.skOject lookupAllForSQL:[NSString stringWithFormat:@"select starttime,locationId from sessions where startdate like '%@'",searchDate]];
            
            NSArray *arEndTime=[app.skOject lookupAllForSQL:[NSString stringWithFormat:@"select endtime from sessions where startdate like '%@'",searchDate]];
            
            self.arrStartTime=[[NSMutableArray alloc]initWithArray:arStartTime];
            
            self.arrEndTime=[[NSMutableArray alloc]initWithArray:arEndTime];
        
        }
        else
        {
            NSArray *arStartTime=[app.skOject lookupAllForSQL:@"select starttime,locationId from sessions"];
            
            NSArray *arEndTime=[app.skOject lookupAllForSQL:@"select endtime from sessions"];
            
            self.arrStartTime=[[NSMutableArray alloc]initWithArray:arStartTime];
            
            self.arrEndTime=[[NSMutableArray alloc]initWithArray:arEndTime];

        }
        
        [tblView reloadData];
    
    }
}
- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl
{

    [refreshControl endRefreshing];
    [self refreshView];

}
#pragma mark - Convet TimeStamp Tp Hour

// --------------------
// Calulate 2 time
// --------------------
-(NSString *)TotalHr :(NSString *)startTime endTime :(NSString *)endtime
{
    NSTimeInterval intervalStartTime=[startTime doubleValue];
    
    NSTimeInterval intervalEndTime=[endtime doubleValue];
    
    NSDate *dateStart = [NSDate dateWithTimeIntervalSince1970:intervalStartTime];
    
    NSDate *dateEnd = [NSDate dateWithTimeIntervalSince1970:intervalEndTime];
    
    NSTimeInterval interval = [dateEnd timeIntervalSinceDate:dateStart];
    
    
    totalCnt =totalCnt + (int)interval;
    
    int hours = (int)interval / 3600;
    // integer division to get the hours part
    int minutes = (interval - (hours*3600)) / 60;
    // interval minus hours part (in seconds) divided by 60 yields minutes
    
    NSString *timeDiff = [NSString stringWithFormat:@"%02d:%02d", hours, minutes];
    NSLog(@"timeDiff ::%@",timeDiff);
    
    // fot TotalTime
    // ********************
    hours = (int)totalCnt / 3600;
    minutes = (totalCnt - (hours*3600)) / 60;
    NSString *timeTotal = [NSString stringWithFormat:@"%02d:%02d", hours, minutes];
    lblTotal.text=timeTotal;
    // ********************
    
    return timeDiff;
}

-(NSString *)convertTimeStampToHour :(NSString *)strTimeStamp
{

    NSTimeInterval _interval=(NSTimeInterval)[strTimeStamp doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
    [_formatter setDateFormat:@"HH:mm"];
    NSString *_date=[_formatter stringFromDate:date];
    
    return _date;
}

-(NSString *)convertTimeStampToDate :(NSString *)strTimeStamp
{
    // divide value to 1000.
    
    NSTimeInterval _interval=(NSTimeInterval)[strTimeStamp doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];

    NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
    [_formatter setDateFormat:@"EEE, MMM dd"];
    NSString *_date=[_formatter stringFromDate:date];
    return _date;
}
-(NSString *)returnPlaceNameFromID :(int) valID
{
    NSString *strName;
  
    NSArray *arr= [app.skOject lookupAllForSQL:[NSString stringWithFormat:@"SELECT locationName FROM locationInfo where locationId = %d",valID]];
    if (arr.count==0)
    {
        return @"Place deleted";
        
    }
    strName=[[arr objectAtIndex:0]valueForKey:@"locationName"];
    
    return strName;
    
    
}

@end
