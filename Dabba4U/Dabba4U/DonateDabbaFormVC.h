//
//  DonateDabbaFormVC.h
//  Dabba4U
//
//  Created by Akrati Goel on 3/6/15.
//  Copyright (c) 2015 Snapdeal.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface DonateDabbaFormVC : UIViewController <UITextFieldDelegate,UITextViewDelegate,CLLocationManagerDelegate,UIAlertViewDelegate>{
    IBOutlet UIScrollView *scroller;
    IBOutlet UITextField *nameTxtField;
    IBOutlet UITextField *phoneTxtField;
    IBOutlet UITextView *addressTxtVw;
    IBOutlet UITextField *noOfPeopleServedTxtField;
    BOOL pickFromCurrentLocation;
    IBOutlet UIButton *currentLocationBtn;
    IBOutlet UIButton *manualAddressBtn;
    BOOL isVeg;
    IBOutlet UIButton *vegBtn;
    IBOutlet UIButton *n_vegBtn;
    IBOutlet UIActivityIndicatorView *activityVw;
    IBOutlet UIButton *donateDabbaBtn;
    UIImage *radioBtn_off_img;
    UIImage *radioBtn_on_img;
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
}

-(IBAction)pickupAddAction:(id)sender;
-(IBAction)foodTypeAction:(id)sender;
-(IBAction)donateDabbaClicked:(id)sender;

@end
