//
//  SettingsViewController.h
//  Geo
//
//  Created by tirthesh.bhatt on 1/31/14.
//  Copyright (c) 2014 vishal khatri - AgileInfoWays. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <MessageUI/MessageUI.h>

@interface SettingsViewController : UIViewController<MFMailComposeViewControllerDelegate>
{

    IBOutlet UITableView *tblView;
    AppDelegate *app;
}

@end
