//
//  LocationViewController.h
//  Geo
//
//  Created by tirthesh.bhatt on 1/31/14.
//  Copyright (c) 2014 vishal khatri - AgileInfoWays. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "locationNameViewController.h"
@interface LocationViewController : UIViewController{
    
    IBOutlet UITableView *tblView;
    NSMutableArray *arrLocationlist;
    AppDelegate *app;
    BOOL isSearchActive;
    UIButton *btnRightImg;
    
}

@end
