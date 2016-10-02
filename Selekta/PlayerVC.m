//
//  PlayerVC.m
//  Selekta
//
//  Created by Charisse Ann Dirain on 6/21/16.
//  Copyright © 2016 Charisse Ann Dirain. All rights reserved.
//

#import "PlayerVC.h"
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

@interface PlayerVC ()<UIGestureRecognizerDelegate>{
    
    
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

}

@property (nonatomic, retain) NSMutableArray *sets;

@end



@implementation PlayerVC
@synthesize slider;
+ (instancetype)sharedInstance
{
    static PlayerVC *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PlayerVC alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

@synthesize searchString;
@synthesize sets;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"main"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    [self becomeFirstResponder];
    slider.continuous = YES;
    
    isSearch = false;
    searchView.hidden = true;
    [self.searchField resignFirstResponder];
    self.navigationController.navigationBar.hidden = YES;
    self.searchField.text=searchString;
    self.searchField.hidden = true;
    sets=[[NSMutableArray alloc] init];
    [self.searchField addTarget:self
                         action:@selector(textFieldDidChange:)
               forControlEvents:UIControlEventEditingChanged];
    self.searchField.returnKeyType = UIReturnKeyGo;
    self.slideMenuController.panGestureEnabled = NO;
    RLMRealm *realm = [RLMRealm defaultRealm];
    allTracks = [[NSMutableArray alloc] init];
    
    defaults = [NSUserDefaults standardUserDefaults];
    NSString *str= [defaults objectForKey:@"recentset"];
    if(str.length==0 || [str isKindOfClass:[NSNull class]] || [str isEqualToString:@""]||[str  isEqualToString:NULL]||[str isEqualToString:@"(null)"]||str==nil || [str isEqualToString:@"<null>"]){
        setid = @"1";
        trackid = @"1";
    }else{
        setid = [defaults objectForKey:@"recentset"];
        trackid = [defaults objectForKey:@"recentid"];
        
    }
    animationFrames = [[NSArray alloc] init];

    animationFramesc = [[NSArray alloc] init];
  
   
    
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
    //[self.view addGestureRecognizer:tapGestureRecognizer];
    
  
     
    }
    
    UISwipeGestureRecognizer *upRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(upSwipeHandle:)];
    upRecognizer.delegate=self;
    upRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:upRecognizer];
    

    RLMResults<CrateRealm1 *> *res = [CrateRealm1 objectsWhere:@"trackID = %@ and set_id = %@",trackid,setid];
 
    
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"switch"]  isEqual: @"on"]){
        
        animationFrames = [NSArray arrayWithObjects:
                           [UIImage imageNamed:@"1.png"],
                           [UIImage imageNamed:@"2.png"],
                           [UIImage imageNamed:@"3.png"],
                           [UIImage imageNamed:@"4.png"],
                           [UIImage imageNamed:@"5.png"],
                           [UIImage imageNamed:@"6.png"],
                           [UIImage imageNamed:@"7.png"],
                           [UIImage imageNamed:@"8.png"],
                           [UIImage imageNamed:@"9.png"],
                           [UIImage imageNamed:@"10.png"],
                           [UIImage imageNamed:@"11.png"],
                           [UIImage imageNamed:@"12.png"],
                           [UIImage imageNamed:@"13.png"],
                           [UIImage imageNamed:@"14.png"],
                           [UIImage imageNamed:@"15.png"],
                           [UIImage imageNamed:@"16.png"],
                           [UIImage imageNamed:@"17.png"],
                           [UIImage imageNamed:@"18.png"],
                           [UIImage imageNamed:@"19.png"],
                           [UIImage imageNamed:@"20.png"],
                           [UIImage imageNamed:@"21.png"],
                           [UIImage imageNamed:@"22.png"],
                           [UIImage imageNamed:@"23.png"],
                           [UIImage imageNamed:@"24.png"],
                           nil];
        
        animationFramesc = [NSArray arrayWithObjects:
                            [UIImage imageNamed:@"whitegif1.png"],
                            [UIImage imageNamed:@"whitegif2.png"],
                            [UIImage imageNamed:@"whitegif3.png"],
                            [UIImage imageNamed:@"whitegif4.png"],
                            [UIImage imageNamed:@"whitegif5.png"],
                            [UIImage imageNamed:@"whitegif6.png"],
                            [UIImage imageNamed:@"whitegif7.png"],
                            [UIImage imageNamed:@"whitegif8.png"],
                            [UIImage imageNamed:@"whitegif9.png"],
                            [UIImage imageNamed:@"whitegif10.png"],
                            [UIImage imageNamed:@"whitegif11.png"],
                            [UIImage imageNamed:@"whitegif12.png"],
                            [UIImage imageNamed:@"whitegif13.png"],
                            [UIImage imageNamed:@"whitegif14.png"],
                            [UIImage imageNamed:@"whitegif15.png"],
                            [UIImage imageNamed:@"whitegif16.png"],
                            [UIImage imageNamed:@"whitegif17.png"],
                            [UIImage imageNamed:@"whitegif18.png"],
                            [UIImage imageNamed:@"whitegif19.png"],
                            [UIImage imageNamed:@"whitegif20.png"],
                            [UIImage imageNamed:@"whitegif21.png"],
                            [UIImage imageNamed:@"whitegif22.png"],
                            [UIImage imageNamed:@"whitegif23.png"],
                            [UIImage imageNamed:@"whitegif24.png"],
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
        crateBtn.hidden = true;
        
        
    }else{
        animatedImageView.hidden = true;
        
        playButton.hidden = false;
        nextButton.hidden = false;
        prevButton.hidden = false;
        crateBtn.hidden = false;
        
        
        if(res.count>0){
            
            [crateBtn setImage:[UIImage imageNamed:@"crateon.png"] forState:UIControlStateNormal];
        }else{
            [crateBtn setImage:[UIImage imageNamed:@"crateoff.png"] forState:UIControlStateNormal];
        }
    }
   
    
    
    
    NSString *isplayed = [[NSUserDefaults standardUserDefaults] objectForKey:@"nowplaying"];
    
    if([isplayed isEqualToString:@"0"]){
        
        defaults = [NSUserDefaults standardUserDefaults];
        
       
        
        if(![[defaults objectForKey:@"recentset"]  isEqual: @""]){
            
            if([[defaults objectForKey:@"recentset"]  isEqual:[defaults objectForKey:@"selectedset"] ]){
                
                setid = [defaults objectForKey:@"recentset"];
                
                
                
                NSString *recentid = [[NSUserDefaults standardUserDefaults] objectForKey:@"recentid"];
                
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
                    
                    [[AppDelegate sharedInstance].audioPlayer playURL:[NSURL URLWithString:trackurl]];
                    slider.value = [res.firstObject.track_start integerValue];
                    //slider.maximumValue = [AppDelegate sharedInstance].audioPlayer.duration;
                    
                    [playButton setImage:[UIImage imageNamed:@"pause_btn"] forState:UIControlStateNormal];
                    NSLog(@"slider value %f",slider.value);
                    [[AppDelegate sharedInstance].audioPlayer seekToTime:[res.firstObject.track_start integerValue]];
                    
                }];
                
                RLMResults<CrateRealm1 *> *res = [CrateRealm1 objectsWhere:@"trackID = %@ and set_id = %@",recentid,setid];
                
                [self observers];
                
                if(res.count>0){
                    
                    
                    
                    NSLog(@"res %@",res);
                    
                    //only if added to crate
                    
                    
    
                    
                    
                    
                    trackTitle.text = res.firstObject.track_name;
                    
                    NSLog(@"track artist %@",res.firstObject.track_artist);
                    
                    trackRecord.text = res.firstObject.track_artist;
                    
                    trackAlbum.text = res.firstObject.track_label;
                    
                    
                    
                    trackurl = res.firstObject.seturl;
                    
                    
                    
                    //[self initplayer];
                    
                    NSLog(@"trackurl %@",res.firstObject.track_start);
                    
                     NSLog(@"trackurl1 %@",res.firstObject.seturl);
                    
                    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"fromcrate"]  isEqual: @"1"] ){
                        slider.value = [res.firstObject.track_start integerValue];
                        //slider.maximumValue = [AppDelegate sharedInstance].audioPlayer.duration;

                         [playButton setImage:[UIImage imageNamed:@"pause_btn"] forState:UIControlStateNormal];
                         NSLog(@"slider value %f",slider.value);
                        [[AppDelegate sharedInstance].audioPlayer seekToTime:[res.firstObject.track_start integerValue]];
                    }

                    
                    
                    /*if([[[NSUserDefaults standardUserDefaults] objectForKey:@"fromcrate"]  isEqual: @"1"] ){
                        NSLog(@"trackurl %ld",[res.firstObject.track_start integerValue]);
                        slider.continuous = YES;
                        slider.minimumValue = 0;
                        slider.maximumValue = [AppDelegate sharedInstance].audioPlayer.duration;
                        [playButton setImage:[UIImage imageNamed:@"pause_btn"] forState:UIControlStateNormal];
                        slider.value = [res.firstObject.track_start floatValue];
                        [slider setValue:[res.firstObject.track_start floatValue] animated:YES];
                        
                        NSLog(@"slider value %f",slider.value);
                        [[AppDelegate sharedInstance].audioPlayer seekToTime:[res.firstObject.track_start floatValue]];
                        [[AppDelegate sharedInstance].audioPlayer playURL:[NSURL URLWithString:trackurl]];

                    }*/
  
                    
                }else{
                    
                   
                    
                    
                    
                }
            }else{
                
                setid = [defaults objectForKey:@"selectedset"];
                
                NSString *recentid = [[NSUserDefaults standardUserDefaults] objectForKey:@"recentid"];
                
                NSLog(@"trackid %@",recentid);
                
                RLMResults<CrateRealm1 *> *res = [CrateRealm1 objectsWhere:@"trackID = %@ and set_id = %@",recentid,setid];
                
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
                     [[AppDelegate sharedInstance].audioPlayer playURL:[NSURL URLWithString:trackurl]];
                    slider.value = [res.firstObject.track_start integerValue];
                    //slider.maximumValue = [AppDelegate sharedInstance].audioPlayer.duration;
                    
                    [playButton setImage:[UIImage imageNamed:@"pause_btn"] forState:UIControlStateNormal];
                    NSLog(@"slider value %f",slider.value);
                    [[AppDelegate sharedInstance].audioPlayer seekToTime:[res.firstObject.track_start integerValue]];
                    
                    
                }];
                
                if(res.count>0){
                    
                    

                    
                   
                    
                    
                    
                    trackTitle.text = res.firstObject.track_name;
                    
                    NSLog(@"track artist %@",res.firstObject.track_artist);
                    
                    trackRecord.text = res.firstObject.track_artist;
                    
                    trackAlbum.text = res.firstObject.track_label;
                    
                    
                    
                    trackurl = res.firstObject.seturl;
                    
                    
                    
                    //[self initplayer];
                    
                    NSLog(@"trackurl %@",res.firstObject.track_start);
                    
                     NSLog(@"trackurl1 %@",res.firstObject.seturl);
                    
                    

                    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"fromcrate"]  isEqual: @"1"] ){
                        slider.value = [res.firstObject.track_start integerValue];
                        //slider.maximumValue = [AppDelegate sharedInstance].audioPlayer.duration;

                        [playButton setImage:[UIImage imageNamed:@"pause_btn"] forState:UIControlStateNormal];
                        NSLog(@"slider value %f",slider.value);
                        [[AppDelegate sharedInstance].audioPlayer seekToTime:[res.firstObject.track_start integerValue]];
                    }
                    /*if([[[NSUserDefaults standardUserDefaults] objectForKey:@"fromcrate"]  isEqual: @"1"] ){
                        NSLog(@"trackurl %ld",[res.firstObject.track_start integerValue]);
                        slider.continuous = YES;
                        slider.minimumValue = 0;
                        slider.maximumValue = [AppDelegate sharedInstance].audioPlayer.duration;
                        [playButton setImage:[UIImage imageNamed:@"pause_btn"] forState:UIControlStateNormal];
                        slider.value = [res.firstObject.track_start floatValue];
                        [slider setValue:[res.firstObject.track_start floatValue] animated:YES];
                        
                        NSLog(@"slider value %f",slider.value);
                        [[AppDelegate sharedInstance].audioPlayer seekToTime:[res.firstObject.track_start floatValue]];
                     


                    }*/

                    
                    
                    
                }else{
                    
                                       
                }
                
            }
            
        }
    
        
    }else{
        [self observers];
        [self initTracks];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidAppear:(BOOL)animated{
    
   
    setid = [defaults objectForKey:@"recentset"];
    trackid = [defaults objectForKey:@"recentid"];
        
    
    
    RLMResults<CrateRealm1 *> *res = [CrateRealm1 objectsWhere:@"trackID = %@ and set_id = %@",trackid,setid];
    
    
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"switch"]  isEqual: @"on"]){
        
        animationFrames = [NSArray arrayWithObjects:
                           [UIImage imageNamed:@"1.png"],
                           [UIImage imageNamed:@"2.png"],
                           [UIImage imageNamed:@"3.png"],
                           [UIImage imageNamed:@"4.png"],
                           [UIImage imageNamed:@"5.png"],
                           [UIImage imageNamed:@"6.png"],
                           [UIImage imageNamed:@"7.png"],
                           [UIImage imageNamed:@"8.png"],
                           [UIImage imageNamed:@"9.png"],
                           [UIImage imageNamed:@"10.png"],
                           [UIImage imageNamed:@"11.png"],
                           [UIImage imageNamed:@"12.png"],
                           [UIImage imageNamed:@"13.png"],
                           [UIImage imageNamed:@"14.png"],
                           [UIImage imageNamed:@"15.png"],
                           [UIImage imageNamed:@"16.png"],
                           [UIImage imageNamed:@"17.png"],
                           [UIImage imageNamed:@"18.png"],
                           [UIImage imageNamed:@"19.png"],
                           [UIImage imageNamed:@"20.png"],
                           [UIImage imageNamed:@"21.png"],
                           [UIImage imageNamed:@"22.png"],
                           [UIImage imageNamed:@"23.png"],
                           [UIImage imageNamed:@"24.png"],
                           nil];
        
        animationFramesc = [NSArray arrayWithObjects:
                            [UIImage imageNamed:@"whitegif1.png"],
                            [UIImage imageNamed:@"whitegif2.png"],
                            [UIImage imageNamed:@"whitegif3.png"],
                            [UIImage imageNamed:@"whitegif4.png"],
                            [UIImage imageNamed:@"whitegif5.png"],
                            [UIImage imageNamed:@"whitegif6.png"],
                            [UIImage imageNamed:@"whitegif7.png"],
                            [UIImage imageNamed:@"whitegif8.png"],
                            [UIImage imageNamed:@"whitegif9.png"],
                            [UIImage imageNamed:@"whitegif10.png"],
                            [UIImage imageNamed:@"whitegif11.png"],
                            [UIImage imageNamed:@"whitegif12.png"],
                            [UIImage imageNamed:@"whitegif13.png"],
                            [UIImage imageNamed:@"whitegif14.png"],
                            [UIImage imageNamed:@"whitegif15.png"],
                            [UIImage imageNamed:@"whitegif16.png"],
                            [UIImage imageNamed:@"whitegif17.png"],
                            [UIImage imageNamed:@"whitegif18.png"],
                            [UIImage imageNamed:@"whitegif19.png"],
                            [UIImage imageNamed:@"whitegif20.png"],
                            [UIImage imageNamed:@"whitegif21.png"],
                            [UIImage imageNamed:@"whitegif22.png"],
                            [UIImage imageNamed:@"whitegif23.png"],
                            [UIImage imageNamed:@"whitegif24.png"],
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
        crateBtn.hidden = true;
        
        
    }else{
        animatedImageView.hidden = true;
        
        playButton.hidden = false;
        nextButton.hidden = false;
        prevButton.hidden = false;
        crateBtn.hidden = false;
        
        
        if(res.count>0){
            
            [crateBtn setImage:[UIImage imageNamed:@"crateon.png"] forState:UIControlStateNormal];
        }else{
            [crateBtn setImage:[UIImage imageNamed:@"crateoff.png"] forState:UIControlStateNormal];
        }
    }
    
     /* [[AppDelegate sharedInstance].audioPlayer playURL:[NSURL URLWithString:trackurl]];
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"fromcrate"]  isEqual: @"1"] ){
        slider.continuous = YES;
        slider.minimumValue = 0;
        slider.maximumValue = [AppDelegate sharedInstance].audioPlayer.duration;
        [playButton setImage:[UIImage imageNamed:@"pause_btn"] forState:UIControlStateNormal];
        slider.value = [res.firstObject.track_start floatValue];
        [slider setValue:[res.firstObject.track_start floatValue] animated:YES];
        
        NSLog(@"slider value %f",slider.value);
        [[AppDelegate sharedInstance].audioPlayer seekToTime:[res.firstObject.track_start floatValue]];
        [[AppDelegate sharedInstance].audioPlayer playURL:[NSURL URLWithString:trackurl]];
      
    }*/
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"fromcrate"]  isEqual: @"1"] ){
        NSLog(@"value %@", res.firstObject);
        NSLog(@"value %ld", [res.firstObject.track_start integerValue]);
        //slider.maximumValue = [AppDelegate sharedInstance].audioPlayer.duration;

        slider.value = [res.firstObject.track_start integerValue];
        [playButton setImage:[UIImage imageNamed:@"pause_btn"] forState:UIControlStateNormal];
        NSLog(@"slider value %f",slider.value);
        [[AppDelegate sharedInstance].audioPlayer seekToTime:slider.value];
    }


}

