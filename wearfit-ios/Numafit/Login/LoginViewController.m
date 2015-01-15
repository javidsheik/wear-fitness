//
//  ViewController.m
//  Numa
//
//  Created by iHotra-LT-02 on 13/10/14.
//  Copyright (c) 2014 iHotra-LT-02. All rights reserved.
//

#import "LoginViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "DailyViewController.h"
#import "AFNetworking.h"
#import "UICKeyChainStore.h"
#import "URL.h"



@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.email.delegate=self;
    self.password.delegate=self;
    self.login.backgroundColor = [self colorFromHexString:@"#66cccc"];
    self.fb.backgroundColor = [self colorFromHexString:@"#333399"];
    
    UIColor *color = [UIColor grayColor];
    self.email.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"Enter email id"
                                    attributes:@{
                                                 NSForegroundColorAttributeName: color,
                                                 NSFontAttributeName : [UIFont fontWithName:@"oswald-regular" size:14.0]
                                                 }
     ];
    
    self.password.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"Password"
                                    attributes:@{
                                                 NSForegroundColorAttributeName: color,
                                                 NSFontAttributeName : [UIFont fontWithName:@"oswald-regular" size:14.0]
                                                 }
     ];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[self colorFromHexString:@"#8E388E"] CGColor], (id)[[self colorFromHexString:@"#EE799F"] CGColor],nil];
    [self.view.layer insertSublayer:gradient atIndex:0];
    
    [[self.fb titleLabel] setFont:[UIFont fontWithName:@"oswald-regular" size:18.0f]];
    [[self.login titleLabel] setFont:[UIFont fontWithName:@"oswald-regular" size:18.0f]];
    [[self.signup titleLabel] setFont:[UIFont fontWithName:@"oswald-bold" size:18.0f]];
    self.noaccount.font = [UIFont fontWithName:@"oswald-regular" size:15.0f];
    [[self.forgotps titleLabel] setFont:[UIFont fontWithName:@"oswald-regular" size:14.0f]];
    self.noaccount.textColor = [self colorFromHexString:@"#fcb9d5"];
    CALayer *btnLayer = [self.fb layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
    CALayer *btnLayer1 = [self.login layer];
    [btnLayer1 setMasksToBounds:YES];
    [btnLayer1 setCornerRadius:5.0f];
    
    
    
    
    [self.email setFont:[UIFont fontWithName:@"oswald-regular" size:18.0f]];
    [self.password setFont:[UIFont fontWithName:@"oswald-regular" size:18.0f]];
    [self.email setTextColor: [UIColor grayColor]];
    [self.password setTextColor: [UIColor grayColor]];
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0,40, 20)];
    self.email.leftView = paddingView1;
    self.email.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0,40, 20)];
    self.password.leftView = paddingView2;
    self.password.leftViewMode = UITextFieldViewModeAlways;
    NSString*title = self.fb.titleLabel.text;
    NSLog(@"title %@",title);
    NSUserDefaults *def =[NSUserDefaults standardUserDefaults];
    [def setObject:@"newuser" forKey:@"user"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
    self.activity.color = [UIColor brownColor];
    [self.view addSubview:self.activity];
    self.activity.center = self.view.center;
    [self.activity setHidden:NO];
    [self.activity startAnimating];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
    
    
}

-(UIColor *)colorFromHexString:(NSString *)hexString
{
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
    
}


-(void)viewDidAppear:(BOOL)animated
{
    
    
    
    NSURL *url = [NSURL URLWithString:Netcheckurl];
    NSData *data = [NSData dataWithContentsOfURL:url];
    if (data)
    {
        [self.activity stopAnimating];
        [self.activity removeFromSuperview];
        self.activity =nil;
    }
    else
    {
        [self.activity stopAnimating];
        [self.activity removeFromSuperview];
        self.activity =nil;
        [self popup:OfflineMsg Title:OfflineTitle image:@"offline.png"];
    }
}

