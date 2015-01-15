//
//  ViewController.h
//  Numa
//
//  Created by iHotra-LT-02 on 13/10/14.
//  Copyright (c) 2014 iHotra-LT-02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface LoginViewController : UIViewController<UITextFieldDelegate,FBLoginViewDelegate>
- (IBAction)Login:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UIButton *login;

@property (strong, nonatomic) IBOutlet UIButton *fb;
@property (strong, nonatomic) IBOutlet UIButton *signup;
@property (strong, nonatomic) IBOutlet UILabel *noaccount;
- (IBAction)fbclick:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *forgotps;
- (IBAction)forgotpassword:(id)sender;
- (IBAction)signUp:(id)sender;
@property(nonatomic,retain) NSString *firstname,*lastname,*profileid,*emailid;
@property (retain, nonatomic) NSMutableData *receivedData,*receivedData1,*receivedData2,*receievedData3;
@property (retain, nonatomic) NSURLConnection *connection,*connection1,*connection2,*connection3;
@property (nonatomic,retain)  UIActivityIndicatorView *activity;

@end