-(BOOL) canBecomeFirstResponder
{
    return YES;
}


-(void) audioPlayerViewPlayFromHTTPSelected:(PlayerVC*)audioPlayerView : (NSString*) url1
{
    NSURL* url = [NSURL URLWithString:url1];
    
    STKDataSource* dataSource = [STKAudioPlayer dataSourceFromURL:url];

    [[AppDelegate sharedInstance].audioPlayer playURL:url];
    
     //[audioPlayer setDataSource:dataSource withQueueItemId:[[SampleQueueId alloc] initWithUrl:url andCount:0]];
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
        [animatedImageView stopAnimating];
        animatedImageView.image = [UIImage imageNamed:@"1.png"];
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
    
    NSLog(@"Slider Changed: %f", slider.value);
    
    //should be on slider value
    
    
    [[AppDelegate sharedInstance].audioPlayer seekToTime:slider.value];
    int recentid = ([trackid integerValue] + 1);
    NSString *validid =[NSString stringWithFormat:@"%d",recentid];
    RLMResults<TracksRealm *> *res = [TracksRealm objectsWhere:@"trackID = %@ and set_id = %@",validid,setid];
    if(res.count>0){
        
        trackid = res.firstObject.trackID;
        trackTitle.text = res.firstObject.track_name;
        
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
        
        if(res.count>0){
            [crateBtn setImage:[UIImage imageNamed:@"crateon.png"] forState:UIControlStateNormal];
        }else{
            [crateBtn setImage:[UIImage imageNamed:@"crateoff.png"] forState:UIControlStateNormal];
        }
        
    
      
   
        
    }else{
        
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
        //[playButton setTitle:@"Resume" forState:UIControlStateNormal];
        
        [playButton setImage:[UIImage imageNamed:@"play_btn"] forState:UIControlStateNormal];
    }
    else if ([AppDelegate sharedInstance].audioPlayer.state & STKAudioPlayerStatePlaying)
    {
        //[playButton setTitle:@"Pause" forState:UIControlStateNormal];
         [playButton setImage:[UIImage imageNamed:@"pause_btn"] forState:UIControlStateNormal];
    }
    else
    {
        //[playButton setTitle:@"" forState:UIControlStateNormal];
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
    
    self.slideMenuController.slideDirection = NVSlideMenuControllerSlideFromLeftToRight;
    [self.slideMenuController toggleMenuAnimated:nil];
    
}

-(void) handleTapFrom: (UITapGestureRecognizer *) del{
    
    if (![AppDelegate sharedInstance].audioPlayer)
    {
        return;
    }
    
    if ([AppDelegate sharedInstance].audioPlayer.state == STKAudioPlayerStatePaused)
    {
        [[AppDelegate sharedInstance].audioPlayer resume];
        [playButton setImage:[UIImage imageNamed:@"pause_btn"] forState:UIControlStateNormal];
    }
    else
    {
        [[AppDelegate sharedInstance].audioPlayer pause];
        [playButton setImage:[UIImage imageNamed:@"play_btn"] forState:UIControlStateNormal];
    }
}

-(void) leftSwipeHandle: (UISwipeGestureRecognizer *) del{
    
    int recentid = ([trackid integerValue] + 1);
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
                               [UIImage imageNamed:@"1.png"],
                               [UIImage imageNamed:@"2.png"],
                               [UIImage imageNamed:@"3.png"],
                               [UIImage imageNamed:@"4.png"],
                               [UIImage imageNamed:@"5.png"],
                               [UIImage imageNamed:@"6.png"],
                               [UIImage imageNamed:@"7.png"],
                               [UIImage imageNamed:@"8.png"],
                               [UIImage imageNamed:@"9.png"],
                               [UIImage imageNamed:@"10.png"],
                               [UIImage imageNamed:@"11.png"],
                               [UIImage imageNamed:@"12.png"],
                               [UIImage imageNamed:@"13.png"],
                               [UIImage imageNamed:@"14.png"],
                               [UIImage imageNamed:@"15.png"],
                               [UIImage imageNamed:@"16.png"],
                               [UIImage imageNamed:@"17.png"],
                               [UIImage imageNamed:@"18.png"],
                               [UIImage imageNamed:@"19.png"],
                               [UIImage imageNamed:@"20.png"],
                               [UIImage imageNamed:@"21.png"],
                               [UIImage imageNamed:@"22.png"],
                               [UIImage imageNamed:@"23.png"],
                               [UIImage imageNamed:@"24.png"],
                               nil];
            
            animationFramesc = [NSArray arrayWithObjects:
                                [UIImage imageNamed:@"whitegif1.png"],
                                [UIImage imageNamed:@"whitegif2.png"],
                                [UIImage imageNamed:@"whitegif3.png"],
                                [UIImage imageNamed:@"whitegif4.png"],
                                [UIImage imageNamed:@"whitegif5.png"],
                                [UIImage imageNamed:@"whitegif6.png"],
                                [UIImage imageNamed:@"whitegif7.png"],
                                [UIImage imageNamed:@"whitegif8.png"],
                                [UIImage imageNamed:@"whitegif9.png"],
                                [UIImage imageNamed:@"whitegif10.png"],
                                [UIImage imageNamed:@"whitegif11.png"],
                                [UIImage imageNamed:@"whitegif12.png"],
                                [UIImage imageNamed:@"whitegif13.png"],
                                [UIImage imageNamed:@"whitegif14.png"],
                                [UIImage imageNamed:@"whitegif15.png"],
                                [UIImage imageNamed:@"whitegif16.png"],
                                [UIImage imageNamed:@"whitegif17.png"],
                                [UIImage imageNamed:@"whitegif18.png"],
                                [UIImage imageNamed:@"whitegif19.png"],
                                [UIImage imageNamed:@"whitegif20.png"],
                                [UIImage imageNamed:@"whitegif21.png"],
                                [UIImage imageNamed:@"whitegif22.png"],
                                [UIImage imageNamed:@"whitegif23.png"],
                                [UIImage imageNamed:@"whitegif24.png"],
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
            crateBtn.hidden = true;
            
            
        }else{
            animatedImageView.hidden = true;
            
            playButton.hidden = false;
            nextButton.hidden = false;
            prevButton.hidden = false;
            crateBtn.hidden = false;
            
            
            if(res.count>0){
                
                [crateBtn setImage:[UIImage imageNamed:@"crateon.png"] forState:UIControlStateNormal];
            }else{
                [crateBtn setImage:[UIImage imageNamed:@"crateoff.png"] forState:UIControlStateNormal];
            }
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
                               [UIImage imageNamed:@"1.png"],
                               [UIImage imageNamed:@"2.png"],
                               [UIImage imageNamed:@"3.png"],
                               [UIImage imageNamed:@"4.png"],
                               [UIImage imageNamed:@"5.png"],
                               [UIImage imageNamed:@"6.png"],
                               [UIImage imageNamed:@"7.png"],
                               [UIImage imageNamed:@"8.png"],
                               [UIImage imageNamed:@"9.png"],
                               [UIImage imageNamed:@"10.png"],
                               [UIImage imageNamed:@"11.png"],
                               [UIImage imageNamed:@"12.png"],
                               [UIImage imageNamed:@"13.png"],
                               [UIImage imageNamed:@"14.png"],
                               [UIImage imageNamed:@"15.png"],
                               [UIImage imageNamed:@"16.png"],
                               [UIImage imageNamed:@"17.png"],
                               [UIImage imageNamed:@"18.png"],
                               [UIImage imageNamed:@"19.png"],
                               [UIImage imageNamed:@"20.png"],
                               [UIImage imageNamed:@"21.png"],
                               [UIImage imageNamed:@"22.png"],
                               [UIImage imageNamed:@"23.png"],
                               [UIImage imageNamed:@"24.png"],
                               nil];
            
            animationFramesc = [NSArray arrayWithObjects:
                                [UIImage imageNamed:@"whitegif1.png"],
                                [UIImage imageNamed:@"whitegif2.png"],
                                [UIImage imageNamed:@"whitegif3.png"],
                                [UIImage imageNamed:@"whitegif4.png"],
                                [UIImage imageNamed:@"whitegif5.png"],
                                [UIImage imageNamed:@"whitegif6.png"],
                                [UIImage imageNamed:@"whitegif7.png"],
                                [UIImage imageNamed:@"whitegif8.png"],
                                [UIImage imageNamed:@"whitegif9.png"],
                                [UIImage imageNamed:@"whitegif10.png"],
                                [UIImage imageNamed:@"whitegif11.png"],
                                [UIImage imageNamed:@"whitegif12.png"],
                                [UIImage imageNamed:@"whitegif13.png"],
                                [UIImage imageNamed:@"whitegif14.png"],
                                [UIImage imageNamed:@"whitegif15.png"],
                                [UIImage imageNamed:@"whitegif16.png"],
                                [UIImage imageNamed:@"whitegif17.png"],
                                [UIImage imageNamed:@"whitegif18.png"],
                                [UIImage imageNamed:@"whitegif19.png"],
                                [UIImage imageNamed:@"whitegif20.png"],
                                [UIImage imageNamed:@"whitegif21.png"],
                                [UIImage imageNamed:@"whitegif22.png"],
                                [UIImage imageNamed:@"whitegif23.png"],
                                [UIImage imageNamed:@"whitegif24.png"],
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
            crateBtn.hidden = true;
            
            
        }else{
            animatedImageView.hidden = true;
            
            playButton.hidden = false;
            nextButton.hidden = false;
            prevButton.hidden = false;
            crateBtn.hidden = false;
            
            
            if(res.count>0){
                
                [crateBtn setImage:[UIImage imageNamed:@"crateon.png"] forState:UIControlStateNormal];
            }else{
                [crateBtn setImage:[UIImage imageNamed:@"crateoff.png"] forState:UIControlStateNormal];
            }
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
                                       [UIImage imageNamed:@"1.png"],
                                       [UIImage imageNamed:@"2.png"],
                                       [UIImage imageNamed:@"3.png"],
                                       [UIImage imageNamed:@"4.png"],
                                       [UIImage imageNamed:@"5.png"],
                                       [UIImage imageNamed:@"6.png"],
                                       [UIImage imageNamed:@"7.png"],
                                       [UIImage imageNamed:@"8.png"],
                                       [UIImage imageNamed:@"9.png"],
                                       [UIImage imageNamed:@"10.png"],
                                       [UIImage imageNamed:@"11.png"],
                                       [UIImage imageNamed:@"12.png"],
                                       [UIImage imageNamed:@"13.png"],
                                       [UIImage imageNamed:@"14.png"],
                                       [UIImage imageNamed:@"15.png"],
                                       [UIImage imageNamed:@"16.png"],
                                       [UIImage imageNamed:@"17.png"],
                                       [UIImage imageNamed:@"18.png"],
                                       [UIImage imageNamed:@"19.png"],
                                       [UIImage imageNamed:@"20.png"],
                                       [UIImage imageNamed:@"21.png"],
                                       [UIImage imageNamed:@"22.png"],
                                       [UIImage imageNamed:@"23.png"],
                                       [UIImage imageNamed:@"24.png"],
                                       nil];
                    
                    animationFramesc = [NSArray arrayWithObjects:
                                        [UIImage imageNamed:@"whitegif1.png"],
                                        [UIImage imageNamed:@"whitegif2.png"],
                                        [UIImage imageNamed:@"whitegif3.png"],
                                        [UIImage imageNamed:@"whitegif4.png"],
                                        [UIImage imageNamed:@"whitegif5.png"],
                                        [UIImage imageNamed:@"whitegif6.png"],
                                        [UIImage imageNamed:@"whitegif7.png"],
                                        [UIImage imageNamed:@"whitegif8.png"],
                                        [UIImage imageNamed:@"whitegif9.png"],
                                        [UIImage imageNamed:@"whitegif10.png"],
                                        [UIImage imageNamed:@"whitegif11.png"],
                                        [UIImage imageNamed:@"whitegif12.png"],
                                        [UIImage imageNamed:@"whitegif13.png"],
                                        [UIImage imageNamed:@"whitegif14.png"],
                                        [UIImage imageNamed:@"whitegif15.png"],
                                        [UIImage imageNamed:@"whitegif16.png"],
                                        [UIImage imageNamed:@"whitegif17.png"],
                                        [UIImage imageNamed:@"whitegif18.png"],
                                        [UIImage imageNamed:@"whitegif19.png"],
                                        [UIImage imageNamed:@"whitegif20.png"],
                                        [UIImage imageNamed:@"whitegif21.png"],
                                        [UIImage imageNamed:@"whitegif22.png"],
                                        [UIImage imageNamed:@"whitegif23.png"],
                                        [UIImage imageNamed:@"whitegif24.png"],
                                        nil];
                    
                    animatedImageView.animationImages = animationFramesc;
                    
                    animatedImageView.hidden = false;
                    animatedImageView.animationDuration = 2.0;
                    [animatedImageView startAnimating];
                    
                    
                    
                    playButton.hidden = true;
                    nextButton.hidden = true;
                    prevButton.hidden = true;
                    crateBtn.hidden = true;
                    
                    
                }else{
                    animatedImageView.hidden = true;
                    
                    playButton.hidden = false;
                    nextButton.hidden = false;
                    prevButton.hidden = false;
                    crateBtn.hidden = false;
                    
                    
                    [crateBtn setImage:[UIImage imageNamed:@"crateon.png"] forState:UIControlStateNormal];
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
                
                
                [[AccountsClient sharedInstance] savetoCrate:userInfo accountID:playerID setID:res.firstObject.set_id trackID:[NSString stringWithFormat:@"%f",res.firstObject.track_start] completion:nil];
                
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
                
                RLMResults<CrateRealm1 *> *res = [CrateRealm1 objectsWhere:@"trackID = %@ and set_id = %@",trackid,setid];
                
                if([[[NSUserDefaults standardUserDefaults] objectForKey:@"switch"]  isEqual: @"on"]){
                    
                    animationFrames = [NSArray arrayWithObjects:
                                       [UIImage imageNamed:@"1.png"],
                                       [UIImage imageNamed:@"2.png"],
                                       [UIImage imageNamed:@"3.png"],
                                       [UIImage imageNamed:@"4.png"],
                                       [UIImage imageNamed:@"5.png"],
                                       [UIImage imageNamed:@"6.png"],
                                       [UIImage imageNamed:@"7.png"],
                                       [UIImage imageNamed:@"8.png"],
                                       [UIImage imageNamed:@"9.png"],
                                       [UIImage imageNamed:@"10.png"],
                                       [UIImage imageNamed:@"11.png"],
                                       [UIImage imageNamed:@"12.png"],
                                       [UIImage imageNamed:@"13.png"],
                                       [UIImage imageNamed:@"14.png"],
                                       [UIImage imageNamed:@"15.png"],
                                       [UIImage imageNamed:@"16.png"],
                                       [UIImage imageNamed:@"17.png"],
                                       [UIImage imageNamed:@"18.png"],
                                       [UIImage imageNamed:@"19.png"],
                                       [UIImage imageNamed:@"20.png"],
                                       [UIImage imageNamed:@"21.png"],
                                       [UIImage imageNamed:@"22.png"],
                                       [UIImage imageNamed:@"23.png"],
                                       [UIImage imageNamed:@"24.png"],
                                       nil];
                    
                    animationFramesc = [NSArray arrayWithObjects:
                                        [UIImage imageNamed:@"whitegif1.png"],
                                        [UIImage imageNamed:@"whitegif2.png"],
                                        [UIImage imageNamed:@"whitegif3.png"],
                                        [UIImage imageNamed:@"whitegif4.png"],
                                        [UIImage imageNamed:@"whitegif5.png"],
                                        [UIImage imageNamed:@"whitegif6.png"],
                                        [UIImage imageNamed:@"whitegif7.png"],
                                        [UIImage imageNamed:@"whitegif8.png"],
                                        [UIImage imageNamed:@"whitegif9.png"],
                                        [UIImage imageNamed:@"whitegif10.png"],
                                        [UIImage imageNamed:@"whitegif11.png"],
                                        [UIImage imageNamed:@"whitegif12.png"],
                                        [UIImage imageNamed:@"whitegif13.png"],
                                        [UIImage imageNamed:@"whitegif14.png"],
                                        [UIImage imageNamed:@"whitegif15.png"],
                                        [UIImage imageNamed:@"whitegif16.png"],
                                        [UIImage imageNamed:@"whitegif17.png"],
                                        [UIImage imageNamed:@"whitegif18.png"],
                                        [UIImage imageNamed:@"whitegif19.png"],
                                        [UIImage imageNamed:@"whitegif20.png"],
                                        [UIImage imageNamed:@"whitegif21.png"],
                                        [UIImage imageNamed:@"whitegif22.png"],
                                        [UIImage imageNamed:@"whitegif23.png"],
                                        [UIImage imageNamed:@"whitegif24.png"],
                                        nil];
                    
                        animatedImageView.animationImages = animationFramesc;
                        
                        animatedImageView.hidden = false;
                        animatedImageView.animationDuration = 2.0;
                        [animatedImageView startAnimating];
                        
    
                    
                    playButton.hidden = true;
                    nextButton.hidden = true;
                    prevButton.hidden = true;
                    crateBtn.hidden = true;
                    
                    
                }else{
                    animatedImageView.hidden = true;
                    
                    playButton.hidden = false;
                    nextButton.hidden = false;
                    prevButton.hidden = false;
                    crateBtn.hidden = false;
                    
                    
                    [crateBtn setImage:[UIImage imageNamed:@"crateon.png"] forState:UIControlStateNormal];
                }
                
              
                
            }];
        }
     }
        
    
    
}