-(void)popup :(NSString *)msg Title:(NSString *)Title image:(NSString *)url
{
    //custom popup setting
    UIView *popview=[[UIView alloc] initWithFrame:CGRectMake(0,0,200,90)];
    popview.backgroundColor=[self colorFromHexString:@"#ececec"];
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:url]];
    image.frame=CGRectMake(30,34,40,40);
    [popview addSubview:image];
    
    UILabel *lbl2=[[UILabel alloc] initWithFrame:CGRectMake(48,3,165,30)];
    lbl2.font=[UIFont fontWithName:@"oswald-regular" size:20.0f];
    lbl2.text=Title;
    lbl2.textColor=[self colorFromHexString:@"#f3a64c"];
    lbl2.textAlignment=NSTextAlignmentCenter;
    [popview insertSubview:lbl2 atIndex:4];
    
    UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(80,22,150,60)];
    lbl.font=[UIFont fontWithName:@"oswald-regular" size:12.0f];
    lbl.lineBreakMode=NSLineBreakByWordWrapping;
    lbl.numberOfLines=5;
    lbl.text=msg;
    lbl.textColor=[self colorFromHexString:@"#858585"];
    [popview insertSubview:lbl atIndex:5];
    
    UIAlertView *ale=[[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
    [ale setValue:popview forKey:@"accessoryView"];
    [ale show];
    //end custom popup
}

- (IBAction)Login:(id)sender {
    
    // login
    if([self.email.text isEqualToString:@""] || [self.password.text isEqualToString:@""])
        
    {
        
        [self popup:@"Please enter your email" Title:@"Enter Email" image:@"warning.png"];
    }
    else
    {
        [self showActivityIndicatorWithStyle:UIActivityIndicatorViewStyleWhiteLarge];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *params = @{@"email": self.email.text,
                                 @"password": self.password.text};
        [manager POST:Loginurl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            
            NSDictionary * name =[responseObject valueForKeyPath:@"data"];
            NSString *token = [[NSString alloc]init];
            token = [name objectForKey:@"token"];
            
            //            NSString *email = [name objectForKey:@"email"];
            int status = [[responseObject valueForKeyPath:@"status"] intValue];
            NSLog(@"value of status is %d",status);
            [UICKeyChainStore setString:token forKey:@"token"];
            
            NSString * string =[UICKeyChainStore stringForKey:@"token"];
            NSString *string1 = [UICKeyChainStore stringForKey:@"id"];
            NSLog(@"token is %@",string);
            NSLog(@"vaue id is %@",string1);
            
            NSUserDefaults *pref =[NSUserDefaults standardUserDefaults];
            [pref setObject:string forKey:@"Token"];
            [pref setObject:[name objectForKey:@"email"]forKey:@"email"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            
            if(status == 200)
            {
                [self getProfile];
            }
            
            else
            {
                
                [self popup:@"Enter Correct email and password" Title:@"Status" image:@"warning.png"];
            }
            NSLog(@"email %@",[name objectForKey:@"email"]);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"response %@",operation.responseObject);
            
            if([[[operation.responseObject objectForKey:@"status"]stringValue] isEqualToString:@"401"])
            {
                NSString *message =[operation.responseObject objectForKey:@"message"];
                
                [self popup:message  Title:@"Status" image:@"error.png"];
                
            }
            else
            {
                
                [self popup:message_503  Title:title_503 image:@"ServerError.png"];
                
            }
            
            [self hideActivityIndicator];
        }];
    }
    
}
- (IBAction)fbclick:(id)sender {
    
    [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"email"]
                                       allowLoginUI:YES
                                  completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                      
                                      [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
                                          if (error) {
                                              
                                              NSLog(@"error:%@",error);
                                              
                                              
                                          }
                                          else
                                          {
                                              // retrive user's details
                                              [self showActivityIndicatorWithStyle:UIActivityIndicatorViewStyleWhiteLarge];
                                              self.firstname=user.first_name;
                                              self.lastname=user.last_name;
                                              self.profileid=user.id;
                                              self.emailid= [user objectForKey:@"email"];
                                              [self fblogin];
                                              
                                              NSLog(@"FB user first name:%@",self.firstname);
                                              NSLog(@"FB user last name:%@",self.lastname);
                                              NSLog(@"FB user birthday:%@",user.birthday);
                                              
                                              NSLog(@"email id:%@",self.emailid);
                                              NSLog(@"profile id %@",self.profileid);
                                              
                                              
                                          }
                                      }];
                                  } ];
    
}

