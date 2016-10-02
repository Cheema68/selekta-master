//
//  MenuViewController.m
//  Selekta
//
//  Created by apple on 11/15/15.
//  Copyright © 2015 apple. All rights reserved.
//

#import "MenuViewController.h"
#import "NVSlideMenuController.h"
#import "AccountsClient.h"
#import "SigninVC.h"
#import <QuartzCore/QuartzCore.h>
#import "SetsViewController.h"
#import "TableViewController.h"
#import "RecentlyPlayedViewController.h"
#import "SettingsVC.h"
#import "PlayerVC.h"
#import "ViewController.h"
#import "AppDelegate.h"
#import "PlayerNewVC.h"

@interface MenuViewController (){
    
    NSUserDefaults *defaults;
    NSString *playerID;
    
    IBOutlet UIImageView *tutorial1;
    IBOutlet UIButton *next1;
}

@end

@implementation MenuViewController
@synthesize profImg,profName;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
        [self.navigationController.view removeGestureRecognizer:self.navigationController.interactivePopGestureRecognizer];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"tutorial"]  isEqual: @"0"]){
        tutorial1.hidden = NO;
       
        next1.hidden = NO;
     
    }else{
        tutorial1.hidden = YES;
       
        next1.hidden = YES;
      
    }
    
    defaults = [NSUserDefaults standardUserDefaults];
    
    playerID = [defaults objectForKey:@"GLOBAL_USER_ID"];
    

    [[AccountsClient sharedInstance] getSingleAccountInfoWithID:playerID completion:^(NSError *error, FDataSnapshot *accountInfo)  {
        
        //NSLog(@"accountInfo = %@", accountInfo);
        //NSLog(@"accountInfo = %@", accountInfo.value[@"profilePic_url"]);
        if(accountInfo != (id) [NSNull null]){

        self.profName.text = accountInfo.value[@"name"];
        if( [[defaults objectForKey:@"GLOBAL_IS_FB"] boolValue] ){
            //[cell.avatar setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:person[@"picture"]]]]];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:accountInfo.value[@"profilePic_url"]]];
                
                //set your image on main thread.
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSLog(@"profile pic url %@",accountInfo.value[@"profilePic_url"]);
                    [self.profImg setImage:[UIImage imageWithData:data]];
                    self.profImg.layer.cornerRadius = 36;
                    self.profImg.clipsToBounds = YES;
                });
            });
        }
        }
        
    }];
    
        
    //self.profImg.image=[UIImage imageNamed:@"molly.png"];
   
    self.navigationController.navigationBar.hidden=YES;

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        //self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return NO;
}

-(IBAction)goSets:(id)sender{
    
    
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"nowplaying"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    SetsViewController *detailsVC = [SetsViewController new];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailsVC];
    [self.slideMenuController closeMenuBehindContentViewController:navController animated:YES completion:nil];
}

-(IBAction)goSettings:(id)sender{
    
    
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"nowplaying"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    SettingsVC *detailsVC = [SettingsVC new];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailsVC];
    [self.slideMenuController closeMenuBehindContentViewController:navController animated:YES completion:nil];
}

-(IBAction)goCrates:(id)sender{
    
    
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"nowplaying"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    TableViewController *detailsVC = [TableViewController new];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailsVC];
    [self.slideMenuController closeMenuBehindContentViewController:navController animated:YES completion:nil];
}

-(IBAction)goRecentlyPlayed:(id)sender{
    
    
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"nowplaying"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    RecentlyPlayedViewController *detailsVC = [RecentlyPlayedViewController new];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailsVC];
    [self.slideMenuController closeMenuBehindContentViewController:navController animated:YES completion:nil];
}

-(IBAction)goNowPlaying:(id)sender{
    
    [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"nowplaying"];
    //[[NSUserDefaults standardUserDefaults] synchronize];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PlayerNewVC *signVC = (PlayerNewVC *)[storyboard instantiateViewControllerWithIdentifier:@"PlayerVC"];
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
    [self.slideMenuController closeMenuBehindContentViewController:signVC animated:YES completion:nil];
    
   
}

-(IBAction)goLogout:(id)sender{
    
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"nowplaying"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewController *signVC = (ViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:signVC];
    [[AppDelegate sharedInstance].audioPlayer stop];
    [self.slideMenuController closeMenuBehindContentViewController:nav animated:YES completion:nil];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"LOGGEDIN"];
    
}

-(IBAction)goTutorialNext:(id)sender{
    
    tutorial1.hidden = YES;
 
    
    next1.hidden = YES;

    
}

-(IBAction)goTips:(id)sender{
    
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"tutorial"];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PlayerNewVC *signVC = (PlayerNewVC *)[storyboard instantiateViewControllerWithIdentifier:@"PlayerVC"];
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
    [self.slideMenuController closeMenuBehindContentViewController:signVC animated:YES completion:nil];

    //tutorial1.hidden = NO;
    
    
    //next1.hidden = NO;
    
    
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
