//
//  AppDelegate.m
//  Selekta
//
//  Created by Charisse Ann Dirain on 6/21/16.
//  Copyright © 2016 Charisse Ann Dirain. All rights reserved.
//

#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <Firebase/Firebase.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import <MediaPlayer/MPMediaItem.h>

#import "MenuViewController.h"
#import "NVSlideMenuController.h"
#import "PlayerVC.h"
#import "STKAudioPlayer.h"
#import "PlayerNewVC.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
@interface AppDelegate (){
    

}

@end

@implementation AppDelegate

@synthesize audioPlayer;

+(AppDelegate*)sharedInstance
{
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSError *setCategoryErr = nil;
    NSError *activationErr  = nil;
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error:&setCategoryErr];
    [[AVAudioSession sharedInstance] setActive:YES error:&activationErr];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];
    
    [Fabric with:@[[Crashlytics class]]];
   
    
    Float32 bufferLength = 0.1;
    AudioSessionSetProperty(kAudioSessionProperty_PreferredHardwareIOBufferDuration, sizeof(bufferLength), &bufferLength);
    
    
    audioPlayer = [[STKAudioPlayer alloc] initWithOptions:(STKAudioPlayerOptions){ .flushQueueOnSeek = NO, .enableVolumeMixer = NO, .equalizerBandFrequencies = {50, 100, 200, 400, 800, 1600, 2600, 16000} }];
    NSString *switchon = [[NSUserDefaults standardUserDefaults] objectForKey:@"switch"];
    
    if([switchon isEqualToString:@"on"]){
        audioPlayer.meteringEnabled = YES;
       // meter.backgroundColor = [UIColor blueColor];
    }else{
        audioPlayer.meteringEnabled = NO;
        //meter.backgroundColor = [UIColor clearColor];
    }
    
    NSString *switchon1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"switch1"];
    
    if([switchon1 isEqualToString:@"on"]){
        [[AppDelegate sharedInstance].audioPlayer resume];
        audioPlayer.volume = [[[NSUserDefaults standardUserDefaults] objectForKey:@"volume"] doubleValue];
        // meter.backgroundColor = [UIColor blueColor];
    }else{
        //audioPlayer.meteringEnabled = NO;
        [[AppDelegate sharedInstance].audioPlayer pause];
        [AppDelegate sharedInstance].audioPlayer.volume = 0.0;
        //meter.backgroundColor = [UIColor clearColor];
    }

    
    [Firebase defaultConfig].persistenceEnabled = YES;
    
    
    NSError *myErr;
    // Initialize the AVAudioSession here.
    if (![[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&myErr]) {
        // Handle the error here.
        NSLog(@"Audio Session error %@, %@", myErr, [myErr userInfo]);
    }
    else{
        // Since there were no errors initializing the session, we'll allow begin receiving remote control events
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    }
    
     //[[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"fromcrate"];
    BOOL loggedin = [[NSUserDefaults standardUserDefaults] boolForKey:@"LOGGEDIN"];
    loggedin=YES;
    //[[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"recentid"];
    //[[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"recentset"];
    // [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"selectedset"];

    
    if(loggedin == true){
        
        
        
        MenuViewController *menuVC = [[MenuViewController alloc] init];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PlayerNewVC *signVC = (PlayerNewVC *)[storyboard instantiateViewControllerWithIdentifier:@"PlayerVC"];
        
        UINavigationController *menuNavigationController = [[UINavigationController alloc] initWithRootViewController:menuVC];
        
        [[AppDelegate sharedInstance].audioPlayer stop];
        NVSlideMenuController *slideMenuVC = [[NVSlideMenuController alloc] initWithMenuViewController:menuNavigationController andContentViewController:signVC];
     
        self.window.rootViewController = slideMenuVC;
        
    }else{
        

    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *currentAppVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *previousVersion = [defaults objectForKey:@"appVersion"];
    if (!previousVersion) {
        // first launch
        
        // ...
        
        [defaults setObject:currentAppVersion forKey:@"appVersion"];
         [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"tutorial"];
        [defaults synchronize];
    } else if ([previousVersion isEqualToString:currentAppVersion]) {
        // same version
          [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"tutorial"];
    } else {
        // other version
        
        // ...
          [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"tutorial"];
        [defaults setObject:currentAppVersion forKey:@"appVersion"];
        [defaults synchronize];
    }
    
  


    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
        [FBSDKAppEvents activateApp];
          // [[AppDelegate sharedInstance].audioPlayer stop];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

- (void)removeFromSuperview {
     audioPlayer.delegate = nil;
    
}

-(BOOL) needsUpdate{
    NSDictionary* infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString* appID = infoDictionary[@"CFBundleIdentifier"];
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?bundleId=%@", appID]];
    NSData* data = [NSData dataWithContentsOfURL:url];
    NSDictionary* lookup = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    if ([lookup[@"resultCount"] integerValue] == 1){
        NSString* appStoreVersion = lookup[@"results"][0][@"version"];
        NSString* currentVersion = infoDictionary[@"CFBundleShortVersionString"];
        if (![appStoreVersion isEqualToString:currentVersion]){
            NSLog(@"Need to update [%@ != %@]", appStoreVersion, currentVersion);
            return YES;
        }
    }
    return NO;
}

@end
