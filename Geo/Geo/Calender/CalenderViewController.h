//
//  CalenderViewController.h
//  Geo
//
//  Created by tirthesh.bhatt on 2/3/14.
//  Copyright (c) 2014 vishal khatri - AgileInfoWays. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSLCalendarView.h"
#import "AppDelegate.h"
@interface CalenderViewController : UIViewController<DSLCalendarViewDelegate>{

    IBOutlet DSLCalendarView *calendarView;
    IBOutlet UILabel *lbldate;
    AppDelegate *app;
    
    NSString *searchDateWithFormat;
    
}

@end
