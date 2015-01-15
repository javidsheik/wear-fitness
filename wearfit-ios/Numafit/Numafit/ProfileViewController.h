//
//  ProfileViewController.h
//  Numafit
//
//  Created by iHotra-LT-02 on 19/11/14.
//  Copyright (c) 2014 sanhotrasoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import"MenuViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface ProfileViewController : MenuViewController<UITextFieldDelegate,UITextViewDelegate,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIAlertViewDelegate>
{
    int devicestatus;
    int findmydevicestatus;
}
@property (strong, nonatomic) IBOutlet UIView *view1;
@property (strong, nonatomic) IBOutlet UILabel *firstname;
@property (strong, nonatomic) IBOutlet UILabel *country;
@property (strong, nonatomic) IBOutlet UILabel *city;
@property (strong, nonatomic) IBOutlet UIImageView *profilepic;
@property (strong, nonatomic) IBOutlet UILabel *doblab;
@property (strong, nonatomic) IBOutlet UILabel *genderlab;
@property (strong, nonatomic) IBOutlet UILabel *heightlab;
@property (strong, nonatomic) IBOutlet UILabel *weightlab;
@property (strong, nonatomic) IBOutlet UIButton *personald;
@property (strong, nonatomic) IBOutlet UIButton *contactd;
@property (strong, nonatomic) IBOutlet UITextField *dobtext;
@property (strong, nonatomic) IBOutlet UIButton *camera;

@property (strong, nonatomic) IBOutlet UIButton *bandd;

@property (strong, nonatomic) IBOutlet UITextField *heighttext;
@property (strong, nonatomic) IBOutlet UIButton *feetb;

- (IBAction)feetclick:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *weighttext;
@property (strong, nonatomic) IBOutlet UIButton *kgb;
- (IBAction)kgclick:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *genderimg;
@property (strong, nonatomic) IBOutlet UIImageView *feetimg;
@property (strong, nonatomic) IBOutlet UIImageView *kgimg;

@property(nonatomic,retain)UIDatePicker *pic;
- (IBAction)personal:(id)sender;
- (IBAction)contact:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *genderb;
- (IBAction)genderclick:(id)sender;
@property(nonatomic,retain)UIButton *save,*cancel,*disconnect;
- (IBAction)band:(id)sender;
@property(nonatomic,retain) UILabel *add,*zipcode,*phno;
@property(nonatomic,retain)UITextView *addview;
@property (nonatomic,retain) UITextField *phtext,*ziptext;
@property(nonatomic,retain)UITableView* tableView1;
@property(nonatomic,retain)NSMutableArray *arr;
@property (nonatomic,retain) UILabel *deviceid,*devicemodel,*devicemaf,*dlab,*molab,*maflab;
@property(nonatomic,retain)NSString *imagepath;
- (IBAction)didtap:(id)sender;
@property(nonatomic,retain)ALAssetsLibrary *library;
@property (nonatomic,retain)  UIActivityIndicatorView *activity;
@property (nonatomic,retain) UIButton *hour,*min,*days,*checkmark,*finddevice;
@property (nonatomic,retain) UISegmentedControl *onoffsegement;




@property (nonatomic,retain)UIAlertView  *buyale;
@end