-(IBAction)goFwd:(id)sender{
    
    int recentid = ([trackid integerValue] + 1);
    NSString *validid =[NSString stringWithFormat:@"%d",recentid];
    RLMResults<TracksRealm *> *res = [TracksRealm objectsWhere:@"trackID = %@ and set_id = %@",validid,setid];
    
    if(res.count>0){
        
        trackid = validid;
       
        trackTitle.text = res.firstObject.track_name;
        
        NSLog(@"track artist %@",res.firstObject.track_artist);
        
        trackRecord.text = res.firstObject.track_artist;
        
        trackAlbum.text = res.firstObject.track_label;
        slider.value = res.firstObject.track_start;
        [[AppDelegate sharedInstance].audioPlayer seekToTime:slider.value];
        
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
                               [UIImage imageNamed:@"1.png"],
                               [UIImage imageNamed:@"2.png"],
                               [UIImage imageNamed:@"3.png"],
                               [UIImage imageNamed:@"4.png"],
                               [UIImage imageNamed:@"5.png"],
                               [UIImage imageNamed:@"6.png"],
                               [UIImage imageNamed:@"7.png"],
                               [UIImage imageNamed:@"8.png"],
                               [UIImage imageNamed:@"9.png"],
                               [UIImage imageNamed:@"10.png"],
                               [UIImage imageNamed:@"11.png"],
                               [UIImage imageNamed:@"12.png"],
                               [UIImage imageNamed:@"13.png"],
                               [UIImage imageNamed:@"14.png"],
                               [UIImage imageNamed:@"15.png"],
                               [UIImage imageNamed:@"16.png"],
                               [UIImage imageNamed:@"17.png"],
                               [UIImage imageNamed:@"18.png"],
                               [UIImage imageNamed:@"19.png"],
                               [UIImage imageNamed:@"20.png"],
                               [UIImage imageNamed:@"21.png"],
                               [UIImage imageNamed:@"22.png"],
                               [UIImage imageNamed:@"23.png"],
                               [UIImage imageNamed:@"24.png"],
                               nil];
            
            animationFramesc = [NSArray arrayWithObjects:
                                [UIImage imageNamed:@"whitegif1.png"],
                                [UIImage imageNamed:@"whitegif2.png"],
                                [UIImage imageNamed:@"whitegif3.png"],
                                [UIImage imageNamed:@"whitegif4.png"],
                                [UIImage imageNamed:@"whitegif5.png"],
                                [UIImage imageNamed:@"whitegif6.png"],
                                [UIImage imageNamed:@"whitegif7.png"],
                                [UIImage imageNamed:@"whitegif8.png"],
                                [UIImage imageNamed:@"whitegif9.png"],
                                [UIImage imageNamed:@"whitegif10.png"],
                                [UIImage imageNamed:@"whitegif11.png"],
                                [UIImage imageNamed:@"whitegif12.png"],
                                [UIImage imageNamed:@"whitegif13.png"],
                                [UIImage imageNamed:@"whitegif14.png"],
                                [UIImage imageNamed:@"whitegif15.png"],
                                [UIImage imageNamed:@"whitegif16.png"],
                                [UIImage imageNamed:@"whitegif17.png"],
                                [UIImage imageNamed:@"whitegif18.png"],
                                [UIImage imageNamed:@"whitegif19.png"],
                                [UIImage imageNamed:@"whitegif20.png"],
                                [UIImage imageNamed:@"whitegif21.png"],
                                [UIImage imageNamed:@"whitegif22.png"],
                                [UIImage imageNamed:@"whitegif23.png"],
                                [UIImage imageNamed:@"whitegif24.png"],
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
            crateBtn.hidden = true;
            
            
        }else{
            animatedImageView.hidden = true;
            
            playButton.hidden = false;
            nextButton.hidden = false;
            prevButton.hidden = false;
            crateBtn.hidden = false;
            
            
            if(res.count>0){
                
                [crateBtn setImage:[UIImage imageNamed:@"crateon.png"] forState:UIControlStateNormal];
            }else{
                [crateBtn setImage:[UIImage imageNamed:@"crateoff.png"] forState:UIControlStateNormal];
            }
        }
        
    }else{
        
    }
   
}

