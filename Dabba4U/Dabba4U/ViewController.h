//
//  ViewController.h
//  Dabba4U
//
//  Created by Akrati Goel on 3/6/15.
//  Copyright (c) 2015 Snapdeal.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <MapKit/MapKit.h>
#import "MyMapPin.h"
#import <CoreLocation/CoreLocation.h>
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface ViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate>{
    IBOutlet UIButton *donateDabbaBtn;
    IBOutlet MKMapView *mapVw;
    NSMutableArray *mapAnnotations;
    CLLocationCoordinate2D coord;
    CLLocationManager *locationManager;
}

-(IBAction)infoAction:(id)sender;
-(IBAction)viewListingClicked:(id)sender;
-(IBAction)donateDabbaClicked:(id)sender;

@end