//
//  SearchDeviceViewController.m
//  Numafit
//
//  Created by apple on 11/11/14.
//  Copyright (c) 2014 sanhotrasoft. All rights reserved.
//

#import "SearchDeviceViewController.h"
#import "DevieListViewController.h"
#import "LoginViewController.h"
#import "DailyViewController.h"
#import "BTLECentralClass.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "URL.h"
@interface SearchDeviceViewController ()

@end

@implementation SearchDeviceViewController

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
    //self.view.backgroundColor=[self colorFromHexString:@"#c740ba"];
    self.view.backgroundColor=[UIColor clearColor];
        [self serarchview];
        [[BTLECentralClass sharedBTLECentralClass] initCentralMangager];
    gofoundscreen=0;

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
-(void)movetonext
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


//view 1 setting start here
-(void)serarchview
{
    [_retry removeFromSuperview];
    [_timer invalidate];
    [_dottimer invalidate];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[self colorFromHexString:@"#8E388E"] CGColor], (id)[[self colorFromHexString:@"#EE799F"] CGColor],nil];
    _searchview=[[UIView alloc] initWithFrame:self.view.bounds];
    [_searchview.layer addSublayer:gradient];
    
    status=0;
     dotstatus=0;
    _searchicon=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Searching-image.png"]];
    _searchicon.frame = CGRectMake(90,200,50,50);
    
    [self searchinglabel];
    _timer=[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(searchanimation) userInfo:nil repeats:YES];
    [_timer fire];
    [_searchview addSubview:_searchicon];
    [self.view addSubview:_searchview];
    _dottimer=[NSTimer scheduledTimerWithTimeInterval:0.7f target:self selector:@selector(animatedot) userInfo:nil repeats:YES];
     [_dottimer fire];
    [self getdeviceslist];
    
    //cancel button code start here
    UIButton *cancelserch=[[UIButton alloc] initWithFrame:CGRectMake(105,self.view.frame.size.height-100,120,35)];
    cancelserch.layer.cornerRadius=4.0f;
    cancelserch.backgroundColor=[self colorFromHexString:@"#c740ba"];
    [cancelserch addTarget:self action:@selector(cancelsearch) forControlEvents:UIControlEventTouchUpInside];
    [cancelserch setTintColor:[UIColor whiteColor]];
    [cancelserch setTitle:@"CANCEL" forState:UIControlStateNormal];
    cancelserch.titleLabel.font=[UIFont fontWithName:@"oswald-regular" size:18.0f];
    [self.view addSubview:cancelserch];
}

