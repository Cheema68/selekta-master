//
//  RecentlyPlayedViewController.m
//  Selekta
//
//  Created by Charisse Ann Jain on 3/10/16.
//  Copyright © 2016 Jerk Magz. All rights reserved.
//

#import "RecentlyPlayedViewController.h"
#import "SetsCell.h"
#import "NVSlideMenuController.h"
#import "SearchViewController.h"

#import "RecentlyPlayedObj.h"
#import "Config.h"
#import "SetObj.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import <MediaPlayer/MPMediaItem.h>
#import "AccountsClient.h"
#import "UIImageView+WebCache.h"
#import "PlayerVC.h"
#import "AppDelegate.h"
#import "RecentlyPlayedRealm.h"
#import "PlayerNewVC.h"

@interface RecentlyPlayedViewController (){
    NSUserDefaults *defaults;
    NSString *playerID;
}
@property (nonatomic, retain) NSMutableArray *crates;
@property (nonatomic) BOOL isShown;
@end

@implementation RecentlyPlayedViewController

@synthesize crates,isShown;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error: nil];
    [[AVAudioSession sharedInstance] setActive: YES error:nil];
    
    // Prevent the application from going to sleep while it is running
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    // Starts receiving remote control events and is the first responder
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    self.navigationController.navigationBar.hidden=YES;
    self.searchField.delegate=self;
    self.searchField.hidden=YES;
    self.goBtn.hidden=YES;
    
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error: nil];
    [[AVAudioSession sharedInstance] setActive: YES error:nil];
    
    // Prevent the application from going to sleep while it is running
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    // Starts receiving remote control events and is the first responder
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    
    crates=[[NSMutableArray alloc] init];
    
    defaults = [NSUserDefaults standardUserDefaults];
    
    playerID = [defaults objectForKey:@"GLOBAL_USER_ID"];
    
        [self observers];
    //[self fetchData];
    // Do any additional setup after loading the view from its nib.
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    self.navigationController.navigationBar.hidden=YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma table delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(crates.count > 5){
        return 5;
    }else{
        return [crates count];
    }
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
    
    
    RecentlyPlayedObj *obj=(RecentlyPlayedObj *)[crates objectAtIndex:indexPath.row];
    
    cell.artist.text= obj.set_artist;
    NSLog(@"set title %@",obj.set_artist);
    cell.title1.text=obj.settitle;
   // cell.artist.text= [NSString stringWithFormat:@"%@ - %@", obj.track_artist, obj.track_name];
   // cell.title1.text=[NSString stringWithFormat:@"From: %@", obj.settitle];
    cell.backgroundView = [[UIView alloc] init];
    
    [cell.img sd_setImageWithURL:[NSURL URLWithString:obj.setbg]
                placeholderImage:[UIImage imageNamed:@"blackbtn.png"]];
    
    
    
    
    
    return cell;
    
}

#pragma mark - Show menu

- (IBAction)showMenu:(id)sender
{
    [self.searchField resignFirstResponder];
    
    if(self.slideMenuController.isMenuOpen==YES){
        [self.slideMenuController closeMenuAnimated:YES completion:nil];
    }else{
        [self.slideMenuController openMenuAnimated:YES completion:nil];
    }
    
     [_searchField resignFirstResponder];
    
}