-(void)fblogin
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"first_name":self.firstname,
                             @"last_name":self.lastname,
                             @"email":self.emailid,
                             @"profile_id":self.profileid};
    
    
    [manager POST:FacebookLogin parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        
        NSDictionary * name =[responseObject valueForKeyPath:@"data"];
        NSString *token = [[NSString alloc]init];
        token = [name objectForKey:@"token"];
        NSString *id1 = [name objectForKey:@"_id"];
        [name objectForKey:@"email"];
        int status = [[responseObject valueForKeyPath:@"status"] intValue];
        NSLog(@"value of status is %d",status);
        [UICKeyChainStore setString:token forKey:@"token"];
        [UICKeyChainStore setString:id1 forKey:@"id"];
        NSUserDefaults *pref =[NSUserDefaults standardUserDefaults];
        [pref setObject:[name objectForKey:@"token"]forKey:@"Token"];
        [pref setObject:[name objectForKey:@"_id"] forKey:@"ID"];
        [pref setObject:[name objectForKey:@"email"] forKey:@"email"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"id %@",id1);
        NSLog(@"token %@",token);
        [self getProfile];
        [FBSession.activeSession closeAndClearTokenInformation];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"response %@",operation.responseObject);
        
        
        NSString *message =[operation.responseObject objectForKey:@"message"];
        
        [self popup:message  Title:@"Error" image:@"error.png"];
        
        [FBSession.activeSession closeAndClearTokenInformation];
        [self hideActivityIndicator];
        
    }];
    
    
    
}

- (IBAction)forgotpassword:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enter Email"
                                                    message:@"Please enter your email"
                                                   delegate:self
                                          cancelButtonTitle:@"Done"
                                          otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
    alert.tag =2;
    
    
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    
    
}
- (IBAction)signUp:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email ID"
                                                    message:@"Please enter your email to signup"
                                                   delegate:self
                                          cancelButtonTitle:@"Done"
                                          otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
    alert.tag =1;
    
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(alertView.tag==1)
    {
        
        NSString * string = [alertView textFieldAtIndex:0].text ;
        
        if (string.length!=0)
        {
            NSString *regExPattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
            NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
            NSUInteger regExMatches = [regEx numberOfMatchesInString:string options:0 range:NSMakeRange(0, [string length])];
            
            if (regExMatches == 0)
            {
                
             [self popup:@"Invalid Email" Title:@"Invalid" image:@"invalid.png"];
            }
            
            
            
            else
            {
                [self showActivityIndicatorWithStyle:UIActivityIndicatorViewStyleWhiteLarge];
                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                NSDictionary *params = @{@"email": [alertView textFieldAtIndex:0].text};
                
                
                [manager POST:Signup parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSLog(@"JSON: %@", responseObject);
                    
                    
                    NSDictionary * name =[responseObject valueForKeyPath:@"data"];
                    NSLog(@"email %@",[name objectForKey:@"email"]);
                    NSString *id1 = [responseObject valueForKeyPath:@"id"];
                    NSLog(@"value of id %@",id1);
                    NSString * message = [name objectForKey:@"message"];
                    [self popup:message Title:@"Success" image:@"sucess.png"];
                    
                    [self hideActivityIndicator];
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                    NSLog(@"error %@",error);
                    NSLog(@"response %@",operation.responseObject);
                    
                    
                    NSString *message =[operation.responseObject objectForKey:@"message"];
                    
                    [self popup:message Title:@"Warning" image:@"warning.png"];
                    
                    [self hideActivityIndicator];
                    
                }];
                
            }
        }
        
    }
    
    
    if(alertView.tag==2)
    {
        
        NSString * string = [alertView textFieldAtIndex:0].text ;
        
        if (string.length!=0)
        {
            NSString *regExPattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
            NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
            NSUInteger regExMatches = [regEx numberOfMatchesInString:string options:0 range:NSMakeRange(0, [string length])];
            
            if (regExMatches == 0)
            {
        
                [self popup:@"Invalid Email" Title:@"Invalid" image:@"invalid.png"];

            }
            
            
            else
            {
                [self showActivityIndicatorWithStyle:UIActivityIndicatorViewStyleWhiteLarge];
                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                NSDictionary *params = @{@"email": [alertView textFieldAtIndex:0].text};
                //            manager.responseSerializer = [AFURLResponseSerializationErrorDomain serializer];
                
                [manager POST:ForgotPassword parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSLog(@"JSON: %@", responseObject);
                    
                    
                    NSDictionary * name =[responseObject valueForKeyPath:@"data"];
                    NSLog(@"email %@",[name objectForKey:@"email"]);
                    NSString *id1 = [responseObject valueForKeyPath:@"id"];
                    NSLog(@"value of id %@",id1);
                    NSString * message = [name objectForKey:@"message"];
                    [self popup:message Title:@"Status" image:@"sucess.png"];
                    [self hideActivityIndicator];
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                    NSLog(@"response %@",operation.responseObject);
                    
                    NSString *message =[operation.responseObject objectForKey:@"message"];
                    
                    [self popup:message Title:@"info" image:@"info.png"];
                    
                    [self hideActivityIndicator];
                    
                }];
                
            }
            
        }
    }
    
}




