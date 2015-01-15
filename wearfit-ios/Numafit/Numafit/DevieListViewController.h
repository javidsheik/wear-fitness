//
//  DevieListViewController.h
//  Numafit
//
//  Created by apple on 31/10/14.
//  Copyright (c) 2014 sanhotrasoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DevieListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>


@property(nonatomic,retain)UITableView *devicelist;
@property(nonatomic,retain)UIButton *login;
@property(nonatomic,retain)UIButton *option;
@property(nonatomic,retain)IBOutlet UIView *header;

@end
