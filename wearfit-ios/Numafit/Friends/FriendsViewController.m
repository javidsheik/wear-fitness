//
//  FriendsViewController.m
//  Numafit
//
//  Created by apple on 24/11/14.
//  Copyright (c) 2014 sanhotrasoft. All rights reserved.
//

#import "FriendsViewController.h"
#import "URL.h"
#import "AFNetworking.h"
@interface FriendsViewController ()

@end

@implementation FriendsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self header];
    reqstatus=1;
    self.view.backgroundColor=[self colorFromHexString:@"#efecec"];
    
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"screen"]intValue]==40)
    {
        _linkedfriends=[[UITableView alloc] initWithFrame:CGRectMake(10,73,300,186+40) style:UITableViewStylePlain];
        _unlinkedfriends=[[UITableView alloc] initWithFrame:CGRectMake(10,290+40,300,200+40) style:UITableViewStylePlain];
    }
    else
    {
        _linkedfriends=[[UITableView alloc] initWithFrame:CGRectMake(10,73,300,186) style:UITableViewStylePlain];
        _unlinkedfriends=[[UITableView alloc] initWithFrame:CGRectMake(10,290,300,200) style:UITableViewStylePlain];
    }
    
    
    _linkedfriends.showsVerticalScrollIndicator=NO;
    _unlinkedfriends.showsVerticalScrollIndicator=NO;
    
    _linkedfriends.delegate=self;
    _linkedfriends.dataSource=self;
    _unlinkedfriends.delegate=self;
    _unlinkedfriends.dataSource=self;
    
    _linkedfriends.backgroundColor=[self colorFromHexString:@"#efecec"];
    _unlinkedfriends.backgroundColor=[self colorFromHexString:@"#efecec"];
    
    self.menulist.frame=CGRectMake(0,-20,self.menu.frame.size.width, self.menu.frame.size.height);
    
    _linkfriendslist=[[NSMutableArray alloc] init];
    _unlinkfriendslist=[[NSMutableArray alloc] init];
    
    [self.view addSubview:_linkedfriends];
    [self.view addSubview: _unlinkedfriends];
    
    //friend request table code start here
    _friendsrequestarray=[[NSMutableArray alloc] init];
    _requeststable=[[UITableView alloc] initWithFrame:CGRectMake(240,45,0,0) style:UITableViewStylePlain];
    _requeststable.delegate=self;
    _requeststable.dataSource=self;
    _requeststable.layer.cornerRadius=8;
    _requeststable.separatorStyle=UITableViewCellSeparatorStyleNone;
    _requeststable.backgroundColor=[self colorFromHexString:@"#efecec"];
    _requeststable.showsVerticalScrollIndicator=NO;
    [self.view addSubview:_requeststable];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==_linkedfriends)
    {
        return _linkfriendslist.count;
    }
    else if(tableView == self.menulist)
    {
        return [self.imagelist count];
    }
    else if(tableView ==_unlinkedfriends)
    {
        return _unlinkfriendslist.count;
    }
    else
    {
        return _friendsrequestarray.count;//this would be replaced with
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.layer.cornerRadius=10;
    cell.clipsToBounds=YES;
    if (tableView==_linkedfriends)
    {
        NSDictionary *data=[_linkfriendslist objectAtIndex:indexPath.row];
        NSString *url=[NSString stringWithFormat:@"http://%@",[data objectForKey:@"profile_picture"]];
        UIImageView *profile=[[UIImageView alloc] initWithImage:[UIImage imageNamed:url]];
        profile.frame=CGRectMake(15,9,65,70);
        profile.layer.cornerRadius=32;
        profile.clipsToBounds=YES;
        [cell addSubview:profile];
        
        
        UILabel *name=[[UILabel alloc]initWithFrame:CGRectMake(100,13,200,30)];
        name.text=[NSString stringWithFormat:@"%@ %@",[data objectForKey:@"first_name"],[data objectForKey:@"last_name"]];
        name.font=[UIFont fontWithName:@"oswald-regular" size:20.0f];
        name.textColor=[self colorFromHexString:@"#767373"];
        [cell addSubview:name];
        
        
        UILabel *points=[[UILabel alloc]initWithFrame:CGRectMake(100,42,200,20)];
        points.text=[NSString stringWithFormat:@"%@  | CALORIES",[data objectForKey:@"consumption_points"]];
        points.font=[UIFont fontWithName:@"oswald-regular" size:13.0f];
        points.textColor=[self colorFromHexString:@"#c1c0c0"];
        [cell addSubview:points];
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
        
    }
    else if (tableView == self.menulist)
    {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    else if (tableView==_requeststable)
    {
        
        NSDictionary *data=[_unlinkfriendslist objectAtIndex:indexPath.row];
        NSString *url=[NSString stringWithFormat:@"http://%@",[data objectForKey:@"profile_picture"]];
        UIImageView *profile=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"friends_icon.png"]];
        profile.frame=CGRectMake(15,9,65,70);
        profile.layer.cornerRadius=32;
        profile.clipsToBounds=YES;
        [cell addSubview:profile];
        
        UILabel *name=[[UILabel alloc]initWithFrame:CGRectMake(100,13,200,30)];
        name.text=@"Dilip Ingole";
        name.font=[UIFont fontWithName:@"oswald-regular" size:17.0f];
        name.textColor=[self colorFromHexString:@"#767373"];
        [cell addSubview:name];
        
        
        UIButton *accept=[[UIButton alloc] initWithFrame:CGRectMake(155,51,36,36)];
        [accept setImage:[UIImage imageNamed:@"sucess.png"] forState:UIControlStateNormal];
        [accept addTarget:self action:@selector(accept:) forControlEvents:UIControlEventTouchUpInside];
        accept.tag=indexPath.row;
        [cell addSubview:accept];
        
        
        UIButton *reject=[[UIButton alloc] initWithFrame:CGRectMake(205,51,34.5,34.5)];
        [reject setImage:[UIImage imageNamed:@"reject.png"] forState:UIControlStateNormal];
        [reject addTarget:self action:@selector(reject:) forControlEvents:UIControlEventTouchUpInside];
        reject.tag=indexPath.row;
        [cell addSubview:reject];
        
        cell.layer.borderWidth=0.5f;
        
    }
    
    else
    {
        NSDictionary *data=[_unlinkfriendslist objectAtIndex:indexPath.row];
        NSString *url=[NSString stringWithFormat:@"http://%@",[data objectForKey:@"profile_picture"]];
        UIImageView *profile=[[UIImageView alloc] initWithImage:[UIImage imageNamed:url]];
        profile.frame=CGRectMake(15,9,65,70);
        profile.layer.cornerRadius=32;
        profile.clipsToBounds=YES;
        [cell addSubview:profile];
        
        UILabel *name=[[UILabel alloc]initWithFrame:CGRectMake(100,13,200,30)];
        name.text=[NSString stringWithFormat:@"%@ %@",[data objectForKey:@"first_name"],[data objectForKey:@"last_name"]];
        name.font=[UIFont fontWithName:@"oswald-regular" size:20.0f];
        name.textColor=[self colorFromHexString:@"#767373"];
        [cell addSubview:name];
        
        UILabel *points=[[UILabel alloc]initWithFrame:CGRectMake(100,42,200,20)];
        points.text=[NSString stringWithFormat:@"%@  | CALORIES",[data objectForKey:@"consumption_points"]];
        points.font=[UIFont fontWithName:@"oswald-regular" size:13.0f];
        points.textColor=[self colorFromHexString:@"#c1c0c0"];
        [cell addSubview:points];
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor whiteColor];
    return cell;
}
-(void)accept:(UIButton *)accept
{
    [_friendsrequestarray removeObjectAtIndex:accept.tag];
    [_requeststable reloadData];
}
-(void)reject:(UIButton *)reject
{
    [_friendsrequestarray removeObjectAtIndex:reject.tag];
    [_requeststable reloadData];
}
-(void)addfriendscellclick
{
    
    NSString *msg=@"Enter Friends Email Address";
    //custom popup setting
    UIView *popview=[[UIView alloc] initWithFrame:CGRectMake(0,0,200,200)];
    popview.backgroundColor=[self colorFromHexString:@"#ececec"];
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"addfroend.png"]];
    image.frame=CGRectMake(30,34,40,40);
    [popview addSubview:image];
    
    UILabel *lbl2=[[UILabel alloc] initWithFrame:CGRectMake(48,3,165,30)];
    lbl2.font=[UIFont fontWithName:@"oswald-regular" size:20.0f];
    lbl2.text=@"Add Friend";
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
    
    _email=[[UITextField alloc] initWithFrame:CGRectMake(35,80,200,30)];
    _email.layer.borderWidth=0.5;
    _email.layer.cornerRadius=3;
    _email.delegate=self;
    _email.textAlignment=NSTextAlignmentCenter;
    [_email setPlaceholder:@"Email"];
    
    [popview addSubview:_email];
    
    _getmailale=[[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Invite", nil];
    [_getmailale setValue:popview forKey:@"accessoryView"];
    [_getmailale show];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_email resignFirstResponder];
    return YES;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *email;
    if (alertView==_getmailale)
    {
        [_email resignFirstResponder];
        if (buttonIndex==1)
        {
            email=_email.text;
            if (email.length!=0)
            {
                NSString *regExPattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
                NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
                NSUInteger regExMatches = [regEx numberOfMatchesInString:email options:0 range:NSMakeRange(0, [email length])];
                
                if (regExMatches == 0)
                {
                    [self popup:@"    Invalid Email"  Title:@"Error" image:@"invalid.png"];
                }
                else
                {
                    [self addfriend:email];
                }
                
            }
            
        }
    }
    
}
-(void)header
{
    UIView *linked =[[UIView  alloc] initWithFrame:CGRectMake(0,43,320,30)];
    UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(15,-2,200,35)];
    lbl.font=[UIFont fontWithName:@"oswald-regular" size:20.0f];
    lbl.textColor=[UIColor whiteColor];
    linked.backgroundColor=[self colorFromHexString:@"#30d4fd"];
    lbl.text=@"Linked Friends";
    [linked addSubview:lbl];
    
    
    
    UIView *unlinked;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"screen"]intValue]==40)
    {
        unlinked =[[UIView  alloc] initWithFrame:CGRectMake(0,260+40,320,30)];
    }
    else
    {
        unlinked =[[UIView  alloc] initWithFrame:CGRectMake(0,260,320,30)];
    }
    
    UILabel *lbl1=[[UILabel alloc] initWithFrame:CGRectMake(15,-2,200,35)];
    lbl1.font=[UIFont fontWithName:@"oswald-regular" size:20.0f];
    lbl1.textColor=[UIColor whiteColor];
    unlinked.backgroundColor=[self colorFromHexString:@"#30d4fd"];
    lbl1.text=@"UnLinked Friends";
    [unlinked addSubview:lbl1];
    [self.view addSubview:linked];
    [self.view addSubview:unlinked];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.menulist)
    {
        return 45;
    }
    else
    {
        return 90.0f;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView== self.menulist)
    {
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}
-(UIColor *)colorFromHexString:(NSString *)hexString
{
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1];
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

