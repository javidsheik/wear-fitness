//
//  EventViewController.h
//  Numafit
//
//  Created by apple on 14/11/14.
//  Copyright (c) 2014 sanhotrasoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface EventViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

{
    int recordcount;
    int pageno;
    int serstatus;
}
@property(nonatomic,retain)UITableView *devicelist;
@property(nonatomic,retain)UIButton *login;
@property(nonatomic,retain)UIButton *option;
@property(nonatomic,retain)UIView *eventtitle;
@property(nonatomic,retain)NSMutableArray *events;

@property(nonatomic,retain)UITableView *eventcontent;
@property(nonatomic,retain)UITextField *search;
@property(nonatomic,retain)NSMutableArray *searcharr;

@end
