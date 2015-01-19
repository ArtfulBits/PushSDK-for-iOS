//
//  ABPushNotificationManager.m
//  ABPushSDK
//
//  Created by Max Gontar on 9/5/14.
//  Copyright (c) 2014 Artfulbits. All rights reserved.
//

#import "ABPushNotificationManager.h"

@implementation ABPushNotificationManager

static ABPushNotificationManager* singleInstance;

@synthesize delegate, operationQueue;

+ (ABPushNotificationManager *)pushManager
{
    static dispatch_once_t dispatchOnceToken;
    
    dispatch_once(&dispatchOnceToken, ^{
        singleInstance = [[ABPushNotificationManager alloc] init];
    });
    
    return singleInstance;
}

- (id)init {
    if (self = [super init]) {
        operationQueue = [NSOperationQueue new];
        operationQueue.maxConcurrentOperationCount = 1;
    }
    return self;
}


- (NSString *)getPushToken
{
    return mPushToken;
}

- (void)registerForPushNotifications:(NSString*)serviceUrl
{
    [ABWebAPI setServiceURL:serviceUrl];
    
    
    //-- Set Notification
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        // iOS 8 Notifications
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        // iOS < 8 Notifications
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
}

- (void) handlePushRegistration:(NSString *)deviceToken
{
    deviceToken = [deviceToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    deviceToken = [deviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    mPushToken = deviceToken;
    [self registerAtService];
}

- (void) handlePushRegistrationFailure:(NSError *)error
{
    if(delegate)
        [delegate onDidFailToRegisterForRemoteNotificationsWithError:error];

}

- (void) handlePushReceived:(NSDictionary *)userInfo onStart:(BOOL)onStart
{
    if(delegate)
        [delegate onPushReceived:self withNotification:userInfo onStart:onStart];
}

-(void) registerForPushNotificationsLocation:(CLLocation*) location version:(NSString*) version login:(NSString*) login password:(NSString*) password
{
    if(mPushToken)
    {
        if(location)
            mLocation = location;
        
        if(version)
            mVersion = version;
        
        if(login)
            mLogin = login;
        
        if(password)
            mPassword = password;
        
        NSInvocationOperation* op = [[NSInvocationOperation alloc] initWithTarget:self
                                                                         selector:@selector(registerAtService)
                                                                           object:nil];
        
        [operationQueue addOperation:op];
    }
    else
    {
        //NSLog
    }
}


-(void) registerForPushNotificationsLogin:(NSString*) login password:(NSString*) password
{
    [self registerForPushNotificationsLocation:nil version:nil login:login password:password];
}

-(void) registerForPushNotificationsVersionUpdate:(NSString*) version
{
    [self registerForPushNotificationsLocation:nil version:version login:nil password:nil];
}

-(void) registerForPushNotificationsLocationUpdate:(CLLocation*) location
{
    [self registerForPushNotificationsLocation:location version:nil login:nil password:nil];
}

-(void) registerAtService
{
    id result = [ABWebAPI registerWithToken:mPushToken location:mLocation version:mVersion login:mLogin password:mPassword];
    
    if([[result class] isSubclassOfClass:[ABError class]])
    {
        ABError *err = (ABError*)result;
       
        //An error occurred
        NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
        [errorDetail setValue:err.message forKey:NSLocalizedDescriptionKey];
       NSError *error = [NSError errorWithDomain:@"AuthorizationError" code:100 userInfo:errorDetail];
        
        
        if(delegate)
            [delegate onDidFailToRegisterForRemoteNotificationsWithError:error];
    }
    else
    {
        if(delegate)
            [delegate onDidRegisterForRemoteNotificationsWithDeviceToken:mPushToken];
    }
}

@end
