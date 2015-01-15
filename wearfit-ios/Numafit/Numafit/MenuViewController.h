//
//  MenuViewController.h
//  Numafit
//
//  Created by apple on 31/10/14.
//  Copyright (c) 2014 sanhotrasoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
   int status;
}


@property(nonatomic,retain)UIView *menu;
@property(nonatomic,retain)UITableView *menulist;
@property(nonatomic,retain)NSMutableArray *namelist;
@property(nonatomic,retain)NSMutableArray *imagelist;
@property (nonatomic,retain)  UIActivityIndicatorView *activity;

-(void)hidemenu;
@end
