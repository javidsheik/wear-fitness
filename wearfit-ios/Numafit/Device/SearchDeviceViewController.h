//
//  SearchDeviceViewController.h
//  Numafit
//
//  Created by apple on 11/11/14.
//  Copyright (c) 2014 sanhotrasoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchDeviceViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    int status;
    int dotstatus;
    int i;
    int gofoundscreen;
}

//searching screen member
@property(nonatomic,retain)UIImageView *searchicon;
@property(nonatomic,retain)NSTimer *timer;
@property(nonatomic,retain)NSTimer *dottimer;
@property(nonatomic,retain)UIView *searchview;
@property(nonatomic,retain)UILabel *d1;
@property(nonatomic,retain)UILabel *d2;
@property(nonatomic,retain)UILabel *d3;
@property(nonatomic,retain)UIAlertView *deviceale;
@property(nonatomic,retain)UITableView *devicetable;
@property(nonatomic,retain)NSArray *devices;




@property(nonatomic,retain)UILabel *count;
//device found screen member

@property(nonatomic,retain)UIView *devicefound;


//retry screen member

@property(nonatomic,retain)UIView *retry;
@property(nonatomic,retain)UIButton *retrybtn;
@property(nonatomic,retain)UIAlertView *buyale;
@end
