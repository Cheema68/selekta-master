//
//  PlayerNewVC.h
//  Selekta
//
//  Created by Charisse Ann Dirain on 8/14/16.
//  Copyright © 2016 Charisse Ann Dirain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STKAudioPlayer.h"

@interface PlayerNewVC : UIViewController{
    
    NSTimer* timer;
    UILabel* label;
    UILabel* statusLabel;
    IBOutlet UISlider* slider;
    IBOutlet UIButton* playButton;
    IBOutlet UIButton* stopButton;
    IBOutlet UIButton* prevButton;
    IBOutlet UIButton* nextButton;
    IBOutlet UIView* meter,*touch;
}
+ (instancetype)sharedInstance;

@property (weak, nonatomic) IBOutlet UITableView *thisTableView;
@property (nonatomic, retain) NSString *searchString;

@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UILabel *setLbl;
@property (nonatomic, retain) IBOutlet UISlider *slider;

@end

