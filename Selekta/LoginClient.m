//
//  LoginClient.m
//  BSGame
//
//  Created by Joseph Marvin Magdadaro on 10/7/15.
//  Copyright (c) 2015 Nerts. All rights reserved.
//

#import "LoginClient.h"
@import Firebase;

@interface LoginClient ()

@end

@implementation LoginClient

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static LoginClient *sharedInstance;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (void) facebookLoginWithReadPermissions:(NSArray *)permissions
    fromViewController:(UIViewController *)viewController
               success:(void (^)(id result))success
               failure:(void (^)(NSError *, NSDictionary *))failure
{
    
    Firebase *ref = [[Firebase alloc] initWithUrl:FIREBASE_URL];
    
    //FIRDatabaseReference *ref= [[FIRDatabase database] reference];
    //[FIRDatabase database].persistenceEnabled = YES;
    
    FBSDKLoginManager *facebookLogin = [[FBSDKLoginManager alloc] init];
    
    return [facebookLogin logInWithReadPermissions:permissions
        fromViewController:viewController
                   handler:^(FBSDKLoginManagerLoginResult *facebookResult, NSError *facebookError)
    {
        if (facebookError) {
            
            [FBSDKLoginManager renewSystemCredentials:^(ACAccountCredentialRenewResult result, NSError *error) {
                
                
            }];
            
            if (failure) {
                failure([NSError errorWithDomain:@"" code:1 userInfo:@{@"info": facebookError}], @{});
            }
            
        } else if (facebookResult.isCancelled) {
            
            if (failure) {
                failure([NSError errorWithDomain:@"" code:2 userInfo:@{@"info": @"Facebook login got cancelled."}], @{});
            }
            
        } else {
            NSString *accessToken = [[FBSDKAccessToken currentAccessToken] tokenString];
            
            [ref authWithOAuthProvider:@"facebook"
                                 token:accessToken
                   withCompletionBlock:^(NSError *error, FAuthData *authData)
             {
                 if (error) {
                     
                     if (failure) {
                         failure([NSError errorWithDomain:@"" code:3 userInfo:@{@"info": error}], @{});
                     }
                     
                 } else {
                     NSLog(@"Logged in! %@", authData);
                     
                     
                     if ([FBSDKAccessToken currentAccessToken]) {
                         [[[FBSDKGraphRequest alloc] initWithGraphPath:@"/me?fields=id,name,picture" parameters:nil]
                          startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                              if (!error) {
                                  
                                  if (success) {
                                      success(result);
                                  }
                                  
                              }else{
                                  
                                  if (failure) {
                                      failure([NSError errorWithDomain:@"" code:4 userInfo:@{@"info": error}], @{});
                                  }
                              }
                          }];
                     }
                     
                 }
             }];
        }
    }];
}

- (void) loginWithEmail: (NSString *) email
                success:(void (^)(id result))success
                failure:(void (^)(NSError *error, NSDictionary *result))failure
{
    
    Firebase *ref = [[Firebase alloc] initWithUrl:FIREBASE_URL];
    
    [ref createUser:email password:EMAIL_PASSWORD withValueCompletionBlock:^(NSError *error, NSDictionary *result) {
        
        BOOL isEmailOk = FALSE;
        
        if (error) {
            
            NSLog(@"RES: %@", result);
            
            NSString *errorStr = [NSString stringWithFormat:@"%@", error];
            
            if ([errorStr rangeOfString:@"EMAIL_TAKEN"].location != NSNotFound) {
                
                isEmailOk = TRUE;
                
            }else{
                
                if (failure) {
                    failure([NSError errorWithDomain:@"" code:1 userInfo:@{@"info": error}], @{});
                }
            }
            
            
        } else {
            
            isEmailOk = TRUE;
        }
        
        if (isEmailOk) {
            
            [ref authUser:email password:EMAIL_PASSWORD withCompletionBlock:^(NSError *error, FAuthData *authData) {
                if (error) {
                    
                    NSLog(@"ERROR: %@", error);
                    
                    if (failure) {
                        failure([NSError errorWithDomain:@"" code:1 userInfo:@{@"info": error}], @{});
                    }
                    
                } else {
                    
                    if (success) {
                        success(@{@"uid":authData.uid,@"token":authData.token});
                    }
                }
            }];
        }
    }];
    

}



@end
