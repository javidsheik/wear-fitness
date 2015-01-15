//
//  AddEventViewController.h
//  Numafit
//
//  Created by apple on 17/11/14.
//  Copyright (c) 2014 sanhotrasoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <GoogleMaps/GoogleMaps.h>
@interface AddEventViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIScrollViewDelegate,UIAlertViewDelegate>
{
    int srcstatus;
    int deststatus;
    int picstatus;
    CGRect rect;
    
    //location variable
    CLLocationCoordinate2D start;
    CLLocationCoordinate2D end;
}
@property(nonatomic,retain)NSMutableArray *locationlist;



@property(nonatomic,retain)UITextField *sourceloc;
@property(nonatomic,retain)UITextField *destinationloc;
@property(nonatomic,retain)UITableView *result;
@property(nonatomic,retain)UIBarButtonItem *done;


//input view member
@property(nonatomic,retain)UIView *contailner;
@property(nonatomic,retain)UITextField *name;
@property(nonatomic,retain)UITextField *discription;

@property(nonatomic,retain)UIButton *date;
@property(nonatomic,retain)UIButton *starttime;
@property(nonatomic,retain)UIButton *endtime;
@property(nonatomic,retain)UIButton *savebtn;
@property(nonatomic,retain)UIButton *cancel;
@property(nonatomic,retain)UIScrollView *scroll;
@property(nonatomic,retain)UIDatePicker *pic;

//share event cod emember
@property(nonatomic,retain)UIAlertView *shareale;
@property(nonatomic,retain)NSString *eventid;


@end
