//
//  PlayerNewVC.m
//  Selekta
//
//  Created by Charisse Ann Dirain on 8/14/16.
//  Copyright © 2016 Charisse Ann Dirain. All rights reserved.
//

#import "PlayerNewVC.h"
#import "STKAudioPlayer.h"

#import "AudioPlayerView.h"

#import <AVFoundation/AVFoundation.h>

#import "STKAutoRecoveringHTTPDataSource.h"

#import "SampleQueueId.h"

#import "NVSlideMenuController.h"

#import <Google/Analytics.h>

#import "Config.h"

#import "UIImageView+WebCache.h"

#import "TrackObj.h"

#import "SetObj.h"

#import <AVFoundation/AVFoundation.h>

#import <MediaPlayer/MPNowPlayingInfoCenter.h>

#import <MediaPlayer/MPMediaItem.h>

#import "AppDelegate.h"

#import "SearchViewController.h"

#import "AccountsClient.h"

#import <Firebase/Firebase.h>

#import "AppDelegate.h"

#import "STKAudioPlayer.h"

#import "AudioPlayerView.h"

#import <AVFoundation/AVFoundation.h>

#import "STKAutoRecoveringHTTPDataSource.h"

#import "SampleQueueId.h"

#import "NVSlideMenuController.h"

#import <Google/Analytics.h>

#import "Config.h"

#import "UIImageView+WebCache.h"

#import "TrackObj.h"

#import "SetObj.h"

#import <AVFoundation/AVFoundation.h>

#import <MediaPlayer/MPNowPlayingInfoCenter.h>

#import <MediaPlayer/MPMediaItem.h>

#import "AppDelegate.h"

#import "SearchViewController.h"

#import "AccountsClient.h"

#import <Firebase/Firebase.h>

#import "AppDelegate.h"
#import "TracksRealm.h"

#import "SetsRealm.h"

#import "CrateRealm1.h"

#import <CRToast/CRToast.h>

#import "SetsRealm.h"

#import "PlayerVC.h"

#import "AppDelegate.h"

#import "SetObj.h"

#import "SetsCell.h"


@interface PlayerNewVC ()<UIGestureRecognizerDelegate,STKAudioPlayerDelegate>{
    IBOutlet UIImageView *bgImg, *coverImg;
    
    IBOutlet UILabel *settitle,*trackTitle,*trackAlbum,*trackRecord;
    
    NSUserDefaults *defaults;
    
    NSString *setid,*trackid,*trackurl;
    
    NSMutableArray *allTracks;
    
    NSString *artist;
    
    IBOutlet UIButton *crateBtn;
    
    IBOutlet UIView *searchView;
    
    BOOL isSearch;
    
    NSArray *animationFrames;
    
    NSArray *animationFramesc;
    
    IBOutlet UIImageView *animatedImageView;
    
    IBOutlet UIImageView *tutorial1,*tutorial2,*tutorial3;
    
    IBOutlet UIButton *next1,*next2,*next3;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *horizontalSpaceConstraint;
@property (nonatomic, retain) NSMutableArray *sets;

@end

@implementation PlayerNewVC

@synthesize slider;
@synthesize searchString;
@synthesize sets;

+ (instancetype)sharedInstance

{
    
    static PlayerNewVC *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        sharedInstance = [[PlayerNewVC alloc] init];
        
        // Do any other initialisation stuff here
        
    });
    
    return sharedInstance;
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker set:kGAIScreenName value:@"main"];
    
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];

    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    
    //tutorial
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"tutorial"]  isEqual: @"0"]){
        
        tutorial1.hidden = NO;
        
        tutorial2.hidden = YES;
        
        tutorial3.hidden = YES;
        
        next1.hidden = NO;
        
        next2.hidden = YES;
        
        next3.hidden = YES;
        
    }else{
        
        tutorial1.hidden = YES;
        
        tutorial2.hidden = YES;
        
        tutorial3.hidden = YES;
        
        next1.hidden = YES;
        
        next2.hidden = YES;
        
        next3.hidden = YES;
        
    }
    animatedImageView.translatesAutoresizingMaskIntoConstraints = YES;
//    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:animatedImageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
//    bottomConstraint.constant = +134;
//
    animatedImageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 2.5, 2.5);
    CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
    if(iOSDeviceScreenSize.height==568 ||  iOSDeviceScreenSize.height == 480 ) {
       animatedImageView.center=CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/100);
    }
    else if(iOSDeviceScreenSize.height==736)
    {
       animatedImageView.center=CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/8);
    }
    else{
        animatedImageView.center=CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/27);
    }
    
    
   [animatedImageView layoutIfNeeded];
    crateBtn.hidden = true;
    
    sets=[[NSMutableArray alloc] init];
    self.navigationController.navigationBar.hidden = YES;
     self.slideMenuController.panGestureEnabled = NO;
    //search functions
    slider.continuous = YES;
    isSearch = false;
    searchView.hidden = true;
    [self.searchField resignFirstResponder];
    self.searchField.text=searchString;
    self.searchField.hidden = true;
    [self.searchField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.searchField.returnKeyType = UIReturnKeyGo;
    
    //end search
    animationFrames = [[NSArray alloc] init];
    animationFramesc = [[NSArray alloc] init];
    
    defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *str= [defaults objectForKey:@"recentset"];
    
    if(str.length==0 || [str isKindOfClass:[NSNull class]] || [str isEqualToString:@""]||[str  isEqualToString:NULL]||[str isEqualToString:@"(null)"]||str==nil || [str isEqualToString:@"<null>"]){
        
        setid = @"1";
        
        trackid = @"1";
        
    }else{
        
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"fromcrate"]  isEqual: @"1"] ){
            
            setid = [defaults objectForKey:@"trackset"];
            
            trackid = [defaults objectForKey:@"trackstart"];
            
        }else{
            
            setid = [defaults objectForKey:@"recentset"];
            
            trackid = [defaults objectForKey:@"recentid"];
            
        }
        
    }
    
    NSString *switchon1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"switch1"];
    if([switchon1 isEqualToString:@"on"]){
        
        [[AppDelegate sharedInstance].audioPlayer resume];
        
        [AppDelegate sharedInstance].audioPlayer.volume = 0.1;
        
        
    }else{
 
        [[AppDelegate sharedInstance].audioPlayer pause];
        
        [AppDelegate sharedInstance].audioPlayer.volume = 0.0;

    }
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"switch"]  isEqual: @"on"]){
        
        touch.hidden = false;
        
    }else{
        
        touch.hidden = true;
        
    }
    
    //set value
    [[AccountsClient sharedInstance] getSingleSetInfoWithID:setid completion:^(NSError *error, FDataSnapshot *accountInfo)  {
        
        NSLog(@"accountInfo = %@", accountInfo);
 
        NSString *url = accountInfo.value[@"set_background_pic"];
 
        [self->bgImg sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@""]];
        NSString *url1 = accountInfo.value[@"set_picture"];
        
        [self->coverImg sd_setImageWithURL:[NSURL URLWithString:url1] placeholderImage:[UIImage imageNamed:@""]];
        
        self->settitle.text = accountInfo.value[@"set_title"];
        self->trackurl = accountInfo.value[@"set_audio_link"];

        NSLog(@"trackurl %@",self->trackurl);

        self->artist = accountInfo.value[@"set_artist"];

        trackurl = accountInfo.value[@"set_audio_link"];
        [[AppDelegate sharedInstance].audioPlayer playURL:[NSURL URLWithString:trackurl]];
        
        
        
        RLMResults<CrateRealm1 *> *res = [CrateRealm1 objectsWhere:@"trackID = %@ and set_id = %@",trackid,setid];
        
        //if from crate
        
        NSString *isplayed = [[NSUserDefaults standardUserDefaults] objectForKey:@"nowplaying"];
        
        if([isplayed isEqualToString:@"2"]){
            
            //do nothing
            
            [self observers];
            
            if([[[NSUserDefaults standardUserDefaults] objectForKey:@"fromcrate"]  isEqual: @"1"] ){
                
                slider.maximumValue = 1000;
                
                slider.value = [res.firstObject.track_start integerValue];
                
                [playButton setImage:[UIImage imageNamed:@"pause_btn"] forState:UIControlStateNormal];
  
                [[AppDelegate sharedInstance].audioPlayer seekToTime:[res.firstObject.track_start integerValue]];
 
            }else{

                [[AppDelegate sharedInstance].audioPlayer seekToTime:[res.firstObject.track_start integerValue]];
                
            }
            
        }else if([isplayed isEqualToString:@"0"]){
            
            [self observers];
            
            if([[[NSUserDefaults standardUserDefaults] objectForKey:@"fromcrate"]  isEqual: @"1"] ){
  
                slider.maximumValue = 1000;
                
                slider.value = [res.firstObject.track_start integerValue];
  
                [playButton setImage:[UIImage imageNamed:@"pause_btn"] forState:UIControlStateNormal];
  
                [[AppDelegate sharedInstance].audioPlayer seekToTime:[res.firstObject.track_start integerValue]];

            }
            
        }else{
            
            [self observers];
            
            [self initTracks];
            
            if([[[NSUserDefaults standardUserDefaults] objectForKey:@"fromcrate"]  isEqual: @"1"] ){
 
                slider.maximumValue = 1000;
                
                slider.value = [res.firstObject.track_start integerValue];
                
                NSLog(@"track start %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"trackstart"]);
                
                [playButton setImage:[UIImage imageNamed:@"pause_btn"] forState:UIControlStateNormal];
                
                NSLog(@"slider value %f",slider.value);
                
                [[AppDelegate sharedInstance].audioPlayer seekToTime:[res.firstObject.track_start integerValue]];
                
            }
            
        }
        
        //change gesture
        
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"switch"]  isEqual: @"on"]){
            
            UISwipeGestureRecognizer *rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipeHandle:)];
            
            rightRecognizer.delegate=self;
            
            rightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;

            [self.view addGestureRecognizer:rightRecognizer];
            
            UISwipeGestureRecognizer *leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeHandle:)];
            
            leftRecognizer.delegate=self;
            
            leftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;

            [self.view addGestureRecognizer:leftRecognizer];
            UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
            
            tapGestureRecognizer.delegate=self;
            
            [touch addGestureRecognizer:tapGestureRecognizer];
            
            animationFrames = [NSArray arrayWithObjects:
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill1.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill2.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill3.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill4.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill5.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill6.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill7.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill8.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill9.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill10.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill11.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill12.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill13.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill14.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill15.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill16.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill17.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill18.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill19.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill20.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill21.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill22.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill23.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill24.png"],
                               
                               nil];
            
            
            animationFramesc = [NSArray arrayWithObjects:
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White1.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White2.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White3.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White4.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White5.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White6.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White7.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White8.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White9.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White10.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White11.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White12.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White13.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White14.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White15.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White16.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White17.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White18.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White19.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White20.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White21.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White22.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White23.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White24.png"],
                               
                               //[UIImage imageNamed:@"selektaRecordSpin_White2.png"],
                               
                               nil];
            if(res.count>0){
      
                animatedImageView.animationImages = animationFramesc;
                
                animatedImageView.hidden = false;
                
                animatedImageView.animationDuration = 2.0;
                
                [animatedImageView startAnimating];
                
            }else{
                
                animatedImageView.animationImages = animationFrames;
                
                animatedImageView.hidden = false;
                
                animatedImageView.animationDuration = 2.0;
                
                [animatedImageView startAnimating];

            }

            playButton.hidden = true;
            
            nextButton.hidden = true;
            
            prevButton.hidden = true;
   
            
        }else{
            
 
            playButton.hidden = false;
            
            nextButton.hidden = false;
            
            prevButton.hidden = false;
            
            
        }
        
        
        
        UISwipeGestureRecognizer *upRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(upSwipeHandle:)];
        
        upRecognizer.delegate=self;
        
        upRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
        
        [self.view addGestureRecognizer:upRecognizer];
        
        
        
        trackTitle.text = res.firstObject.track_name;
        
        
        
        NSLog(@"track artist %@",res.firstObject.track_artist);
        
        
        
        trackRecord.text = res.firstObject.track_artist;
        
        
        
        trackAlbum.text = res.firstObject.track_label;
        
        [playButton setImage:[UIImage imageNamed:@"pause_btn"] forState:UIControlStateNormal];
        
    }];
    
    
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        
    }
    
}

