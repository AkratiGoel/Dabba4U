//
//  DabbaInfoVC.h
//  Dabba4U
//
//  Created by Akrati Goel on 3/6/15.
//  Copyright (c) 2015 Snapdeal.com. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <MapKit/MapKit.h>
#import "MyMapPin.h"
#import <CoreLocation/CoreLocation.h>
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface DabbaInfoVC : UIViewController{
    IBOutlet MKMapView *mapVw;
    IBOutlet UIScrollView *scroller;
    IBOutlet UILabel *nameLbl;
    IBOutlet UIButton *phoneBtn;
    IBOutlet UILabel *addressLbl;
    IBOutlet UILabel *noOfPeopleServedLbl;
    IBOutlet UIImageView *foodTypeImgVw;
    CLLocationCoordinate2D coord;
    CLLocationManager *locationManager;
    NSMutableArray *mapAnnotations;
}

@property (assign) long tagVal;

-(IBAction)phoneAction:(id)sender;

@end
