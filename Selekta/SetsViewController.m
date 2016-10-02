//
//  SetsViewController.m
//  cellTest
//
//  Created by SherwiN on 1/14/16.
//

#import "SetsViewController.h"
#import "SetsCell.h"
#import "NVSlideMenuController.h"
#import "SearchViewController.h"

#import "SetObj.h"
#import "Config.h"

#import "UIImageView+WebCache.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import <MediaPlayer/MPMediaItem.h>
#import "AccountsClient.h"
#import "MenuViewController.h"
#import "PlayerVC.h"
#import "AppDelegate.h"
#import "SetsRealm.h"
#import "PlayerNewVC.h"

@interface SetsViewController (){
       NSUserDefaults *defaults;
    IBOutlet UIImageView *tutorial1;
    IBOutlet UIButton *next1;

}
@property (nonatomic, retain) NSMutableArray *sets;
@property (nonatomic) BOOL isShown;
@end

@implementation SetsViewController

@synthesize sets,isShown;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    //[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
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
    
    sets=[[NSMutableArray alloc] init];
    //[self fetchData];
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"tutorial"]  isEqual: @"0"]){
        tutorial1.hidden = NO;
        
        next1.hidden = NO;
        
    }else{
        tutorial1.hidden = YES;
        
        next1.hidden = YES;
        
    }
    
     [self observers];
       // Do any additional setup after loading the view from its nib.
}

