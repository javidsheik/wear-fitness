//
//  EventdetailsViewController.h
//  Numafit
//
//  Created by apple on 25/11/14.
//  Copyright (c) 2014 sanhotrasoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface EventdetailsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>


@property(nonatomic,retain)NSDictionary *dict;
@property(nonatomic,retain)UITableView *eventdis;

@property(nonatomic,retain)NSArray *namelist;
@property(nonatomic,retain)NSArray *dislist;
@property(nonatomic,retain)NSArray *colorlist;
@property(nonatomic,retain)NSArray *iconlist;
@property(nonatomic,retain)NSString *eventid;
@property(nonatomic,retain)UISwitch *switchbutton;
@end
