//
//  CircleListViewController.h
//  Numafit
//
//  Created by iHotra-LT-02 on 21/11/14.
//  Copyright (c) 2014 sanhotrasoft. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "MenuViewController.h"
@interface CircleListViewController : MenuViewController<UITableViewDelegate,UITableViewDataSource>
{
    
    UILabel *circlelabel;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,retain) NSArray *array;
@property (nonatomic,retain) NSMutableArray *circlename,*circledesc,*circletag, *circles,*friendcount;
@property (nonatomic,retain)  UIActivityIndicatorView *activity;
@property (nonatomic,assign) int currentPage;
@property (nonatomic,assign) int circlecount;


@end
