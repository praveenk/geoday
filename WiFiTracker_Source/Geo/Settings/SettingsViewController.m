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

-(void)viewWillAppear:(BOOL)animated{

    
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
    
    return 2;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle=UITableViewCellAccessoryNone;
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Networks";
    }
    else
    {
        cell.textLabel.text = @"Export Data";
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
    else
    {
        [self SendMail];
    }
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
