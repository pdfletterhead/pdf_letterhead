//
//  PLRetrievePrice.h
//  App Pricing
//
//  Created by Pim Snel on 18-01-16.
//  Copyright © 2016 Lingewoud BV. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PLRetrievePrice : NSObject

@property (assign) BOOL priceFound;
@property (retain) NSString * formattedPrice;

- (id) initWithAppId:(NSNumber*)appId;

@end
