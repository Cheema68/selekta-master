//
//  LoginClient.h
//  BSGame
//
//  Created by Joseph Marvin Magdadaro on 10/7/15.
//  Copyright (c) 2015 DollTV. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Config.h"

@interface LoginClient : NSObject

+ (LoginClient *) sharedInstance;

- (void) facebookLoginWithReadPermissions: (NSArray *) permissions
                       fromViewController: (UIViewController *) viewController
                                  success:(void (^)(id result))success
                                  failure:(void (^)(NSError *error, NSDictionary *result))failure;

- (void) loginWithEmail: (NSString *) email
                success:(void (^)(id result))success
                failure:(void (^)(NSError *error, NSDictionary *result))failure;

@end
