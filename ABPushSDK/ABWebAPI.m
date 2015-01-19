//
//  SWebAPU.m
//  SafariApp
//
//  Created by Max Gontar on 3/3/14.
//  Copyright (c) 2014 Sanzinia Ltd. All rights reserved.
//

#import "ABWebAPI.h"
#import "ABPushToken.h"

NSString *const METHOD_REGISTRATION = @"RegisterToken";
//?token={4215B7AF-B74F-4D09-B032-C196AA51BFAB}&login=spuser&pass=qwerty1234%^

@implementation ABWebAPI

static NSString * serviceURL;
//{"anonymous":"true","success":"token added"}
//{"anonymous":"true","sharepoint auth error":"incorrect credentials","success":"token added"}

+ (id)registerWithToken:(NSString*)token location:(CLLocation*)location version:(NSString*)version login:(NSString*)login password:(NSString*)password
{
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setValue:token forKey:@"token"];
    
    [params setValue:@"ios" forKey:@"platform"];
    
    if(location)
        [params setValue:[NSString stringWithFormat:@"%f;%f", location.coordinate.latitude, location.coordinate.longitude] forKey:@"location"];
    if(version)
        [params setValue:version forKey:@"appversion"];
    if(login)
        [params setValue:login forKey:@"login"];
    if(password)
        [params setValue:password forKey:@"pass"];
    
    /*
     if(login)
     [params setValue:@"spuser1" forKey:@"login"];
     if(password)
     [params setValue:@"qwerty1234%^" forKey:@"pass"];
     */
    //make request
    id result = [self makeRequest:METHOD_REGISTRATION dataParams:params];
    return result;
}

+ (id)registerWithToken:(NSString*)token location:(CLLocation*)location login:(NSString*)login password:(NSString*)password
{
    return [self registerWithToken:token location:location version:nil login:login password:password];
}
+ (id)registerWithToken:(NSString*)token version:(NSString*)version login:(NSString*)login password:(NSString*)password
{
    return [self registerWithToken:token location:nil version:version login:login password:password];
}
+ (id)registerWithToken:(NSString*)token login:(NSString*)login password:(NSString*)password
{
    return [self registerWithToken:token location:nil version:nil login:login password:password];
}
+ (id)registerWithToken:(NSString*)token location:(CLLocation*)location version:(NSString*)version
{
    return [self registerWithToken:token location:location version:version login:nil password:nil];
}
+ (id)registerWithToken:(NSString*)token location:(CLLocation*)location
{
    return [self registerWithToken:token location:location version:nil login:nil password:nil];
}
+ (id)registerWithToken:(NSString*)token version:(NSString*)version
{
    return [self registerWithToken:token location:nil version:version login:nil password:nil];
}
+ (id)registerWithToken:(NSString*)token
{
    return [self registerWithToken:token location:nil version:nil login:nil password:nil];
}

+ (id)parseJSONData:(id)data
{
    if([data valueForKey:@"error"] != nil)
    {
        ABError *error = [ABError new];
        error.message = [data valueForKey:@"error"];
        return error;
    }
    else if([data valueForKey:@"success"] != nil)
    {
        ABResult *result = [ABResult new];
        result.anonymous = [[data valueForKey:@"anonymous"] boolValue];
        result.success = [data valueForKey:@"success"];
        return result;
    }
    return  nil;
}

+ (id)makeRequest:(NSString*)method dataParams:(NSDictionary*)dataParams
{
    return [self makeRequest:method dataParams:dataParams data:nil];
}

+ (id)makeRequest:(NSString*)method dataParams:(NSDictionary*)dataParams data:(NSData*)data
{
    NSMutableString* dataParamsString = [NSMutableString new];
    
    for (id key in [dataParams allKeys])
    {
        if([dataParamsString length] > 0)
            [dataParamsString appendString:@"&"];
        
        if([dataParamsString length] == 0)
            [dataParamsString appendString:@"?"];
        
        [dataParamsString appendFormat:@"%@=", key];
        [dataParamsString appendString:[[dataParams objectForKey:key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
    return [ABWebAPI makeRequest:method params:dataParamsString data:data];
}

+ (id)makeRequest:(NSString*)method params:(NSString*)params data:(NSData*)data
{
    NSURLRequest* urlRequest = [ABWebAPI buildRequest:method params:params data:data];
    NSURLResponse* urlResponse = nil;
    NSError* error = nil;
    
    NSData* responseData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&urlResponse error:&error];
    
#if DEBUG
    NSString *str = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
#endif
    
    if(error)
        return error;
    
#if DEBUG
    //NSLog(@"RESPONSE : %@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
#endif
    
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData //1
                          
                          options:kNilOptions
                          error:&error];
    if(error)
        return error;
    
    if(json)
    {
        return [ABWebAPI parseJSONData:json];
    }
    
    return [NSError errorWithDomain:@"NOT JSON" code:0 userInfo:nil];
}

+ (NSURLRequest*)buildRequest:(NSString*)method params:(NSString*)params data:(NSData*)data
{
    NSMutableString* urlString = [NSMutableString new];
    NSMutableURLRequest* urlRequest = [NSMutableURLRequest new];
    
    [urlString appendString:serviceURL];
    [urlString appendString:method];
    if(params)
    {
        [urlString appendString:params];
    }
    
    [urlRequest setURL:[NSURL URLWithString:urlString]];
    //[urlRequest setTimeoutInterval:15];
    
    
#if DEBUG
    NSLog(@"REQUEST : %@", urlString);
#endif
    
    [urlRequest setHTTPMethod:@"GET"];
    /*
     [urlRequest addValue:@"no-cache" forHTTPHeaderField:@"Cache-Control"];
     [urlRequest addValue:@"max-age=0" forHTTPHeaderField:@"Cache-Control"];
     [urlRequest addValue:@"0" forHTTPHeaderField:@"expires"];
     [urlRequest addValue:@"Tue, 01 Jan 1980 1:00:00 GMT" forHTTPHeaderField:@"expires"];
     [urlRequest addValue:@"no-cache" forHTTPHeaderField:@"pragma"];
     */
    return urlRequest;
}


+ (NSString*) serviceURL
{ @synchronized(self) { return serviceURL; } }

+ (void) setServiceURL:(NSString*)url
{ @synchronized(self) { serviceURL = url; } }

@end