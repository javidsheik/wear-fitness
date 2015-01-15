//
//  MenuViewController.m
//  Numafit
//
//  Created by apple on 31/10/14.
//  Copyright (c) 2014 sanhotrasoft. All rights reserved.
//

#import "MenuViewController.h"
#import "EColumnChartViewController.h"
#import "DailyViewController.h"
#import "TrackViewController.h"
#import "UICKeyChainStore.h"
#import "LoginViewController.h"
#import "EventViewController.h"
#import "ProfileViewController.h"
#import "FriendsViewController.h"
#import "CircleListViewController.h"
#import "AFNetworking.h"
#import "CreateGoalViewController.h"
#import "ViewGoalViewController.h"
#import "BTLECentralClass.h"
#import "StartViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

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
    [self navigationbarsetting];

    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menuicon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(showmenu)];
    self.navigationController.navigationBar.barTintColor=[UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [_menu removeFromSuperview];

    _namelist=[[NSMutableArray alloc] initWithObjects:@"TODAY",@"ACTIVITY",@"TRACK",@"PROFILE",@"GOALS",@"FRIENDS",@"CIRCLES",@"EVENTS",@"LOGOUT", nil];
    
     _imagelist=[[NSMutableArray alloc] initWithObjects:@"menu_01.png",@"menu_02.png",@"menu_03.png",@"menu_04.png",@"menu_05.png",@"menu_06.png",@"menu_07.png",@"menu_08.png",@"menu_09.png", nil];
    
     status=0;
    _menu=[[UIView alloc] initWithFrame:CGRectMake(-180,45,180,self.view.frame.size.height)];
    _menu.backgroundColor=[self colorFromHexString:@"#252121"];
    _menulist=[[UITableView alloc] initWithFrame:CGRectMake(0,15,_menu.frame.size.width, _menu.frame.size.height) style:UITableViewStylePlain];
    
    
    _menulist.delegate=self;
    _menulist.dataSource=self;
    _menulist.backgroundColor=[UIColor clearColor];
    _menulist.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    [_menu addSubview:_menulist];
    [self.view addSubview:_menu];
    
}
- (BOOL)prefersStatusBarHidden
{
    return YES;
}
-(void)navigationbarsetting
{
    //background color for navigation bar setting
    self.navigationController.navigationBar.backgroundColor=[UIColor clearColor];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.navigationController.navigationBar.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[self colorFromHexString:@"#8E388E"] CGColor], (id)[[self colorFromHexString:@"#EE799F"] CGColor],nil];
    [self.navigationController.navigationBar.layer insertSublayer:gradient atIndex:1];
    //end
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell  *cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.backgroundColor=[UIColor clearColor];
    
    UILabel *name=[[UILabel alloc] initWithFrame:CGRectMake(70,10,60,20)];
    
    
    name.text=[_namelist objectAtIndex:indexPath.row];
    name.textColor= [self colorFromHexString:@"#7b7676"];
    name.font=[UIFont fontWithName:@"oswald-regular" size:16.0f];
    [cell addSubview:name];
    
    
    UIImageView *img=[[UIImageView alloc] initWithImage:[UIImage imageNamed:[_imagelist objectAtIndex:indexPath.row]]];
    img.frame=CGRectMake(13,8,25,25);
    
    [cell addSubview:img];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.row)
    {
        case 0:
            [self opentoday];
            break;
        case 1:
            [self openactivity];
             break;
        case 2:
            [self opentrack];
             break;
        case 3:
            [self openprofile];
            break;
        case 4:
            [self opengoals];
            break;
        case 5:
            [self openfriends];
            break;
        case 6:
            [self opencircle];
            break;
        case 7:
            [self openevents];
            break;
        case 8:
            [self openlogout];
            break;
        default:
            break;
    }
    
}
-(void)showmenu
{
    [_menu removeFromSuperview];
    if (status==0)
    {
        status=1;
        [UIView animateWithDuration:0.5f animations:^{
            _menu.frame = CGRectMake(0,45,180,self.view.frame.size.height);
        }];
    }
    else
    {
        status=0;
        [UIView animateWithDuration:0.5f animations:^{
            _menu.frame = CGRectMake(-180,45,180,self.view.frame.size.height);
        }];
    }
    [self.view insertSubview:_menu atIndex:100];
}

