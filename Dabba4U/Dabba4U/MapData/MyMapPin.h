//
//  MyMapPin.h
//  Dabba4U
//
//  Created by Akrati Goel on 3/6/15.
//  Copyright (c) 2015 Snapdeal.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MyMapPin : NSObject <MKAnnotation> {
    CLLocationCoordinate2D coordinate;
    NSString *title;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic,retain) NSString *title;
@property (nonatomic) int tagVal;

- (id) initWithCoords:(CLLocationCoordinate2D) coords;

@end