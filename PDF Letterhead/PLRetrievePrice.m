//
//  PLRetrievePrice.m
//  App Pricing
//
//  Created by Pim Snel on 18-01-16.
//  Copyright © 2016 Lingewoud BV. All rights reserved.
//

#import "PLRetrievePrice.h"

@implementation PLRetrievePrice

- (id) initWithAppId:(NSNumber*)appId{
    
    self.priceFound = NO;
    
    self = [super init];
    [self retrieveFormattedPrice:appId];
    return self;
}


- (void)retrieveFormattedPrice:(NSNumber*)appId {
    
    self.formattedPrice = @"";
    
    [NSTimeZone resetSystemTimeZone];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    NSString *country = [[timeZone localizedName:NSTimeZoneNameStyleShortGeneric locale:[NSLocale systemLocale]] lowercaseString];
    
    NSString *queryString = [NSString stringWithFormat:@"https://itunes.apple.com/lookup?id=%@&country=%@", [appId stringValue], country];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:queryString] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
    
    NSData *returnedData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSError *error = nil;
    id object = nil;
    
    if(returnedData){
        NSLog(@"lalalala");
        
        object = [NSJSONSerialization
                     JSONObjectWithData:returnedData
                     options:0
                     error:&error];
        
    }
    
    if(error) {
        
    }
    
    if([object isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *results = object;
        NSLog(@"results: %@", results[@"resultCount"]);
        if([results[@"resultCount"] isEqualToNumber:@1 ]){
            self.priceFound = YES;
            self.formattedPrice = results[@"results"][0][@"formattedPrice"];
        }
    }
    else
    {
    }
}


@end
