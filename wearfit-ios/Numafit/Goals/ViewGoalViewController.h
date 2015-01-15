//
//  ViewGoalViewController.h
//  Numafit
//
//  Created by iHotra-LT-02 on 06/12/14.
//  Copyright (c) 2014 sanhotrasoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"

@interface ViewGoalViewController : MenuViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic,retain) UIButton *save,*cancel;
@property(nonatomic,retain) NSMutableArray *goaltype;
@property (nonatomic,retain) UITableView *tableView;
@property(nonatomic,retain)UIDatePicker *pic;
@property (strong, nonatomic) IBOutlet UIView *view2;
@property (strong, nonatomic) IBOutlet UILabel *typelab;
@property (strong, nonatomic) IBOutlet UILabel *goaltype1;
@property (strong, nonatomic) IBOutlet UILabel *points;
@property (strong, nonatomic) IBOutlet UILabel *points1;
@property (strong, nonatomic) IBOutlet UILabel *caloriegoal;
@property (strong, nonatomic) IBOutlet UILabel *cal;
@property (strong, nonatomic) IBOutlet UILabel *dailyper;
@property (strong,nonatomic) IBOutlet UILabel *daily_per;

@end