-(void)viewDidAppear:(BOOL)animated
{
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(0,5,70,25)];
    title.text=@"Friends";
    title.font=[UIFont fontWithName:@"oswald-regular" size:19.0f];
    title.textColor=[UIColor whiteColor];
    self.navigationItem.titleView=title;
    
    _count=[[UILabel alloc] initWithFrame:CGRectMake(20,2,15,15)];
    _count.backgroundColor=[UIColor redColor];
    _count.text=@"10";
    _count.layer.cornerRadius=7;
    _count.clipsToBounds=YES;
    _count.textAlignment=NSTextAlignmentCenter;
    _count.font=[UIFont fontWithName:@"oswald-regular" size:10.0f];
    
    _friendreq=[[UIButton alloc] initWithFrame:CGRectMake(230,4,35,35)];
    [_friendreq setImage:[UIImage imageNamed:@"friends_icon.png"] forState:UIControlStateNormal];
    [self.navigationController.navigationBar addSubview:_friendreq];
    [_friendreq addTarget:self action:@selector(animaterequsettable) forControlEvents:UIControlEventTouchUpInside];
    
    [_friendreq addSubview:_count];
    //navigation Add event button setting
    UIBarButtonItem *addfriends=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addfriendscellclick)];
    self.navigationItem.rightBarButtonItem=addfriends;
   
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(getfriendslist) userInfo:nil repeats:NO];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [_count  removeFromSuperview];
    [_friendreq removeFromSuperview];
}
-(void)animaterequsettable
{
    _count.text=[NSString stringWithFormat:@"%lu",(unsigned long)_friendsrequestarray.count];
    if (reqstatus==1)
    {
        [UIView animateWithDuration:0.7f animations:^{
            _requeststable.frame = CGRectMake(20,45,250,350);
        }];
        reqstatus=0;
    }
    else
    {
        [UIView animateWithDuration:0.7f animations:^{
            _requeststable.frame = CGRectMake(240,45,0,0);
        }];
        reqstatus=1;
    }
    
}

