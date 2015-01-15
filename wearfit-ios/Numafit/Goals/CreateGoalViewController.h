//
//  CreateGoalViewController.h
//  Numafit
//
//  Created by iHotra-LT-02 on 01/12/14.
//  Copyright (c) 2014 sanhotrasoft. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface CreateGoalViewController : UIViewController <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *view1;
@property (strong, nonatomic) IBOutlet UILabel *AP;
@property (strong, nonatomic) IBOutlet UILabel *Dailyper;
@property (strong, nonatomic) IBOutlet UITextField *Activity_Points;
@property (strong, nonatomic) IBOutlet UITextField *Daily_Percent;
@property (nonatomic,retain) UIButton *save,*cancel;
@property(nonatomic,retain) NSMutableArray *goaltype;
@property (nonatomic,retain) UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITextField *weighttext;
@property (strong, nonatomic) IBOutlet UILabel *weightlab;
@property (strong, nonatomic) IBOutlet UIButton *unit;
- (IBAction)unitclick:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *goalstep;
@property (strong, nonatomic) IBOutlet UILabel *goaldis;
@property (strong, nonatomic) IBOutlet UILabel *goalsteps;
@property (strong, nonatomic) IBOutlet UILabel *goaldist;
@property (strong, nonatomic) IBOutlet UILabel *meter;
@property (strong, nonatomic) IBOutlet UILabel *percent;

@end
