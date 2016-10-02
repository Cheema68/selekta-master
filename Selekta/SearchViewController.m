//
//  SearchViewController.m
//  cellTest
//
//  Created by SherwiN on 1/14/16.
//

#import "SearchViewController.h"
#import "NVSlideMenuController.h"
#import "SearchViewController.h"
#import "SetObj.h"
#import "Config.h"

#import "SetsCell.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import <MediaPlayer/MPMediaItem.h>
#import "UIImageView+WebCache.h"

#import "SetsRealm.h"
#import "PlayerNewVC.h"
#import "AppDelegate.h"
#import "SetObj.h"


@interface SearchViewController ()
@property (nonatomic, retain) NSMutableArray *sets;

@end

@implementation SearchViewController
@synthesize searchString;
@synthesize sets;
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
   
    [self.searchField resignFirstResponder];
    self.navigationController.navigationBar.hidden = YES;
    self.searchField.text=searchString;
    sets=[[NSMutableArray alloc] init];
    [self.searchField addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
    self.searchField.returnKeyType = UIReturnKeyGo;
    //[self fetchData:searchString];
   
    // Do any additional setup after loading the view from its nib.
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


- (IBAction)showMenu:(id)sender
{
    
    if(self.slideMenuController.isMenuOpen==YES){
        [self.slideMenuController closeMenuAnimated:YES completion:nil];
    }else{
        [self.slideMenuController openMenuAnimated:YES completion:nil];
    }
    
     [_searchField resignFirstResponder];
    
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
          
        }
        [self.thisTableView reloadData];
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
        PlayerNewVC *signVC = (PlayerNewVC *)[storyboard instantiateViewControllerWithIdentifier:@"PlayerVC"];
        [[AppDelegate sharedInstance].audioPlayer stop];
        //[AppDelegate sharedInstance].audioPlayer  = nil;
        [self.slideMenuController closeMenuBehindContentViewController:signVC animated:YES completion:nil];
    }else{
        
    }
}

/*-(void) fetchData : (NSString *) text{
    
    //this part is working
    sets=[[NSMutableArray alloc] init];
    PFQuery *querySet = [PFQuery queryWithClassName:@"Set"];
    NSLog(@"searchString %@",text);
    [querySet whereKey:@"set_artist" containsString:text];
    [querySet findObjectsInBackgroundWithBlock:^(NSArray *set, NSError *error) {
        // posts are posts where post.user.userType == X
        //NSLog(@"trackids %@",tracks);
        
        if (error) {
            // The find succeeded. The first 100 objects are available in objects
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            
        } else {
          
            for (PFObject *object in set) {
                // Create an object of type Person with the PFObject
                SetObj *setobj = [[SetObj alloc] init];
                NSString *sobjID = object.objectId;
                setobj.objectId = sobjID;
                
                setobj.set_artist=[object objectForKey:@"set_artist"];
                setobj.set_audio_link=[object objectForKey:@"set_audio_link"];
                setobj.set_id=[object objectForKey:@"set_id"];
                setobj.set_title=[object objectForKey:@"set_title"];
                setobj.created_at=[object objectForKey:@"created_at"];
                setobj.updated_at=[object objectForKey:@"updated_at"];
                PFFile *userImageFile = [object objectForKey:@"button_image"];//
                setobj.imgfile= userImageFile;
                
                [self.sets addObject:setobj];
                
                
            }
            
            self.setLbl.text=[NSString stringWithFormat:@"%lu RESULT(S) FOUND",(unsigned long)sets.count];
            
            [self.thisTableView reloadData];
        }
        
    }];
    
}

-(void)textFieldDidChange :(UITextField *)theTextField{
    NSLog( @"text changed: %@", theTextField.text);
    [sets removeAllObjects];
    [self fetchData: theTextField.text];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.slideMenuController.isMenuOpen==NO){
        MainViewController *detailsVC = [MainViewController new];
        
        SetObj *set=[self.sets objectAtIndex:indexPath.row];
        NSLog(@"set id %@",set.set_id);
        NSString *recentset=[[NSUserDefaults standardUserDefaults] objectForKey:@"recentset"];
        NSString *recentid=[[NSUserDefaults standardUserDefaults] objectForKey:@"recentid"];
        
        if([recentset isEqualToString:set.set_id]){
            //check the recent track
            detailsVC.setid=set.set_id;
            detailsVC.trackid=recentid;
            
        }else{
            detailsVC.setid=set.set_id;
            detailsVC.trackid=@"1";
        }
        NSLog(@"setid %@",detailsVC.setid);
        [[NSUserDefaults standardUserDefaults] setObject:detailsVC.setid forKey:@"recentset"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSUserDefaults standardUserDefaults] setObject:detailsVC.trackid forKey:@"recentid"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailsVC];
        [self.slideMenuController closeMenuBehindContentViewController:navController animated:YES completion:nil];
    }else{
        
    }
}*/

@end
