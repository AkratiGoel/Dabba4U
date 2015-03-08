//
//  DabbaInfoVC.m
//  Dabba4U
//
//  Created by Akrati Goel on 3/6/15.
//  Copyright (c) 2015 Snapdeal.com. All rights reserved.
//

#import "DabbaInfoVC.h"
#import "AppDelegate.h"

@interface DabbaInfoVC ()

@end

@implementation DabbaInfoVC

@synthesize tagVal;

-(void)setData{
    AppDelegate *myDelegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];
    int indexNo = (int)self.tagVal;
    [nameLbl setText:[NSString stringWithFormat:@"%@",[[myDelegate.dataArr objectAtIndex:indexNo] objectForKey:@"name"]]];
    [phoneBtn setTitle:[NSString stringWithFormat:@"%@",[[myDelegate.dataArr objectAtIndex:indexNo] objectForKey:@"phone"]] forState:UIControlStateNormal];
    [addressLbl setText:[NSString stringWithFormat:@"%@",[[myDelegate.dataArr objectAtIndex:indexNo] objectForKey:@"address"]]];
    [noOfPeopleServedLbl setText:[NSString stringWithFormat:@"No. of people served: %@",[[myDelegate.dataArr objectAtIndex:indexNo] objectForKey:@"num_people"]]];
    BOOL isVeg = [[[myDelegate.dataArr objectAtIndex:indexNo] objectForKey:@"food_type"] boolValue];
    UIImage *vegImg = [UIImage imageNamed:@"veg.png"];
    UIImage *nvImg = [UIImage imageNamed:@"nv.png"];
    if (isVeg) {
        [foodTypeImgVw setImage:vegImg];
    }
    else{
        [foodTypeImgVw setImage:nvImg];
    }
}

+ (CGFloat)annotationPadding;
{
    return 10.0f;
}
+ (CGFloat)calloutHeight;
{
    return 40.0f;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
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

-(void)addAnnoations
{
    MKCoordinateSpan span = {.latitudeDelta =  0.8, .longitudeDelta =  0.8};
    if ([mapAnnotations count]!=0) {
        [mapAnnotations removeAllObjects];
    }
    AppDelegate *myDelegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];
    int indexNo = (int)self.tagVal;
    PFGeoPoint *location = [[myDelegate.dataArr objectAtIndex:indexNo] objectForKey:@"location"];
    float latitude = location.latitude; // returns object latitude
    float longitude = location.longitude; // returns object longitude
    
    coord.latitude = latitude;
    coord.longitude = longitude;
    
    MKCoordinateRegion region = {coord, span};
    [mapVw setRegion:region];
    MyMapPin *pin;
    pin = [[MyMapPin alloc] initWithCoords:coord];
    pin.title = [[myDelegate.dataArr objectAtIndex:indexNo] objectForKey:@"name"];
    pin.tagVal = indexNo;
    [mapAnnotations addObject:pin];
    
    [mapVw removeAnnotations:mapVw.annotations];  // remove any annotations that exist
    [mapVw addAnnotations:mapAnnotations];
}

-(void)viewDidAppear:(BOOL)animated{
    
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [mapVw setMapType:MKMapTypeStandard];
    
    // create out annotations array
    mapAnnotations = [[NSMutableArray alloc] init];
    
    //Get Data
    [self addAnnoations];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:(id)self];
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    
    [self setData];
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

-(IBAction)phoneAction:(id)sender{
    
}

@end