-(IBAction)goBck:(id)sender{
    int recentid = ([trackid integerValue] - 1);
    NSString *validid =[NSString stringWithFormat:@"%d",recentid];
    RLMResults<TracksRealm *> *res = [TracksRealm objectsWhere:@"trackID = %@ and set_id = %@",validid,setid];
    
    if(res.count>0){
        
        trackid = validid;
        trackTitle.text = res.firstObject.track_name;
        
        NSLog(@"track artist %@",res.firstObject.track_artist);
        
        trackRecord.text = res.firstObject.track_artist;
        
        trackAlbum.text = res.firstObject.track_label;
        slider.value = res.firstObject.track_start;
        [[AppDelegate sharedInstance].audioPlayer seekToTime:slider.value];
        
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
                               [UIImage imageNamed:@"1.png"],
                               [UIImage imageNamed:@"2.png"],
                               [UIImage imageNamed:@"3.png"],
                               [UIImage imageNamed:@"4.png"],
                               [UIImage imageNamed:@"5.png"],
                               [UIImage imageNamed:@"6.png"],
                               [UIImage imageNamed:@"7.png"],
                               [UIImage imageNamed:@"8.png"],
                               [UIImage imageNamed:@"9.png"],
                               [UIImage imageNamed:@"10.png"],
                               [UIImage imageNamed:@"11.png"],
                               [UIImage imageNamed:@"12.png"],
                               [UIImage imageNamed:@"13.png"],
                               [UIImage imageNamed:@"14.png"],
                               [UIImage imageNamed:@"15.png"],
                               [UIImage imageNamed:@"16.png"],
                               [UIImage imageNamed:@"17.png"],
                               [UIImage imageNamed:@"18.png"],
                               [UIImage imageNamed:@"19.png"],
                               [UIImage imageNamed:@"20.png"],
                               [UIImage imageNamed:@"21.png"],
                               [UIImage imageNamed:@"22.png"],
                               [UIImage imageNamed:@"23.png"],
                               [UIImage imageNamed:@"24.png"],
                               nil];
            
            animationFramesc = [NSArray arrayWithObjects:
                                [UIImage imageNamed:@"whitegif1.png"],
                                [UIImage imageNamed:@"whitegif2.png"],
                                [UIImage imageNamed:@"whitegif3.png"],
                                [UIImage imageNamed:@"whitegif4.png"],
                                [UIImage imageNamed:@"whitegif5.png"],
                                [UIImage imageNamed:@"whitegif6.png"],
                                [UIImage imageNamed:@"whitegif7.png"],
                                [UIImage imageNamed:@"whitegif8.png"],
                                [UIImage imageNamed:@"whitegif9.png"],
                                [UIImage imageNamed:@"whitegif10.png"],
                                [UIImage imageNamed:@"whitegif11.png"],
                                [UIImage imageNamed:@"whitegif12.png"],
                                [UIImage imageNamed:@"whitegif13.png"],
                                [UIImage imageNamed:@"whitegif14.png"],
                                [UIImage imageNamed:@"whitegif15.png"],
                                [UIImage imageNamed:@"whitegif16.png"],
                                [UIImage imageNamed:@"whitegif17.png"],
                                [UIImage imageNamed:@"whitegif18.png"],
                                [UIImage imageNamed:@"whitegif19.png"],
                                [UIImage imageNamed:@"whitegif20.png"],
                                [UIImage imageNamed:@"whitegif21.png"],
                                [UIImage imageNamed:@"whitegif22.png"],
                                [UIImage imageNamed:@"whitegif23.png"],
                                [UIImage imageNamed:@"whitegif24.png"],
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
            crateBtn.hidden = true;
            
            
        }else{
            animatedImageView.hidden = true;
            
            playButton.hidden = false;
            nextButton.hidden = false;
            prevButton.hidden = false;
            crateBtn.hidden = false;
            
            
            if(res.count>0){
                
                [crateBtn setImage:[UIImage imageNamed:@"crateon.png"] forState:UIControlStateNormal];
            }else{
                [crateBtn setImage:[UIImage imageNamed:@"crateoff.png"] forState:UIControlStateNormal];
            }
        }
        
    }else{
        
    }
}

