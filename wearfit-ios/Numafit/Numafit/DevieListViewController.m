//
//  DevieListViewController.m
//  Numafit
//
//  Created by apple on 31/10/14.
//  Copyright (c) 2014 sanhotrasoft. All rights reserved.
//

#import "DevieListViewController.h"
#import "LoginViewController.h"
#import "DailyViewController.h"
@interface DevieListViewController ()

@end

@implementation DevieListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self settitleview];
    self.view.backgroundColor=[self colorFromHexString:@"#e4e1e1"];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"screen"]intValue]==40)
    {
    _devicelist=[[UITableView alloc] initWithFrame:CGRectMake(20,90,280,360) style:UITableViewStylePlain];
    }
    else
    {
    _devicelist=[[UITableView alloc] initWithFrame:CGRectMake(20,50,280,350) style:UITableViewStylePlain];
    }
    
    _devicelist.delegate=self;
    _devicelist.dataSource=self;
    _devicelist.backgroundColor=[UIColor clearColor];
    _devicelist.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_devicelist];
    [self setlayout];
  }
-(void)closeview
{
    
    NSUserDefaults *pref =[NSUserDefaults standardUserDefaults];
    NSString *token = [pref objectForKey:@"Token"];
    NSString *ID = [pref objectForKey:@"ID"];
    if(token.length == 0 || ID.length==0)
   {
     LoginViewController *login=(LoginViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"login"];
     [self presentViewController:login animated:YES completion:nil];
   
   }
    else
    {
        
        DailyViewController *daily=(DailyViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"daily"];
        [self presentViewController:daily animated:YES completion:nil];
       

    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8*2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    //if (cell==nil)
    //{
       UITableViewCell *cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    //}
    cell.backgroundColor=[UIColor clearColor];
    if (indexPath.row%2==0)
    {
        cell.layer.borderWidth=0.5f;
        cell.layer.cornerRadius=10;
UIImageView *bandimage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"device_inactive.png"]];
        bandimage.frame=CGRectMake(15,5,45,55);
        [cell addSubview:bandimage];
        
    UIImageView *optionicon=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"deviceicon.png"]];
        optionicon.frame=CGRectMake(255,5,10,30);
        
        _option=[[UIButton alloc] initWithFrame:CGRectMake(255,5,10,30)];
        [_option setImage:[UIImage imageNamed:@"deviceicon.png"] forState:UIControlStateNormal];
    [_option addTarget:self action:@selector(showoption:) forControlEvents:UIControlEventTouchUpInside];
        _option.tag=indexPath.row;
        [cell addSubview:_option];
        
        UILabel *devicename=[[UILabel alloc]initWithFrame:CGRectMake(70,10,150,20)];
        devicename.text=@"DEVICE NAME";
        devicename.font=[UIFont fontWithName:@"oswald-regular" size:20.0f];
        devicename.textColor=[self colorFromHexString:@"#817e7e"];
        [cell addSubview:devicename];
        
        UILabel *devicstatus=[[UILabel alloc]initWithFrame:CGRectMake(70,35,150,20)];
        devicstatus.text=@"Disconneced";
        devicstatus.font=[UIFont fontWithName:@"oswald-regular" size:13.0f];
        devicstatus.textColor=[self colorFromHexString:@"#b7b5b5"];
        [cell addSubview:devicstatus];
        
        cell.backgroundColor=[self colorFromHexString:@"#efecec"];
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row%2==0)
    {
        return 60.0f;
    }
    else
    {
        return 15.0f;
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
-(BOOL)prefersStatusBarHidden
{
    return YES;
}
-(void)showoption:(UIButton *)btn
{
UIAlertView *ale=[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@" Device No-%ld",(long)btn.tag] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"CONNECT",@"DISCONNECT",@"DELETE", nil];
    [ale show];
}
-(void)settitleview
{
   _header.backgroundColor=[UIColor clearColor];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = _header.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[self colorFromHexString:@"#8E388E"] CGColor], (id)[[self colorFromHexString:@"#EE799F"] CGColor],nil];
    [_header.layer insertSublayer:gradient atIndex:1];
    UILabel *title=[[UILabel alloc] initWithFrame:CGRectMake(100,13,150,25)];
    title.text=@"Saved Devices";
    title.font=[UIFont fontWithName:@"oswald-regular" size:24.0f];
    title.textColor=[UIColor whiteColor];
    [_header addSubview:title];
}

-(void)setlayout
{
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"screen"]intValue]==40)
    {
         _login=[[UIButton alloc] initWithFrame:CGRectMake(47,420+65,230,45)];
    }
    else
    {
         _login=[[UIButton alloc] initWithFrame:CGRectMake(47,420,230,45)];
    }
   
    [_login setTitle:@"LOGIN" forState:UIControlStateNormal];
    _login.titleLabel.textColor=[UIColor blackColor];
    _login.backgroundColor=[self colorFromHexString:@"#1fd0ad"];
    _login.titleLabel.font=[UIFont fontWithName:@"oswald-regular" size:20.0f];
    _login.layer.cornerRadius=5.0f;
    [_login addTarget:self action:@selector(closeview) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_login];

}
@end
