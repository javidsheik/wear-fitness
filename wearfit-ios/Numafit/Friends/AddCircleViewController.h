//
//  AddCircleViewController.h
//  Numafit
//
//  Created by iHotra-LT-02 on 22/11/14.
//  Copyright (c) 2014 sanhotrasoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddCircleViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITextField *name;
@property (strong, nonatomic) IBOutlet UITextField *desc;
@property (strong, nonatomic) IBOutlet UITextField *tag;

@property (nonatomic,retain)  UIActivityIndicatorView *activity;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,retain) NSMutableArray *firstname,*array1,*arrayCellChecked1,*frnds,*lastname,*email;
@property (strong, nonatomic) IBOutlet UIView *view2;
@property (strong, nonatomic) IBOutlet UIView *view3;
@property (strong, nonatomic) IBOutlet UILabel *pickfrnd;
@property (nonatomic,retain) UIButton *save,*cancel;
@property (nonatomic,retain) NSString *circleid;
@property (nonatomic,retain)UIAlertView *waitale;

@end

