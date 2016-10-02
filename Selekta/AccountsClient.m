//
//  AccountsClient.m
//  BSGame
//
//  Created by Joseph Marvin Magdadaro on 10/12/15.
//  Copyright (c) 2015 DollTV. All rights reserved.
//

#import "AccountsClient.h"

@implementation AccountsClient

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static AccountsClient *sharedInstance;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

-(void)removeObserverWithAccountId:(NSString *)accountId{
    Firebase *ref = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@/accounts/%@", FIREBASE_URL,accountId]];
    
    [ref removeAllObservers];
}

- (void)saveAccountWithInfo:(NSDictionary *)info accountID: (NSString *) aID completion:(void(^)(NSError *error, NSDictionary *accountInfo))completion{
    Firebase *ref = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@/accounts", FIREBASE_URL]];
    
    NSLog(@"AID = %@", aID);
    
    Firebase *userRef = [ref childByAppendingPath:aID];
    
    [userRef setValue:info];
    
    if( completion ){
        completion(nil, info);
    }
}

- (void)isAccountExistWithID:(NSString *)accountID completion:(void (^)(NSError *, bool isExist))completion{
    Firebase *ref = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@/accounts/%@", FIREBASE_URL, accountID]];
    
    [ref observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        
        //NSLog(@"Snapshot2 = %@", snapshot.value);
        //NSLog(@"Snapshot = %@ %@", snapshot.key, accountID);
        
        if( completion ){
            if( snapshot.value != [NSNull null] )
                completion(nil, TRUE);
            else
                completion(nil, FALSE);
        }
        
    } withCancelBlock:^(NSError *error) {
        
        if( completion ){
            completion(error, nil);
        }
    }];
}

-(void) getAccountInfoWithID:(NSString *)accountID completion:(void (^)(NSError *, NSDictionary *))completion{
    Firebase *ref = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@/accounts/%@", FIREBASE_URL, accountID]];
    
    [ref observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        
        //NSLog(@"Snapshot = %@", snapshot.value);
        
        if( completion ){
            completion(nil, snapshot.value);
        }
        
    } withCancelBlock:^(NSError *error) {
        
        if( completion ){
            completion(error, nil);
        }
    }];
}

-(void) getSingleAccountInfoWithID:(NSString *)accountID completion:(void (^)(NSError *error, FDataSnapshot *accounts))completion{
    Firebase *ref = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@/accounts/%@", FIREBASE_URL, accountID]];
    
    [ref observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        
        //NSLog(@"Snapshot = %@", snapshot.value);
        
        if( completion ){
            completion(nil, snapshot);
        }
        
    } withCancelBlock:^(NSError *error) {
        
        if( completion ){
            completion(error, nil);
        }
    }];
}

- (void)saveEmailWithID: (NSString *) aID email: (NSString *) email completion:(void(^)(NSError *error, NSString *email))completion{
    Firebase *ref = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@/emails", FIREBASE_URL]];
    
    Firebase *userRef = [ref childByAppendingPath:aID];
    
    [userRef setValue:email];
    
    if( completion ){
        completion(nil, email);
    }
}

- (void)isEmailExist: (NSMutableArray *) emailsArr completion:(void(^)(NSError *error,  bool isExist))completion{
    
    Firebase *ref = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@/emails/", FIREBASE_URL]];
    
    [ref observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        
        
        NSDictionary *emails = snapshot.value;
        
        NSArray *emailIDs = [emails allKeys];
        
        BOOL isEmailFound = FALSE;
        
        for (int j = 0; j < [emailsArr count]; j++) {
            NSString * email = [emailsArr objectAtIndex:j];
            
            for (int i = 0; i < [emailIDs count]; i++) {
                NSString *eadd = [emails objectForKey:[emailIDs objectAtIndex:i]];
                
                if( [eadd isEqualToString:email] ){
                    
                    //NSLog(@"email = %@", email);
                    
                    isEmailFound = TRUE;
                    
                    if( completion )
                        completion(nil, TRUE);
                    
                    break;
                }
            }
        }
        
        if( completion ){
            if( !isEmailFound )
                completion(nil, FALSE);
        }
        
    } withCancelBlock:^(NSError *error) {
        
        if( completion ){
            completion(error, nil);
        }
    }];
}

- (void)saveSets:(NSDictionary *)info accountID: (NSString *) aID completion:(void(^)(NSError *error, NSDictionary *accountInfo))completion{
    Firebase *ref = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@/sets", FIREBASE_URL]];
    
    NSLog(@"AID = %@", aID);
    
    Firebase *userRef = [ref childByAppendingPath:aID];
    
    [userRef setValue:info];
    
    if( completion ){
        completion(nil, info);
    }
}

