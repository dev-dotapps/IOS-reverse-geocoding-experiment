//
//  AppDelegate.h
//  Location Tester
//
//  Created by Ani Tumanyan on 2015-08-30.
//  Copyright (c) 2015 Ani Tumanyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

static NSString *const googleAPIKey = @"AIzaSyA6wmb1HGBC89I2P_O7VWj-IuUrdjhqVQs";

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