-(void) saveSets{
    
    NSString *dateString = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterFullStyle];
    NSLog(@"%@",dateString);
    NSDictionary *userInfo1 = @{
                                @"setid" : @"5",
                                @"setf_audio_link" : @"http://tramusic.net/selekta/bpm_mix.mp3",
                                @"set_picture" : @"http://www.selektamusic.com/app/Covers/wolf_lamb.jpg",
                                @"set_artist" : @"Wolf + Lamb",
                                @"set_filename" : @"bpm_mix",
                                @"set_background_pic" : @"http://www.selektamusic.com/app/backgrounds/backgroundtest.png",
                                @"set_btn_image" : @"http://www.selektamusic.com/app/set_button/Wolflamb.png",
                                @"set_title" : @"Crew Love Miami",
                                @"dateCreated" : dateString,
                                };
    
    NSLog(@"%@", userInfo1);
    
    [[AccountsClient sharedInstance] saveSets:userInfo1 accountID:@"5" completion:nil];
    
    NSDictionary *userInfo2 = @{
                                @"setid" : @"4",
                                @"set_audio_link" : @"http://tramusic.net/selekta/bpm_mix.mp3",
                                @"set_picture" : @"http://www.selektamusic.com/app/Covers/pete_cover.png",
                                @"set_artist" : @"Pete Tong",
                                @"set_filename" : @"bpm_mix",
                                @"set_background_pic" : @"http://www.selektamusic.com/app/backgrounds/ed_banger.png",
                                @"set_btn_image" : @"http://www.selektamusic.com/app/set_button/petetong.png",
                                @"set_title" : @"Ibiza Villa Mix",
                                @"dateCreated" : dateString,
                                };
    
    [[AccountsClient sharedInstance] saveSets:userInfo2 accountID:@"4" completion:nil];
    
    NSDictionary *userInfo3 = @{
                                @"setid" : @"3",
                                @"set_audio_link" : @"http://tramusic.net/selekta/just_be.mp3",
                                @"set_picture" : @"http://www.selektamusic.com/app/Covers/waff_cover.png",
                                @"set_artist" : @"Waff",
                                @"set_filename" : @"bpm_mix",
                                @"set_background_pic" : @"http://www.selektamusic.com/app/backgrounds/timewarp.jpg",
                                @"set_btn_image" : @"http://www.selektamusic.com/app/set_button/waff.png",
                                @"set_title" : @"Time Warp Live Set",
                                @"dateCreated" : dateString,
                                };
    
    [[AccountsClient sharedInstance] saveSets:userInfo3 accountID:@"3" completion:nil];
    
    
    NSDictionary *userInfo4 = @{
                                @"setid" : @"2",
                                @"set_audio_link" : @"http://tramusic.net/selekta/amtrac_night_bass_mix.mp3",
                                @"set_picture" : @"http://www.selektamusic.com/app/Covers/luciano_cover.png",
                                @"set_artist" : @"Luciano",
                                @"set_filename" : @"amtrac_night_bass_mix",
                                @"set_background_pic" : @"http://www.selektamusic.com/app/backgrounds/luciano.jpg",
                                @"set_btn_image" : @"http://www.selektamusic.com/app/set_button/luciano.png",
                                @"set_title" : @"Summer Exclusive Mix",
                                @"dateCreated" : dateString,
                                };
    
    [[AccountsClient sharedInstance] saveSets:userInfo4 accountID:@"2" completion:nil];
    
    NSDictionary *userInfo5 = @{
                                @"setid" : @"1",
                                @"set_audio_link" : @"http://tramusic.net/selekta/test_mix.mp3",
                                @"set_picture" : @"http://www.selektamusic.com/app/Covers/skrillex.png",
                                @"set_artist" : @"Skrillex",
                                @"set_filename" : @"test_mix",
                                @"set_background_pic" : @"http://www.selektamusic.com/app/backgrounds/blurred.png",
                                @"set_btn_image" : @"http://www.selektamusic.com/app/set_button/skrillex.png",
                                @"set_title" : @"Busy P's Paris Is Burning Mix",
                                @"dateCreated" : dateString,
                                };
    
    [[AccountsClient sharedInstance] saveSets:userInfo5 accountID:@"1" completion:nil];
}

