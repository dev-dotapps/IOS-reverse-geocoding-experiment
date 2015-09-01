//
//  DetailViewController.m
//  Location Tester
//
//  Created by Ani Tumanyan on 2015-08-30.
//  Copyright (c) 2015 Ani Tumanyan. All rights reserved.
//

#import "DetailViewController.h"
#import "AFNetworking/AFHTTPSessionManager.h"


@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self activateLocationServices];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)activateLocationServices {
    if (self.locationManager == nil)
    {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = 10;
        
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
        {
            [self.locationManager requestWhenInUseAuthorization];
        }
    }
    
    [self.locationManager startUpdatingLocation];
    
}

#pragma mark - Location Services

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //[self.locationManager stopUpdatingLocation];
    
    CLLocation *location = [locations lastObject];
    CLLocationDegrees lat = location.coordinate.latitude;
    CLLocationDegrees lng = location.coordinate.longitude;
    
    NSString *position = [NSString stringWithFormat:@"(%f, %f)", lat, lng];
    self.positionLabel.text = position;
    
    // Set Apple's reverse geo location
    [self appleReverseGeoLocation:lat longitude:lng];
    
    // Set Google's reverse geo location
    [self googleReverseGeoLocation:lat longitude:lng];
    
    // Set Bing's reverse geo location
    [self bingReverseGeoLocation:lat longitude:lng];
}

- (void)appleReverseGeoLocation:(CLLocationDegrees) ltd longitude:(CLLocationDegrees)lng
{
    NSMutableArray *addresses = [NSMutableArray array];
    
    CLGeocoder *ceo = [[CLGeocoder alloc] init];
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:ltd longitude:lng];
    
    [ceo reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if (error == nil && [placemarks count] > 0)
        {
            for (CLPlacemark *placemark in placemarks) {
                NSArray *lines = placemark.addressDictionary[@"FormattedAddressLines"];
                NSString *addressString = [lines componentsJoinedByString:@", "];
                [addresses addObject:addressString];
            }
        }
        
        self.appleAddressLabel.text = [self stringify:addresses];
    }];
}

- (void)googleReverseGeoLocation:(CLLocationDegrees) ltd longitude:(CLLocationDegrees)lng
{
    NSMutableArray *addresses = [NSMutableArray array];
    
    [[GMSGeocoder geocoder] reverseGeocodeCoordinate:CLLocationCoordinate2DMake(ltd, lng) completionHandler:^(GMSReverseGeocodeResponse* response, NSError* error) {
        for(GMSAddress* addressObj in [response results])
        {
            NSLog(@"coordinate.latitude=%f", addressObj.coordinate.latitude);
            NSLog(@"coordinate.longitude=%f", addressObj.coordinate.longitude);
            NSLog(@"thoroughfare=%@", addressObj.thoroughfare);
            NSLog(@"locality=%@", addressObj.locality);
            NSLog(@"subLocality=%@", addressObj.subLocality);
            NSLog(@"administrativeArea=%@", addressObj.administrativeArea);
            NSLog(@"postalCode=%@", addressObj.postalCode);
            NSLog(@"country=%@", addressObj.country);
            NSLog(@"lines=%@", addressObj.lines);
            NSString *addressString = [addressObj.lines componentsJoinedByString:@", "];
            [addresses addObject:addressString];
        }
        
        self.googleAddressLabel.text = [self stringify:addresses];
    }];
}

- (void)bingReverseGeoLocation:(CLLocationDegrees) ltd longitude:(CLLocationDegrees)lng
{
    NSMutableArray *addresses = [NSMutableArray array];
    
    // 1
    NSURL *baseURL = [NSURL URLWithString:kBING_LOCATION_URL];
    
    // 2
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    // 3
    NSString *locationParams = [NSString stringWithFormat:@"/REST/V1/Locations/%f,%f?%@", ltd, lng, kBING_PARAMS];
    
    [manager GET:locationParams parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *response = (NSDictionary*)responseObject;
            if (response[@"resourceSets"] != nil && response[@"resourceSets"][0][@"estimatedTotal"] > 0) {
                NSArray *locations = response[@"resourceSets"][0][@"resources"];
                
                for(NSDictionary* addressObj in locations) {
                    [addresses addObject:addressObj[@"name"]];
                }
                
                self.bingAddressLabel.text = [self stringify:addresses];
            } else {
                self.bingAddressLabel.text = @"Nothing found";
            }
            
            
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        self.bingAddressLabel.text = @"Nothing found";
    }];
}

- (NSString *)stringify:(NSMutableArray *)addresses {
    return [NSString stringWithFormat:@"* %@", [addresses componentsJoinedByString:@"\n* "]];
}

@end