-(void)cancelsearch
{
    [[BTLECentralClass sharedBTLECentralClass] stopCentralManagerScan];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)searchinglabel
{
    UILabel *ser=[[UILabel alloc] initWithFrame:CGRectMake(100,25,160,55)];
    ser.text=@"SEARCHING";
    ser.textColor=[UIColor whiteColor];
    ser.font=[UIFont fontWithName:@"oswald-regular" size:30.0f];
    [_searchview addSubview:ser];
    
    UILabel *help;
    UIImageView *circle;
    i=0;
    circle=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"empty_circle.png"]];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"screen"]intValue]==40)
    {
      help=[[UILabel alloc] initWithFrame:CGRectMake(120,420+90,180,45)];
        circle.frame=CGRectMake(35,125+35,250,250);
        i=40;
    }
    else
    {
        help=[[UILabel alloc] initWithFrame:CGRectMake(120,420,180,45)];
        circle.frame=CGRectMake(35,120,250,250);
    }
    [_searchview addSubview:circle];
    UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(120,60,180,45)];
    lbl.text=@"For Numa Band";
    lbl.textColor=[self colorFromHexString:@"#c740ba"];
    lbl.font=[UIFont fontWithName:@"oswald-regular" size:17.0f];
    [_searchview addSubview:lbl];
    
    
    help.text=@"Need Help?";
    help.textColor=[UIColor whiteColor];
    help.font=[UIFont fontWithName:@"oswald-regular" size:20.0f];
    [_searchview addSubview:help];
    
    _d1=[[UILabel alloc] initWithFrame:CGRectMake(245,28,20,40)];
    _d2=[[UILabel alloc] initWithFrame:CGRectMake(261,28,20,40)];
    _d3=[[UILabel alloc] initWithFrame:CGRectMake(277,28,20,40)];
    
     _d1.text=@".";
     _d2.text=@".";
     _d3.text=@".";
    
    _d1.textColor=[UIColor whiteColor];
    _d2.textColor=[UIColor whiteColor];
    _d3.textColor=[UIColor whiteColor];
    _d1.font=[UIFont fontWithName:@"oswald-regular" size:40.0f];
    _d2.font=[UIFont fontWithName:@"oswald-regular" size:40.0f];
    _d3.font=[UIFont fontWithName:@"oswald-regular" size:40.0f];

   
    
    //removable code
    _count=[[UILabel alloc] initWithFrame:CGRectMake(140,95,100,30)];
    _count.font=[UIFont fontWithName:@"oswald-regular" size:15.0f];
    [_searchview addSubview:_count];
}
-(void)animatedot
{
    if (dotstatus==0)
    {
        [_searchview addSubview:_d1];
        dotstatus=1;
    }else if (dotstatus==1)
    {
        [_searchview addSubview:_d2];
         dotstatus=2;
    }else if (dotstatus==2)
    {
        [_searchview addSubview:_d3];
        dotstatus=3;
    }else
    {
        [_d1 removeFromSuperview];
        [_d2 removeFromSuperview];
        [_d3 removeFromSuperview];
        dotstatus=0;
    }
    
     _count.text=[NSString stringWithFormat:@"%d of 40",gofoundscreen];
    if (gofoundscreen==40 && _devices.count==0)
    {
        [self openretryscreen];
         gofoundscreen=0;
        [[BTLECentralClass sharedBTLECentralClass] stopCentralManagerScan];
        [_dottimer invalidate];
        [_timer invalidate];
    }
    else if(gofoundscreen==40 && _devices.count>0)
    {
        [_dottimer invalidate];
        [_timer invalidate];
         gofoundscreen=0;
    }
    gofoundscreen++;
}
-(void)searchanimation
{
    if (status==0)
    {
        [UIView animateWithDuration:1.0f animations:^{
            _searchicon.frame = CGRectMake(90,210+i,50,50);
        }];
        status=1;
    }
    else if(status==1)
    {
        [UIView animateWithDuration:1.0f animations:^{
            _searchicon.frame = CGRectMake(140,165+i,50,50);
        }];
        status=2;
    }
    else if (status==2)
    {
        [UIView animateWithDuration:1.0f animations:^{
            _searchicon.frame = CGRectMake(180,210+i,50,50);
        }];
        status=3;
    }
    else if(status==3)
    {
        [UIView animateWithDuration:1.0f animations:^{
            _searchicon.frame = CGRectMake(130,260+i,50,50);
        }];
        status=0;
    }
}

//device list table view start here

-(void)getdeviceslist
{
    NSLog(@"getdevicelist called");
    //[[BTLECentralClass sharedBTLECentralClass] stopCentralManagerScan];
    [[BTLECentralClass sharedBTLECentralClass] scan];
    [BTLECentralClass sharedBTLECentralClass].returnPeripherlsArray=^(NSArray *list)
    {
        _devices=list;
        dispatch_async(dispatch_get_main_queue(),^{
            
            NSLog(@"found list");
            //reload your table here;
            [self showtableview];
            [_devicetable reloadData];
        });
        
    };
}

