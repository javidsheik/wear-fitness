//
//  EColumnChartViewController.h
//  EChart
//
//  Created by Efergy China on 11/12/13.
//  Copyright (c) 2013 Scott Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EColumnChart.h"
#import "MenuViewController.h"
@interface EColumnChartViewController :MenuViewController <EColumnChartDelegate, EColumnChartDataSource,UIGestureRecognizerDelegate>
{
    int startweek;
    int originalweekstart;
    int endweek;
}
@property (strong, nonatomic) EColumnChart *eColumnChart;
@property (retain, nonatomic) IBOutlet UISegmentedControl *seg;
@property (retain, nonatomic) UIView *segmentline;
@property (retain, nonatomic) NSArray *daylist;
@property (retain, nonatomic) NSArray *weekdata;

@property (retain, nonatomic)UISwipeGestureRecognizer *leftswipe;
@property (retain, nonatomic)UISwipeGestureRecognizer *rightswipe;

@property (retain, nonatomic)UIView *line;
@end
