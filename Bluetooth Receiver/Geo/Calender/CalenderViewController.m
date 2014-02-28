    //
//  CalenderViewController.m
//  Geo
//
//  Created by tirthesh.bhatt on 2/3/14.
//  Copyright (c) 2014 vishal khatri - AgileInfoWays. All rights reserved.
//

#import "CalenderViewController.h"

@interface CalenderViewController ()

@end

@implementation CalenderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.title= @"Jump to Date";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    calendarView.delegate = self;
    
    UIBarButtonItem *rightBarbutton=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(DoneButton)];
    
    rightBarbutton.tintColor=[UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem=rightBarbutton;
    
    
    UIBarButtonItem *leftBarbutton=[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButton)];
    
    rightBarbutton.tintColor=[UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem=leftBarbutton;


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)DoneButton
{
//    NSArray *arrstarttime =[app.skOject lookupAllForSQL:@"select starttime,sessionid from sessions"];
//    NSString * result = [[arrstarttime valueForKey:@"starttime"] componentsJoinedByString:@","];
//    
//    [self convertTimeStampToDate:result];

    isSearchActive=YES;
    
     [self dismissViewControllerAnimated:YES completion:nil];
    

}
-(void)cancelButton
{

    isSearchActive=NO;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Time to Date covert method
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
#pragma mark - DSLCalendarViewDelegate methods

- (void)calendarView:(DSLCalendarView *)calendarView didSelectRange:(DSLCalendarRange *)range {
    if (range != nil)
    {
        NSLog( @"Selected %@ - %@", range.strStart, range.strEnd);
        
        NSTimeInterval _interval=(NSTimeInterval)[range.strStart doubleValue];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
        NSDateFormatter *df = [NSDateFormatter new];
        //Create the date assuming the given string is in GMT (SERVER TIME HERE)
        [df setDateFormat:@"EEE, MMM dd, yyyy"];
        NSString *serverDateString = [df stringFromDate:date];
        lbldate.text = [NSString stringWithFormat:@"%@", serverDateString];
        
        [df setDateFormat:@"dd-MM-YYYY"];
        searchDate = [df stringFromDate:date];
        
        
    
    }
    else {
        NSLog( @"No selection" );
    }
}

- (DSLCalendarRange*)calendarView:(DSLCalendarView *)calendarView didDragToDay:(NSDateComponents *)day selectingRange:(DSLCalendarRange *)range {
    if (NO) { // Only select a single day
        return [[DSLCalendarRange alloc] initWithStartDay:day endDay:day];
    }
    else if (NO) { // Don't allow selections before today
        NSDateComponents *today = [[NSDate date] dslCalendarView_dayWithCalendar:calendarView.visibleMonth.calendar];
        
        NSDateComponents *startDate = range.startDay;
        NSDateComponents *endDate = range.endDay;
        
        if ([self day:startDate isBeforeDay:today] && [self day:endDate isBeforeDay:today]) {
            return nil;
        }
        else {
            if ([self day:startDate isBeforeDay:today]) {
                startDate = [today copy];
            }
            if ([self day:endDate isBeforeDay:today]) {
                endDate = [today copy];
            }
            
            return [[DSLCalendarRange alloc] initWithStartDay:startDate endDay:endDate];
        }
    }
    
    return range;
}

- (void)calendarView:(DSLCalendarView *)calendarView willChangeToVisibleMonth:(NSDateComponents *)month duration:(NSTimeInterval)duration {
    NSLog(@"Will show %@ in %.3f seconds", month, duration);
}

- (void)calendarView:(DSLCalendarView *)calendarView didChangeToVisibleMonth:(NSDateComponents *)month {
    NSLog(@"Now showing %@", month);
}

- (BOOL)day:(NSDateComponents*)day1 isBeforeDay:(NSDateComponents*)day2 {
    return ([day1.date compare:day2.date] == NSOrderedAscending);
}

@end
