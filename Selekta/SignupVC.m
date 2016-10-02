//
//  SignupVC.m
//  Selekta
//
//  Created by Charisse Ann Dirain on 5/19/16.
//  Copyright © 2016 Matias Muhonen. All rights reserved.
//

#import "SignupVC.h"
#import "LoginClient.h"
#import "AccountsClient.h"
#import "MenuViewController.h"
#import "NVSlideMenuController.h"
#import "PlayerNewVC.h"

@interface SignupVC (){
    

}

@property (weak, nonatomic) IBOutlet UITextField *email,*password,*name,*confirmpass;
@end

@implementation SignupVC

- (void)viewDidLoad {
    [super viewDidLoad];
       self.navigationController.navigationBar.hidden = YES;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return true;
}

- (IBAction)loginWithFacebook:(id)sender {
    
    [[LoginClient sharedInstance] facebookLoginWithReadPermissions:@[@"email",@"public_profile",@"user_friends"] fromViewController:self success:^(id result) {

        NSMutableDictionary *resDict = [[NSMutableDictionary alloc] initWithDictionary:result];
        
        NSLog(@"RES = %@", resDict);
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        NSString *firstName = [[resDict[@"name"] componentsSeparatedByString:@" "] firstObject];
        
        [userDefaults setObject:firstName       forKey:@"GLOBAL_USER_NAME"];
        [userDefaults setObject:resDict[@"id"]  forKey:@"GLOBAL_USER_ID"];
        [userDefaults setBool:YES               forKey:@"GLOBAL_IS_FB"];
        [userDefaults setBool:YES forKey:@"LOGGEDIN"];
        [userDefaults synchronize];
        
        NSString *profPic = [[[resDict objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"];
        
        [[AccountsClient sharedInstance] isAccountExistWithID:resDict[@"id"] completion:^(NSError *error, bool isExist) {
            if (!isExist) {
                NSDictionary *userInfo = @{
                                           @"name" : resDict[@"name"],
                                           @"lastname" : resDict[@"name"],
                                           @"email" : @"",
                                           @"isFacebook" : @"TRUE",
                                           @"isActive" : @"1",
                                           @"username" : firstName,
                                           @"password" : @"",
                                           @"profilePic_url" : profPic,
                                           };
                
                NSLog(@"%@", userInfo);
                
                [[AccountsClient sharedInstance] saveAccountWithInfo:userInfo accountID:resDict[@"id"] completion:nil];
            }
        }];
        
        [self openMainScreen];
        
    } failure:^(NSError *error, NSDictionary *result) {
        
        NSLog(@"ERROR: %@", error);
    }];
    
}

- (IBAction) back:(id)sender{
    
    self.navigationController.navigationBar.hidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void) openMainScreen{
    
    
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"nowplaying"];
    [[NSUserDefaults standardUserDefaults] setObject:@"on" forKey:@"switch"];

    [[NSUserDefaults standardUserDefaults] synchronize];
    
    MenuViewController *menuVC = [[MenuViewController alloc] init];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PlayerNewVC *signVC = (PlayerNewVC *)[storyboard instantiateViewControllerWithIdentifier:@"PlayerVC"];
    
    UINavigationController *menuNavigationController = [[UINavigationController alloc] initWithRootViewController:menuVC];
    
    
    NVSlideMenuController *slideMenuVC = [[NVSlideMenuController alloc] initWithMenuViewController:menuNavigationController andContentViewController:signVC];
    [self.navigationController pushViewController:slideMenuVC animated:YES];
}

- (IBAction)loginWithEmail:(id)sender {
    
    if(_email.text.length == 0 || _name.text.length == 0 || _password.text.length == 0 || _confirmpass.text.length == 0 ){
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please input all required fields." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }else{
    
    [[LoginClient sharedInstance] loginWithEmail:_email.text success:^(id result) {
        
        [self.view endEditing:YES];
        
        
        NSMutableDictionary *resDict = [[NSMutableDictionary alloc] initWithDictionary:result];
        
        NSLog(@"RES = %@", resDict);
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        //NSString *firstName = [[resDict[@"name"] componentsSeparatedByString:@" "] firstObject];
        
        [userDefaults setObject:self->_email.text       forKey:@"GLOBAL_USER_NAME"];
        [userDefaults setObject:resDict[@"uid"]  forKey:@"GLOBAL_USER_ID"];
        [userDefaults setBool:NO               forKey:@"GLOBAL_IS_FB"];
        [userDefaults synchronize];
        
        NSLog(@"UID = %@", resDict[@"uid"]);
        
        [[AccountsClient sharedInstance] isAccountExistWithID:resDict[@"uid"] completion:^(NSError *error, bool isExist) {
            if (!isExist) {
                NSDictionary *userInfo = @{
                                           @"name" : self->_name.text,
                                           @"email" : self->_email.text,
                                           @"lastname" : @"",
                                           @"email" : @"",
                                           @"isFacebook" : @"TRUE",
                                           @"isActive" : @"1",
                                           @"username" : self->_email.text,
                                           @"password" : self->_password.text,
                                           @"profilePic_url" : @"",
                                           };
                
                NSLog(@"%@", userInfo);
                
                [[AccountsClient sharedInstance] saveAccountWithInfo:userInfo accountID:resDict[@"uid"] completion:nil];
                
                [[AccountsClient sharedInstance] saveEmailWithID:resDict[@"uid"] email:self->_email.text completion:nil];
            }
        }];
        
        [self openMainScreen];
        
    } failure:^(NSError *error, NSDictionary *result) {
        
        NSLog(@"ERROR: %@", error);
        
        NSString *errorStr = [NSString stringWithFormat:@"%@", error];
        
        if ([errorStr rangeOfString:@"INVALID_EMAIL"].location != NSNotFound) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Invalid Email" message:@"Please try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
        }
        
    }];
    }
}


@end
