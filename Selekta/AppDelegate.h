//
//  AppDelegate.h
//  Selekta
//
//  Created by Charisse Ann Dirain on 6/21/16.
//  Copyright © 2016 Charisse Ann Dirain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STKAudioPlayer.h"
#import "AudioPlayerView.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong) STKAudioPlayer* audioPlayer;
+(AppDelegate*)sharedInstance;
@end

