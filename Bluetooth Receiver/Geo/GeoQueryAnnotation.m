//
//  GeoQueryAnnotation.m
//  Geolocations
//
//  Created by Saurabh on 1/15/13.
//  Copyright (c) 2012 Parse, Inc. All rights reserved.
//

#import "GeoQueryAnnotation.h"

@implementation GeoQueryAnnotation
@synthesize coordinate = _coordinate;
@synthesize title = _title;
@synthesize subtitle = _subtitle;

#pragma mark - NSObject
-(id)initWithCoordinate:(CLLocationCoordinate2D)dropPinLocation{
    
    self = [super init];
    if (self) {
        _coordinate=dropPinLocation;
        [self configureLabels];
    }
    return self;
}


#pragma mark - MKAnnotation

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    _coordinate = newCoordinate;
    [self configureLabels];
}


#pragma mark - ()

- (void)configureLabels {
    _title = @"Add Annotation";
}

@end
