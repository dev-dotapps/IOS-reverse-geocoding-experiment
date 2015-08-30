//
//  DetailViewController.h
//  Location Tester
//
//  Created by Ani Tumanyan on 2015-08-30.
//  Copyright (c) 2015 Ani Tumanyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@import GoogleMaps;

@interface DetailViewController : UIViewController<CLLocationManagerDelegate>


#define kBING_LOCATION_URL @"http://dev.virtualearth.net"
#define kBING_PARAMS @"o=json&key=Agt96zm2ZKqppqqTNUacgskpTi5Dt6jZ9fh7pk1MXTni1WvtOkyTAY-rvPNlP33I"


//http://dev.virtualearth.net/REST/V1/Locations/43.85332,-79.497061?o=xml&key=Agt96zm2ZKqppqqTNUacgskpTi5Dt6jZ9fh7pk1MXTni1WvtOkyTAY-rvPNlP33I

@property (nonatomic,strong) CLLocationManager *locationManager;

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UILabel *appleAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *googleAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *bingAddressLabel;

@end

