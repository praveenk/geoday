//
//  locationNameViewController.h
//  Geo
//
//  Created by vishal Khatri on 1/30/14.
//  Copyright (c) 2014 vishal khatri - AgileInfoWays. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface locationNameViewController : UIViewController
{
    AppDelegate *app;
    
    IBOutlet UIButton *buttonSave;
}

@property (retain, nonatomic) IBOutlet UITextField *txtField;
@property (weak, nonatomic) IBOutlet UILabel *labelCurrentWiFi;
@property (nonatomic,readwrite) BOOL  isCancelButtonNeeded;

- (IBAction)buttonSaveCurrentWiFi:(id)sender;

@end
