//
//  ViewController.m
//  Dabba4U
//
//  Created by Akrati Goel on 3/6/15.
//  Copyright (c) 2015 Snapdeal.com. All rights reserved.
//

#import "ViewController.h"
#import "AboutAppVC.h"
#import "DonateDabbaFormVC.h"
#import "DabbaListingVC.h"
#import <Parse/Parse.h>
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

-(void)setUI{
    [self setTitle:@"Dabba4U"];
    
    UIButton *infoBtn = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [infoBtn addTarget:self action:@selector(infoAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc]initWithCustomView:infoBtn];
    [self.navigationItem setLeftBarButtonItem:leftBarBtn];
    
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc]init];
    [rightBarBtn setImage:[UIImage imageNamed:@"Listing.png"]];
    [rightBarBtn setTarget:self];
    [rightBarBtn setAction:@selector(viewListingClicked:)];
    [self.navigationItem setRightBarButtonItem:rightBarBtn];
    
    [donateDabbaBtn setTitleColor:[UIColor colorWithRed:0.082 green:0.494 blue:0.984 alpha:1] forState:UIControlStateNormal];
    [donateDabbaBtn.layer setCornerRadius:3.0f];
    [donateDabbaBtn.layer setBorderWidth:2.0f];
    [donateDabbaBtn.layer setBorderColor:[[UIColor colorWithRed:0.082 green:0.494 blue:0.984 alpha:1] CGColor]];
}

+ (CGFloat)annotationPadding;
{
    return 10.0f;
}
+ (CGFloat)calloutHeight;
{
    return 40.0f;
}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // if it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // handle our custom annotations
    //
    if ([annotation isKindOfClass:[MyMapPin class]])
    {
        MyMapPin *castedObject = (MyMapPin *)annotation;
        
        // try to dequeue an existing pin view first
        static NSString* MyMapPinIdentifier = @"MyMapPinIdentifier";
        MKPinAnnotationView* pinView = (MKPinAnnotationView *)
        [mapVw dequeueReusableAnnotationViewWithIdentifier:MyMapPinIdentifier];
        if (!pinView)
        {
            // if an existing pin view was not available, create one
            MKPinAnnotationView* customPinView = [[MKPinAnnotationView alloc]
                                                  initWithAnnotation:annotation reuseIdentifier:MyMapPinIdentifier];
            customPinView.canShowCallout = YES;
            customPinView.opaque = NO;
            [customPinView setTag:[castedObject tagVal]];
            [customPinView setPinColor:MKPinAnnotationColorPurple];
            return customPinView;
        }
        else{
            pinView.annotation = annotation;
        }
        return pinView;
    }
    return nil;
}

-(void)addAnnoations
{
    MKCoordinateSpan span = {.latitudeDelta =  0.8, .longitudeDelta =  0.8};
    if ([mapAnnotations count]!=0) {
        [mapAnnotations removeAllObjects];
    }
    
    AppDelegate *myDelegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    for (int i=0; i<[myDelegate.dataArr count]; i++) {
        PFGeoPoint *location = [[myDelegate.dataArr objectAtIndex:i] objectForKey:@"location"];
        float latitude = location.latitude; // returns object latitude
        float longitude = location.longitude; // returns object longitude
        
        coord.latitude = latitude;
        coord.longitude = longitude;
        
        MKCoordinateRegion region = {coord, span};
        [mapVw setRegion:region];
        MyMapPin *pin;
        pin = [[MyMapPin alloc] initWithCoords:coord];
        pin.title = [[myDelegate.dataArr objectAtIndex:i] objectForKey:@"name"];
        pin.tagVal = i;
        [mapAnnotations addObject:pin];
    }

    [mapVw removeAnnotations:mapVw.annotations];  // remove any annotations that exist
    [mapVw addAnnotations:mapAnnotations];
}

-(void)getData{
    AppDelegate *myDelegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];
    PFQuery *query = [PFQuery queryWithClassName:@"Dabba"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        myDelegate.dataArr = [[NSMutableArray alloc]initWithArray:objects];
        [self addAnnoations];
    }];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"Getting Location");
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        mapVw.showsUserLocation = YES;
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%@", error.localizedDescription);
}

-(void)viewDidAppear:(BOOL)animated{
    
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [mapVw setMapType:MKMapTypeStandard];
    
    // create out annotations array
    mapAnnotations = [[NSMutableArray alloc] init];
    
    //Get Data
    [self getData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:(id)self];
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    
    [self setUI];
}

-(IBAction)donateDabbaClicked:(id)sender{
    DonateDabbaFormVC *donateDabbaFormVC = [[DonateDabbaFormVC alloc]initWithNibName:@"DonateDabbaFormVC" bundle:nil];
    [self.navigationController pushViewController:donateDabbaFormVC animated:YES];
}

-(IBAction)infoAction:(id)sender{
    AboutAppVC *aboutAppVC = [[AboutAppVC alloc]initWithNibName:@"AboutAppVC" bundle:nil];
    [self.navigationController pushViewController:aboutAppVC animated:YES];
}

-(IBAction)viewListingClicked:(id)sender{
    DabbaListingVC *dabbaListingVC = [[DabbaListingVC alloc]initWithNibName:@"DabbaListingVC" bundle:nil];
    [self.navigationController pushViewController:dabbaListingVC animated:YES];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    mapAnnotations = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
