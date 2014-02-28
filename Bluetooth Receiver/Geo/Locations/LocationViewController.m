//
//  LocationViewController.m
//  Geo
//
//  Created by tirthesh.bhatt on 1/31/14.
//  Copyright (c) 2014 vishal khatri - AgileInfoWays. All rights reserved.
//

#import "LocationViewController.h"
#import "SearchLocationViewController.h"
#import "locationNameViewController.h"

@interface LocationViewController ()

@end

@implementation LocationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title =@"Location";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    isSearchActive=FALSE;
    
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem *rightBarbutton=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewLoaction)];
    
    rightBarbutton.tintColor=[UIColor whiteColor];
    
    //self.navigationItem.rightBarButtonItem=rightBarbutton;
    
    
    
    btnRightImg=[UIButton buttonWithType:UIButtonTypeCustom];
    btnRightImg.frame = CGRectMake(0.0, 0.0, 25, 25);
    [btnRightImg setImage:[UIImage imageNamed:@"edit.png"] forState:UIControlStateNormal];
    
    // Set the Target and Action for aButton
    [btnRightImg addTarget:self action:@selector(deleteRecordsFromDataBase) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * barButtonRight=[[UIBarButtonItem alloc]initWithCustomView:btnRightImg];

    // old
   // self.navigationItem.rightBarButtonItems=@[rightBarbutton,barButtonRight];
    
    self.navigationItem.rightBarButtonItem=rightBarbutton;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    NSArray *arrlocation = [app.skOject lookupAllForSQL:@"select * from locationInfo"];
    
    arrLocationlist = [[NSMutableArray alloc]initWithArray:arrlocation];
    
    [tblView reloadData];

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
    return arrLocationlist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle=UITableViewCellAccessoryNone;
    cell.backgroundColor=[UIColor whiteColor];
   
    cell.textLabel.text = [[arrLocationlist objectAtIndex:indexPath.row]valueForKey:@"locationName"];

    cell.detailTextLabel.text = [[arrLocationlist objectAtIndex:indexPath.row]valueForKey:@"deviceId"];
    cell.detailTextLabel.font=[UIFont systemFontOfSize:11];
    
    
    // *******************************************
    // add UISwitch Controller
    
    // **************************************************
    UISwitch *switchLocEnable = [[UISwitch alloc] initWithFrame: CGRectMake(226, 12, 60, 30)];
    switchLocEnable.tag=[[[arrLocationlist objectAtIndex:indexPath.row]valueForKey:@"locationId"]integerValue];
    
    [switchLocEnable setOn:[[[arrLocationlist objectAtIndex:indexPath.row]valueForKey:@"locationEnable"]boolValue]];
    
    [switchLocEnable addTarget: self action: @selector(flip:) forControlEvents: UIControlEventValueChanged];
    // Set the desired frame location of onoff here
    cell.accessoryView=switchLocEnable;
    [cell.contentView addSubview: switchLocEnable];

    // ******************************************
    
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}
#pragma mark - Deletes Row
// Determine whether a given row is eligible for reordering or not.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
	{
        
     
        int loc_Id=[[[arrLocationlist objectAtIndex:indexPath.row]valueForKey:@"locationId"]integerValue];
        
        NSString *strQuery=[NSString stringWithFormat:@"DELETE FROM locationInfo where locationId=%d",loc_Id];
        
        [app.skOject lookupAllForSQL:strQuery];
        
        NSString *strdelQuery=[NSString stringWithFormat:@"DELETE FROM sessions where locationId=%d",loc_Id];
        
        [app.skOject lookupAllForSQL:strdelQuery];
        
        [self viewWillAppear:YES];
    }
}

#pragma mark -  Location

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addNewLoaction
{
//    SearchLocationViewController *seachView=[[SearchLocationViewController alloc]initWithNibName:@"SearchLocationViewController" bundle:nil];
    
    locationNameViewController *locView=[[locationNameViewController alloc]initWithNibName:@"locationNameViewController" bundle:nil];
    
    locView.isCancelButtonNeed=YES;
    
    UINavigationController *navView=[[UINavigationController alloc]initWithRootViewController:locView];
    
    [app setAppearanceOfNavigationBar:navView];
    
    [self presentViewController:navView animated:YES  completion:Nil];

}

- (IBAction) flip: (id) sender
{
    UISwitch *onoff = (UISwitch *) sender;
    
    NSLog(@"onoff.tag ::%d",onoff.tag);
    
    NSString *strQuery=[NSString stringWithFormat:@"Update locationInfo set locationEnable='%d' where locationId=%d",onoff.on,onoff.tag];
   
    [app.skOject lookupAllForSQL:strQuery];
    
    NSLog(@"%@", onoff.on ? @"On" : @"Off");
    
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"STOP_TRACKING_TIME"];
    
    if (onoff.on)
    {
        NSString *strUpdateQuery=[NSString stringWithFormat:@"UPDATE locationInfo SET locationEnable = '0' WHERE locationId <> %d",onoff.tag];
    
        [app.skOject lookupAllForSQL:strUpdateQuery];
      
        [self viewWillAppear:YES];
       
        [app saveCurrentTimeWhenUserDisconnectedWithBleutoothDevice];
        
    }
    else
    {
        [self checkIsThereTrackingContinue:onoff.tag];
    
    }

}
-(void)deleteRecordsFromDataBase
{
    if (!isSearchActive)
    {
        [tblView setEditing:YES animated:YES];
        isSearchActive=TRUE;

        [btnRightImg setImage:[UIImage imageNamed:@"done1.png"] forState:UIControlStateNormal];
    }
    else
    {
        
        [tblView setEditing:NO animated:YES];
        isSearchActive=FALSE;
        [btnRightImg setImage:[UIImage imageNamed:@"edit.png"] forState:UIControlStateNormal];
    }
}

-(void)checkIsThereTrackingContinue :(int) locationId
{
 
    NSString *strCurrentUUIDTracking=[[NSUserDefaults standardUserDefaults]objectForKey:@"CURRENT_UUID_TRACK"];

    NSString *strQuery=[NSString stringWithFormat:@"select * from locationInfo where locationId=%d",locationId];
    
    NSArray *arrDetails= [app.skOject lookupAllForSQL:strQuery];

    NSString *strDatabseUUID=[[arrDetails objectAtIndex:0]valueForKey:@"deviceId"];
    
    if ([strCurrentUUIDTracking isEqualToString:strDatabseUUID])
    {
        [app saveCurrentTimeWhenUserDisconnectedWithBleutoothDevice];
    }
    
}

-(void)dealloc
{
 
}
@end
