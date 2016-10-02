//
//  UserObj.h
//  Selekta
//
//  Created by apple on 19/11/2015.
//  Copyright © 2015 Jerk Magz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserObj : NSObject
@property(nonatomic, retain) NSString *facebookID;
@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSString *location;
@property(nonatomic, retain) NSString *gender;
@property(nonatomic, retain) NSString *birthday;
@property(nonatomic, retain) NSURL *pictureURL;
@property(nonatomic, retain) NSString *email;
@end