-(IBAction)goSearch:(id)sender{
    
    SearchViewController *detailsVC = [SearchViewController new];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailsVC];
    [self.slideMenuController closeMenuBehindContentViewController:navController animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.slideMenuController.isMenuOpen==NO){
        
        
        RecentlyPlayedObj *crate=[self.crates objectAtIndex:indexPath.row];
        NSLog(@"set id %@",crate.set_id);
        NSString *recentset=[[NSUserDefaults standardUserDefaults] objectForKey:@"recentset"];
        NSString *recentid=[[NSUserDefaults standardUserDefaults] objectForKey:@"recentid"];
        NSString *cid= [NSString stringWithFormat:@"%ld",([crate.trackID integerValue])];
        if([recentset isEqualToString:crate.set_id]){
            //check the recent trac
            
            [[NSUserDefaults standardUserDefaults] setObject:crate.set_id forKey:@"recentset"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSLog(@"selected set %@",crate.set_id);
            
            
            [[NSUserDefaults standardUserDefaults] setObject:cid forKey:@"recentid"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }else{
            
            
            [[NSUserDefaults standardUserDefaults] setObject:crate.set_id forKey:@"recentset"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSUserDefaults standardUserDefaults] setObject:cid forKey:@"recentid"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"recentid"];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"nowplaying"];
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"fromcrate"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PlayerNewVC *signVC = (PlayerNewVC *)[storyboard instantiateViewControllerWithIdentifier:@"PlayerVC"];
        [[AppDelegate sharedInstance].audioPlayer stop];
        //[AppDelegate sharedInstance].audioPlayer  = nil;
        [self.slideMenuController closeMenuBehindContentViewController:signVC animated:YES completion:nil];
    }
}

-(IBAction)onGo:(id)sender{
    
    SearchViewController *detailsVC = [SearchViewController new];
    detailsVC.searchString=self.searchField.text;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailsVC];
    [self.slideMenuController closeMenuBehindContentViewController:navController animated:YES completion:nil];
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    [textField resignFirstResponder];
    
    self.searchField.hidden=YES;
    self.goBtn.hidden=YES;
    self.searchBtn.hidden=NO;
    
    SearchViewController *detailsVC = [SearchViewController new];
    detailsVC.searchString=self.searchField.text;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailsVC];
    [self.slideMenuController closeMenuBehindContentViewController:navController animated:YES completion:nil];
    
    return NO;
}

