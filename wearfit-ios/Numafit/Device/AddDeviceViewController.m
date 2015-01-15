//
//  AddDeviceViewController.m
//  Numafit
//
//  Created by apple on 31/12/14.
//  Copyright (c) 2014 sanhotrasoft. All rights reserved.
//

#import "AddDeviceViewController.h"
#import "BTLECentralClass.h"
#import "URL.h"
@interface AddDeviceViewController ()

@end

@implementation AddDeviceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    gofoundscreen=0;
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[self colorFromHexString:@"#f9f8f8"];
    [[BTLECentralClass sharedBTLECentralClass] initCentralMangager];
    [self getdeviceslist];
    UIActivityIndicatorView *wait=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    wait.frame=CGRectMake(60,85,130,60);
    
    UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(45,4,250,35)];
    lbl.text=@"Searching  Devices...";
    lbl.font=[UIFont fontWithName:@"oswald-regular" size:25.0f];
    lbl.textColor=[self colorFromHexString:@"#fc630f"];
    
    UILabel *lbl1=[[UILabel alloc] initWithFrame:CGRectMake(55,40,200,29)];
    lbl1.text=@"Please Tap your Numa Band";
    lbl1.font=[UIFont fontWithName:@"oswald-regular" size:15.0f];
    lbl1.textColor=[self colorFromHexString:@"#383635"];
    
    
    UIView *line=[[UIView alloc] initWithFrame:CGRectMake(20,150,280,2)];
    line.backgroundColor=[self colorFromHexString:@"#a4a4a4"];
    
    UIView *v=[[UIView alloc] initWithFrame:CGRectMake(20,30,300,80)];
    [v addSubview:lbl];
    [v addSubview:lbl1];
    [self.view addSubview:wait];
    [self.view addSubview:v];
    [self.view addSubview:line];
    
    UIButton *cancel=[[UIButton alloc] initWithFrame:CGRectMake(175,self.view.frame.size.height-50,90,35)];
    [cancel setTitle:@"CANCEL" forState:UIControlStateNormal];
    cancel.titleLabel.font=[UIFont fontWithName:@"oswald-regular" size:15.0f];
    cancel.tintColor=[UIColor whiteColor];
    cancel.backgroundColor=[self colorFromHexString:@"#f4346b"];
    cancel.layer.cornerRadius=4;
    [self.view addSubview:cancel];
    [cancel addTarget:self action:@selector(cancelaction) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *More=[[UIButton alloc] initWithFrame:CGRectMake(40,self.view.frame.size.height-50,110,35)];
    [More setTitle:@"More Devices" forState:UIControlStateNormal];
    More.titleLabel.font=[UIFont fontWithName:@"oswald-regular" size:15.0f];
    More.tintColor=[UIColor whiteColor];
    More.backgroundColor=[self colorFromHexString:@"#f4346b"];
    More.layer.cornerRadius=4;
    [self.view addSubview:More];
    [More addTarget:self action:@selector(moredevices) forControlEvents:UIControlEventTouchUpInside];
    
    
    _info=[[UILabel alloc] initWithFrame:CGRectMake(60,200,200,100)];
    _info.text=@"Your Numa Band List Appear Here Select device from list which you want to Save & Connect";
    _info.lineBreakMode=NSLineBreakByWordWrapping;
    _info.numberOfLines=5;
    _info.font=[UIFont fontWithName:@"oswald-regular" size:10.0f];
    _info.textColor=[self colorFromHexString:@"#383635"];
    [self.view addSubview:_info];
    
    _count=[[UILabel alloc] initWithFrame:CGRectMake(140,115,100,30)];
    _count.font=[UIFont fontWithName:@"oswald-regular" size:15.0f];
    _count.textColor=[self colorFromHexString:@"#383635"];
    [self.view addSubview:_count];
    _timer=[NSTimer scheduledTimerWithTimeInterval:0.7f target:self selector:@selector(animatedot) userInfo:nil repeats:YES];
    [_timer fire];
}
-(void)animatedot
{
  _count.text=[NSString stringWithFormat:@"%d of 40",gofoundscreen];
    if (gofoundscreen==40 && _devices.count==0)
    {
        gofoundscreen=0;
        [[BTLECentralClass sharedBTLECentralClass] stopCentralManagerScan];
        [_timer invalidate];
        [self popup];
    }
    else if(gofoundscreen==40 && _devices.count>0)
    {
        _count.text=@"Select Band";
        [_timer invalidate];
         gofoundscreen=0;
    }
    gofoundscreen++;
}
-(void)popup
{
    NSString *msg=@"Hey Do you want Buy \nnew Numa Band. !!!";

    //custom popup setting
    UIView *popview=[[UIView alloc] initWithFrame:CGRectMake(0,0,180,100)];
    popview.backgroundColor=[self colorFromHexString:@"#ececec"];
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"info.png"]];
    image.frame=CGRectMake(30,28,30,50);
    [popview addSubview:image];
    
    UILabel *lbl2=[[UILabel alloc] initWithFrame:CGRectMake(70,5,130,30)];
    lbl2.font=[UIFont fontWithName:@"oswald-regular" size:20.0f];
    lbl2.text=@"Suggestion";
    lbl2.textColor=[self colorFromHexString:@"#f3a64c"];
    lbl2.textAlignment=NSTextAlignmentCenter;
    [popview insertSubview:lbl2 atIndex:4];
    
    UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(80,15,150,90)];
    lbl.font=[UIFont fontWithName:@"oswald-regular" size:12.0f];
    lbl.lineBreakMode=NSLineBreakByWordWrapping;
    lbl.numberOfLines=5;
    lbl.text=msg;
    lbl.textColor=[self colorFromHexString:@"#858585"];
    //lbl.textAlignment=NSTextAlignmentRight;
    [popview insertSubview:lbl atIndex:5];

    _buyale=[[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Retry",@"Buy Band",@"Cancel",nil];
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
            [self moredevices];
        }
        else if(buttonIndex==1)
        {
            NSURL *url = [NSURL URLWithString:bandpurchaseurl];
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}
-(void)moredevices
{
    gofoundscreen=0;
    [[BTLECentralClass sharedBTLECentralClass] stopCentralManagerScan];
    [self getdeviceslist];
    [_timer invalidate];
    _timer=[NSTimer scheduledTimerWithTimeInterval:0.7f target:self selector:@selector(animatedot) userInfo:nil repeats:YES];
    [_timer fire];
}
-(void)cancelaction
{
    [[BTLECentralClass sharedBTLECentralClass] stopCentralManagerScan];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)getdeviceslist
{
    NSLog(@"getdevicelist called");
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

    [_info removeFromSuperview];
    _devicetable=[[UITableView alloc] initWithFrame:CGRectMake(20,175,280,self.view.frame.size.height-230) style:UITableViewStylePlain];
    _devicetable.delegate=self;
    _devicetable.dataSource=self;
    _devicetable.separatorStyle=UITableViewCellSeparatorStyleNone;
    _devicetable.backgroundColor=[self colorFromHexString:@"#f9f8f8"];
    [self.view addSubview:_devicetable];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _devices.count*2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    if (indexPath.row%2==0)
    {
        cell.backgroundColor=[self colorFromHexString:@"#f9f8f8"];
    }
    else
    {
        int index=indexPath.row/2;
        CBPeripheral *device=[_devices objectAtIndex:index];
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
        cell.layer.borderWidth=0.5;
        cell.layer.cornerRadius=3;
        cell.textLabel.font=[UIFont fontWithName:@"oswald-regular" size:20.0f];
    }
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    int index=indexPath.row/2;
    CBPeripheral *device=[_devices objectAtIndex:index];
    [[NSUserDefaults standardUserDefaults]setObject:device.name forKey:@"device_id"];
    [[NSUserDefaults standardUserDefaults] setObject:@"adddevice" forKey:@"addviewcontroller"];
    [[BTLECentralClass sharedBTLECentralClass] stopCentralManagerScan];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row%2==0)
    {
        return 20.0f;
    }
    else
    {
        return 65.0f;
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
-(void)viewDidDisappear:(BOOL)animated
{
    [[BTLECentralClass sharedBTLECentralClass] stopCentralManagerScan];
    [_timer invalidate];
}
@end
