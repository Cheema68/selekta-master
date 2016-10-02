//
//  SetsRealm.h
//  Selekta
//
//  Created by Charisse Ann Dirain on 6/25/16.
//  Copyright © 2016 Charisse Ann Dirain. All rights reserved.
//

#import <Realm/Realm.h>

@interface SetsRealm : RLMObject
@property(nonatomic, retain) NSString *objectId;
@property(nonatomic, retain) NSString *set_id;
@property(nonatomic, retain) NSString *set_artist;
@property(nonatomic, retain) NSString *set_audio_link;
@property(nonatomic, retain) NSString *set_picture;
@property(nonatomic, retain) NSString *set_title;
@property(nonatomic, retain) NSString *created_at;
@property(nonatomic, retain) NSString *updated_at;
@property(nonatomic, retain) NSString *setfilename;
@property(nonatomic, retain) NSString *set_background_pic;
@property(nonatomic, retain) NSString *set_btn_image;
@property(nonatomic, retain) NSString *userid;
@end




// This protocol enables typed collections. i.e.:
// RLMArray<SetsRealm>
RLM_ARRAY_TYPE(SetsRealm)