-(void) saveTracksSet1{
    
    NSString *setid =@"1";
    NSString *dateString = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterFullStyle];
    NSLog(@"%@",dateString);
    NSDictionary *userInfo = @{
                               @"trackID" : @"1",
                               @"track_start" : @"1",
                               @"set_id" : setid,
                               @"track_artists" : @"NGHTMRE",
                               @"track_name" : @"ID",
                               @"track_label" : @"",
                               @"track_album" : @"",
                               @"set_title" : @"Busy P's Paris Is Burning Mix",
                               @"dateCreated" : dateString,
                               };
    
    [[AccountsClient sharedInstance] saveTracks:userInfo accountID:@"1" setID:setid completion:nil];
    
    NSDictionary *userInfo1 = @{
                                @"trackID" : @"2",
                                @"track_start" : @"100",
                                @"set_id" : setid,
                                @"track_artists" : @"Jack U",
                                @"track_name" : @"Holla Out (Feat. Snails' Taranchyla) VIP",
                                @"track_label" : @"",
                                @"track_album" : @"",
                                @"set_title" : @"Busy P's Paris Is Burning Mix",
                                @"dateCreated" : dateString,
                                };
    
    [[AccountsClient sharedInstance] saveTracks:userInfo1 accountID:@"2" setID:setid completion:nil];
    
    NSDictionary *userInfo3 = @{
                                @"trackID" : @"3",
                                @"track_start" : @"200",
                                @"set_id" : setid,
                                @"track_artists" : @"Valentino Kahn",
                                @"track_name" : @"Deep Down Low (Rickyxsan’s Low AF Bootleg)",
                                @"track_label" : @"",
                                @"track_album" : @"",
                                @"set_title" : @"Busy P's Paris Is Burning Mix",
                                @"dateCreated" : dateString,
                                };
    
    [[AccountsClient sharedInstance] saveTracks:userInfo3 accountID:@"3" setID:setid completion:nil];
    
    NSDictionary *userInfo4 = @{
                                @"trackID" : @"4",
                                @"track_start" : @"300",
                                @"set_id" : setid,
                                @"track_artists" : @"Warrior",
                                @"track_name" : @"The End (Carnage  Breaux Festival Trap Remix)",
                                @"track_label" : @"",
                                @"track_album" : @"",
                                @"set_title" : @"Busy P's Paris Is Burning Mix",
                                @"dateCreated" : dateString,
                                };
    
    [[AccountsClient sharedInstance] saveTracks:userInfo4 accountID:@"4" setID:setid completion:nil];
    
    NSDictionary *userInfo5 = @{
                                @"trackID" : @"5",
                                @"track_start" : @"400",
                                @"set_id" : setid,
                                @"track_artists" : @"Eptic",
                                @"track_name" : @"Move That Dope (Woolymammoth  Quix Remix)",
                                @"track_label" : @"",
                                @"track_album" : @"",
                                @"set_title" : @"Busy P's Paris Is Burning Mix",
                                @"dateCreated" : dateString,
                                };
    
    [[AccountsClient sharedInstance] saveTracks:userInfo5 accountID:@"5" setID:setid completion:nil];
    
    NSDictionary *userInfo6 = @{
                                @"trackID" : @"6",
                                @"track_start" : @"500",
                                @"set_id" : setid,
                                @"track_artists" : @"Future",
                                @"track_name" : @"Ectoplasm",
                                @"track_label" : @"",
                                @"track_album" : @"",
                                @"set_title" : @"Busy P's Paris Is Burning Mix",
                                @"dateCreated" : dateString,
                                };
    
    [[AccountsClient sharedInstance] saveTracks:userInfo6 accountID:@"6" setID:setid completion:nil];
    
    NSDictionary *userInfo7 = @{
                                @"trackID" : @"7",
                                @"track_start" : @"600",
                                @"set_id" : setid,
                                @"track_artists" : @"Eptic ft. Must Die",
                                @"track_name" : @"Lean On (Ookay It’s Lit Bootleg)",
                                @"track_label" : @"",
                                @"track_album" : @"",
                                @"set_title" : @"Busy P's Paris Is Burning Mix",
                                @"dateCreated" : dateString,
                                };
    
    [[AccountsClient sharedInstance] saveTracks:userInfo7 accountID:@"7" setID:setid completion:nil];
    
    NSDictionary *userInfo8 = @{
                                @"trackID" : @"8",
                                @"track_start" : @"700",
                                @"set_id" : setid,
                                @"track_artists" : @"Major Lazer",
                                @"track_name" : @"We Like to Party (Slander  NGHTMRE Festival Trap Edit)",
                                @"track_label" : @"",
                                @"track_album" : @"",
                                @"set_title" : @"Busy P's Paris Is Burning Mix",
                                @"dateCreated" : dateString,
                                };
    
    [[AccountsClient sharedInstance] saveTracks:userInfo8 accountID:@"8" setID:setid completion:nil];
    
    NSDictionary *userInfo9 = @{
                                @"trackID" : @"9",
                                @"track_start" : @"800",
                                @"set_id" : setid,
                                @"track_artists" : @"Showtek",
                                @"track_name" : @"Solutions, with Donnis",
                                @"track_label" : @"",
                                @"track_album" : @"",
                                @"set_title" : @"Busy P's Paris Is Burning Mix",
                                @"dateCreated" : dateString,
                                };
    
    [[AccountsClient sharedInstance] saveTracks:userInfo9 accountID:@"9" setID:setid completion:nil];
    
    NSDictionary *userInfo10 = @{
                                 @"trackID" : @"10",
                                 @"track_start" : @"900",
                                 @"set_id" : setid,
                                 @"track_artists" : @"MR. Carmack",
                                 @"track_name" : @"Burial (Skrillex' Trollphace Remix) [G-Buck edit]",
                                 @"track_label" : @"",
                                 @"track_album" : @"",
                                 @"set_title" : @"Busy P's Paris Is Burning Mix",
                                 @"dateCreated" : dateString,
                                 };
    
    [[AccountsClient sharedInstance] saveTracks:userInfo10 accountID:@"10" setID:setid completion:nil];
    
    //second
    NSDictionary *userInfo11 = @{
                                 @"trackID" : @"11",
                                 @"track_start" : @"1000",
                                 @"set_id" : setid,
                                 @"track_artists" : @"Yogi",
                                 @"track_name" : @"Jungle Bae ft. Bunji Garlin (Sirenz Rework)",
                                 @"track_label" : @"",
                                 @"track_album" : @"",
                                 @"set_title" : @"Busy P's Paris Is Burning Mix",
                                 @"dateCreated" : dateString,
                                 };
    
    [[AccountsClient sharedInstance] saveTracks:userInfo11 accountID:@"11" setID:setid completion:nil];
    
    NSDictionary *userInfo12 = @{
                                 @"trackID" : @"12",
                                 @"track_start" : @"1050",
                                 @"set_id" : setid,
                                 @"track_artists" : @"Jack U",
                                 @"track_name" : @"Acrylics (RL Grime Edit)",
                                 @"track_label" : @"",
                                 @"track_album" : @"",
                                 @"set_title" : @"Busy P's Paris Is Burning Mix",
                                 @"dateCreated" : dateString,
                                 };
    
    [[AccountsClient sharedInstance] saveTracks:userInfo12 accountID:@"12" setID:setid completion:nil];
    
    NSDictionary *userInfo13 = @{
                                 @"trackID" : @"13",
                                 @"track_start" : @"1100",
                                 @"set_id" : setid,
                                 @"track_artists" : @"TNGHT",
                                 @"track_name" : @"The Dopest (Cesqeaux Remix)",
                                 @"track_label" : @"",
                                 @"track_album" : @"",
                                 @"set_title" : @"Busy P's Paris Is Burning Mix",
                                 @"dateCreated" : dateString,
                                 };
    
    [[AccountsClient sharedInstance] saveTracks:userInfo13 accountID:@"13" setID:setid completion:nil];
    
    NSDictionary *userInfo14 = @{
                                 @"trackID" : @"14",
                                 @"track_start" : @"1150",
                                 @"set_id" : setid,
                                 @"track_artists" : @"Moksi",
                                 @"track_name" : @"Trap Queen",
                                 @"track_label" : @"",
                                 @"track_album" : @"",
                                 @"set_title" : @"Busy P's Paris Is Burning Mix",
                                 @"dateCreated" : dateString,
                                 };
    
    [[AccountsClient sharedInstance] saveTracks:userInfo14 accountID:@"14" setID:setid completion:nil];
    
    NSDictionary *userInfo15 = @{
                                 @"trackID" : @"15",
                                 @"track_start" : @"1200",
                                 @"set_id" : setid,
                                 @"track_artists" : @"Fetty Wap",
                                 @"track_name" : @"Get Low (Aazar Remix)",
                                 @"track_label" : @"",
                                 @"track_album" : @"",
                                 @"set_title" : @"Busy P's Paris Is Burning Mix",
                                 @"dateCreated" : dateString,
                                 };
    
    [[AccountsClient sharedInstance] saveTracks:userInfo5 accountID:@"15" setID:setid completion:nil];
    
    NSDictionary *userInfo16 = @{
                                 @"trackID" : @"16",
                                 @"track_start" : @"1250",
                                 @"set_id" : setid,
                                 @"track_artists" : @"Dillon Francis  DJ Snake",
                                 @"track_name" : @"B2U ft. Ian Everson",
                                 @"track_label" : @"",
                                 @"track_album" : @"",
                                 @"set_title" : @"Busy P's Paris Is Burning Mix",
                                 @"dateCreated" : dateString,
                                 };
    
    [[AccountsClient sharedInstance] saveTracks:userInfo16 accountID:@"16" setID:setid completion:nil];
    
    NSDictionary *userInfo17 = @{
                                 @"trackID" : @"17",
                                 @"track_start" : @"1300",
                                 @"set_id" : setid,
                                 @"track_artists" : @"Boombox Cartel",
                                 @"track_name" : @"Only Getting Younger (NGHTMRE/ Imanos Remix)",
                                 @"track_label" : @"",
                                 @"track_album" : @"",
                                 @"set_title" : @"Busy P's Paris Is Burning Mix",
                                 @"dateCreated" : dateString,
                                 };
    
    [[AccountsClient sharedInstance] saveTracks:userInfo17 accountID:@"17" setID:setid completion:nil];
    
    NSDictionary *userInfo18 = @{
                                 @"trackID" : @"18",
                                 @"track_start" : @"1350",
                                 @"set_id" : setid,
                                 @"track_artists" : @"Elliphant ft. Skrillex",
                                 @"track_name" : @"Jiggy (NGHTMRE Remix)",
                                 @"track_label" : @"",
                                 @"track_album" : @"",
                                 @"set_title" : @"Busy P's Paris Is Burning Mix",
                                 @"dateCreated" : dateString,
                                 };
    
    [[AccountsClient sharedInstance] saveTracks:userInfo18 accountID:@"18" setID:setid completion:nil];
    
    NSDictionary *userInfo19 = @{
                                 @"trackID" : @"19",
                                 @"track_start" : @"1400",
                                 @"set_id" : setid,
                                 @"track_artists" : @"Victor Niglio",
                                 @"track_name" : @"Dum Dee Dum (NGHTMRE Remix) [Unreleased]",
                                 @"track_label" : @"",
                                 @"track_album" : @"",
                                 @"set_title" : @"Busy P's Paris Is Burning Mix",
                                 @"dateCreated" : dateString,
                                 };
    
    [[AccountsClient sharedInstance] saveTracks:userInfo19 accountID:@"19" setID:setid completion:nil];
    
    NSDictionary *userInfo20 = @{
                                 @"trackID" : @"20",
                                 @"track_start" : @"1450",
                                 @"set_id" : setid,
                                 @"track_artists" : @"Keys n Krates",
                                 @"track_name" : @"Holla Out (Feat. Snails' Taranchyla) VIP",
                                 @"track_label" : @"",
                                 @"track_album" : @"",
                                 @"set_title" : @"Busy P's Paris Is Burning Mix",
                                 @"dateCreated" : dateString,
                                 };
    
    [[AccountsClient sharedInstance] saveTracks:userInfo20 accountID:@"20" setID:setid completion:nil];
    
    //third
    NSDictionary *userInfo21 = @{
                                 @"trackID" : @"21",
                                 @"track_start" : @"1500",
                                 @"set_id" : setid,
                                 @"track_artists" : @"NGHTMRE",
                                 @"track_name" : @"STREET",
                                 @"track_label" : @"",
                                 @"track_album" : @"",
                                 @"set_title" : @"Busy P's Paris Is Burning Mix",
                                 @"dateCreated" : dateString,
                                 };
    
    [[AccountsClient sharedInstance] saveTracks:userInfo21 accountID:@"21" setID:setid completion:nil];
    
    NSDictionary *userInfo22 = @{
                                 @"trackID" : @"22",
                                 @"track_start" : @"1550",
                                 @"set_id" : setid,
                                 @"track_artists" : @"A. G. Cook",
                                 @"track_name" : @"Beautiful (Rustie Edit)",
                                 @"track_label" : @"",
                                 @"track_album" : @"",
                                 @"set_title" : @"Busy P's Paris Is Burning Mix",
                                 @"dateCreated" : dateString,
                                 };
    
    [[AccountsClient sharedInstance] saveTracks:userInfo22 accountID:@"22" setID:setid completion:nil];
    
    NSDictionary *userInfo23 = @{
                                 @"trackID" : @"23",
                                 @"track_start" : @"1600",
                                 @"set_id" : setid,
                                 @"track_artists" : @"NGHTMRE",
                                 @"track_name" : @"ID",
                                 @"track_label" : @"",
                                 @"track_album" : @"",
                                 @"set_title" : @"Busy P's Paris Is Burning Mix",
                                 @"dateCreated" : dateString,
                                 };
    
    [[AccountsClient sharedInstance] saveTracks:userInfo23 accountID:@"23" setID:setid completion:nil];
    
    NSDictionary *userInfo24 = @{
                                 @"trackID" : @"24",
                                 @"track_start" : @"1650",
                                 @"set_id" : setid,
                                 @"track_artists" : @"NGHTMRE Slander",
                                 @"track_name" : @"Gud Vibrations",
                                 @"track_label" : @"",
                                 @"track_album" : @"",
                                 @"set_title" : @"Busy P's Paris Is Burning Mix",
                                 @"dateCreated" : dateString,
                                 };
    
    [[AccountsClient sharedInstance] saveTracks:userInfo24 accountID:@"24" setID:setid completion:nil];
    
    NSDictionary *userInfo25 = @{
                                 @"trackID" : @"25",
                                 @"track_start" : @"1700",
                                 @"set_id" : setid,
                                 @"track_artists" : @"NGHTMRE Slander",
                                 @"track_name" : @"Warning",
                                 @"track_label" : @"",
                                 @"track_album" : @"",
                                 @"set_title" : @"Busy P's Paris Is Burning Mix",
                                 @"dateCreated" : dateString,
                                 };
    
    [[AccountsClient sharedInstance] saveTracks:userInfo25 accountID:@"25" setID:setid completion:nil];
    
    NSDictionary *userInfo26 = @{
                                 @"trackID" : @"26",
                                 @"track_start" : @"1750",
                                 @"set_id" : setid,
                                 @"track_artists" : @"Instant Party!  Breaux",
                                 @"track_name" : @"Moon of Pejeng",
                                 @"track_label" : @"",
                                 @"track_album" : @"",
                                 @"set_title" : @"Busy P's Paris Is Burning Mix",
                                 @"dateCreated" : dateString,
                                 };
    
    [[AccountsClient sharedInstance] saveTracks:userInfo26 accountID:@"26" setID:setid completion:nil];
    
    NSDictionary *userInfo27 = @{
                                 @"trackID" : @"27",
                                 @"track_start" : @"1800",
                                 @"set_id" : setid,
                                 @"track_artists" : @"The Prodigy",
                                 @"track_name" : @"Rhythm Bomb (NGHTMRE Remix)",
                                 @"track_label" : @"",
                                 @"track_album" : @"",
                                 @"set_title" : @"Busy P's Paris Is Burning Mix",
                                 @"dateCreated" : dateString,
                                 };
    
    [[AccountsClient sharedInstance] saveTracks:userInfo27 accountID:@"27" setID:setid completion:nil];
    
    NSDictionary *userInfo28 = @{
                                 @"trackID" : @"28",
                                 @"track_start" : @"1850",
                                 @"set_id" : setid,
                                 @"track_artists" : @"Major Lazer Dj Snake",
                                 @"track_name" : @"Lean On (NGHTMRE Remix)",
                                 @"track_label" : @"",
                                 @"track_album" : @"",
                                 @"set_title" : @"Busy P's Paris Is Burning Mix",
                                 @"dateCreated" : dateString,
                                 };
    
    [[AccountsClient sharedInstance] saveTracks:userInfo28 accountID:@"28" setID:setid completion:nil];
    
    NSDictionary *userInfo29 = @{
                                 @"trackID" : @"29",
                                 @"track_start" : @"1900",
                                 @"set_id" : setid,
                                 @"track_artists" : @"Slander NGHTMRE",
                                 @"track_name" : @"You",
                                 @"track_label" : @"",
                                 @"track_album" : @"",
                                 @"set_title" : @"Busy P's Paris Is Burning Mix",
                                 @"dateCreated" : dateString,
                                 };
    
    [[AccountsClient sharedInstance] saveTracks:userInfo29 accountID:@"29" setID:setid completion:nil];
    
    
}

