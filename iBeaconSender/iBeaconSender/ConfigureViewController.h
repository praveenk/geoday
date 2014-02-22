//
//  ConfigureViewController.h
//  iBeaconSender
//
//  Created by henit.nathvani on 2/12/14.
//  Copyright (c) 2014 agilepc-105. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APLUUIDViewController.h"

#import <AudioToolbox/AudioToolbox.h>

@interface ConfigureViewController : UITableViewController


- (void)updateAdvertisedRegion;

- (IBAction)unwindUUIDSelector:(UIStoryboardSegue*)sender;


@end
