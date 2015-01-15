//
//  CircleDetailViewController.h
//  Numafit
//
//  Created by iHotra-LT-02 on 26/11/14.
//  Copyright (c) 2014 sanhotrasoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableview1;
@property (strong, nonatomic) IBOutlet UITableView *tableview2;
@property (strong, nonatomic) IBOutlet UIView *view2;

@property (strong, nonatomic) IBOutlet UILabel *label2;


@property(nonatomic,retain) NSString *circlename,*circledesc,*circleid;
@property (nonatomic,retain) NSMutableArray *firstname,*array1,*arrayCellChecked1,*frnds,*lastname,*frndid,*myfrndid,*userid,*addedfname,*addedlname,*addfrndid;
@property (nonatomic,retain) UIButton *save,*cancel;
@end