-(void) saveTracksSet2{
    
    NSString *setid =@"2";
    NSString *dateString = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterFullStyle];
    NSLog(@"%@",dateString);
    NSDictionary *userInfo = @{
                               @"trackID" : @"1",
                               @"track_start" : @"1",
                               @"set_id" : setid,
                               @"track_artists" : @"MANT",
                               @"track_name" : @"Free",
                               @"track_label" : @"",
                               @"track_album" : @"",
                               @"set_title" : @"Summer Exclusive Mix",
                               @"dateCreated" : dateString,
                               };
    
    [[AccountsClient sharedInstance] saveTracks:userInfo accountID:@"1" setID:setid completion:nil];
    
    NSDictionary *userInfo1 = @{
                                @"trackID" : @"2",
                                @"track_start" : @"100",
                                @"set_id" : setid,
                                @"track_artists" : @"Gorgon City ft. Romans",
                                @"track_name" : @"Saving My Life",
                                @"track_label" : @"Virgin / EMI",
                                @"track_album" : @"",
                                @"set_title" : @"Summer Exclusive Mix",
                                @"dateCreated" : dateString,
                                };
    
    [[AccountsClient sharedInstance] saveTracks:userInfo1 accountID:@"2" setID:setid completion:nil];
    
    NSDictionary *userInfo3 = @{
                                @"trackID" : @"3",
                                @"track_start" : @"300",
                                @"set_id" : setid,
                                @"track_artists" : @"Rills",
                                @"track_name" : @"Everybody",
                                @"track_label" : @"",
                                @"track_album" : @"",
                                @"set_title" : @"Summer Exclusive Mix",
                                @"dateCreated" : dateString,
                                };
    
    [[AccountsClient sharedInstance] saveTracks:userInfo3 accountID:@"3" setID:setid completion:nil];
    
    NSDictionary *userInfo4 = @{
                                @"trackID" : @"4",
                                @"track_start" : @"450",
                                @"set_id" : setid,
                                @"track_artists" : @"Ricardo Villalobos",
                                @"track_name" : @"Enfants",
                                @"track_label" : @"Chants",
                                @"track_album" : @"",
                                @"set_title" : @"Summer Exclusive Mix",
                                @"dateCreated" : dateString,
                                };
    
    [[AccountsClient sharedInstance] saveTracks:userInfo4 accountID:@"4" setID:setid completion:nil];
    
    NSDictionary *userInfo5 = @{
                                @"trackID" : @"5",
                                @"track_start" : @"580",
                                @"set_id" : setid,
                                @"track_artists" : @"Jeff Mills",
                                @"track_name" : @"The Bells",
                                @"track_label" : @"Purpose Maker",
                                @"track_album" : @"",
                                @"set_title" : @"Summer Exclusive Mix",
                                @"dateCreated" : dateString,
                                };
    
    [[AccountsClient sharedInstance] saveTracks:userInfo5 accountID:@"5" setID:setid completion:nil];
    
    NSDictionary *userInfo6 = @{
                                @"trackID" : @"6",
                                @"track_start" : @"710",
                                @"set_id" : setid,
                                @"track_artists" : @"Junior Jack",
                                @"track_name" : @"Thrill Me",
                                @"track_label" : @"PIAS",
                                @"track_album" : @"",
                                @"set_title" : @"Summer Exclusive Mix",
                                @"dateCreated" : dateString,
                                };
    
    [[AccountsClient sharedInstance] saveTracks:userInfo6 accountID:@"6" setID:setid completion:nil];
    
}