- (void)didReceiveMemoryWarning

{
    
    [super didReceiveMemoryWarning];
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    [animatedImageView stopAnimating];    //here animation stops
    
    [animatedImageView removeFromSuperview];    // here view removes from view hierarchy
    
    animatedImageView = nil;
    
}

-(IBAction)goSearch:(id)sender{
    
    /*SearchViewController *detailsVC = [SearchViewController new];
     
     UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailsVC];
     [self.slideMenuController closeMenuBehindContentViewController:navController animated:YES completion:nil];*/
    
    if(isSearch == false){
        searchView.hidden = NO;
        self.searchField.hidden = NO;
        [self.searchField becomeFirstResponder];
        isSearch = true;
        animatedImageView.hidden = YES;
    }else{
        searchView.hidden = YES;
        isSearch = false;
        self.searchField.hidden = YES;
        [self.searchField resignFirstResponder];
        animatedImageView.hidden = NO;
    }
}

-(void) viewDidDisappear:(BOOL)animated{

}

-(void) viewDidAppear:(BOOL)animated{

    self.slideMenuController.panGestureEnabled = NO;
    
    //[crateBtn setImage:[UIImage imageNamed:@"crateoff.png"] forState:UIControlStateNormal];
    
    NSString *switchon1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"switch1"];
    
    
    
    if([switchon1 isEqualToString:@"on"]){
        
        [[AppDelegate sharedInstance].audioPlayer resume];
        
        [AppDelegate sharedInstance].audioPlayer.volume = [[[NSUserDefaults standardUserDefaults] objectForKey:@"volume"] doubleValue];

    }else{
    
        [[AppDelegate sharedInstance].audioPlayer pause];
        
        [AppDelegate sharedInstance].audioPlayer.volume = 0.0;
 
    }
 
}

-(BOOL) canBecomeFirstResponder

{
    
    return YES;
    
}

-(void) audioPlayerViewPlayFromHTTPSelected:(PlayerNewVC*)audioPlayerView : (NSString*) url1

{
    
    NSURL* url = [NSURL URLWithString:url1];
    

    [[AppDelegate sharedInstance].audioPlayer playURL:url];
    
    
    
    NSString *switchon1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"switch1"];
    
    if([switchon1 isEqualToString:@"on"]){
        
        [[AppDelegate sharedInstance].audioPlayer resume];
        
        [AppDelegate sharedInstance].audioPlayer.volume = [[[NSUserDefaults standardUserDefaults] objectForKey:@"volume"] doubleValue];
        
    }else{
 
        [[AppDelegate sharedInstance].audioPlayer pause];
        
        [AppDelegate sharedInstance].audioPlayer.volume = 0.0;
    }
    
}

-(IBAction)goPlay:(id)sender{
    
    [self playButtonPressed];
    
}

-(IBAction)goStop:(id)sender{
    
    [self playButtonPressed];
    
}

-(void) stopButtonPressed

{
    
    [[AppDelegate sharedInstance].audioPlayer pause];
    
}


-(void) playButtonPressed

{
    
    if (![AppDelegate sharedInstance].audioPlayer)
        
    {
        
        return;
        
    }
    

    
    if ([AppDelegate sharedInstance].audioPlayer.state == STKAudioPlayerStatePaused)
        
    {
        
        [[AppDelegate sharedInstance].audioPlayer resume];
        
        [playButton setImage:[UIImage imageNamed:@"pause_btn"] forState:UIControlStateNormal];
        
        [animatedImageView startAnimating];
        
        
    }
    
    else
        
    {
        
        [[AppDelegate sharedInstance].audioPlayer pause];
        
        [playButton setImage:[UIImage imageNamed:@"play_btn"] forState:UIControlStateNormal];

        
    }
    
    
    
    NSString *switchon1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"switch1"];
    
    
    
    if([switchon1 isEqualToString:@"on"]){
        
        [[AppDelegate sharedInstance].audioPlayer resume];
        
        [AppDelegate sharedInstance].audioPlayer.volume = [[[NSUserDefaults standardUserDefaults] objectForKey:@"volume"] doubleValue];
        
    }else{
        
        [[AppDelegate sharedInstance].audioPlayer pause];
        
        [AppDelegate sharedInstance].audioPlayer.volume = 0.0;

    }
    
}

-(NSString*) formatTimeFromSeconds:(int)totalSeconds

