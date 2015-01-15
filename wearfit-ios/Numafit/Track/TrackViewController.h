//
//  TrackViewController.h
//  Numafit
//
//  Created by iHotra-LT-02 on 03/11/14.
//  Copyright (c) 2014 sanhotrasoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"

@interface TrackViewController :MenuViewController<UIGestureRecognizerDelegate>
@property (nonatomic,retain)  UILabel *food;
@property (nonatomic,retain)  UILabel *water;
@property (nonatomic,retain) UILabel *weight;
@property (nonatomic,retain)  UILabel *activity1;
@property (nonatomic,retain) UILabel *events;
@property (nonatomic,retain) UIView *foodview;
@property (nonatomic,retain) UIView *waterview;
@property (nonatomic,retain) UIView *weightview;
@property (nonatomic,retain)  UIView *activityview;
@property (nonatomic,retain)  UIView *eventsview;
@property (nonatomic,retain) UIImageView *foodimage;
@property (nonatomic,retain) UIImageView *waterimage;
@property (nonatomic,retain) UIImageView *weightimage;
@property (nonatomic,retain) UIImageView *activityimage;
@property (nonatomic,retain) UIImageView *eventimage;

@property (nonatomic,retain) UIButton *foodimage1;
@property (nonatomic,retain) UIButton *waterimage1;
@property (nonatomic,retain) UIButton *weightimage1;
@property (nonatomic,retain) UIButton *activityimage1;
@property (nonatomic,retain) UIButton *eventimage1;

@end