-(void)showtableview
{
    [_deviceale dismissWithClickedButtonIndex:0 animated:YES];
     NSLog(@"tablec called");
    _devicetable=[[UITableView alloc] initWithFrame:CGRectMake(0,0,200,300) style:UITableViewStylePlain];
    _devicetable.delegate=self;
    _devicetable.dataSource=self;
    
    _deviceale=[[UIAlertView alloc] initWithTitle:@"Device List" message:@"Select Device to Connect" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Search More",nil];
    [_deviceale setValue:_devicetable forKey:@"accessoryView"];
    [_deviceale show];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _devices.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    CBPeripheral *device=[_devices objectAtIndex:indexPath.row];
    cell.textLabel.text=device.name;
    NSString *state;
    if (device.state==0)
    {
        state=@"Disconnected";
    }
    else
    {
        state=@"connected";
    }
    cell.detailTextLabel.text=state;
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_deviceale dismissWithClickedButtonIndex:0 animated:YES];
    CBPeripheral *device=[_devices objectAtIndex:indexPath.row];
    [[NSUserDefaults standardUserDefaults]setObject:device.name forKey:@"device_id"];
    [[BTLECentralClass sharedBTLECentralClass] stopCentralManagerScan];
    [self devicefoundscreen:device.name];
}
//view 1 setting ends here

//Device found screen code strart here
-(void)devicefoundscreen:(NSString *)devicename
{
    [_searchview removeFromSuperview];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[self colorFromHexString:@"#8E388E"] CGColor], (id)[[self colorFromHexString:@"#EE799F"] CGColor],nil];
    _devicefound=[[UIView alloc] initWithFrame:self.view.bounds];
    [_devicefound.layer addSublayer:gradient];
    [self.view addSubview:_devicefound];
    UILabel *found=[[UILabel alloc] initWithFrame:CGRectMake(80,25,250,55)];
    found.text=@"DEVICE FOUND";
    found.textColor=[UIColor whiteColor];
    found.font=[UIFont fontWithName:@"oswald-regular" size:30.0f];
    [_devicefound addSubview:found];
    
    UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(80,60,180,45)];
    lbl.text=devicename;
    lbl.textAlignment=NSTextAlignmentCenter;
    lbl.textColor=[self colorFromHexString:@"#c740ba"];
    lbl.font=[UIFont fontWithName:@"oswald-regular" size:17.0f];
    [_devicefound addSubview:lbl];
    
    UIImageView *circle=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bandimage"]];
    UIButton *login;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"screen"]intValue]==40)
    {
        login=[[UIButton alloc] initWithFrame:CGRectMake(60,410+60,200,40)];
        circle.frame=CGRectMake(10,110+40,290,260);
    }
    else
    {   circle.frame=CGRectMake(10,110,290,260);
        login=[[UIButton alloc] initWithFrame:CGRectMake(60,410,200,40)];
    }
    [_devicefound addSubview:circle];
    
    login.backgroundColor=[self colorFromHexString:@"#c740ba"];
    
    NSUserDefaults *pref =[NSUserDefaults standardUserDefaults];
    NSString *token = [pref objectForKey:@"Token"];
    NSString *ID = [pref objectForKey:@"ID"];
    if(token.length == 0 || ID.length==0)
    {
        [login setTitle:@"LOGIN" forState:UIControlStateNormal];
        
    }
    else
    {
        
        [login setTitle:@"NEXT" forState:UIControlStateNormal];
    }

   
    login.titleLabel.font=[UIFont fontWithName:@"oswald-regular" size:20.0f];
    login.layer.cornerRadius=5.0f;
    [login addTarget:self action:@selector(movetonext) forControlEvents:UIControlEventTouchUpInside];
    [_devicefound addSubview:login];
    
}
//Device found screen code end here




