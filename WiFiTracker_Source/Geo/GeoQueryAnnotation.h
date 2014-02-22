//
//  GeoQueryAnnotation.h
//  Geolocations
//
//  Created by Saurabh Gupta on 1/15/13.
//  Copyright (c) 2012 Parse, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

/*
 *-------------------------------------------------------------------------------------------
 *	GeoQueryAnnotation is class used for when we drop pin on the map using long press gesture
 *-------------------------------------------------------------------------------------------
 */

@interface GeoQueryAnnotation : NSObject <MKAnnotation>

-(id)initWithCoordinate:(CLLocationCoordinate2D)dropPinLocation;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;

@end
