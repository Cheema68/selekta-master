//
//  AccountsClient.h
//  BSGame
//
//  Created by Joseph Marvin Magdadaro on 10/12/15.
//  Copyright (c) 2015 DollTV. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Config.h"

@interface AccountsClient : NSObject

+ (AccountsClient *) sharedInstance;

- (void)saveAccountWithInfo:(NSDictionary *)info accountID: (NSString *) aID completion:(void(^)(NSError *error, NSDictionary *accountInfo))completion;
- (void)isAccountExistWithID: (NSString *) accountID completion:(void(^)(NSError *error,  bool isExist))completion;
- (void) getAccountInfoWithID: (NSString *) accountID completion:(void(^)(NSError *error, NSDictionary *accountInfo))completion;
-(void) getSingleAccountInfoWithID:(NSString *)accountID completion:(void (^)(NSError *error, FDataSnapshot *accounts))completion;

- (void)saveEmailWithID: (NSString *) aID email: (NSString *) email completion:(void(^)(NSError *error, NSString *email))completion;
- (void)isEmailExist: (NSMutableArray *) emailsArr completion:(void(^)(NSError *error,  bool isExist))completion;

-(void)removeObserverWithAccountId:(NSString *)accountId;
- (void)saveSets:(NSDictionary *)info accountID: (NSString *) aID completion:(void(^)(NSError *error, NSDictionary *accountInfo))completion;
-(void) getSingleSetInfoWithID:(NSString *)setID completion:(void (^)(NSError *error, FDataSnapshot *accounts))completion;
-(void)getAllSets: (NSString *) gameID completion:(void (^)(NSError *error, FDataSnapshot *scores))completion;

- (void)saveTracks:(NSDictionary *)info accountID: (NSString *) aID setID: (NSString *) sID completion:(void(^)(NSError *error, NSDictionary *accountInfo))completion;
-(void)getAllTracks: (NSString *) gameID completion:(void (^)(NSError *error, FDataSnapshot *scores))completion;
-(void)savetoCrate:(NSDictionary *)info accountID: (NSString *) aID setID: (NSString *) sID  trackID: (NSString *) tID completion:(void(^)(NSError *error, NSDictionary *accountInfo))completion;

- (void)savetoRecent:(NSDictionary *)info accountID: (NSString *) aID setID: (NSString *) sID  trackID: (NSString *) tID completion:(void(^)(NSError *error, NSDictionary *accountInfo))completion;
-(void)getAllRecents: (NSString *) accountID completion:(void (^)(NSError *error, FDataSnapshot *scores))completion;
-(void)getAllCrates: (NSString *) accountID   completion:(void (^)(NSError *error, FDataSnapshot *scores))completion;
@end