-(void)viewDidUnload{
    [self removeObserverGetSets];
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
    return [sets count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 84;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"setsCell";
    
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
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
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

#pragma mark - Show menu

- (IBAction)showMenu:(id)sender
{
    [self.searchField resignFirstResponder];
    
    if(self.slideMenuController.isMenuOpen==YES){
        [self.slideMenuController closeMenuAnimated:YES completion:nil];
    }else{
        self.slideMenuController.slideDirection = NVSlideMenuControllerSlideFromLeftToRight;
        [self.slideMenuController toggleMenuAnimated:nil];
    }
    
     [_searchField resignFirstResponder];
    
}

-(IBAction)onSearch:(id)sender{
    
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
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.slideMenuController.isMenuOpen==NO){
        //FSPlayerViewController *detailsVC = [FSPlayerViewController new];
    
        SetObj *set=[self.sets objectAtIndex:indexPath.row];
        NSLog(@"set id %@",set.set_id);
        [[NSUserDefaults standardUserDefaults] setObject:set.set_id forKey:@"recentset"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"recentid"];
        [[NSUserDefaults standardUserDefaults] synchronize];
       
        
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

-(void) fetchData{
    
    NSMutableArray *sets1=[[NSMutableArray alloc] initWithObjects:@"http://tramusic.net/selekta/bpm_mix.mp3",@"http://tramusic.net/selekta/bpm_mix.mp3",@"http://tramusic.net/selekta/just_be.mp3",@"http://tramusic.net/selekta/amtrac_night_bass_mix.mp3",@"http://tramusic.net/selekta/test_mix.mp3", nil];
    
    NSMutableArray *title=[[NSMutableArray alloc] initWithObjects:@"Crew Love Miami",@"Ibiza Villa Mix",@"Time Warp Live Set",@"Summer Exclusive Mix",@"Busy P's Paris Is Burning Mix", nil];
    
     NSMutableArray *artist=[[NSMutableArray alloc] initWithObjects:@"Wolf + Lamb",@"Pete Tong",@"Waff",@"Luciano",@"Skrillex", nil];
    
    NSMutableArray *pic=[[NSMutableArray alloc] initWithObjects:@"http://www.selektamusic.com/app/set_button/Wolflamb.png",@"http://www.selektamusic.com/app/set_button/petetong.png",@"http://www.selektamusic.com/app/set_button/waff.png",@"http://www.selektamusic.com/app/set_button/luciano.png",@"http://www.selektamusic.com/app/set_button/skrillex.png", nil];
    
    for(int i=0;i<[sets1 count];i++){
        SetObj *setobj = [[SetObj alloc] init];
        NSString *sobjID = [NSString stringWithFormat:@"%d",i];
        setobj.objectId = sobjID;
    
        setobj.set_artist=artist[i];
        setobj.set_audio_link=sets1[i];
        setobj.set_id=sobjID;
        setobj.set_title=title[i];
        setobj.created_at=@"CREATED AT";
        setobj.updated_at=@"UPDATED AT";
        setobj.set_picture=pic[i];
        //PFFile *userImageFile = [object objectForKey:@"button_image"];//
        //setobj.imgfile= userImageFile;
    
        [self.sets addObject:setobj];
    }
    
    self.setLbl.text=[NSString stringWithFormat:@"%lu SELEKTA SETS",(unsigned long)sets.count];
    
    [self.thisTableView reloadData];
}

-(void)observers{
    
    [[AccountsClient sharedInstance] getAllSets:@"ALL" completion:^(NSError *error, FDataSnapshot *sets1) {
        
        NSLog(@"All Sets = %@", sets1.value);
        
        NSString *playerid=[defaults objectForKey:@"GLOBAL_USER_ID"];
        
        if (sets1.value != (id)[NSNull null]) {
            
            [self.sets removeAllObjects];
   
         
            
             RLMRealm *realm = [RLMRealm defaultRealm];

            for (int i=0; i < [sets1.value count]; i++) {
                
                NSDictionary *setid = [sets1.value objectAtIndex:i];
                if(setid != (id)[NSNull null]){
                    NSLog(@"setid = %@", setid[@"set_artist"]);
                     SetObj *setobj = [[SetObj alloc] init];
                     NSString *sobjID = [NSString stringWithFormat:@"%d",i];
                     setobj.objectId = sobjID;
                     
                     setobj.set_artist=setid[@"set_artist"];
                     setobj.set_audio_link=setid[@"set_audio_link"];
                     setobj.set_id=setid[@"setid"];
                     setobj.set_title=setid[@"set_title"];
                     setobj.created_at=setid[@"dateCreated"];
                     setobj.updated_at=setid[@"dateCreated"];
                     setobj.set_picture=setid[@"set_picture"];
                     setobj.set_background_pic=setid[@"set_background_pic"];
                     setobj.set_btn_image=setid[@"set_btn_image"];
                     //[self.sets addObject:setobj];
                    
                   
                    SetsRealm *tobjr = [[SetsRealm alloc] init];
                    tobjr.objectId = sobjID;
                    
                    tobjr.set_artist=setid[@"set_artist"];
                    tobjr.set_audio_link=setid[@"set_audio_link"];
                    tobjr.set_id=setid[@"setid"];
                    tobjr.set_title=setid[@"set_title"];
                    tobjr.created_at=setid[@"dateCreated"];
                    tobjr.updated_at=setid[@"dateCreated"];
                    tobjr.set_picture=setid[@"set_picture"];
                    tobjr.set_background_pic=setid[@"set_background_pic"];
                    tobjr.set_btn_image=setid[@"set_btn_image"];
                    tobjr.userid = playerid;
                    
                    // Updating book with id = 1
                    [realm beginWriteTransaction];
                    [realm addOrUpdateObject:tobjr];
                    [realm commitWriteTransaction];

                     
            
                }

               
            }
            
            NSPredicate *billingPredicate = [NSPredicate predicateWithFormat: @"userid = %@", playerid];
            RLMResults<SetsRealm *> *res = [[SetsRealm objectsWithPredicate: billingPredicate]
                                                      sortedResultsUsingProperty:@"created_at" ascending:NO];
            NSLog(@"crates %@",res);
            [sets removeAllObjects];
            
            if(res.count>0){
                
                for (int i=0;i<res.count;i++){
                    SetsRealm *r = (SetsRealm *)[res objectAtIndex:i];
                    SetObj *tobjr = [[SetObj alloc] init];
                    tobjr.objectId = r.objectId;
                    
                    tobjr.set_artist=r.set_artist;
                    tobjr.set_audio_link=r.set_audio_link;
                    tobjr.set_id=r.set_id;
                    tobjr.set_title=r.set_title;
                    tobjr.created_at=r.created_at;
                    tobjr.updated_at=r.updated_at;
                    tobjr.set_picture=r.set_picture;
                    tobjr.set_background_pic=r.set_background_pic;
                    tobjr.set_btn_image=r.set_btn_image;
                    [sets addObject:tobjr];
                    
                }
                
                [self.thisTableView reloadData];
            }
            
               self.setLbl.text=[NSString stringWithFormat:@"%lu SELEKTA SETS",(unsigned long)[sets count]];
            
        }
        
    }];
    
}

-(void) removeObserverGetSets{
    
    Firebase *ref = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@/sets", FIREBASE_URL]];
    
    [ref removeAllObservers];
}

-(IBAction)goTutorialNext:(id)sender{
    
    tutorial1.hidden = YES;
    
    
    next1.hidden = YES;
    
    
}

@end
