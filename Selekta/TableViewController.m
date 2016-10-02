//
//  TableViewController.m
//  cellTest
//
//  Created by SherwiN on 1/13/16.
//

#import "TableViewController.h"
#import "SetsCell.h"
#import "NVSlideMenuController.h"
#import "SearchViewController.h"

#import "CrateObj.h"
#import "Config.h"
#import "CrateCell.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import <MediaPlayer/MPMediaItem.h>
#import "AccountsClient.h"
#import "UIImageView+WebCache.h"
#import "PlayerVC.h"
#import "AppDelegate.h"
#import "CrateRealm1.h"
#import <QuartzCore/QuartzCore.h>
#import "PlayerNewVC.h"

@interface TableViewController (){
    
    
    NSUserDefaults *defaults;
    NSString *playerID;
    
    IBOutlet UIImageView *tutorial1;
    IBOutlet UIButton *next1;
}
@property (nonatomic, retain) NSMutableArray *crates;
@property (nonatomic) BOOL isShown;
@end

@implementation TableViewController

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
    self.navigationController.navigationBar.hidden=YES;
    self.searchField.delegate=self;
    self.searchField.hidden=YES;
    self.goBtn.hidden=NO;
    
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
    
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"tutorial"]  isEqual: @"0"]){
        tutorial1.hidden = NO;
        
        next1.hidden = NO;
        
    }else{
        tutorial1.hidden = YES;
        
        next1.hidden = YES;
        
    }
    
    [[AccountsClient sharedInstance] getSingleAccountInfoWithID:playerID completion:^(NSError *error, FDataSnapshot *accountInfo)  {
        
        NSLog(@"accountInfo = %@", accountInfo);
        NSLog(@"accountInfo = %@", accountInfo.value[@"profilePic_url"]);
        
        self.crateTitle.text = [NSString stringWithFormat:@"%@'s CRATE", accountInfo.value[@"name"]];
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
    }];
    
    
    [self observers];
    //[self fetchData];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidUnload{
    [self removeObserverGetCrates];
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    self.navigationController.navigationBar.hidden=YES;
    [self observers];
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
    NSLog(@"crate %@",crates);
    return [crates count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 84;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"crateCell";
    
    CrateCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[CrateCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    
    CrateObj *obj=(CrateObj *)[crates objectAtIndex:indexPath.row];
    cell.artist.text= [NSString stringWithFormat:@"%@ - %@", obj.track_artist, obj.track_name];
    cell.title1.text=[NSString stringWithFormat:@"From: %@", obj.settitle];
    cell.backgroundView = [[UIView alloc] init];
    
    [cell.img sd_setImageWithURL:[NSURL URLWithString:obj.setbg]
                placeholderImage:[UIImage imageNamed:@"blackbtn.png"]];
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    NSInteger colorIndex = indexPath.row % 3;
    switch (colorIndex) {
        case 0:
            
            cell.backgroundView.backgroundColor = [UIColor colorWithRed:(226/255.0) green:(220/255.0) blue:(198/255.0) alpha:1];
            break;
        case 1:
            cell.backgroundView.backgroundColor = [UIColor colorWithRed:(206/255.0) green:(206/255.0) blue:(206/255.0) alpha:1];
            break;
        case 2:
            cell.backgroundView.backgroundColor = [UIColor colorWithRed:(163/255.0) green:(160/255.0) blue:(166/255.0) alpha:1];
            break;
    }
    
    
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

/*-(IBAction)onSearch:(id)sender{
    
    if(isShown==FALSE){
        self.searchField.hidden=NO;
        self.goBtn.hidden=YES;
        self.searchBtn.hidden=NO;
        [self.searchField becomeFirstResponder];
        isShown=TRUE;
    }else{
        self.searchField.hidden=YES;
        self.goBtn.hidden=YES;
        self.searchBtn.hidden=NO;
        [self.searchField resignFirstResponder];
        isShown=FALSE;
    }
    
}*/

-(IBAction)goSearch:(id)sender{
    
    SearchViewController *detailsVC = [SearchViewController new];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailsVC];
    [self.slideMenuController closeMenuBehindContentViewController:navController animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
      if(self.slideMenuController.isMenuOpen==NO){
 
    
    CrateObj *crate=[self.crates objectAtIndex:indexPath.row];
    NSLog(@"set id %@",crate.set_id);
    NSString *recentset=[[NSUserDefaults standardUserDefaults] objectForKey:@"recentset"];
    NSString *recentid=[[NSUserDefaults standardUserDefaults] objectForKey:@"recentid"];
    NSString *cid= [NSString stringWithFormat:@"%ld",([crate.trackID integerValue])];
    NSLog(@"cid %@",cid);
    if([recentset isEqualToString:crate.set_id]){
        //check the recent trac
        
        [[NSUserDefaults standardUserDefaults] setObject:crate.set_id forKey:@"selectedset"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"selected set %@",crate.set_id);
    
        
        [[NSUserDefaults standardUserDefaults] setObject:cid forKey:@"recentid"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }else{
        
        
        [[NSUserDefaults standardUserDefaults] setObject:crate.set_id forKey:@"selectedset"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSUserDefaults standardUserDefaults] setObject:cid forKey:@"recentid"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }

    
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"nowplaying"];
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"fromcrate"];
    [[NSUserDefaults standardUserDefaults] setObject:crate.trackID forKey:@"trackstart"];
    [[NSUserDefaults standardUserDefaults] setObject:crate.set_id forKey:@"trackset"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PlayerNewVC *signVC = (PlayerNewVC *)[storyboard instantiateViewControllerWithIdentifier:@"PlayerVC"];
    [[AppDelegate sharedInstance].audioPlayer stop];
          
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
    
    [[AccountsClient sharedInstance] getAllCrates:playerid completion:^(NSError *error, FDataSnapshot *sets1) {
        
        NSLog(@"All Crates = %@", sets1.value);
        
        if (sets1.value != (id)[NSNull null]) {
            
            [crates removeAllObjects];
            
 
            RLMRealm *realm = [RLMRealm defaultRealm];
          
            NSLog(@"The class is %@",[sets1.value class]);
            if([sets1.value isKindOfClass:[NSArray class]]){
                NSArray *setids = sets1.value;
                NSLog(@"setid %@",setids);
                for (int i=0; i < setids.count; i++) {
                    NSDictionary *setme1 = [setids objectAtIndex:i];
                    if(setme1 != (id)[NSNull null]){
                    
                    CrateObj *setobj = [[CrateObj alloc] init];
                    NSString *sobjID = [setme1 objectForKey:@"trackID"];
                    setobj.objectId = sobjID;
                    
                    setobj.set_id=[setme1 objectForKey:@"set_id"];
                    setobj.crate_id=sobjID;
                    setobj.trackID=[setme1 objectForKey:@"trackID"];
                    setobj.settitle=[setme1 objectForKey:@"set_title"];
                    setobj.created_at=[setme1 objectForKey:@"dateCreated"];
                    setobj.updated_at=[setme1 objectForKey:@"dateCreated"];
                    setobj.track_name=[setme1 objectForKey:@"track_name"];
                    setobj.track_artist=[setme1 objectForKey:@"track_artists"];
                    setobj.setbg=[setme1 objectForKey:@"setbg"];
                    
                    
                    
                    CrateRealm1 *tobjr = [[CrateRealm1 alloc] init];
                    tobjr.objectId = sobjID;
                    
                    tobjr.set_id=[setme1 objectForKey:@"set_id"];
                    tobjr.crate_id=sobjID;
                    tobjr.trackID=[setme1 objectForKey:@"trackID"];
                    tobjr.settitle=[setme1 objectForKey:@"set_title"];
                    tobjr.created_at=[setme1 objectForKey:@"dateCreated"];
                    tobjr.updated_at=[setme1 objectForKey:@"dateCreated"];
                    tobjr.track_name=[setme1 objectForKey:@"track_name"];
                    tobjr.track_artist=[setme1 objectForKey:@"track_artists"];
                    tobjr.setbg=[setme1 objectForKey:@"setbg"];
                    tobjr.userid = playerid;
                    tobjr.track_label = [setme1 objectForKey:@"track_label"];
                    tobjr.track_start = [setme1 objectForKey:@"track_start"];
                    tobjr.seturl = [setme1 objectForKey:@"seturl"];
                    tobjr.set_artist = [setme1 objectForKey:@"track_artists"];;
                    
                    // Updating book with id = 1
                    [realm beginWriteTransaction];
                    [realm addOrUpdateObject:tobjr];
                    [realm commitWriteTransaction];
                        
                    }
                    //
                    /*if(setme1 != (id)[NSNull null]){
                     
                     for(int i=0;i<setme1.count;i++){
                     if([setme1 objectAtIndex:i] != (id)[NSNull null]){
                     
                     
                     
                     //[self.crates addObject:tobjr];
                     }
                     }
                     //NSArray *set = setme1.allValues;
                     
                     }*/
                    
                    
                }
            }else{
                NSDictionary *setids = sets1.value;
                NSLog(@"setid %@",setids);
                if(setids.count != 0){
                    NSArray *setid = [setids allValues];
                    for (int i=0; i < setid.count; i++) {
                        NSDictionary *setme1 = [setid objectAtIndex:i];
                        
                        CrateObj *setobj = [[CrateObj alloc] init];
                        NSString *sobjID = [setme1 objectForKey:@"trackID"];
                        setobj.objectId = sobjID;
                        
                        setobj.set_id=[setme1 objectForKey:@"set_id"];
                        setobj.crate_id=sobjID;
                        setobj.trackID=[setme1 objectForKey:@"trackID"];
                        setobj.settitle=[setme1 objectForKey:@"set_title"];
                        setobj.created_at=[setme1 objectForKey:@"dateCreated"];
                        setobj.updated_at=[setme1 objectForKey:@"dateCreated"];
                        setobj.track_name=[setme1 objectForKey:@"track_name"];
                        setobj.track_artist=[setme1 objectForKey:@"track_artists"];
                        setobj.setbg=[setme1 objectForKey:@"setbg"];
                        
                        
                        
                        CrateRealm1 *tobjr = [[CrateRealm1 alloc] init];
                        tobjr.objectId = sobjID;
                        
                        tobjr.set_id=[setme1 objectForKey:@"set_id"];
                        tobjr.crate_id=sobjID;
                        tobjr.trackID=[setme1 objectForKey:@"trackID"];
                        tobjr.settitle=[setme1 objectForKey:@"set_title"];
                        tobjr.created_at=[setme1 objectForKey:@"dateCreated"];
                        tobjr.updated_at=[setme1 objectForKey:@"dateCreated"];
                        tobjr.track_name=[setme1 objectForKey:@"track_name"];
                        tobjr.track_artist=[setme1 objectForKey:@"track_artists"];
                        tobjr.setbg=[setme1 objectForKey:@"setbg"];
                        tobjr.userid = playerid;
                        tobjr.track_label = [setme1 objectForKey:@"track_label"];
                        tobjr.track_start = [setme1 objectForKey:@"track_start"];
                        tobjr.seturl = [setme1 objectForKey:@"seturl"];
                        tobjr.set_artist = [setme1 objectForKey:@"track_artists"];;
                        
                        // Updating book with id = 1
                        [realm beginWriteTransaction];
                        [realm addOrUpdateObject:tobjr];
                        [realm commitWriteTransaction];
                        //
                        /*if(setme1 != (id)[NSNull null]){
                         
                         for(int i=0;i<setme1.count;i++){
                         if([setme1 objectAtIndex:i] != (id)[NSNull null]){
                         
                         
                         
                         //[self.crates addObject:tobjr];
                         }
                         }
                         //NSArray *set = setme1.allValues;
                         
                         }*/
                        
                        
                    }
                }
            }
            
          

            //NSDictionary *setid1 = [sets1.value objectAtIndex:i];
            //NSArray *all = setid.allValues;
           

            NSPredicate *billingPredicate = [NSPredicate predicateWithFormat: @"userid = %@", playerid];
            RLMResults<CrateRealm1 *> *res = [[CrateRealm1 objectsWithPredicate: billingPredicate]
                                            sortedResultsUsingProperty:@"created_at" ascending:NO];
            NSLog(@"crates %@",res);
            [crates removeAllObjects];
            
            if(res.count>0){
                
                for (int i=0;i<res.count;i++){
                    CrateRealm1 *r = (CrateRealm1 *)[res objectAtIndex:i];
                    CrateObj *tobjr = [[CrateObj alloc] init];
                    tobjr.objectId = r.objectId;;
                    
                    tobjr.set_id=r.set_id;
                    tobjr.crate_id=r.objectId;
                    tobjr.trackID=r.trackID;
                    tobjr.settitle=r.settitle;
                    tobjr.created_at=r.created_at;
                    tobjr.updated_at=r.updated_at;
                    tobjr.track_name=r.track_name;
                    tobjr.track_artist=r.track_artist;
                    tobjr.setbg=r.setbg;
                    [crates addObject:tobjr];
                    
                }
                [self.thisTableView reloadData];
            }
             self.setLbl.text=[NSString stringWithFormat:@"%lu TRACKS IN YOUR CRATE",(unsigned long)[crates count]];
            
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
            
                       
        

            
        }
        
    }];
    
}

-(void) removeObserverGetCrates{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *playerid=[defaults objectForKey:@"GLOBAL_USER_ID"];
    Firebase *ref = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@/crates", FIREBASE_URL]];
    
    [ref removeAllObservers];
}

-(IBAction)goTutorialNext:(id)sender{
    
    tutorial1.hidden = YES;
    
    
    next1.hidden = YES;
    
    
}


@end
