//
//  SearchViewController.h
//  cellTest
//
//  Created by SherwiN on 1/14/16.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *thisTableView;
@property (nonatomic, retain) NSString *searchString;

@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UILabel *setLbl;
@end
