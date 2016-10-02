//
//  RecentlyPlayedRealm.h
//  Selekta
//
//  Created by Charisse Ann Dirain on 6/25/16.
//  Copyright © 2016 Charisse Ann Dirain. All rights reserved.
//

#import <Realm/Realm.h>

@interface RecentlyPlayedRealm : RLMObject
@property(nonatomic, retain) NSString *objectId;
@property(nonatomic, retain) NSString *set_id;
@property(nonatomic, retain) NSString *crate_id;
@property(nonatomic, retain) NSString *trackID;
@property(nonatomic, retain) NSString *created_at;
@property(nonatomic, retain) NSString *updated_at;
@property(nonatomic, retain) NSString *track_name;
@property(nonatomic, retain) NSString *track_artist;
@property(nonatomic, retain) NSString *set_artist;
@property(nonatomic, retain) NSString *settitle;
@property(nonatomic, retain) NSString *setbg;
@property(nonatomic, retain) NSString *userid;
@end



// This protocol enables typed collections. i.e.:
// RLMArray<RecentlyPlayedRealm>
RLM_ARRAY_TYPE(RecentlyPlayedRealm)
