//
//  Profile+CoreDataProperties.h
//  PDF Letterhead
//
//  Created by Richard Vollebregt on 16/12/15.
//  Copyright © 2015 Pim Snel. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Profile.h"

NS_ASSUME_NONNULL_BEGIN

@interface Profile (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *bgImagePath;
@property (nullable, nonatomic, retain) NSString *coverImagePath;
@property (nullable, nonatomic, retain) NSString *lastUpdated;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *uid;

@end

NS_ASSUME_NONNULL_END