{
    
    int seconds = totalSeconds % 60;
    
    int minutes = (totalSeconds / 60) % 60;
    
    int hours = totalSeconds / 3600;

    return [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
    
}

-(void) sliderChanged

{
    
    if (![AppDelegate sharedInstance].audioPlayer)
        
    {
        
        return;
        
    }
    
    [[AppDelegate sharedInstance].audioPlayer seekToTime:slider.value];
    
    int recentid = ([trackid intValue] + 1);
    
    //NSString *validid =[NSString stringWithFormat:@"%d",recentid];
    
    RLMResults<TracksRealm *> *res = [TracksRealm objectsWhere:@"track_start >= %f and set_id = %@",slider.value,setid];

    if(res.count>0){
    
        trackid = res.firstObject.trackID;
        
        trackTitle.text = res.firstObject.track_name;
        
        trackRecord.text = res.firstObject.track_artist;
    
        trackAlbum.text = res.firstObject.track_label;

        [[NSUserDefaults standardUserDefaults] setObject:self->setid forKey:@"recentset"];
  
        [[NSUserDefaults standardUserDefaults] synchronize];

        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",res.firstObject.trackID] forKey:@"recentid"];
 
        [[NSUserDefaults standardUserDefaults] synchronize];
      
        MPNowPlayingInfoCenter *playingInfoCenter = [MPNowPlayingInfoCenter defaultCenter];
       
        NSMutableDictionary *songInfo = [[NSMutableDictionary alloc] init];
       
        MPMediaItemArtwork *albumArt = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:@"cover"]];
       
        [songInfo setObject:trackTitle.text forKey:MPMediaItemPropertyTitle];
    
        [songInfo setObject:res.firstObject.track_artist forKey:MPMediaItemPropertyArtist];
    
        [songInfo setObject:res.firstObject.track_label forKey:MPMediaItemPropertyAlbumTitle];
      
        [songInfo setObject:[NSNumber numberWithDouble:slider.value] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
      
        [songInfo setObject:[NSNumber numberWithDouble:200] forKey:MPMediaItemPropertyPlaybackDuration];
     
        [songInfo setObject:[NSNumber numberWithDouble:([AppDelegate sharedInstance].audioPlayer.state == STKAudioPlayerStatePaused ? 0.0f : 1.0f)] forKey:MPNowPlayingInfoPropertyPlaybackRate];
        
        [songInfo setObject:albumArt forKey:MPMediaItemPropertyArtwork];
      
        [playingInfoCenter setNowPlayingInfo:songInfo];
 
        RLMResults<CrateRealm1 *> *res = [CrateRealm1 objectsWhere:@"trackID = %@ and set_id = %@",trackid,setid];
       
        if(res.count>0){
            
            //[crateBtn setImage:[UIImage imageNamed:@"crateon.png"] forState:UIControlStateNormal];
            
        }else{
            
            //[crateBtn setImage:[UIImage imageNamed:@"crateoff.png"] forState:UIControlStateNormal];
            
        }
 
    }
    
    
    
}
-(void) setupTimer

{
    
    timer = [NSTimer timerWithTimeInterval:0.001 target:self selector:@selector(tick) userInfo:nil repeats:YES];
    
    
    
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
}

-(void) tick

{
    
    if (![AppDelegate sharedInstance].audioPlayer)
        
    {
        
        slider.value = 0;
        
        label.text = @"";
        
        statusLabel.text = @"";

        return;
        
    }
    

    if ([AppDelegate sharedInstance].audioPlayer.currentlyPlayingQueueItemId == nil)
        
    {
        
        slider.value = [AppDelegate sharedInstance].audioPlayer.progress;
        
        slider.minimumValue = 0;
        
        slider.maximumValue = [AppDelegate sharedInstance].audioPlayer.duration;
        
        
        
        label.text = @"";
        
        
        
        return;
        
    }
    
    
    
    if ([AppDelegate sharedInstance].audioPlayer.duration != 0)
        
    {
        
        slider.minimumValue = 0;
        
        slider.maximumValue = [AppDelegate sharedInstance].audioPlayer.duration;
        
        slider.value = [AppDelegate sharedInstance].audioPlayer.progress;
        
        
        
        label.text = [NSString stringWithFormat:@"%@ - %@", [self formatTimeFromSeconds:[AppDelegate sharedInstance].audioPlayer.progress], [self formatTimeFromSeconds:[AppDelegate sharedInstance].audioPlayer.duration]];
        
    }
    
    else
        
    {
        
        slider.value = [AppDelegate sharedInstance].audioPlayer.progress;
        
        slider.minimumValue = 0;
        
        slider.maximumValue =  [AppDelegate sharedInstance].audioPlayer.duration;
        
        
        
        label.text =  [NSString stringWithFormat:@"Live stream %@", [self formatTimeFromSeconds:[AppDelegate sharedInstance].audioPlayer.progress]];
        
    }
    
    
    
    statusLabel.text = [AppDelegate sharedInstance].audioPlayer.state == STKAudioPlayerStateBuffering ? @"buffering" : @"";
    
    
    
    CGFloat newWidth = 320 * (([[AppDelegate sharedInstance].audioPlayer peakPowerInDecibelsForChannel:1] + 60)/60);
    
    
    
    meter.frame = CGRectMake(0, self.view.bounds.size.height/2, newWidth, 30);
    
}

-(void) updateControls

{
    
    if ([AppDelegate sharedInstance].audioPlayer == nil)
        
    {
        
        [playButton setImage:[UIImage imageNamed:@"play_btn"] forState:UIControlStateNormal];
        
        
        
    }
    
    else if ([AppDelegate sharedInstance].audioPlayer.state == STKAudioPlayerStatePaused)
        
    {
        
    
        [playButton setImage:[UIImage imageNamed:@"play_btn"] forState:UIControlStateNormal];
        
    }
    
    else if ([AppDelegate sharedInstance].audioPlayer.state & STKAudioPlayerStatePlaying)
        
    {
    
        [playButton setImage:[UIImage imageNamed:@"pause_btn"] forState:UIControlStateNormal];
        
    }
    
    else
        
    {
    
        [playButton setImage:[UIImage imageNamed:@"pause_btn"] forState:UIControlStateNormal];
        
    }
    
    
    
    [self tick];
    
}

-(void) setAudioPlayer:(STKAudioPlayer*)value

{
    
    if ([AppDelegate sharedInstance].audioPlayer)
        
    {
        
        [AppDelegate sharedInstance].audioPlayer.delegate = nil;
        
    }
    
    
    
    [AppDelegate sharedInstance].audioPlayer = value;
    
    [AppDelegate sharedInstance].audioPlayer.delegate = self;
    
    
    
    [self updateControls];
    
}



-(STKAudioPlayer*) audioPlayer

{
    
    return [AppDelegate sharedInstance].audioPlayer;
    
}
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer stateChanged:(STKAudioPlayerState)state previousState:(STKAudioPlayerState)previousState

{
    
    if (state == STKAudioPlayerStateBuffering) {
        
        [audioPlayer seekToTime:slider.value];
        
    }
    
    [self updateControls];
    
}

-(void) audioPlayer:(STKAudioPlayer*)audioPlayer unexpectedError:(STKAudioPlayerErrorCode)errorCode

{
    
    [self updateControls];
    
}



-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didStartPlayingQueueItemId:(NSObject*)queueItemId

{
    
    SampleQueueId* queueId = (SampleQueueId*)queueItemId;
    
    
    
    NSLog(@"Started: %@", [queueId.url description]);
    
    
    
    [self updateControls];
    
}

