//
//  ABPushNotificationManager.h
//  ABPushSDK
//
//  Created by Max Gontar on 9/5/14.
//  Copyright (c) 2014 Artfulbits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABPushNotificationDelegate.h"
#import "ABWebAPI.h"
#import "ABResult.h"
#import "ABError.h"

@interface ABPushNotificationManager : NSObject
{
    NSString* mPushToken;
    NSString* mLogin;
    NSString* mPassword;
    NSString* mServiceUrl;
    
    NSString* mVersion;
    CLLocation* mLocation;
}

@property (nonatomic, assign) NSObject<ABPushNotificationDelegate> *delegate;
@property (readonly, strong, nonatomic) NSOperationQueue* operationQueue;

+ (ABPushNotificationManager *)pushManager;
- (NSString *)getPushToken;
- (void)registerForPushNotifications:(NSString*)serviceUrl;

- (void) handlePushRegistration:(NSString *)deviceToken;
- (void) handlePushRegistrationFailure:(NSError *)error;
- (void) handlePushReceived:(NSDictionary *)userInfo onStart:(BOOL)onStart;

-(void) registerForPushNotificationsLocation:(CLLocation*) location version:(NSString*) version login:(NSString*) login password:(NSString*) password;
-(void) registerForPushNotificationsLogin:(NSString*) login password:(NSString*) password;
-(void) registerForPushNotificationsVersionUpdate:(NSString*) version;
-(void) registerForPushNotificationsLocationUpdate:(CLLocation*) location;

@end
