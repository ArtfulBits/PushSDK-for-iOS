//
//  ABPushToken.h
//  PushClientApp
//
//  Created by Max Gontar on 9/1/14.
//  Copyright (c) 2014 Artfulbits. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABPushToken : NSObject
@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) NSString *login;
@property (strong, nonatomic) NSString *password;
@end
