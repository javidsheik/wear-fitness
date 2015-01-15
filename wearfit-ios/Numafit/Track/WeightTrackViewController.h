//
//  WeightTrackViewController.h
//  Numafit
//
//  Created by apple on 07/11/14.
//  Copyright (c) 2014 sanhotrasoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeightTrackViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
//all labels
@property(nonatomic,retain)IBOutlet UILabel *qtylabel;
@property(nonatomic,retain)IBOutlet UILabel *timelabel;
@property(nonatomic,retain)IBOutlet UILabel *unitlabel;
@property(nonatomic,retain)IBOutlet UILabel *todaylabel;

//buttons
@property(nonatomic,retain)UIButton *savebutton;
@property(nonatomic,retain)UIButton *cancelbutton;

//text fileds
@property(nonatomic,retain)IBOutlet UIButton *timetype;
@property(nonatomic,retain)IBOutlet UIButton *watterunit;
@property(nonatomic,retain)IBOutlet UITextField *qtytext;
@property(nonatomic,retain)IBOutlet UIButton *timetext;

//views
@property(nonatomic,retain)IBOutlet UIView *cotainer;
@property(nonatomic,retain)UITableView *pop;
@property(nonatomic,retain)NSArray *unitlist;

@property(nonatomic,retain)UIDatePicker *pic;

@end