- (void)showActivityIndicatorWithStyle:(UIActivityIndicatorViewStyle)style {
    CGRect frame = self.view.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    view.backgroundColor = [UIColor darkGrayColor];
    view.layer.opacity = 0.5;
    view.tag = 1;
    [self.view addSubview:view];
    UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
    indicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin
    | UIViewAutoresizingFlexibleRightMargin
    | UIViewAutoresizingFlexibleTopMargin
    | UIViewAutoresizingFlexibleBottomMargin;
    indicator.tag = 2;
    indicator.center = view.center;
    [indicator startAnimating];
    [self.view addSubview:indicator];
}

- (void)hideActivityIndicator {
    [[self.view viewWithTag:1] removeFromSuperview];
    [[self.view viewWithTag:2] removeFromSuperview];
}
-(BOOL)prefersStatusBarHidden
{
    
    return YES;
}



-(void) getProfile
{
    
    
    NSUserDefaults *pref =[NSUserDefaults standardUserDefaults];
    NSString *token = [pref objectForKey:@"Token"];
    NSString *email =[pref objectForKey:@"email"];
    
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString * string = [NSString stringWithFormat:@"http://numa.simpliot.com/api/user/profile/%@?token=%@",email,token];
    
    string = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager GET: string parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *data =[responseObject valueForKeyPath:@"data"];
        NSString *id1 = [data objectForKey:@"id"];
        
        NSString *dob =[data objectForKey:@"date_of_birth"];
        
        if(![[data objectForKey:@"date_of_birth"]isEqual:[NSNull null]])
        {
            dob= [dob substringToIndex:[dob length]-14];
            [pref setObject:dob forKey:@"dob"];
        }
        
        NSLog(@"data %@",data);
        NSUserDefaults *pref =[NSUserDefaults standardUserDefaults];
        [pref setObject:id1 forKey:@"ID"];
        
        NSLog(@" zip %@",[data objectForKey:@"zip"]);
        if(![[data objectForKey:@"zip"]isEqual:[NSNull null]])
        {
            [pref setObject:[[data objectForKey:@"zip"]stringValue] forKey:@"zip"];
        }
        if(![[data objectForKey:@"mobile"]isEqual:[NSNull null]])
        {
            [pref setObject:[[data objectForKey:@"mobile"]stringValue] forKey:@"phone"];
        }
        
        
        if(![[data objectForKey:@"height"]isEqual:[NSNull null]])
        {
            
            [pref setObject:[[data objectForKey:@"height"]stringValue] forKey:@"height"];
        }
        
        if(![[data objectForKey:@"weight"]isEqual:[NSNull null]])
        {
            
            [pref setObject:[[data objectForKey:@"weight"]stringValue] forKey:@"weight"];
        }
        [pref setObject:[data objectForKey:@"first_name"] forKey:@"firstname"];
        [pref setObject:[data objectForKey:@"last_name"] forKey:@"last_name"];
        [pref setObject:[data objectForKey:@"country"] forKey:@"country"];
        [pref setObject:[data objectForKey:@"city"] forKey:@"city"];
          [pref setObject:[data objectForKey:@"address"] forKey:@"address"];
        [pref setObject:[data objectForKey:@"gender"] forKey:@"gender"];
        [pref setObject:[data objectForKey:@"height_unit"] forKey:@"height_unit"];
        
        [pref setObject:[data objectForKey:@"weight_unit"] forKey:@"weight_unit"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [UICKeyChainStore setString:id1 forKey:@"id"];
        NSLog(@"id1 value %@",[UICKeyChainStore stringForKey:@"id"]);
        
        NSLog(@"id is %@",id1);
        NSLog(@"value in dictionary %@",data);
        [self hideActivityIndicator];
        DailyViewController *daily=(DailyViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"daily"];
        [self presentViewController:daily animated:YES completion:nil];
        
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"response %@",operation.responseObject);
        
        
        NSString *message =[operation.responseObject objectForKey:@"message"];
        
        [self popup:message Title:@"Error" image:@"error.png"];
        
        [self hideActivityIndicator];
        
    }];
    
    
    
}

@end
