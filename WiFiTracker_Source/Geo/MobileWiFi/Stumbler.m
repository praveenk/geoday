//
//  SOLStumbler.m
//  Stumbler
//
//  Created by Bryan Bernhart on 1/6/10.
//  Copyright 2010 Bryan Bernhart. All rights reserved.
//      License: GNU General Public License
//

#import "Stumbler.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <SystemConfiguration/CaptiveNetwork.h>

#import <CoreTelephony/CoreTelephonyDefines.h>
#include <dlfcn.h>

@implementation Stumbler

- (id)init
{
    self = [super init];
    
    networks = [[NSMutableDictionary alloc] init];
    
//    libHandle = dlopen("/System/Library/SystemConfiguration/WiFiManager.bundle/WiFiManager", RTLD_LAZY);
    
    
//    libHandle = dlopen("/System/Library/SystemConfiguration/IPConfiguration.bundle/IPConfiguration", RTLD_LAZY);

    libHandle = dlopen("/System/Library/SystemConfiguration/IPConfiguration.bundle/IPConfiguration", RTLD_LAZY);

    char *error;
    if (libHandle == NULL && (error = dlerror()) != NULL)  {
        NSLog(@"%s",error);
//        exit(1);
    }
    
    
    apple80211Open = dlsym(libHandle, "Apple80211Open");
    apple80211Bind = dlsym(libHandle, "Apple80211BindToInterface");
    apple80211Close = dlsym(libHandle, "Apple80211Close");
    apple80211Scan = dlsym(libHandle, "Apple80211Scan");
    
    apple80211Open(&airportHandle);
    apple80211Bind(airportHandle, @"en0");
    
    return self;
}

- (NSDictionary *)network:(NSString *) BSSID
{
    return [networks objectForKey:@"BSSID"];
}

- (NSDictionary *)networks
{
    return networks;
}

- (void)scanNetworks
{
    NSLog(@"Scanning WiFi Channels...");
    
//    NSDictionary *parameters = [[NSDictionary alloc] init];
//    NSArray *scan_networks;
    //is a CFArrayRef of CFDictionaryRef(s) containing key/value data on each discovered network
    CFArrayRef myArray1 = CNCopySupportedInterfaces();
    NSMutableArray *data = [(__bridge NSArray *) myArray1 mutableCopy];
    CFDictionaryRef myDict = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray1, 0));
    NSLog(@"%@",myDict);
    apple80211Scan(airportHandle, &data, &myDict);

    for (int i = 0; i < [data count]; i++) {
        [networks setObject:[data objectAtIndex: i] forKey:[[data objectAtIndex: i] objectForKey:@"BSSID"]];
    }
    NSLog(@"Scanning WiFi Channels Finished.");
}

- (int)numberOfNetworks
{
    return [networks count];
}

- ( NSString * ) description {
    
    NSMutableString *result = [[NSMutableString alloc] initWithString:@"Networks State: \n"];
    
    for (id key in networks){
        
        [result appendString:[NSString stringWithFormat:@"%@ (MAC: %@), RSSI: %@, Channel: %@ \n",
                              [[networks objectForKey: key] objectForKey:@"SSID_STR"], //Station Name
                              key, //Station BBSID (MAC Address)
                              [[networks objectForKey: key] objectForKey:@"RSSI"], //Signal Strength
                              [[networks objectForKey: key] objectForKey:@"CHANNEL"]  //Operating Channel
                              ]];
    }
    
    return [NSString stringWithString:result];
}

- (void) dealloc {
    apple80211Close(airportHandle);
//    [super dealloc];
}


@end