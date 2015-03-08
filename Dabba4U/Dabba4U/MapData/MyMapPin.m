//
//  MyMapPin.m
//  Dabba4U
//
//  Created by Akrati Goel on 3/6/15.
//  Copyright (c) 2015 Snapdeal.com. All rights reserved.
//

#import "MyMapPin.h"


@implementation MyMapPin

@synthesize coordinate;
@synthesize title;

- (id) initWithCoords:(CLLocationCoordinate2D) coords {
    self = [super init];
    if (self != nil) {
        coordinate = coords; 
    }
    return self;
}

@end
