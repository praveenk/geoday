//
//  SettingsViewController.m
//  Geo
//
//  Created by tirthesh.bhatt on 1/31/14.
//  Copyright (c) 2014 vishal khatri - AgileInfoWays. All rights reserved.
//

#import "SettingsViewController.h"
#import "LocationViewController.h"
@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Settings";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // **************************************************
    // bar button item right
    // **************************************************
    
    UIBarButtonItem *rightBarbutton= [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
    rightBarbutton.tintColor=[UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem=rightBarbutton;
    

}

-(void)viewWillAppear:(BOOL)animated
{
    
}

#pragma mark -Rightbarbutton item

-(void)done{
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
    
    return 4;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle=UITableViewCellAccessoryNone;
    

    switch (indexPath.row)
    {
        case 0:
            cell.textLabel.text = @"Location";
            break;

        case 1:
            cell.textLabel.text = @"Export Data";
            break;

        case 2:
            cell.textLabel.text = @"Value A";
            cell.detailTextLabel.text=[[NSUserDefaults standardUserDefaults]valueForKey:@"VALUE_A"];
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            break;

        case 3:
            cell.textLabel.text = @"Value B";
            cell.detailTextLabel.text=[[NSUserDefaults standardUserDefaults]valueForKey:@"VALUE_B"];
            cell.accessoryType = UITableViewCellAccessoryNone;
            break;

    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        LocationViewController *locationVw = [[LocationViewController alloc]initWithNibName:@"LocationViewController" bundle:nil];
        [self.navigationController pushViewController:locationVw animated:YES];
    }
    else if (indexPath.row==1)
    {
        [self SendMail];
    }
    else if (indexPath.row==2)
    {
    
        UIActionSheet *action=[[UIActionSheet alloc]initWithTitle:@"Geo Day" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:Nil otherButtonTitles:@"Near",@"Immediate", nil];
        
        action.tag=1;
        
        [action showInView:self.view];
        
        
    }
    else if (indexPath.row==3)
    {
        UIActionSheet *action=[[UIActionSheet alloc]initWithTitle:@"Geo Day" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:Nil otherButtonTitles:@"Unknown",@"Far", nil];
        
        action.tag=2;
        
        [action showInView:self.view];
    
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (actionSheet.tag==1)
    {
        if (buttonIndex==0)
        {
            NSLog(@"Near");
            
            [[NSUserDefaults standardUserDefaults]setObject:@"Near" forKey:@"VALUE_A"];
           
        }
        else if (buttonIndex==1)
        {
            NSLog(@"Immediate");
            
            [[NSUserDefaults standardUserDefaults]setObject:@"Immediate" forKey:@"VALUE_A"];
        }
        else if (buttonIndex==2)
        {
            NSLog(@"Cancel Click");
        }

    }
    else
    {
        if (buttonIndex==0)
        {
           NSLog(@"Unknown");
          [[NSUserDefaults standardUserDefaults]setObject:@"Unknown" forKey:@"VALUE_B"];
        
        }
        else if (buttonIndex==1)
        {
            NSLog(@"Far");
            [[NSUserDefaults standardUserDefaults]setObject:@"Far" forKey:@"VALUE_B"];
        }
        else if (buttonIndex==2)
        {
            NSLog(@"Cancel Click");
        }
    
    }
    
    [tblView reloadData];
    

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)SendMail
{
    [app.skOject MakeCSVFromDatabase:@"SELECT locationinfo.locationName,sessions.starttime,sessions.endtime FROM sessions LEFT JOIN locationinfo ON locationinfo.locationId = sessions.locationId"];
    
    NSError *error = nil;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *fullPath = [[paths lastObject] stringByAppendingPathComponent:@"location.csv"];
//    NSURL *csvURL = [NSURL URLWithString:fullPath];
    NSData *csvData = [NSData dataWithContentsOfFile:fullPath];
    
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
        if(mailController!=nil) {
            mailController.mailComposeDelegate = self;
            
            
            [mailController addAttachmentData:csvData mimeType:@"text/csv" fileName:@"RepliconGeoData.csv"];
            
            
            [mailController setSubject:@"Export CSV File"];
            mailController.mailComposeDelegate = self;
            [mailController setMessageBody:@"Please check" isHTML:NO];
            [self presentViewController:mailController animated:YES completion:nil];
        }
    }
    // Present mail view controller on screen

}
#pragma mark Mfmail Delegate method
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
        {
            NSLog(@"Mail sent");
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"GeoDay" message:@"Mail Sent" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            //[alert show];
            break;
        }
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