-(void) getSingleSetInfoWithID:(NSString *)setID completion:(void (^)(NSError *error, FDataSnapshot *accounts))completion{
    Firebase *ref = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@/sets/%@", FIREBASE_URL, setID]];
    
    [ref observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        
        NSLog(@"Snapshot = %@", snapshot.value);
        
        if( completion ){
            completion(nil, snapshot);
        }
        
    } withCancelBlock:^(NSError *error) {
        
        if( completion ){
            completion(error, nil);
        }
    }];
}

-(void)getAllSets: (NSString *) gameID completion:(void (^)(NSError *error, FDataSnapshot *scores))completion{
    Firebase *ref = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@/sets", FIREBASE_URL]];
    
    //if(ref != nil){
    
    [ref observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        
        //NSLog(@"Snapshot = %@", snapshot);
        
        if( completion ){
            completion(nil, snapshot);
        }
        
    } withCancelBlock:^(NSError *error) {
        
        if( completion ){
            completion(error, nil);
        }
    }];
    
    //}
}

- (void)saveTracks:(NSDictionary *)info accountID: (NSString *) aID setID: (NSString *) sID completion:(void(^)(NSError *error, NSDictionary *accountInfo))completion{
    Firebase *ref = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@/tracks/%@", FIREBASE_URL,sID]];
    
    NSLog(@"AID = %@", aID);
    
    Firebase *userRef = [ref childByAppendingPath:aID];
    
    [userRef setValue:info];
    
    if( completion ){
        completion(nil, info);
    }
}

-(void)getAllTracks: (NSString *) gameID completion:(void (^)(NSError *error, FDataSnapshot *scores))completion{
    Firebase *ref = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@/tracks/%@", FIREBASE_URL,gameID]];
    
    //if(ref != nil){
    
    [ref observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        
        //NSLog(@"Snapshot = %@", snapshot);
        
        if( completion ){
            completion(nil, snapshot);
        }
        
    } withCancelBlock:^(NSError *error) {
        
        if( completion ){
            completion(error, nil);
        }
    }];
    
    //}
}


- (void)savetoCrate:(NSDictionary *)info accountID: (NSString *) aID setID: (NSString *) sID  trackID: (NSString *) tID completion:(void(^)(NSError *error, NSDictionary *accountInfo))completion{
    Firebase *ref = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@/crates/%@", FIREBASE_URL,aID]];
    
    NSLog(@"AID = %@", aID);
    NSLog(@"sID = %@", sID);
    Firebase *userRef = [ref childByAppendingPath:tID];//[[ref childByAppendingPath:sID] childByAppendingPath:tID];
    
    [userRef setValue:info];
    
    if( completion ){
        completion(nil, info);
    }
}

- (void)savetoRecent:(NSDictionary *)info accountID: (NSString *) aID setID: (NSString *) sID  trackID: (NSString *) tID completion:(void(^)(NSError *error, NSDictionary *accountInfo))completion{
    Firebase *ref = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@/recent/%@", FIREBASE_URL,aID]];
    
    NSLog(@"AID = %@", aID);
    
    Firebase *userRef = [ref childByAppendingPath:sID];
    
    [userRef setValue:info];
    
    if( completion ){
        completion(nil, info);
    }
}

-(void)getAllCrates: (NSString *) accountID   completion:(void (^)(NSError *error, FDataSnapshot *scores))completion{
    Firebase *ref = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@/crates/%@/", FIREBASE_URL,accountID]];
  
    
     NSLog(@"Snapshot = %@", ref);
    //if(ref != nil){
    
    [ref observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        
        NSLog(@"Snapshot = %@", snapshot);
        
        if( completion ){
            completion(nil, snapshot);
        }
        
    } withCancelBlock:^(NSError *error) {
        
        if( completion ){
            completion(error, nil);
        }
    }];
    
    //}
}

-(void)getAllRecents: (NSString *) accountID completion:(void (^)(NSError *error, FDataSnapshot *scores))completion{
    Firebase *ref = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@/recent/%@/", FIREBASE_URL,accountID]];
    
    //if(ref != nil){
    
    [ref observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        
        //NSLog(@"Snapshot = %@", snapshot);
        
        if( completion ){
            completion(nil, snapshot);
        }
        
    } withCancelBlock:^(NSError *error) {
        
        if( completion ){
            completion(error, nil);
        }
    }];
    
    //}
}


@end
