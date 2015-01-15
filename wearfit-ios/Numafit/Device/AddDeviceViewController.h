//
//  AddDeviceViewController.h
//  Numafit
//
//  Created by apple on 31/12/14.
//  Copyright (c) 2014 sanhotrasoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddDeviceViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    int gofoundscreen;
}
@property(nonatomic,retain)UITableView *devicetable;

@property(nonatomic,retain)NSArray *devices;
@property(nonatomic,retain)UILabel *info;
@property(nonatomic,retain)UILabel *count;
@property(nonatomic,retain)NSTimer *timer;
@property(nonatomic,retain)UIAlertView *buyale;

@end
