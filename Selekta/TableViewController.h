//
//  TableViewController.h
//  cellTest
//
//  Created by SherwiN on 1/13/16.
//

#import <UIKit/UIKit.h>

@interface TableViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *thisTableView;
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UIButton *goBtn,*searchBtn;
@property (weak, nonatomic) IBOutlet UILabel *setLbl,*crateTitle;
@property(nonatomic, retain) IBOutlet UIImageView *profImg;

@end
