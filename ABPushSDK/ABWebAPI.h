//
//  SWebAPU.h
//  SafariApp
//
//  Created by Max Gontar on 3/3/14.
//  Copyright (c) 2014 Sanzinia Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "ABError.h"
#import "ABResult.h"
#import "ABPushToken.h"

extern NSString *const METHOD_REGISTRATION;

@interface ABWebAPI : NSObject

+ (id)parseJSONData:(id)data;
+ (id)makeRequest:(NSString*)method dataParams:(NSDictionary*)dataParams;
+ (id)makeRequest:(NSString*)method dataParams:(NSDictionary*)dataParams data:(NSData*)data;
+ (id)makeRequest:(NSString*)method params:(NSString*)params data:(NSData*)data;
+ (NSURLRequest*)buildRequest:(NSString*)method params:(NSString*)params data:(NSData*)data;
+ (id)registerWithToken:(NSString*)token location:(CLLocation*)location version:(NSString*)version login:(NSString*)login password:(NSString*)password;
+ (id)registerWithToken:(NSString*)token location:(CLLocation*)location login:(NSString*)login password:(NSString*)password;
+ (id)registerWithToken:(NSString*)token version:(NSString*)version login:(NSString*)login password:(NSString*)password;
+ (id)registerWithToken:(NSString*)token login:(NSString*)login password:(NSString*)password;
+ (id)registerWithToken:(NSString*)token location:(CLLocation*)location version:(NSString*)version;
+ (id)registerWithToken:(NSString*)token location:(CLLocation*)location;
+ (id)registerWithToken:(NSString*)token version:(NSString*)version;
+ (id)registerWithToken:(NSString*)token;

+ (NSString*) serviceURL;
+ (void) setServiceURL:(NSString*)url;
@end