//retry screen code start here
-(void)openretryscreen
{
    [_devicefound removeFromSuperview];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[self colorFromHexString:@"#8E388E"] CGColor], (id)[[self colorFromHexString:@"#EE799F"] CGColor],nil];
    _retry=[[UIView alloc] initWithFrame:self.view.bounds];
    [_retry.layer addSublayer:gradient];
    [self.view addSubview:_retry];
    
    UILabel *found=[[UILabel alloc] initWithFrame:CGRectMake(50,25,300,55)];
    found.text=@"DEVICE NOT FOUND";
    found.textColor=[UIColor whiteColor];
    found.font=[UIFont fontWithName:@"oswald-regular" size:30.0f];
    [_retry addSubview:found];

    UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(50,75,250,20)];
    lbl.text=@"Please make sure your band is charged";
    lbl.textColor=[UIColor yellowColor];
    lbl.font=[UIFont fontWithName:@"oswald-regular" size:15.0f];
    [_retry addSubview:lbl];
    
    UILabel *lbl1=[[UILabel alloc] initWithFrame:CGRectMake(50,90,250,20)];
    lbl1.text=@"and is close to your device!";
    lbl1.textColor=[UIColor yellowColor];
    lbl1.font=[UIFont fontWithName:@"oswald-regular" size:15.0f];
    [_retry addSubview:lbl1];
    
    UIImageView *circle=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"devicenot-found"]];
    _retrybtn=[[UIButton alloc] init];
    UIButton *cancel;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"screen"]intValue]==40)
    {
        _retrybtn.frame=CGRectMake(25,410+60,130,40);
        circle.frame=CGRectMake(25,110+40,260,270);
        cancel=[[UIButton alloc] initWithFrame:CGRectMake(165,410+60,130,40)];
    }
    else
    {
         _retrybtn.frame=CGRectMake(25,410,130,40);
        circle.frame=CGRectMake(25,110,260,270);
        cancel=[[UIButton alloc] initWithFrame:CGRectMake(165,410,130,40)];
    }
     [_retry addSubview:circle];
    _retrybtn.backgroundColor=[self colorFromHexString:@"#c740ba"];
    [_retrybtn setTitle:@"RETRY" forState:UIControlStateNormal];
    _retrybtn.titleLabel.font=[UIFont fontWithName:@"oswald-regular" size:20.0f];
    _retrybtn.layer.cornerRadius=5.0f;
    [_retrybtn addTarget:self action:@selector(serarchview) forControlEvents:UIControlEventTouchUpInside];
    [_retry addSubview:_retrybtn];

    
    cancel.backgroundColor=[self colorFromHexString:@"#c740ba"];
    [cancel setTitle:@"BUY BAND" forState:UIControlStateNormal];
    cancel.titleLabel.font=[UIFont fontWithName:@"oswald-regular" size:20.0f];
    cancel.layer.cornerRadius=5.0f;
    [_retry addSubview:cancel];
    [cancel addTarget:self action:@selector(cancelaction) forControlEvents:UIControlEventTouchUpInside];
}
-(void)cancelaction
{
    NSString *msg=@"Hey Do you want Buy new Numa Band ?";
    
    //custom popup setting
    UIView *popview=[[UIView alloc] initWithFrame:CGRectMake(0,0,200,90)];
    popview.backgroundColor=[self colorFromHexString:@"#ececec"];
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"band.png"]];
    image.frame=CGRectMake(30,34,40,40);
    [popview addSubview:image];
    
    UILabel *lbl2=[[UILabel alloc] initWithFrame:CGRectMake(48,3,165,30)];
    lbl2.font=[UIFont fontWithName:@"oswald-regular" size:20.0f];
    lbl2.text=@"Suggestion";
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
    
    _buyale=[[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"NO",@"YES",nil];
    [_buyale setValue:popview forKey:@"accessoryView"];
    [_buyale show];
    //end custom popup
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView==_buyale)
    {
        if (buttonIndex==0)
        {
            //exit(0);
        }
        else
        {
            NSURL *url = [NSURL URLWithString:bandpurchaseurl];
            [[UIApplication sharedApplication] openURL:url];
        }
    }
    else if (alertView==_deviceale)
    {
        if (buttonIndex==0)
        {
            _devices=nil;
            gofoundscreen=0;
            [self serarchview];
        }
    }
}
-(void)viewDidDisappear:(BOOL)animated
{
    [[BTLECentralClass sharedBTLECentralClass] stopCentralManagerScan];
}
//retry screen code end here

-(void)popup :(NSString *)msg Title:(NSString *)Title image:(NSString *)url
{
   
}
@end