- (IBAction)showMenu:(id)sender {
    
    
    
    if(self.slideMenuController.isMenuOpen==YES){
        
        [self.slideMenuController closeMenuAnimated:YES completion:nil];

    }else{
        
        self.slideMenuController.slideDirection = NVSlideMenuControllerSlideFromLeftToRight;
        
        [self.slideMenuController toggleMenuAnimated:nil];
        
        
    }
    

    [_searchField resignFirstResponder];
 
    
}
-(void) handleTapFrom: (UITapGestureRecognizer *) del{
    
    if (![AppDelegate sharedInstance].audioPlayer)
        
    {
        
        return;
        
    }
    
    
    
    if ([AppDelegate sharedInstance].audioPlayer.state == STKAudioPlayerStatePaused)
        
    {
        
        [[AppDelegate sharedInstance].audioPlayer resume];
        
        RLMResults<CrateRealm1 *> *res = [CrateRealm1 objectsWhere:@"trackID = %@ and set_id = %@",trackid,setid];
        
        animationFrames = [NSArray arrayWithObjects:
                           
                           [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill1.png"],
                           
                           [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill2.png"],
                           
                           [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill3.png"],
                           
                           [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill4.png"],
                           
                           [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill5.png"],
                           
                           [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill6.png"],
                           
                           [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill7.png"],
                           
                           [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill8.png"],
                           
                           [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill9.png"],
                           
                           [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill10.png"],
                           
                           [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill11.png"],
                           
                           [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill12.png"],
                           
                           [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill13.png"],
                           
                           [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill14.png"],
                           
                           [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill15.png"],
                           
                           [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill16.png"],
                           
                           [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill17.png"],
                           
                           [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill18.png"],
                           
                           [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill19.png"],
                           
                           [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill20.png"],
                           
                           [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill21.png"],
                           
                           [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill22.png"],
                           
                           [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill23.png"],
                           
                           [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill24.png"],
                           
                           nil];
        
        
        animationFramesc = [NSArray arrayWithObjects:
                            
                            [UIImage imageNamed:@"selektaRecordSpin_White1.png"],
                            
                            [UIImage imageNamed:@"selektaRecordSpin_White2.png"],
                            
                            [UIImage imageNamed:@"selektaRecordSpin_White3.png"],
                            
                            [UIImage imageNamed:@"selektaRecordSpin_White4.png"],
                            
                            [UIImage imageNamed:@"selektaRecordSpin_White5.png"],
                            
                            [UIImage imageNamed:@"selektaRecordSpin_White6.png"],
                            
                            [UIImage imageNamed:@"selektaRecordSpin_White7.png"],
                            
                            [UIImage imageNamed:@"selektaRecordSpin_White8.png"],
                            
                            [UIImage imageNamed:@"selektaRecordSpin_White9.png"],
                            
                            [UIImage imageNamed:@"selektaRecordSpin_White10.png"],
                            
                            [UIImage imageNamed:@"selektaRecordSpin_White11.png"],
                            
                            [UIImage imageNamed:@"selektaRecordSpin_White12.png"],
                            
                            [UIImage imageNamed:@"selektaRecordSpin_White13.png"],
                            
                            [UIImage imageNamed:@"selektaRecordSpin_White14.png"],
                            
                            [UIImage imageNamed:@"selektaRecordSpin_White15.png"],
                            
                            [UIImage imageNamed:@"selektaRecordSpin_White16.png"],
                            
                            [UIImage imageNamed:@"selektaRecordSpin_White17.png"],
                            
                            [UIImage imageNamed:@"selektaRecordSpin_White18.png"],
                            
                            [UIImage imageNamed:@"selektaRecordSpin_White19.png"],
                            
                            [UIImage imageNamed:@"selektaRecordSpin_White20.png"],
                            
                            [UIImage imageNamed:@"selektaRecordSpin_White21.png"],
                            
                            [UIImage imageNamed:@"selektaRecordSpin_White22.png"],
                            
                            [UIImage imageNamed:@"selektaRecordSpin_White23.png"],
                            
                            [UIImage imageNamed:@"selektaRecordSpin_White24.png"],
                            
                            //[UIImage imageNamed:@"selektaRecordSpin_White2.png"],
                            
                            nil];
        
        
        
        if(res.count>0){
            
            
            
            animatedImageView.animationImages = animationFramesc;
            
            
            
            animatedImageView.hidden = false;
            
            animatedImageView.animationDuration = 2.0;
            
            [animatedImageView startAnimating];
            
            //[GiFHUD setGifWithImageName:@"selektaRecordSpin.gif"];
            
            
            
        }else{
            
            animatedImageView.animationImages = animationFrames;
            
            
            
            animatedImageView.hidden = false;
            
            animatedImageView.animationDuration = 2.0;
            
            [animatedImageView startAnimating];
            
            //[GiFHUD setGifWithImageName:@"selektaRecordSpin.gif"];
            
            
            
        }
        
        
        
        //[GiFHUD show];
        
        
        
        playButton.hidden = true;
        
        nextButton.hidden = true;
        
        prevButton.hidden = true;
        
        //crateBtn.hidden = true;
        
        
        
    }
    
    else
        
    {
        
        [[AppDelegate sharedInstance].audioPlayer pause];
        
        //[GiFHUD dismiss];
        
        
        
        RLMResults<CrateRealm1 *> *res = [CrateRealm1 objectsWhere:@"trackID = %@ and set_id = %@",trackid,setid];
 
        if(res.count>0){
            
            
            
            //animatedImageView.animationImages = animationFramesc;
            
            
            
            animatedImageView.hidden = false;
            
            animatedImageView.animationDuration = 2.0;
            
            [animatedImageView stopAnimating];
            
            animatedImageView.image = [UIImage imageNamed:@"selektaRecordSpin_White1.png"];
            
            //[GiFHUD setGifWithImageName:@"selektarecordanimationwhite-version.gif"];
            
            
            
        }else{
            
            //animatedImageView.animationImages = animationFrames;
            
            
            
            animatedImageView.hidden = false;
            
            animatedImageView.animationDuration = 2.0;
            
            [animatedImageView stopAnimating];
            
            animatedImageView.image = [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill1.png"];
            
            //[GiFHUD setGifWithImageName:@"selektarecordanimationnoBack.gif"];
            
            
            
        }
        
        //[GiFHUD show];
        
        
        
        
        
        playButton.hidden = true;
        
        nextButton.hidden = true;
        
        prevButton.hidden = true;
        
        //crateBtn.hidden = true;
        
        
        
        [playButton setImage:[UIImage imageNamed:@"play_btn"] forState:UIControlStateNormal];
        
        
        
        
        
    }
    
}
-(void) leftSwipeHandle: (UISwipeGestureRecognizer *) del{
    
    int recentid = ([trackid intValue] + 1);
    
    NSString *validid =[NSString stringWithFormat:@"%d",recentid];
    
    RLMResults<TracksRealm *> *res = [TracksRealm objectsWhere:@"trackID = %@ and set_id = %@",validid,setid];
    
    
    
    if(res.count>0){
        
        
        
        trackid = validid;
        
        trackTitle.text = res.firstObject.track_name;
        
        slider.value = res.firstObject.track_start;
        
        [[AppDelegate sharedInstance].audioPlayer seekToTime:slider.value];
        
        
        
        NSLog(@"track artist %@",res.firstObject.track_artist);
        
        
        
        trackRecord.text = res.firstObject.track_artist;
        
        
        
        trackAlbum.text = res.firstObject.track_label;
        
        
        
        
        
        [[NSUserDefaults standardUserDefaults] setObject:self->setid forKey:@"recentset"];
        
        
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        
        
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",validid] forKey:@"recentid"];
        
        
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        
        
        
        
        
        MPNowPlayingInfoCenter *playingInfoCenter = [MPNowPlayingInfoCenter defaultCenter];
        
        
        
        
        
        
        
        NSMutableDictionary *songInfo = [[NSMutableDictionary alloc] init];
        
        
        
        
        
        
        
        MPMediaItemArtwork *albumArt = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:@"cover"]];
        
        
        
        
        
        
        
        [songInfo setObject:trackTitle.text forKey:MPMediaItemPropertyTitle];
        
        
        
        [songInfo setObject:res.firstObject.track_artist forKey:MPMediaItemPropertyArtist];
        
        
        
        [songInfo setObject:res.firstObject.track_label forKey:MPMediaItemPropertyAlbumTitle];
        
        
        
        [songInfo setObject:[NSNumber numberWithDouble:slider.value] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
        
        
        
        [songInfo setObject:[NSNumber numberWithDouble:200] forKey:MPMediaItemPropertyPlaybackDuration];
        
        
        
        [songInfo setObject:[NSNumber numberWithDouble:([AppDelegate sharedInstance].audioPlayer.state == STKAudioPlayerStatePaused ? 0.0f : 1.0f)] forKey:MPNowPlayingInfoPropertyPlaybackRate];
        
        
        
        [songInfo setObject:albumArt forKey:MPMediaItemPropertyArtwork];
        
        
        
        
        
        
        
        [playingInfoCenter setNowPlayingInfo:songInfo];
        
        
        
        
        
        RLMResults<CrateRealm1 *> *res = [CrateRealm1 objectsWhere:@"trackID = %@ and set_id = %@",trackid,setid];
        
        
        
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"switch"]  isEqual: @"on"]){
            
            
            
            animationFrames = [NSArray arrayWithObjects:
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill1.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill2.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill3.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill4.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill5.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill6.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill7.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill8.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill9.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill10.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill11.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill12.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill13.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill14.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill15.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill16.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill17.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill18.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill19.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill20.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill21.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill22.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill23.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill24.png"],
                               
                               nil];
            
            
            animationFramesc = [NSArray arrayWithObjects:
                                
                                [UIImage imageNamed:@"selektaRecordSpin_White1.png"],
                                
                                [UIImage imageNamed:@"selektaRecordSpin_White2.png"],
                                
                                [UIImage imageNamed:@"selektaRecordSpin_White3.png"],
                                
                                [UIImage imageNamed:@"selektaRecordSpin_White4.png"],
                                
                                [UIImage imageNamed:@"selektaRecordSpin_White5.png"],
                                
                                [UIImage imageNamed:@"selektaRecordSpin_White6.png"],
                                
                                [UIImage imageNamed:@"selektaRecordSpin_White7.png"],
                                
                                [UIImage imageNamed:@"selektaRecordSpin_White8.png"],
                                
                                [UIImage imageNamed:@"selektaRecordSpin_White9.png"],
                                
                                [UIImage imageNamed:@"selektaRecordSpin_White10.png"],
                                
                                [UIImage imageNamed:@"selektaRecordSpin_White11.png"],
                                
                                [UIImage imageNamed:@"selektaRecordSpin_White12.png"],
                                
                                [UIImage imageNamed:@"selektaRecordSpin_White13.png"],
                                
                                [UIImage imageNamed:@"selektaRecordSpin_White14.png"],
                                
                                [UIImage imageNamed:@"selektaRecordSpin_White15.png"],
                                
                                [UIImage imageNamed:@"selektaRecordSpin_White16.png"],
                                
                                [UIImage imageNamed:@"selektaRecordSpin_White17.png"],
                                
                                [UIImage imageNamed:@"selektaRecordSpin_White18.png"],
                                
                                [UIImage imageNamed:@"selektaRecordSpin_White19.png"],
                                
                                [UIImage imageNamed:@"selektaRecordSpin_White20.png"],
                                
                                [UIImage imageNamed:@"selektaRecordSpin_White21.png"],
                                
                                [UIImage imageNamed:@"selektaRecordSpin_White22.png"],
                                
                                [UIImage imageNamed:@"selektaRecordSpin_White23.png"],
                                
                                [UIImage imageNamed:@"selektaRecordSpin_White24.png"],
                                
                                //[UIImage imageNamed:@"selektaRecordSpin_White2.png"],
                                
                                nil];

            
            
            
            if(res.count>0){
                
                
                
                animatedImageView.animationImages = animationFramesc;
                
                
                
                animatedImageView.hidden = false;
                
                animatedImageView.animationDuration = 2.0;
                
                [animatedImageView startAnimating];
                
                //animatedImageView.image = [UIImage imageNamed:@"selektaRecordSpin_White1.png"];
                
                //[GiFHUD setGifWithImageName:@"selektarecordanimationwhite-version.gif"];
                
                
                
            }else{
                
                animatedImageView.animationImages = animationFrames;
                
                
                
                animatedImageView.hidden = false;
                
                animatedImageView.animationDuration = 2.0;
                
                [animatedImageView startAnimating];
                
                //animatedImageView.image = [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill1.png"];
                
                //[GiFHUD setGifWithImageName:@"selektarecordanimationnoBack.gif"];
                
                
                
            }
            
            
            
            //[GiFHUD show];
            
            
            
            playButton.hidden = true;
            
            nextButton.hidden = true;
            
            prevButton.hidden = true;
            
            crateBtn.hidden = true;
            
            
            
            
            
        }else{
            
            animatedImageView.hidden = true;
            
            
            
            playButton.hidden = false;
            
            nextButton.hidden = false;
            
            prevButton.hidden = false;
            
            crateBtn.hidden = true;
            
            
            
            // [GiFHUD dismiss];
            
            /*if(res.count>0){
             
             
             
             [crateBtn setImage:[UIImage imageNamed:@"crateon.png"] forState:UIControlStateNormal];
             
             }else{
             
             [crateBtn setImage:[UIImage imageNamed:@"crateoff.png"] forState:UIControlStateNormal];
             
             }*/
            
        }
        
        
        
    }else{
        
        
        
    }
}

-(void) rightSwipeHandle: (UISwipeGestureRecognizer *) del{
    
    int recentid = ([trackid integerValue] - 1);
    
    NSString *validid =[NSString stringWithFormat:@"%d",recentid];
    
    RLMResults<TracksRealm *> *res = [TracksRealm objectsWhere:@"trackID = %@ and set_id = %@",validid,setid];
    
    
    
    if(res.count>0){
        
        
        
        trackid = validid;
        
        trackTitle.text = res.firstObject.track_name;
        
        
        
        NSLog(@"track artist %@",res.firstObject.track_artist);
        
        slider.value = res.firstObject.track_start;
        
        [[AppDelegate sharedInstance].audioPlayer seekToTime:slider.value];
        
        
        
        
        
        trackRecord.text = res.firstObject.track_artist;
        
        
        
        trackAlbum.text = res.firstObject.track_label;
        
        
        
        [[NSUserDefaults standardUserDefaults] setObject:self->setid forKey:@"recentset"];
        
        
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        
        
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",validid] forKey:@"recentid"];
        
        
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        
        
        
        
        
        MPNowPlayingInfoCenter *playingInfoCenter = [MPNowPlayingInfoCenter defaultCenter];
        
        
        
        
        
        
        
        NSMutableDictionary *songInfo = [[NSMutableDictionary alloc] init];
        
        
        
        
        
        
        
        MPMediaItemArtwork *albumArt = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:@"cover"]];
        
        
        
        
        
        
        
        [songInfo setObject:trackTitle.text forKey:MPMediaItemPropertyTitle];
        
        
        
        [songInfo setObject:res.firstObject.track_artist forKey:MPMediaItemPropertyArtist];
        
        
        
        [songInfo setObject:res.firstObject.track_label forKey:MPMediaItemPropertyAlbumTitle];
        
        
        
        [songInfo setObject:[NSNumber numberWithDouble:slider.value] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
        
        
        
        [songInfo setObject:[NSNumber numberWithDouble:200] forKey:MPMediaItemPropertyPlaybackDuration];
        
        
        
        [songInfo setObject:[NSNumber numberWithDouble:([AppDelegate sharedInstance].audioPlayer.state == STKAudioPlayerStatePaused ? 0.0f : 1.0f)] forKey:MPNowPlayingInfoPropertyPlaybackRate];
        
        
        
        [songInfo setObject:albumArt forKey:MPMediaItemPropertyArtwork];
        
        
        
        
        
        
        
        [playingInfoCenter setNowPlayingInfo:songInfo];
        
        
        
        
        
        RLMResults<CrateRealm1 *> *res = [CrateRealm1 objectsWhere:@"trackID = %@ and set_id = %@",trackid,setid];
        
        
        
        
        
        
        
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"switch"]  isEqual: @"on"]){
            
            
            
            animationFrames = [NSArray arrayWithObjects:
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill1.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill2.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill3.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill4.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill5.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill6.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill7.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill8.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill9.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill10.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill11.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill12.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill13.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill14.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill15.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill16.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill17.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill18.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill19.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill20.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill21.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill22.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill23.png"],
                               
                               [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill24.png"],
                               
                               nil];
            
            
            animationFramesc = [NSArray arrayWithObjects:
                                
                                [UIImage imageNamed:@"selektaRecordSpin_White1.png"],
                                
                                [UIImage imageNamed:@"selektaRecordSpin_White2.png"],
                                
                                [UIImage imageNamed:@"selektaRecordSpin_White3.png"],
                                
                                [UIImage imageNamed:@"selektaRecordSpin_White4.png"],
                                
                                [UIImage imageNamed:@"selektaRecordSpin_White5.png"],
                                
                                [UIImage imageNamed:@"selektaRecordSpin_White6.png"],
                                
                                [UIImage imageNamed:@"selektaRecordSpin_White7.png"],
                                
                                [UIImage imageNamed:@"selektaRecordSpin_White8.png"],
                                
                                [UIImage imageNamed:@"selektaRecordSpin_White9.png"],
                                
                                [UIImage imageNamed:@"selektaRecordSpin_White10.png"],
                                
                                [UIImage imageNamed:@"selektaRecordSpin_White11.png"],
                                
                                [UIImage imageNamed:@"selektaRecordSpin_White12.png"],
                                
                                [UIImage imageNamed:@"selektaRecordSpin_White13.png"],
                                
                                [UIImage imageNamed:@"selektaRecordSpin_White14.png"],
                                
                                [UIImage imageNamed:@"selektaRecordSpin_White15.png"],
                                
                                [UIImage imageNamed:@"selektaRecordSpin_White16.png"],
                                
                                [UIImage imageNamed:@"selektaRecordSpin_White17.png"],
                                
                                [UIImage imageNamed:@"selektaRecordSpin_White18.png"],
                                
                                [UIImage imageNamed:@"selektaRecordSpin_White19.png"],
                                
                                [UIImage imageNamed:@"selektaRecordSpin_White20.png"],
                                
                                [UIImage imageNamed:@"selektaRecordSpin_White21.png"],
                                
                                [UIImage imageNamed:@"selektaRecordSpin_White22.png"],
                                
                                [UIImage imageNamed:@"selektaRecordSpin_White23.png"],
                                
                                [UIImage imageNamed:@"selektaRecordSpin_White24.png"],
                                
                                //[UIImage imageNamed:@"selektaRecordSpin_White2.png"],
                                
                                nil];
            
            
            
            
            if(res.count>0){
                
                
                
                animatedImageView.animationImages = animationFramesc;
                
                
                
                animatedImageView.hidden = false;
                
                animatedImageView.animationDuration = 2.0;
                
                [animatedImageView startAnimating];
                
                //animatedImageView.image = [UIImage imageNamed:@"selektaRecordSpin_White1.png"];
                
                //[GiFHUD setGifWithImageName:@"selektarecordanimationwhite-version.gif"];
                
                
                
            }else{
                
                animatedImageView.animationImages = animationFrames;
                
                
                
                animatedImageView.hidden = false;
                
                animatedImageView.animationDuration = 2.0;
                
                [animatedImageView startAnimating];
                
                //animatedImageView.image = [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill1.png"];
                
                //[GiFHUD setGifWithImageName:@"selektarecordanimationnoBack.gif"];
                
                
                
            }
            
            
            //[GiFHUD show];
            
            playButton.hidden = true;
            
            nextButton.hidden = true;
            
            prevButton.hidden = true;
            
            crateBtn.hidden = true;
            
            
            
            
            
        }else{
            
            animatedImageView.hidden = true;
            
            
            
            playButton.hidden = false;
            
            nextButton.hidden = false;
            
            prevButton.hidden = false;
            
            crateBtn.hidden = true;
            
            // [GiFHUD dismiss];
            
            
            
            /*if(res.count>0){
             
             
             
             [crateBtn setImage:[UIImage imageNamed:@"crateon.png"] forState:UIControlStateNormal];
             
             }else{
             
             [crateBtn setImage:[UIImage imageNamed:@"crateoff.png"] forState:UIControlStateNormal];
             
             }*/
            
        }
        
        
        
        
        
    }else{
        
        
        
    }
}
-(void) upSwipeHandle: (UISwipeGestureRecognizer *) del{
    
    if(![trackid  isEqual: @""] || ![setid isEqual: @""]){
        
        
        
        RLMResults<TracksRealm *> *res = [TracksRealm objectsWhere:@"trackID = %@ and set_id = %@",trackid,setid];
        
        
        
        if(res.count>0){
            
            [[AccountsClient sharedInstance] getSingleSetInfoWithID:setid completion:^(NSError *error, FDataSnapshot *accountInfo)  {
                
                
                
                NSLog(@"accountInfo = %@", accountInfo.value);
                
                SetObj *st = [[SetObj alloc] init];
                
                NSString *sobjID = [NSString stringWithFormat:@"%@",accountInfo.value[@"setid"]];
                
                st.objectId = sobjID;
                
                
                
                st.set_artist=accountInfo.value[@"set_artist"];
                
                st.set_audio_link=accountInfo.value[@"set_audio_link"];
                
                st.set_id=accountInfo.value[@"setid"];
                
                st.set_title=accountInfo.value[@"set_title"];
                
                st.created_at=accountInfo.value[@"dateCreated"];
                
                st.updated_at=accountInfo.value[@"dateCreated"];
                
                st.set_picture=accountInfo.value[@"set_picture"];
                
                st.set_background_pic=accountInfo.value[@"set_background_pic"];
                
                st.set_btn_image=accountInfo.value[@"set_btn_image"];
                
                
                
                NSString *dateString = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                        
                                                                      dateStyle:NSDateFormatterShortStyle
                                        
                                                                      timeStyle:NSDateFormatterFullStyle];
                
                NSLog(@"%@",dateString);
                
                NSString *playerID = [defaults objectForKey:@"GLOBAL_USER_ID"];
                
                NSDictionary *userInfo = @{
                                           
                                           @"trackID" : res.firstObject.trackID,
                                           
                                           @"set_id" : res.firstObject.set_id,
                                           
                                           @"track_artists" : res.firstObject.track_artist,
                                           
                                           @"track_name" : res.firstObject.track_name,
                                           
                                           @"track_label" : res.firstObject.track_label,
                                           
                                           @"track_album" : st.set_title,
                                           
                                           @"set_title" : st.set_title,
                                           
                                           @"dateCreated" : dateString,
                                           
                                           @"setbg" : st.set_btn_image,
                                           
                                           @"seturl" : st.set_audio_link,
                                           
                                           @"tracklabel": res.firstObject.track_label,
                                           
                                           @"track_start": [NSString stringWithFormat:@"%f",res.firstObject.track_start]
                                           
                                           };
                
                
                
                NSLog(@"userinfo %@",userInfo);
                
                RLMRealm *realm = [RLMRealm defaultRealm];
                
                CrateRealm1 *tobjr = [[CrateRealm1 alloc] init];
                
                tobjr.objectId = res.firstObject.objectId;
                
                
                
                tobjr.set_id=res.firstObject.set_id;
                
                tobjr.crate_id=res.firstObject.set_id;
                
                tobjr.trackID=res.firstObject.trackID;
                
                tobjr.created_at = res.firstObject.created_at;
                
                tobjr.updated_at=res.firstObject.updated_at;
                
                tobjr.track_name = res.firstObject.track_name;
                
                tobjr.track_artist = res.firstObject.track_artist;
                
                tobjr.settitle = st.set_title;
                
                tobjr.setbg = st.set_btn_image;
                
                tobjr.track_label = res.firstObject.track_label;
                
                tobjr.track_start = [NSString stringWithFormat:@"%f",res.firstObject.track_start];
                
                tobjr.seturl = st.set_audio_link;
                
                
                
                // Updating book with id = 1
                
                [realm beginWriteTransaction];
                
                [realm addOrUpdateObject:tobjr];
                
                [realm commitWriteTransaction];
                
                
                
                
                
                [[AccountsClient sharedInstance] savetoCrate:userInfo accountID:playerID setID:res.firstObject.set_id trackID:[NSString stringWithFormat:@"%d",(int)floor(res.firstObject.track_start+0.5)] completion:nil];
                
                
                
                NSDictionary *options = @{
                                          
                                          kCRToastTextKey : @"Track added to Create",
                                          
                                          kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                                          
                                          kCRToastBackgroundColorKey : [UIColor clearColor],
                                          
                                          kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
                                          
                                          kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeGravity),
                                          
                                          kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionLeft),
                                          
                                          kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionRight)
                                          
                                          };
                
                /*[CRToastManager showNotificationWithOptions:options
                 
                 completionBlock:^{
                 
                 NSLog(@"Completed");
                 
                 }];*/
                
                
                
                if([[[NSUserDefaults standardUserDefaults] objectForKey:@"switch"]  isEqual: @"on"]){
                    
                    
                    
                    animationFrames = [NSArray arrayWithObjects:
                                       
                                       [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill1.png"],
                                       
                                       [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill2.png"],
                                       
                                       [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill3.png"],
                                       
                                       [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill4.png"],
                                       
                                       [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill5.png"],
                                       
                                       [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill6.png"],
                                       
                                       [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill7.png"],
                                       
                                       [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill8.png"],
                                       
                                       [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill9.png"],
                                       
                                       [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill10.png"],
                                       
                                       [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill11.png"],
                                       
                                       [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill12.png"],
                                       
                                       [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill13.png"],
                                       
                                       [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill14.png"],
                                       
                                       [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill15.png"],
                                       
                                       [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill16.png"],
                                       
                                       [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill17.png"],
                                       
                                       [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill18.png"],
                                       
                                       [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill19.png"],
                                       
                                       [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill20.png"],
                                       
                                       [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill21.png"],
                                       
                                       [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill22.png"],
                                       
                                       [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill23.png"],
                                       
                                       [UIImage imageNamed:@"selektaRecordSpin_White_no_Fill24.png"],
                                       
                                       nil];
                    
                    
                    animationFramesc = [NSArray arrayWithObjects:
                                        
                                        [UIImage imageNamed:@"selektaRecordSpin_White1.png"],
                                        
                                        [UIImage imageNamed:@"selektaRecordSpin_White2.png"],
                                        
                                        [UIImage imageNamed:@"selektaRecordSpin_White3.png"],
                                        
                                        [UIImage imageNamed:@"selektaRecordSpin_White4.png"],
                                        
                                        [UIImage imageNamed:@"selektaRecordSpin_White5.png"],
                                        
                                        [UIImage imageNamed:@"selektaRecordSpin_White6.png"],
                                        
                                        [UIImage imageNamed:@"selektaRecordSpin_White7.png"],
                                        
                                        [UIImage imageNamed:@"selektaRecordSpin_White8.png"],
                                        
                                        [UIImage imageNamed:@"selektaRecordSpin_White9.png"],
                                        
                                        [UIImage imageNamed:@"selektaRecordSpin_White10.png"],
                                        
                                        [UIImage imageNamed:@"selektaRecordSpin_White11.png"],
                                        
                                        [UIImage imageNamed:@"selektaRecordSpin_White12.png"],
                                        
                                        [UIImage imageNamed:@"selektaRecordSpin_White13.png"],
                                        
                                        [UIImage imageNamed:@"selektaRecordSpin_White14.png"],
                                        
                                        [UIImage imageNamed:@"selektaRecordSpin_White15.png"],
                                        
                                        [UIImage imageNamed:@"selektaRecordSpin_White16.png"],
                                        
                                        [UIImage imageNamed:@"selektaRecordSpin_White17.png"],
                                        
                                        [UIImage imageNamed:@"selektaRecordSpin_White18.png"],
                                        
                                        [UIImage imageNamed:@"selektaRecordSpin_White19.png"],
                                        
                                        [UIImage imageNamed:@"selektaRecordSpin_White20.png"],
                                        
                                        [UIImage imageNamed:@"selektaRecordSpin_White21.png"],
                                        
                                        [UIImage imageNamed:@"selektaRecordSpin_White22.png"],
                                        
                                        [UIImage imageNamed:@"selektaRecordSpin_White23.png"],
                                        
                                        [UIImage imageNamed:@"selektaRecordSpin_White24.png"],
                                        
                                        //[UIImage imageNamed:@"selektaRecordSpin_White2.png"],
                                        
                                        nil];
                    
                    
                    
                    animatedImageView.animationImages = animationFramesc;
                    
                    
                    
                     animatedImageView.hidden = false;
                    
                     animatedImageView.animationDuration = 2.0;
                    
                     [animatedImageView startAnimating];
                    
                    
                    
                    // [GiFHUD setGifWithImageName:@"selektaRecordSpin.gif"];
                    
                    
                    
                    //[GiFHUD show];
                    
                    playButton.hidden = true;
                    
                    nextButton.hidden = true;
                    
                    prevButton.hidden = true;
                    
                    crateBtn.hidden = true;
                    
                    
                    
                    
                    
                }else{
                    
                    animatedImageView.hidden = true;
                    
                    // [GiFHUD dismiss];
                    
                    playButton.hidden = false;
                    
                    nextButton.hidden = false;
                    
                    prevButton.hidden = false;
                    
                    crateBtn.hidden = true;
                    
                    
                    
                    
                    
                    //[crateBtn setImage:[UIImage imageNamed:@"crateon.png"] forState:UIControlStateNormal];
                    
                }
                
                
                
                
                
                
                
                
                
            }];
            
        }
        
    }
}

-(void)observers{

    NSLog(@"setid %@",setid);
    
    [[AccountsClient sharedInstance] getAllTracks:setid completion:^(NSError *error, FDataSnapshot *sets1) {
        
        
        
        if (sets1.value != (id)[NSNull null]) {
            
            RLMRealm *realm = [RLMRealm defaultRealm];
            
            
            
            for (int i=0; i <sets1.childrenCount; i++) {
                
                
                
                NSDictionary *setid1 = [sets1.value objectAtIndex:i];
                
                if(setid1 != (id)[NSNull null]){
                    
                    NSLog(@"trackid = %@", setid1[@"trackID"]);
                    
                    TrackObj *tobj = [[TrackObj alloc] init];
                    
                    NSString *sobjID = [NSString stringWithFormat:@"%@",setid1[@"trackID"]];
                    
                    tobj.objectId = sobjID;
                    
                    
                    
                    tobj.set_id=setid1[@"set_id"];
                    
                    tobj.trackID=sobjID;
                    
                    tobj.track_artist=setid1[@"track_artists"];
                    
                    tobj.track_label=setid1[@"track_label"];
                    
                    tobj.track_name=setid1[@"track_name"];
                    
                    tobj.track_start=setid1[@"track_start"];
                    
                    tobj.created_at=setid1[@"dateCreated"];
                    
                    tobj.updated_at=setid1[@"dateCreated"];
                    
                    
                    
                    [self->allTracks addObject:tobj];
                    
                    
                    
                    TracksRealm *tobjr = [[TracksRealm alloc] init];
                    
                    tobjr.objectId = sobjID;
                    
                    
                    
                    tobjr.set_id=setid1[@"set_id"];
                    
                    tobjr.trackID=sobjID;
                    
                    tobjr.track_artist=setid1[@"track_artists"];
                    
                    tobjr.track_label=setid1[@"track_label"];
                    
                    tobjr.track_name=setid1[@"track_name"];
                    
                    tobjr.track_start=[setid1[@"track_start"] doubleValue];
                    
                    tobjr.created_at=setid1[@"dateCreated"];
                    
                    tobjr.updated_at=setid1[@"dateCreated"];
                    
                    
                    
                    // Updating book with id = 1
                    
                    [realm beginWriteTransaction];
                    
                    [realm addOrUpdateObject:tobjr];
                    
                    [realm commitWriteTransaction];
                    
                    
                    
                }
    
            }
            
            
            
            [self savetoRecent];
            
            [self showTrackData];
            
        }
        

    }];
    

    
}
-(void) removeObserverGetTracks{
    

    Firebase *ref = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@/tracks", FIREBASE_URL]];
    

    [ref removeAllObservers];
    
}

-(IBAction)saveToCrateAction:(id)sender{
    
}

-(IBAction)goFwd:(id)sender{
}

-(IBAction)goBck:(id)sender{
}

-(void) saveSets{
    
}

-(void) initplayer{
 
    NSLog(@"trackurl %@",trackurl);
    
    [self audioPlayerViewPlayFromHTTPSelected:self:trackurl];
    
    
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    
    
    [self becomeFirstResponder];
    
    
    
    NSString *switchon1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"switch1"];
    
    
    
    if([switchon1 isEqualToString:@"on"]){
        
        [[AppDelegate sharedInstance].audioPlayer resume];
        
        [AppDelegate sharedInstance].audioPlayer.volume = [[[NSUserDefaults standardUserDefaults] objectForKey:@"volume"] doubleValue];
        
        // meter.backgroundColor = [UIColor blueColor];
        
    }else{
        
        //audioPlayer.meteringEnabled = NO;
        
        [[AppDelegate sharedInstance].audioPlayer pause];
        
        [AppDelegate sharedInstance].audioPlayer.volume = 0.0;
        
        //meter.backgroundColor = [UIColor clearColor];
        
    }
    
    
    
    slider.continuous = YES;
    
    [slider addTarget:self action:@selector(sliderChanged) forControlEvents:UIControlEventValueChanged];
    
    
    
    [self setupTimer];
    
    [self updateControls];
    
}

-(void) savetoRecent{
    
    
    
    
    
    if(![trackid  isEqual: @""] || ![setid isEqual: @""]){
        
        
        
        RLMResults<TracksRealm *> *res = [TracksRealm objectsWhere:@"trackID = %@ and set_id = %@",trackid,setid];
        
        
        
        if(res.count>0){
            
            [[AccountsClient sharedInstance] getSingleSetInfoWithID:setid completion:^(NSError *error, FDataSnapshot *accountInfo)  {
                
                
                
                NSLog(@"accountInfo = %@", accountInfo.value);
                
                SetObj *st = [[SetObj alloc] init];
                
                NSString *sobjID = [NSString stringWithFormat:@"%@",accountInfo.value[@"setid"]];
                
                st.objectId = sobjID;
                
                
                
                st.set_artist=accountInfo.value[@"set_artist"];
                
                st.set_audio_link=accountInfo.value[@"set_audio_link"];
                
                st.set_id=accountInfo.value[@"setid"];
                
                st.set_title=accountInfo.value[@"set_title"];
                
                st.created_at=accountInfo.value[@"dateCreated"];
                
                st.updated_at=accountInfo.value[@"dateCreated"];
                
                st.set_picture=accountInfo.value[@"set_picture"];
                
                st.set_background_pic=accountInfo.value[@"set_background_pic"];
                
                st.set_btn_image=accountInfo.value[@"set_btn_image"];
                
                
                
                NSString *dateString = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                        
                                                                      dateStyle:NSDateFormatterShortStyle
                                        
                                                                      timeStyle:NSDateFormatterFullStyle];
                
                NSLog(@"%@",dateString);
                
                NSString *playerID = [self->defaults objectForKey:@"GLOBAL_USER_ID"];
                
                NSDictionary *userInfo = @{
                                           
                                           @"trackID" : res.firstObject.trackID,
                                           
                                           @"track_start" : [NSString stringWithFormat:@"%f",res.firstObject.track_start],
                                           
                                           @"set_id" : res.firstObject.set_id,
                                           
                                           @"track_artists" : res.firstObject.track_artist,
                                           
                                           @"set_artist" : st.set_artist,
                                           
                                           @"track_name" : res.firstObject.track_name,
                                           
                                           @"track_label" : res.firstObject.track_label,
                                           
                                           @"track_album" : st.set_title,
                                           
                                           @"set_title" : st.set_title,
                                           
                                           @"dateCreated" : dateString,
                                           
                                           @"setbg" : st.set_btn_image,
                                           
                                           @"seturl" : st.set_audio_link,
                                           
                                           };
                
                
                
                [[AccountsClient sharedInstance] savetoRecent:userInfo accountID:playerID setID:setid trackID:trackid completion:nil];
                
                
                
            }];
            
        }
        
        
        
    }
    
    
    
}

-(void) initTracks{
 
    [[AccountsClient sharedInstance] getSingleSetInfoWithID:setid completion:^(NSError *error, FDataSnapshot *accountInfo)  {
        
        
        
        NSLog(@"accountInfo = %@", accountInfo);
        
        NSString *url = accountInfo.value[@"set_background_pic"];
        
        [self->bgImg sd_setImageWithURL:[NSURL URLWithString:url]
         
                       placeholderImage:[UIImage imageNamed:@""]];
        
        
        
        NSString *url1 = accountInfo.value[@"set_picture"];
        
        [self->coverImg sd_setImageWithURL:[NSURL URLWithString:url1]
         
                          placeholderImage:[UIImage imageNamed:@""]];
        
        self->settitle.text = accountInfo.value[@"set_title"];
        
        
        
        self->trackurl = accountInfo.value[@"set_audio_link"];
        
        NSLog(@"trackurl %@",self->trackurl);
        
        self->artist = accountInfo.value[@"set_artist"];
        
        
        
        trackurl = accountInfo.value[@"set_audio_link"];
        
        [self initplayer];
        
    }];
    
}

-(void) showTrackData{
    

    RLMResults<TracksRealm *> *res = [TracksRealm objectsWhere:@"trackID = %@ and set_id = %@",trackid,setid];
    
    
    
    if(res.count>0){

        //[crateBtn setImage:[UIImage imageNamed:@"crateon.png"] forState:UIControlStateNormal];
 
        trackTitle.text = res.firstObject.track_name;
        
        
        
        NSLog(@"track artist %@",res.firstObject.track_artist);
        
        
        
        trackRecord.text = res.firstObject.track_artist;
        
        
        
        trackAlbum.text = res.firstObject.track_label;
        
        
        
        [[NSUserDefaults standardUserDefaults] setObject:self->setid forKey:@"recentset"];
        
        
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",trackid] forKey:@"recentid"];
        
        
        
        [[NSUserDefaults standardUserDefaults] synchronize];
    
        MPNowPlayingInfoCenter *playingInfoCenter = [MPNowPlayingInfoCenter defaultCenter];
 
        NSMutableDictionary *songInfo = [[NSMutableDictionary alloc] init];
        

        MPMediaItemArtwork *albumArt = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:@"cover"]];
        

        [songInfo setObject:trackTitle.text forKey:MPMediaItemPropertyTitle];
        
        
        
        [songInfo setObject:res.firstObject.track_artist forKey:MPMediaItemPropertyArtist];
        
        
        
        [songInfo setObject:res.firstObject.track_label forKey:MPMediaItemPropertyAlbumTitle];
        
        
        
        [songInfo setObject:[NSNumber numberWithDouble:slider.value] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
        
        
        
        [songInfo setObject:[NSNumber numberWithDouble:200] forKey:MPMediaItemPropertyPlaybackDuration];
        
        
        
        [songInfo setObject:[NSNumber numberWithDouble:([AppDelegate sharedInstance].audioPlayer.state == STKAudioPlayerStatePaused ? 0.0f : 1.0f)] forKey:MPNowPlayingInfoPropertyPlaybackRate];
        
        
        
        [songInfo setObject:albumArt forKey:MPMediaItemPropertyArtwork];
        

        [playingInfoCenter setNowPlayingInfo:songInfo];
 
    }
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation

{
    
    //Return YES for supported orientations
    
    return YES;
    
    //return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
    
}



#pragma table delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    
    return 1;
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [sets count];
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 84;
    
}





- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"SetsCell";
    
    
    
    SetsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[SetsCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
    }
    
    
    
    SetObj *ob=(SetObj *)[sets objectAtIndex:indexPath.row];
    
    cell.artist.text= ob.set_artist;
    
    NSLog(@"set title %@",ob.set_title);
    
    cell.title1.text=ob.set_title;
    
    //cell.img.file=ob.imgfile;
    
    //[cell.img loadInBackground];
    
    [cell.img sd_setImageWithURL:[NSURL URLWithString:ob.set_btn_image]
     
                placeholderImage:[UIImage imageNamed:@"blackbtn.png"]];
    
    cell.backgroundView = [[UIView alloc] init];
    

    NSInteger colorIndex = indexPath.row % 3;
    
    switch (colorIndex) {
            
        case 0:
            
            
            
            cell.backgroundView.backgroundColor = [UIColor clearColor];//[UIColor colorWithRed:(226/255.0) green:(220/255.0) blue:(198/255.0) alpha:1];
            
            break;
            
        case 1:
            
            cell.backgroundView.backgroundColor = [UIColor clearColor];//[UIColor colorWithRed:(206/255.0) green:(206/255.0) blue:(206/255.0) alpha:1];
            
            break;
            
        case 2:
            
            cell.backgroundView.backgroundColor = [UIColor clearColor];//[UIColor colorWithRed:(163/255.0) green:(160/255.0) blue:(166/255.0) alpha:1];
            
            break;
            
    }
    
    
    
    
    
    return cell;
    
    
    
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField;

{
    
    [textField resignFirstResponder];
    
    
    
    return NO;
    
}



-(void)textFieldDidChange :(UITextField *)theTextField{
    
    
    
    RLMResults<SetsRealm *> *res = [[SetsRealm objectsWhere:@"set_title contains[c] %@ or set_artist contains[c] %@",theTextField.text,theTextField.text] sortedResultsUsingProperty:@"created_at" ascending:NO];
    
    [sets removeAllObjects];
    
    
    
    if(res.count>0){
        
        self.setLbl.text=[NSString stringWithFormat:@"%lu RESULT(S) FOUND",(unsigned long) res.count];
        
        for (int i=0;i<res.count;i++){
            
            SetsRealm *r = (SetsRealm *)[res objectAtIndex:i];
            
            SetObj *setobj = [[SetObj alloc] init];
            
            setobj.objectId = r.objectId;
            
            
            
            setobj.set_artist=r.set_artist;
            
            setobj.set_audio_link=r.set_audio_link;
            
            setobj.set_id=r.set_id;
            
            setobj.set_title=r.set_title;
            
            setobj.created_at=r.created_at;
            
            setobj.updated_at=r.updated_at;
            
            setobj.set_picture=r.set_picture;
            
            setobj.set_background_pic=r.set_background_pic;
            
            setobj.set_btn_image=r.set_btn_image;
            
            [sets addObject:setobj];
            
            [self.thisTableView reloadData];
            
        }
        
    }else{
        
        self.setLbl.text=[NSString stringWithFormat:@"NO RESULT(S) FOUND"];
        
        [self.thisTableView reloadData];
        
    }
    
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    if(self.slideMenuController.isMenuOpen==NO){
        
        //FSPlayerViewController *detailsVC = [FSPlayerViewController new];
        
        
        
        SetObj *set=[self.sets objectAtIndex:indexPath.row];
        
        NSLog(@"set id %@",set.set_id);
        
        NSString *recentset=[[NSUserDefaults standardUserDefaults] objectForKey:@"recentset"];
        
        NSString *recentid=[[NSUserDefaults standardUserDefaults] objectForKey:@"recentid"];
        
        
        
        if([recentset isEqualToString:set.set_id]){
            
            //check the recent trac
            
            
            
            [[NSUserDefaults standardUserDefaults] setObject:set.set_id forKey:@"recentset"];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSLog(@"selected set %@",set.set_id);
            
            
            
            [[NSUserDefaults standardUserDefaults] setObject:recentid forKey:@"recentid"];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            
        }else{
    
            
            [[NSUserDefaults standardUserDefaults] setObject:set.set_id forKey:@"recentset"];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"recentid"];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            
        }
        
   
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"nowplaying"];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"fromcrate"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        PlayerNewVC *signVC = (PlayerNewVC *)[storyboard instantiateViewControllerWithIdentifier:@"PlayerVC"];
        
        [[AppDelegate sharedInstance].audioPlayer stop];
        
        //[AppDelegate sharedInstance].audioPlayer  = nil;
        
        [self.slideMenuController closeMenuBehindContentViewController:signVC animated:YES completion:nil];
        
    }else{
        
        
        
    }
    
}

-(IBAction)goTutorialNext:(id)sender{
    
    
    
    tutorial1.hidden = YES;
    
    tutorial2.hidden = NO;
    
    tutorial3.hidden = YES;
    
    next1.hidden = YES;
    
    next2.hidden = NO;
    
    next3.hidden = YES;
    
    
    
}



-(IBAction)goTutorial1Next:(id)sender{
    
    
    
    tutorial1.hidden = YES;
    
    tutorial2.hidden = YES;
    
    tutorial3.hidden = NO;
    
    
    
    next1.hidden = YES;
    
    next2.hidden = YES;
    
    next3.hidden = NO;
    
    
    
}







-(IBAction)goTutorial2Next:(id)sender{
    
    
    
    tutorial1.hidden = YES;
    
    tutorial2.hidden = YES;
    
    tutorial3.hidden = YES;
    
    
    
    next1.hidden = YES;
    
    next2.hidden = YES;
    
    next3.hidden = YES;
    
    
    
}



-(IBAction)hideTutorial1:(id)sender{
    
    
    
    tutorial1.hidden = YES;
    
    tutorial2.hidden = YES;
    
    tutorial3.hidden = YES;
    
    
    
    next1.hidden = YES;
    
    next2.hidden = YES;
    
    next3.hidden = YES;
    
}

@end
