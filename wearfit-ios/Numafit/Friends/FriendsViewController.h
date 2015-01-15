//
//  FriendsViewController.h
//  Numafit
//
//  Created by apple on 24/11/14.
//  Copyright (c) 2014 sanhotrasoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"
@interface FriendsViewController :MenuViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UITextFieldDelegate>
{
    int reqstatus;
}
@property(nonatomic,retain)UITableView *linkedfriends;
@property(nonatomic,retain)UITableView *unlinkedfriends;
@property(nonatomic,retain)UITableView *requeststable;
@property(nonatomic,retain)NSMutableArray *linkfriendslist;
@property(nonatomic,retain)NSMutableArray *unlinkfriendslist;
@property(nonatomic,retain)UIAlertView *getmailale;
@property(nonatomic,retain)UITextField *email;
@property(nonatomic,retain)UIButton *friendreq;
@property(nonatomic,retain)UILabel *count;

@property(nonatomic,retain)NSMutableArray *friendsrequestarray;
@end
