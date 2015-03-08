//
//  DonateDabbaFormVC.m
//  Dabba4U
//
//  Created by Akrati Goel on 3/6/15.
//  Copyright (c) 2015 Snapdeal.com. All rights reserved.
//

#import "DonateDabbaFormVC.h"
#import <Parse/Parse.h>

@interface DonateDabbaFormVC ()

@end

@implementation DonateDabbaFormVC

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    
    if (newLocation != nil) {
        currentLocation = newLocation;
        [locationManager stopUpdatingLocation];
    }
    
    NSLog(@"Resolving the Address");
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            
            NSString *addStr = [NSString stringWithFormat:@"%@, %@\n%@, %@\n%@, %@", placemark.subLocality,placemark.locality,placemark.subAdministrativeArea,placemark.administrativeArea,placemark.postalCode,placemark.country];
            
            addressTxtVw.text = addStr;
            
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
}

-(void)getCurrentLocation {
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];
}

-(IBAction)pickupAddAction:(UIButton*)sender{
    pickFromCurrentLocation = !pickFromCurrentLocation;
    
    if (pickFromCurrentLocation) {
        [self getCurrentLocation];
        [currentLocationBtn setImage:radioBtn_on_img forState:UIControlStateNormal];
        [manualAddressBtn setImage:radioBtn_off_img forState:UIControlStateNormal];
    }
    else{
        [currentLocationBtn setImage:radioBtn_off_img forState:UIControlStateNormal];
        [manualAddressBtn setImage:radioBtn_on_img forState:UIControlStateNormal];
    }
}

-(IBAction)foodTypeAction:(UIButton*)sender{
    isVeg = !isVeg;
    if (isVeg) {
        [vegBtn setImage:radioBtn_on_img forState:UIControlStateNormal];
        [n_vegBtn setImage:radioBtn_off_img forState:UIControlStateNormal];
    }
    else{
        [vegBtn setImage:radioBtn_off_img forState:UIControlStateNormal];
        [n_vegBtn setImage:radioBtn_on_img forState:UIControlStateNormal];
    }
}


#pragma mark- Validate email id

- (BOOL)emailRegEx:(NSString *)string {
    
    // lowercase the email for proper validation
    string = [string lowercaseString];
    // regex for email validation
    NSString *emailRegEx =@"[A-Z0-9a-z._%+-]{1,24}@[A-Za-z0-9.-]{2,20}\\.[A-Za-z]{2,4}";
    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:string];
    
    return myStringMatchesRegEx;
}

-(BOOL)validatePhoneNumber:(NSString *)phoneStr{
    NSString *regex = @"[0-9]+(-[0-9]+)?";
    NSPredicate *testRegex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if([testRegex evaluateWithObject:phoneStr]){
        if ([phoneStr length]==10) {
            return TRUE;
        }
        else{
            return FALSE;
        }
    }
    else
        return FALSE;
}