-(void)observers{
    
    
    NSString *playerid=[defaults objectForKey:@"GLOBAL_USER_ID"];
    
    [[AccountsClient sharedInstance] getAllRecents:playerid  completion:^(NSError *error, FDataSnapshot *sets1) {
        
        NSLog(@"All Crates = %@", sets1.value);
        
        if (sets1.value != (id)[NSNull null]) {
            
            [crates removeAllObjects];
            
            RLMRealm *realm = [RLMRealm defaultRealm];
            
            
            
            NSArray *setid = sets1.value;
            NSLog(@"setid %@",setid);
                            //NSDictionary *setid1 = [sets1.value objectAtIndex:i];
            //NSArray *all = setid.allValues;
            for (int i=0; i < setid.count; i++) {
                NSDictionary *setme1 = [setid objectAtIndex:i];
                if(setme1 != (id)[NSNull null]){
                    RecentlyPlayedObj *setobj = [[RecentlyPlayedObj alloc] init];
                    NSString *sobjID = [NSString stringWithFormat:@"%d",i];
                    setobj.objectId = sobjID;
                    
                    setobj.set_id=[setme1 objectForKey:@"set_id"];
                    setobj.crate_id=sobjID;
                    setobj.trackID=[setme1 objectForKey:@"trackID"];
                    setobj.settitle=[setme1 objectForKey:@"set_title"];
                    setobj.created_at=[setme1 objectForKey:@"dateCreated"];
                    setobj.updated_at=[setme1 objectForKey:@"dateCreated"];
                    setobj.track_name=[setme1 objectForKey:@"track_name"];
                    setobj.track_artist=[setme1 objectForKey:@"track_artists"];
                    setobj.set_artist=[setme1 objectForKey:@"set_artist"];
                    setobj.setbg=[setme1 objectForKey:@"setbg"];
                   
                    
                    
                    RecentlyPlayedRealm *tobjr = [[RecentlyPlayedRealm alloc] init];
                    tobjr.objectId = sobjID;
                    
                    tobjr.set_id=[setme1 objectForKey:@"set_id"];
                    tobjr.crate_id=sobjID;
                    tobjr.trackID=[setme1 objectForKey:@"trackID"];
                    tobjr.settitle=[setme1 objectForKey:@"set_title"];
                    tobjr.created_at=[setme1 objectForKey:@"dateCreated"];
                    tobjr.updated_at=[setme1 objectForKey:@"dateCreated"];
                    tobjr.track_name=[setme1 objectForKey:@"track_name"];
                    tobjr.track_artist=[setme1 objectForKey:@"track_artists"];
                    tobjr.set_artist=[setme1 objectForKey:@"set_artist"];
                    tobjr.setbg=[setme1 objectForKey:@"setbg"];
                    tobjr.userid = playerid;
                    
                    // Updating book with id = 1
                    [realm beginWriteTransaction];
                    [realm addOrUpdateObject:tobjr];
                    [realm commitWriteTransaction];
                    
                     //[self.crates addObject:tobjr];
                }
                
                
            }
            
            NSPredicate *billingPredicate = [NSPredicate predicateWithFormat: @"userid = %@", playerid];
            RLMResults<RecentlyPlayedRealm *> *res = [[RecentlyPlayedRealm objectsWithPredicate: billingPredicate]
                                                                            sortedResultsUsingProperty:@"created_at" ascending:NO];
            NSLog(@"crates %@",res);
            [crates removeAllObjects];
            
            if(res.count>0){
               
                for (int i=0;i<res.count;i++){
                    RecentlyPlayedRealm *r = (RecentlyPlayedRealm *)[res objectAtIndex:i];
                    RecentlyPlayedObj *tobjr = [[RecentlyPlayedObj alloc] init];
                    tobjr.objectId = r.objectId;
                    
                    tobjr.set_id=r.set_id;
                    tobjr.crate_id=r.objectId;
                    tobjr.trackID=r.trackID;
                    tobjr.settitle=r.settitle;
                    tobjr.created_at=r.created_at;
                    tobjr.updated_at=r.updated_at;
                    tobjr.track_name=r.track_name;
                    tobjr.track_artist=r.track_artist;
                    tobjr.set_artist=r.set_artist;
                    tobjr.setbg=r.setbg;
                    [crates addObject:tobjr];
                 
                }
                [self.thisTableView reloadData];
            }
            
            self.setLbl.text=[NSString stringWithFormat:@"%lu SETS RECENTLY PLAYED",(unsigned long)[crates count]];
            /*for (int i=0; i < setid.count; i++) {
             NSArray *setme = [setid objectAtIndex:i];
             // NSLog(@"setid %@",[setid objectAtIndex:1]);
             for(int j = 0; j< setme.count;j++){
             NSDictionary *setme1 = [setme objectAtIndex:j];
             if(setme1 != (id)[NSNull null]){
             NSLog(@"setid = %@", setme1.allValues);
             
             NSArray *setme2 = setme1.allValues;
             NSLog(@"setme1 = %@", setme2);
             CrateObj *setobj = [[CrateObj alloc] init];
             NSString *sobjID = [NSString stringWithFormat:@"%d",i];
             setobj.objectId = sobjID;
             
             setobj.set_id=[setme2[0] objectForKey:@"set_id"];
             setobj.crate_id=sobjID;
             setobj.trackID=[setme2[0] objectForKey:@"trackID"];
             setobj.settitle=[setme2[0] objectForKey:@"set_title"];
             setobj.created_at=[setme2[0] objectForKey:@"dateCreated"];
             setobj.updated_at=[setme2[0] objectForKey:@"dateCreated"];
             setobj.track_name=[setme2[0] objectForKey:@"track_name"];
             setobj.track_artist=[setme2[0] objectForKey:@"track_artists"];
             setobj.setbg=[setme2[0] objectForKey:@"setbg"];
             [self.crates addObject:setobj];
             
             }
             }
             
             
             }*/
            
            
            [self.thisTableView reloadData];
            
            
        }
        
    }];
    
}

-(void) removeObserverGetCrates{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *playerid=[defaults objectForKey:@"GLOBAL_USER_ID"];
    Firebase *ref = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@/recent", FIREBASE_URL]];
    
    [ref removeAllObservers];
}

@end