-(UIColor *)colorFromHexString:(NSString *)hexString
{
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1];
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (status==1)
    {
         [self showmenu];
    }
}
-(void)hidemenu
{
    if (status==1)
    {
        [self showmenu];
    }
}

//menu item event

-(void)opentoday
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)openactivity
{
    UINavigationController *navController = self.navigationController;
    [navController popViewControllerAnimated:NO];
    EColumnChartViewController *week=(EColumnChartViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"weeklymodule"];
    [navController pushViewController:week animated:NO];
}
-(void)opentrack
{
    UINavigationController *navController = self.navigationController;
    [navController popViewControllerAnimated:NO];
    TrackViewController *track=(TrackViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"track"];
    [navController pushViewController:track animated:NO];
}
-(void)openprofile
{
    UINavigationController *navController = self.navigationController;
    [navController popViewControllerAnimated:NO];
    ProfileViewController *profile =(ProfileViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"profile"];
    [navController pushViewController:profile animated:NO];
}
-(void)opengoals
{
    UINavigationController *navController = self.navigationController;
    [navController popViewControllerAnimated:NO];
    ViewGoalViewController *goal =(ViewGoalViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"viewgoal"];
    [navController pushViewController:goal animated:NO];
}
-(void)openfriends
{
    UINavigationController *navController = self.navigationController;
    [navController popViewControllerAnimated:NO];
    FriendsViewController *profile =(FriendsViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"friends"];
    [navController pushViewController:profile animated:NO];
}
-(void)opencircle
{
    UINavigationController *navController = self.navigationController;
    [navController popViewControllerAnimated:NO];
    CircleListViewController *circle =(CircleListViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"circle"];
    [navController pushViewController:circle animated:NO];
}
-(void)openevents
{
     UINavigationController *navController = self.navigationController;
    [navController popViewControllerAnimated:NO];
    EventViewController *addevent=(EventViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"event"];
    [navController pushViewController:addevent animated:NO];
}
-(void)openlogout
{
    [self logout];
    
}

-(void)logout

{
    
    NSUserDefaults *pref =[NSUserDefaults standardUserDefaults];
    
    
    UIActivityIndicatorView *wait=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    wait.color=[self colorFromHexString:@"#bfdecc"];
    UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(105,4,150,20)];
    lbl.text=@"Logging out...";
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
    [self hidemenu];
    [waitale show];
    
    if([pref objectForKey:@"Token"]==NULL)
    {
        
        NSLog(@"token is null");
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"token":[pref objectForKey:@"Token"] };
    
    
    [manager POST:@"http://numa.simpliot.com/api/oauth/logout" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [pref setObject:NULL forKey:@"Token"];
        [pref setObject:NULL forKey:@"ID"];
        
        [pref setObject:NULL forKey:@"zip"];
        [pref setObject: NULL forKey:@"phone"];
        [pref setObject: NULL forKey:@"firstname"];
        [pref setObject: NULL forKey:@"last_name"];
        [pref setObject: NULL forKey:@"country"];
        [pref setObject:NULL forKey:@"city"];
        
        
        [pref setObject:NULL forKey:@"gender"];
        [pref setObject:NULL forKey:@"dob"];
        [pref setObject:NULL forKey:@"height"];
        [pref setObject:NULL forKey:@"height_unit"];
        [pref setObject:NULL forKey:@"weight"];
        [pref setObject:NULL forKey:@"weight_unit"];
        [pref setObject:NULL forKey:@"address"];
        [pref setObject:NULL forKey:@"alarmhour"];
        [pref setObject:NULL forKey:@"alarmmin"];
        [pref setObject:NULL forKey:@"alarmday"];
        [pref setObject:NULL forKey:@"alarmvalue"];
        [pref setObject:NULL forKey:@"caloriegoal"];
        [pref setObject:NULL forKey:@"stepsgoal"];
        [pref setObject:NULL forKey:@"distgoal"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        //band disconnect band
        [[BTLECentralClass sharedBTLECentralClass]disconnectPeripheral];
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"device_id"];
        
        StartViewController *start=(StartViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"searchseg"];
        [self presentViewController:start animated:YES completion:nil];
        [waitale dismissWithClickedButtonIndex:0 animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message"
                                                        message:@"Something is wrong on server"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        
        [waitale dismissWithClickedButtonIndex:0 animated:YES];
        [alert show];
        
        
    }];
}
@end
