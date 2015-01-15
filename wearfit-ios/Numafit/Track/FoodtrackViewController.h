//
//  FoodtrackViewController.h
//  Numafit
//
//  Created by iHotra-LT-02 on 04/11/14.
//  Copyright (c) 2014 sanhotrasoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoodtrackViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    
    UITableView *autocompleteTableView;
}

@property (strong, nonatomic) IBOutlet UIButton *select;
- (IBAction)selectqn:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *breakefast;
- (IBAction)Breakfastclick:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *lunch;
- (IBAction)Lunchclick:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *dinner;
@property (strong, nonatomic) IBOutlet UIButton *snacks;
- (IBAction)Snacksclick:(id)sender;
- (IBAction)Dinnerclick:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *name;
@property (strong, nonatomic) IBOutlet UITextField *quantity;
@property (strong, nonatomic) IBOutlet UITextField *calorie;
@property (strong, nonatomic) UIButton *save;
@property (strong, nonatomic) UIButton *cancel;
@property (strong, nonatomic) IBOutlet UIView *view1;
@property (strong, nonatomic) IBOutlet UILabel *today;
@property (strong, nonatomic) IBOutlet UIView *view2;
@property (nonatomic,retain)  UIActivityIndicatorView *activity;
@property (nonatomic,retain) NSMutableArray *arrayofnames;
@property(nonatomic,retain) NSString *value;
@property (nonatomic,retain) NSNumber *ozqn,*gmqn,*calories;
@property (nonatomic,retain)NSArray *foods;
@property(nonatomic,retain)UITableView* tableView;
@property(nonatomic,retain)NSMutableArray *arr;
@property (nonatomic,retain)UIAlertView *waitale;

@end