-(BOOL)isNumeric:(NSString*)inputString
{
    NSCharacterSet *cs=[[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSString *filtered;
    filtered = [[inputString componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return [inputString isEqualToString:filtered];
}

-(BOOL)validateData{
    BOOL isOK = YES;
    if ([nameTxtField.text isEqualToString:@""]) {
        isOK = NO;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"Please enter your name."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    if (isOK) {
        if ([phoneTxtField.text isEqualToString:@""]) {
            isOK = NO;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"Please enter your mobile number."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    if (isOK) {
        if (![self validatePhoneNumber:phoneTxtField.text]) {
            isOK = NO;
            phoneTxtField.text = @"";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"Please enter a valid 10-digits mobile number"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    if (isOK) {
        if (![self isNumeric:phoneTxtField.text]) {
            isOK = NO;
            phoneTxtField.text = @"";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"Please enter a valid 10-digits mobile number"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    if (isOK) {
        if (([addressTxtVw.text isEqualToString:@""]) ||([addressTxtVw.text isEqualToString:@"Pickup address"])){
            isOK = NO;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"Please enter the address for pickup."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    if (isOK) {
        if ([noOfPeopleServedTxtField.text isEqualToString:@""]) {
            isOK = NO;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"Please enter number of people your dabba would serve (approx.)."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    if (isOK) {
        if (![self isNumeric:noOfPeopleServedTxtField.text]) {
            isOK = NO;
            noOfPeopleServedTxtField.text = @"";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"Number of people your dabba would serve should be in number."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    if (isOK) {
        if ([noOfPeopleServedTxtField.text intValue]<5) {
            isOK = NO;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"Number of people your dabba would serve is less than 5. Please donate your dabba to any needy near you :-)"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    return isOK;
}

- (CLLocationCoordinate2D) geoCodeUsingAddress:(NSString *)address
{
    double latitude = 0, longitude = 0;
    NSString *esc_addr =  [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result) {
        NSScanner *scanner = [NSScanner scannerWithString:result];
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
            [scanner scanDouble:&latitude];
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                [scanner scanDouble:&longitude];
            }
        }
    }
    CLLocationCoordinate2D center;
    center.latitude = latitude;
    center.longitude = longitude;
    return center;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ((alertView.tag == 9)&&(buttonIndex == 0))
    {
        [self.navigationController popViewControllerAnimated:TRUE];
    }
}

-(void)donateDabba{
    NSNumber *phoneNum = [NSNumber numberWithLongLong:[phoneTxtField.text longLongValue]];
    PFObject *parseObj = [PFObject objectWithClassName:@"Dabba"];
    parseObj[@"name"] = nameTxtField.text;
    parseObj[@"phone"] = phoneNum;
    parseObj[@"address"] = addressTxtVw.text;
    if (isVeg) {
        parseObj[@"food_type"] = [NSNumber numberWithBool:TRUE];
    }
    else {
        parseObj[@"food_type"] = [NSNumber numberWithBool:FALSE];
    }
    parseObj[@"num_people"] = [NSNumber numberWithInt:[noOfPeopleServedTxtField.text intValue]];
    
    PFGeoPoint *geopoint;
    if (currentLocation) {
    }
    else {
        CLLocationCoordinate2D coord = [self geoCodeUsingAddress:addressTxtVw.text];
        currentLocation = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
    }
    geopoint = [PFGeoPoint geoPointWithLocation:currentLocation];
    parseObj[@"location"] = geopoint;
    [parseObj saveInBackground];
    if ([parseObj save]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"We have received your request"
                                                        message:@"Thanks for donating your Dabba :-)"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert setTag:9];
        [alert show];
    }
}

-(IBAction)donateDabbaClicked:(UIButton*)sender{
    BOOL isOK = [self validateData];
    if (isOK) {
        [self donateDabba];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Pickup address"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Pickup address";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}

-(void)setUI{
    [self setTitle:@"Donate my Dabba"];
    
    pickFromCurrentLocation = FALSE;
    isVeg = TRUE;
    
    [addressTxtVw setBackgroundColor:[UIColor whiteColor]];
    [addressTxtVw.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [addressTxtVw.layer setBorderWidth:2.0];
    [addressTxtVw.layer setCornerRadius:2.0];
    addressTxtVw.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    addressTxtVw.text = @"Pickup address";
    [addressTxtVw setDelegate:self];
    addressTxtVw.textColor = [UIColor lightGrayColor];
    
    radioBtn_off_img = [UIImage imageNamed:@"radioBtn_off.png"];
    radioBtn_on_img = [UIImage imageNamed:@"radioBtn_on.png"];
    
    [donateDabbaBtn setTitleColor:[UIColor colorWithRed:0.082 green:0.494 blue:0.984 alpha:1] forState:UIControlStateNormal];
    [donateDabbaBtn.layer setCornerRadius:3.0f];
    [donateDabbaBtn.layer setBorderWidth:2.0f];
    [donateDabbaBtn.layer setBorderColor:[[UIColor colorWithRed:0.082 green:0.494 blue:0.984 alpha:1] CGColor]];
    
    [activityVw setHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUI];
    locationManager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [locationManager requestAlwaysAuthorization];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
