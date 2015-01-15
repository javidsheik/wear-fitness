//
//  ViewController.h
//  Numafit
//
//  Created by apple on 30/10/14.
//  Copyright (c) 2014 sanhotrasoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
@interface DailyViewController : MenuViewController<UIAlertViewDelegate>
{
    int counter;
    int blestatus;
    int batstatus;
    int syncstatus;
    int laststep;
    
    //this filed are used to user set goals
    int user_step_goal;
    int user_cal_goal;
    int user_dist_goal;
}
@property(nonatomic,retain)IBOutlet UIButton *steps;
@property(nonatomic,retain)IBOutlet UIButton *calories;
@property(nonatomic,retain)IBOutlet UIButton *sleeping;
@property(nonatomic,retain)IBOutlet UIButton *distance;
@property(nonatomic,retain)NSMutableArray *sharedataarr;

@property(nonatomic,retain)NSTimer *timer;
@property(nonatomic,retain)UILabel *per;
@property(nonatomic,retain)UIView *batrycontainer;
@property(nonatomic,retain)UIView *fill;

@property(nonatomic,retain)IBOutlet UILabel *header;
@property(nonatomic,retain)IBOutlet UILabel *synctime;
@property(nonatomic,retain)IBOutlet UILabel *date;

@property(nonatomic,retain)UILabel *point;
@property(nonatomic,retain)UILabel *goal;
@property(nonatomic,retain)UILabel *donestep;


//sync button
@property(nonatomic,retain)UIBarButtonItem *sync;
@property(nonatomic,retain)UIBarButtonItem *stopsync;
@property(nonatomic,retain)CBPeripheral *peripheral;

@property(nonatomic,retain)UIAlertView *adddeviceale;
@property(nonatomic,retain)UIAlertView *waitale;
@end
