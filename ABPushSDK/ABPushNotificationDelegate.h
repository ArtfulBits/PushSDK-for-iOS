//
//  ABPushNotificationDelegate.h
//  ABPushSDK
//
//  Created by Max Gontar on 9/5/14.
//  Copyright (c) 2014 Artfulbits. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ABPushNotificationManager;

@protocol ABPushNotificationDelegate <NSObject>

-(void)onDidRegisterForRemoteNotificationsWithDeviceToken:(NSString *)token;
-(void)onDidFailToRegisterForRemoteNotificationsWithError:(NSError *)error;
-(void)onPushReceived:(ABPushNotificationManager *)pushManager withNotification:(NSDictionary *)pushNotification onStart:(BOOL)onStart;
@end
