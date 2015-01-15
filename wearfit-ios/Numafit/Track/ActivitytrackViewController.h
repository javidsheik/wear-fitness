//
//  ActivitytrackViewController.h
//  Numafit
//
//  Created by iHotra-LT-02 on 06/11/14.
//  Copyright (c) 2014 sanhotrasoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivitytrackViewController : UIViewController <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    
    UITableView *autocompleteTableView;
}
@property (strong, nonatomic) IBOutlet UITextField *nametext;
@property (strong, nonatomic) IBOutlet UIButton *hourtext;
@property (strong, nonatomic) IBOutlet UIButton *mintext;
@property (strong, nonatomic) IBOutlet UIButton *amtext;
@property (strong, nonatomic) IBOutlet UIButton*hourtext1;
@property (strong, nonatomic) IBOutlet UIButton *mintext1;
@property (strong, nonatomic) IBOutlet UIButton *amtext1;
@property (strong, nonatomic) IBOutlet UITextField *calorietext;
@property (strong, nonatomic) IBOutlet UILabel *namelab;
@property (strong, nonatomic) IBOutlet UILabel *todaylab;
@property (strong, nonatomic) IBOutlet UILabel *starttimelab;
@property (strong, nonatomic) IBOutlet UILabel *endtimelab;
@property (strong, nonatomic) IBOutlet UILabel *calorielab;
@property (strong, nonatomic) IBOutlet UIView *view1;
- (IBAction)starthour:(id)sender;
- (IBAction)startmin:(id)sender;
- (IBAction)startam:(id)sender;
- (IBAction)endam:(id)sender;
- (IBAction)endhour:(id)sender;
- (IBAction)endmin:(id)sender;
@property(nonatomic,retain)UITableView* tableView;
@property(nonatomic,retain)NSMutableArray *arr;
@property (strong, nonatomic) UIButton *save;
@property (strong, nonatomic) UIButton *cancel;
@property (nonatomic,retain)  UIActivityIndicatorView *activity;
@property (nonatomic,retain) NSMutableArray *activities,*autocomplete;

@end
