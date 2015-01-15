//
//  MonthlyViewController.h
//  Numafit
//
//  Created by apple on 03/11/14.
//  Copyright (c) 2014 sanhotrasoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EColumnChart.h"
#import "MenuViewController.h"
@interface MonthlyViewController :MenuViewController <EColumnChartDelegate, EColumnChartDataSource,UIGestureRecognizerDelegate>
{
    int year;
    int yearstatus;
}

@property (strong, nonatomic) EColumnChart *eColumnChart;
@property (retain, nonatomic) IBOutlet UISegmentedControl *seg;
@property (retain, nonatomic)UIView *segmentline;
@property (retain, nonatomic)IBOutlet UIView *pointview;
@property (retain, nonatomic)IBOutlet UIView *cupview;
@property (retain, nonatomic)IBOutlet UILabel *pointcount;

@property (retain, nonatomic)NSArray *monthlist;

@property (retain, nonatomic)UISwipeGestureRecognizer *leftswipe;
@property (retain, nonatomic)UISwipeGestureRecognizer *rightswipe;

@end