-(void) saveTracksSet3{
    
    NSString *setid =@"3";
    NSString *dateString = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterFullStyle];
    NSLog(@"%@",dateString);
    NSDictionary *userInfo = @{
                               @"trackID" : @"1",
                               @"track_start" : @"1",
                               @"set_id" : setid,
                               @"track_artists" : @"Sneaky Tim",
                               @"track_name" : @"Everybody",
                               @"track_label" : @"",
                               @"track_album" : @"",
                               @"set_title" : @"Time Warp Live Set",
                               @"dateCreated" : dateString,
                               };
    
    [[AccountsClient sharedInstance] saveTracks:userInfo accountID:@"1" setID:setid completion:nil];
    
    NSDictionary *userInfo1 = @{
                                @"trackID" : @"2",
                                @"track_start" : @"120",
                                @"set_id" : setid,
                                @"track_artists" : @"Davina Moss",
                                @"track_name" : @"Begging Me",
                                @"track_label" : @"Hot Creations",
                                @"track_album" : @"",
                                @"set_title" : @"Time Warp Live Set",
                                @"dateCreated" : dateString,
                                };
    
    [[AccountsClient sharedInstance] saveTracks:userInfo1 accountID:@"2" setID:setid completion:nil];
    
    NSDictionary *userInfo3 = @{
                                @"trackID" : @"3",
                                @"track_start" : @"330",
                                @"set_id" : setid,
                                @"track_artists" : @"Green Velvet  Patrick Topping",
                                @"track_name" : @"When Is Now",
                                @"track_label" : @"Relief",
                                @"track_album" : @"",
                                @"set_title" : @"Time Warp Live Set",
                                @"dateCreated" : dateString,
                                };
    
    [[AccountsClient sharedInstance] saveTracks:userInfo3 accountID:@"3" setID:setid completion:nil];
    
    
}

-(void) saveTracksSet4{
    
    NSString *setid =@"4";
    NSString *dateString = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterFullStyle];
    NSLog(@"%@",dateString);
    NSDictionary *userInfo = @{
                               @"trackID" : @"1",
                               @"track_start" : @"1",
                               @"set_id" : setid,
                               @"track_artists" : @"ZHU",
                               @"track_name" : @"In the Morning",
                               @"track_label" : @"Mind of a Genius",
                               @"track_album" : @"",
                               @"set_title" : @"Ibiza Villa Mix",
                               @"dateCreated" : dateString,
                               };
    
    [[AccountsClient sharedInstance] saveTracks:userInfo accountID:@"1" setID:setid completion:nil];
    
    NSDictionary *userInfo1 = @{
                                @"trackID" : @"2",
                                @"track_start" : @"200",
                                @"set_id" : setid,
                                @"track_artists" : @"MK ft. Becky Hill",
                                @"track_name" : @"Piece of Me",
                                @"track_label" : @"Area 10",
                                @"track_album" : @"",
                                @"set_title" : @"Ibiza Villa Mix",
                                @"dateCreated" : dateString,
                                };
    
    [[AccountsClient sharedInstance] saveTracks:userInfo1 accountID:@"2" setID:setid completion:nil];
    
    NSDictionary *userInfo3 = @{
                                @"trackID" : @"3",
                                @"track_start" : @"330",
                                @"set_id" : setid,
                                @"track_artists" : @"FLume ft. Kai",
                                @"track_name" : @"Never Be Like You (Disclosure Remix)",
                                @"track_label" : @"Future Classics",
                                @"track_album" : @"",
                                @"set_title" : @"Ibiza Villa Mix",
                                @"dateCreated" : dateString,
                                };
    
    [[AccountsClient sharedInstance] saveTracks:userInfo3 accountID:@"3" setID:setid completion:nil];
    
    NSDictionary *userInfo4 = @{
                                @"trackID" : @"4",
                                @"track_start" : @"450",
                                @"set_id" : setid,
                                @"track_artists" : @"M83",
                                @"track_name" : @"Do It, Try It",
                                @"track_label" : @"Sony/EMI",
                                @"track_album" : @"",
                                @"set_title" : @"Ibiza Villa Mix",
                                @"dateCreated" : dateString,
                                };
    
    [[AccountsClient sharedInstance] saveTracks:userInfo4 accountID:@"4" setID:setid completion:nil];
    
    NSDictionary *userInfo5 = @{
                                @"trackID" : @"5",
                                @"track_start" : @"570",
                                @"set_id" : setid,
                                @"track_artists" : @"Riva Starr  ft. Green Velvet",
                                @"track_name" : @"You're Beating",
                                @"track_label" : @"Starr Recs",
                                @"track_album" : @"",
                                @"set_title" : @"Ibiza Villa Mix",
                                @"dateCreated" : dateString,
                                };
    
    [[AccountsClient sharedInstance] saveTracks:userInfo5 accountID:@"5" setID:setid completion:nil];
    
    
    
}

-(void) saveTracksSet5{
    
    NSString *setid =@"5";
    NSString *dateString = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterFullStyle];
    NSLog(@"%@",dateString);
    NSDictionary *userInfo = @{
                               @"trackID" : @"1",
                               @"track_start" : @"1",
                               @"set_id" : setid,
                               @"track_artists" : @"Midnight Magic",
                               @"track_name" : @"I Gotta Feeling (Nick Monaco & David Marston Remix)",
                               @"track_label" : @"Crew Love",
                               @"track_album" : @"",
                               @"set_title" : @"Crew Love Miami",
                               @"dateCreated" : dateString,
                               };
    
    [[AccountsClient sharedInstance] saveTracks:userInfo accountID:@"1" setID:setid completion:nil];
    
    
    
    
    
}

-(void) saveToCrate : (TracksRealm *) track : (SetObj *) set{
    
    
    

  
    
}

-(void) initplayer{
    

    NSLog(@"trackurl %@",trackurl);
    [self audioPlayerViewPlayFromHTTPSelected:self:trackurl];
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    [self becomeFirstResponder];
    
   
    
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
        
        
        
        [crateBtn setImage:[UIImage imageNamed:@"crateon.png"] forState:UIControlStateNormal];
        
        
        
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

-(void) viewWillDisappear:(BOOL)animated{

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
    }else{
        searchView.hidden = YES;
        isSearch = false;
        self.searchField.hidden = YES;
        [self.searchField resignFirstResponder];
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
    
    
    
    /*Firebase *ref = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@/sets", FIREBASE_URL]];
     [[[ref queryOrderedByChild:@"set_title"] queryEqualToValue:theTextField.text] observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
     NSLog(@"%@", snapshot.key);
     
     NSLog(@"All Sets = %@", snapshot.value);
     if (snapshot.value != (id)[NSNull null]) {
     self.setLbl.text=[NSString stringWithFormat:@"%lu RESULT(S) FOUND",(unsigned long)[snapshot.value count]-1];
     
     [self.thisTableView reloadData];
     }
     
     }];*/
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
        [[NSUserDefaults standardUserDefaults] synchronize];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PlayerVC *signVC = (PlayerVC *)[storyboard instantiateViewControllerWithIdentifier:@"PlayerVC"];
        [[AppDelegate sharedInstance].audioPlayer stop];
        [self.slideMenuController closeMenuBehindContentViewController:signVC animated:YES completion:nil];
    }else{
        
    }
}

-(void) setCrate {
    
    
    NSArray *animationFrames = [NSArray arrayWithObjects:
                                [UIImage imageNamed:@"1.png"],
                                [UIImage imageNamed:@"2.png"],
                                [UIImage imageNamed:@"3.png"],
                                [UIImage imageNamed:@"4.png"],
                                [UIImage imageNamed:@"5.png"],
                                [UIImage imageNamed:@"6.png"],
                                [UIImage imageNamed:@"7.png"],
                                [UIImage imageNamed:@"8.png"],
                                [UIImage imageNamed:@"9.png"],
                                [UIImage imageNamed:@"10.png"],
                                [UIImage imageNamed:@"11.png"],
                                [UIImage imageNamed:@"12.png"],
                                [UIImage imageNamed:@"13.png"],
                                [UIImage imageNamed:@"14.png"],
                                [UIImage imageNamed:@"15.png"],
                                [UIImage imageNamed:@"16.png"],
                                [UIImage imageNamed:@"17.png"],
                                [UIImage imageNamed:@"18.png"],
                                [UIImage imageNamed:@"19.png"],
                                [UIImage imageNamed:@"20.png"],
                                [UIImage imageNamed:@"21.png"],
                                [UIImage imageNamed:@"22.png"],
                                [UIImage imageNamed:@"23.png"],
                                [UIImage imageNamed:@"24.png"],
                                nil];
    
    NSArray *animationFramesc = [NSArray arrayWithObjects:
                                 [UIImage imageNamed:@"whitegif1.png"],
                                 [UIImage imageNamed:@"whitegif2.png"],
                                 [UIImage imageNamed:@"whitegif3.png"],
                                 [UIImage imageNamed:@"whitegif4.png"],
                                 [UIImage imageNamed:@"whitegif5.png"],
                                 [UIImage imageNamed:@"whitegif6.png"],
                                 [UIImage imageNamed:@"whitegif7.png"],
                                 [UIImage imageNamed:@"whitegif8.png"],
                                 [UIImage imageNamed:@"whitegif9.png"],
                                 [UIImage imageNamed:@"whitegif10.png"],
                                 [UIImage imageNamed:@"whitegif11.png"],
                                 [UIImage imageNamed:@"whitegif12.png"],
                                 [UIImage imageNamed:@"whitegif13.png"],
                                 [UIImage imageNamed:@"whitegif14.png"],
                                 [UIImage imageNamed:@"whitegif15.png"],
                                 [UIImage imageNamed:@"whitegif16.png"],
                                 [UIImage imageNamed:@"whitegif17.png"],
                                 [UIImage imageNamed:@"whitegif18.png"],
                                 [UIImage imageNamed:@"whitegif19.png"],
                                 [UIImage imageNamed:@"whitegif20.png"],
                                 [UIImage imageNamed:@"whitegif21.png"],
                                 [UIImage imageNamed:@"whitegif22.png"],
                                 [UIImage imageNamed:@"whitegif23.png"],
                                 [UIImage imageNamed:@"whitegif24.png"],
                                 nil];
    
    animatedImageView.animationImages = animationFrames;
    animatedImageView.animationDuration = 2.0;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
