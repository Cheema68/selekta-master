//
//  TrackObj.h
//  Selekta
//
//  Created by apple on 28/12/2015.
//  Copyright © 2015 Jerk Magz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrackObj : NSObject
@property(nonatomic, retain) NSString *objectId;
@property(nonatomic, retain) NSString *set_id;
@property(nonatomic, retain) NSString *trackID;
@property(nonatomic, retain) NSString *track_artist;
@property(nonatomic, retain) NSString *track_label;
@property(nonatomic, retain) NSString *track_name;
@property(nonatomic, retain) NSString *track_start;
@property(nonatomic, retain) NSString *created_at;
@property(nonatomic, retain) NSString *updated_at;

@end