-(void)getfriendslist
{
    NSURL *url = [NSURL URLWithString:Netcheckurl];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    if (data)
    {
        //activityIndicator codeing
        UIActivityIndicatorView *wait=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        wait.color=[self colorFromHexString:@"#bfdecc"];
        UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(105,4,150,20)];
        lbl.text=@"Reciving List...";
        lbl.font=[UIFont fontWithName:@"oswald-regular" size:15.0f];
        lbl.textColor=[self colorFromHexString:@"#bfdecc"];
        
        UIView *v=[[UIView alloc] initWithFrame:CGRectMake(0,0,100,80)];
        [v addSubview:wait];
        [v addSubview:lbl];
        wait.frame=CGRectMake(120,40,30,30);
        v.backgroundColor=[self colorFromHexString:@"#636467"];
        UIAlertView *waitale=[[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
        [wait startAnimating];
        [waitale setValue:v forKey:@"accessoryView"];
        [waitale show];
        //end activityindicator
        
        AFHTTPRequestOperationManager *request=[AFHTTPRequestOperationManager manager];
        NSString *userid=[[NSUserDefaults standardUserDefaults] objectForKey:@"ID"];
        NSString *token=[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"];
        
        
        NSString *url=[NSString stringWithFormat:@"https://numa.simpliot.com/api/friends?user_id=%@&token=%@",userid,token];
        [request GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             [waitale dismissWithClickedButtonIndex:0 animated:YES];
             if ([[responseObject objectForKey:@"status"]intValue]==200)
             {
                 NSDictionary *data=[responseObject objectForKey:@"data"];
                 if ([[data objectForKey:@"count"]intValue]>0)
                 {
                     [_linkfriendslist removeAllObjects];
                     [_unlinkfriendslist removeAllObjects];
                     NSArray *arr=[data objectForKey:@"friends"];
                     
                     for (NSDictionary *dict1 in arr)
                     {
                         NSString *points=[dict1 objectForKey:@"consumption_points"];
                         NSArray *user=[dict1 objectForKey:@"user"];
                         NSDictionary *dict2=[user objectAtIndex:0];
                         
                         NSString *fname=[dict2 objectForKey:@"first_name"];
                         NSString *lname=[dict2 objectForKey:@"last_name"];
                         if (fname==nil || [fname isEqualToString:@"null"])
                         {
                             fname=@"  ";
                         }
                         if(lname==nil || [lname isEqualToString:@"null"])
                         {
                             lname=@"";
                         }
                         int flage=0;
                         
                         if (points==nil || [points isEqualToString:@"null"])
                         {
                             points=@"0";
                         }
                         
                         if ([[dict2 objectForKey:@"linked"]intValue]==1)
                         {
                             NSMutableDictionary *data=[[NSMutableDictionary alloc] init];
                             
                             
                             [data setObject:fname forKey:@"first_name"];
                             [data setObject:lname forKey:@"last_name"];
                             [data setObject:[dict2 objectForKey:@"profile_picture"] forKey:@"profile_picture"];
                             [data setObject:points forKey:@"consumption_points"];
                             [_linkfriendslist addObject:data];
                         }
                         else
                         {
                             NSArray *key=[dict2 allKeys];
                             for (NSString *str in key)
                             {
                                 if ([str isEqualToString:@"first_name"])
                                 {
                                     flage=1;
                                 }
                             }
                             NSMutableDictionary *data=[[NSMutableDictionary alloc] init];
                             if (flage==0)
                             {
                                 NSString *email=[dict2 objectForKey:@"email"];
                                 if (email==nil || [email isEqualToString:@"null"])
                                 {
                                     email=@"  ";
                                 }
                                 [data setObject:email forKey:@"first_name"];
                                 [data setObject:@"" forKey:@"last_name"];
                                 [data setObject:[dict2 objectForKey:@"profile_picture"] forKey:@"profile_picture"];
                                 [data setObject:points forKey:@"consumption_points"];
                             }
                             else
                             {
                                 [data setObject:fname forKey:@"first_name"];
                                 [data setObject:lname forKey:@"last_name"];
                                 [data setObject:[dict2 objectForKey:@"profile_picture"] forKey:@"profile_picture"];
                                 [data setObject:points forKey:@"consumption_points"];
                             }
                             [_unlinkfriendslist addObject:data];
                         }
                     }
                     _friendsrequestarray=_unlinkfriendslist;
                     [_unlinkedfriends reloadData];
                     [_linkedfriends reloadData];
                 }
                 else
                 {
                     [self popup:@"No Friends In List"  Title:@"Status" image:@"warning.png"];
                 }
             }
             
         } failure:^(AFHTTPRequestOperation *operation,NSError *err)
         {
             [waitale dismissWithClickedButtonIndex:0 animated:YES];
             [self popup:message_503  Title:title_503 image:@"ServerError.png"];         }];
        
    }else
    {
        [self popup:OfflineMsg Title:OfflineTitle image:@"offline.png"];
    }
}

-(void)addfriend:(NSString *)email
{
    NSURL *url = [NSURL URLWithString:Netcheckurl];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    if (data)
    {
        //activityIndicator codeing
        UIActivityIndicatorView *wait=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        wait.color=[self colorFromHexString:@"#bfdecc"];
        UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(105,4,150,20)];
        lbl.text=@"Sending Request...";
        lbl.font=[UIFont fontWithName:@"oswald-regular" size:15.0f];
        lbl.textColor=[self colorFromHexString:@"#bfdecc"];
        
        UIView *v=[[UIView alloc] initWithFrame:CGRectMake(0,0,100,80)];
        [v addSubview:wait];
        [v addSubview:lbl];
        wait.frame=CGRectMake(120,40,30,30);
        v.backgroundColor=[self colorFromHexString:@"#636467"];
        UIAlertView *waitale=[[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
        [wait startAnimating];
        [waitale setValue:v forKey:@"accessoryView"];
        [waitale show];
        //end activityindicator
        
        AFHTTPRequestOperationManager *request=[AFHTTPRequestOperationManager manager];
        NSString *userid=[[NSUserDefaults standardUserDefaults] objectForKey:@"ID"];
        NSString *token=[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"];
        
        NSDictionary *postdata=@{@"user_id":userid,
                                 @"email":email,
                                 @"token":token,};
        [request POST:FriendsInviteurl parameters:postdata success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             [waitale dismissWithClickedButtonIndex:0 animated:YES];
             if ([[responseObject objectForKey:@"status"]intValue]==200)
             {
                 NSDictionary *data=[responseObject objectForKey:@"data"];
                 [self popup:[data objectForKey:@"message"]  Title:@"Status" image:@"sucess.png"];
                 [self getfriendslist];
             }
             
         } failure:^(AFHTTPRequestOperation *operation,NSError *err)
         {
             [waitale dismissWithClickedButtonIndex:0 animated:YES];
             [self popup:message_503  Title:title_503 image:@"ServerError.png"];
         }];
        
    }else
    {
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


@end
