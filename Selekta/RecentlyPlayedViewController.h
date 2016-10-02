//
//  RecentlyPlayedViewController.h
//  Selekta
//
//  Created by Charisse Ann Jain on 3/10/16.
//  Copyright © 2016 Jerk Magz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecentlyPlayedViewController :UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *thisTableView;
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UIButton *goBtn,*searchBtn;
@property (weak, nonatomic) IBOutlet UILabel *setLbl;
@end
