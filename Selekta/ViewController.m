//
//  ViewController.m
//  Selekta
//
//  Created by Charisse Ann Dirain on 6/21/16.
//  Copyright © 2016 Charisse Ann Dirain. All rights reserved.
//

#import "ViewController.h"
#import "MenuViewController.h"
#import "NVSlideMenuController.h"
#import "SignupVC.h"
#import "SigninVC.h"
#import <AVFoundation/AVFoundation.h>
static const float PLAYER_VOLUME = 0.0;
typedef NS_ENUM(NSUInteger, currentStatus) {
    freeStatus = 0,
    loginStatus,
    signupStatus,
};

@interface ViewController ()
@property (nonatomic) AVPlayer *player;
@property (weak, nonatomic) IBOutlet UIView *playerView;
@property (nonatomic) currentStatus status;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.status = freeStatus;
    [self createVideoPlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChangeFrame:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil
     ];

    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)goSignup:(id)sender{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SignupVC *signVC = (SignupVC *)[storyboard instantiateViewControllerWithIdentifier:@"SignupVC"];
    
    [self.navigationController pushViewController:signVC animated:YES];
    
}

-(IBAction)goSignin:(id)sender{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SigninVC *signVC = (SigninVC *)[storyboard instantiateViewControllerWithIdentifier:@"SigninVC"];
 
    [self.navigationController pushViewController:signVC animated:YES];
    
}

- (void)createVideoPlayer {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"selekta" ofType:@"mp4"];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url];
    //[playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    self.player = [AVPlayer playerWithPlayerItem:playerItem];
    self.player.volume = PLAYER_VOLUME;
    
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    playerLayer.videoGravity = UIViewContentModeScaleToFill;
    playerLayer.frame = CGRectMake(0, -10, self.view.bounds.size.width+50, self.view.bounds.size.height+50);
    [self.playerView.layer addSublayer:playerLayer];
    
    [self.player play];
    
    [self.player.currentItem addObserver:self forKeyPath:AVPlayerItemDidPlayToEndTimeNotification options:NSKeyValueObservingOptionNew context:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}

- (void)moviePlayDidEnd:(NSNotification*)notification{
    
    AVPlayerItem *item = [notification object];
    [item seekToTime:kCMTimeZero];
    [self.player play];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGRect beginKeyboardRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endKeyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat yOffset = endKeyboardRect.origin.y - beginKeyboardRect.origin.y;
    for (UIView *subview in self.view.subviews) {
        if ([subview isEqual:self.playerView]) {
            continue;
        }
        CGRect frame = subview.frame;
        frame.origin.y += yOffset;
        subview.frame = frame;
    }
}


@end
