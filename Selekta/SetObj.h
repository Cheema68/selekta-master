//
//  SetObj.h
//  Selekta
//
//  Created by apple on 28/12/2015.
//  Copyright © 2015 Jerk Magz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Config.h"

@interface SetObj : NSObject
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
//@property (nonatomic, retain) PFFile *imgfile;
@end
