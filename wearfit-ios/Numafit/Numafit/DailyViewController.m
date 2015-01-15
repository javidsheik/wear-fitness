//
//  ViewController.m
//  Numafit
//
//  Created by apple on 30/10/14.
//  Copyright (c) 2014 sanhotrasoft. All rights reserved.
//

#import "DailyViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"
#import "NUMA_ACTIVITIES.h"
#import "AFNetworking.h"
#import "BraceletModel.h"
#import "constVar.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "BTLECentralClass.h"
#import "AddDeviceViewController.h"
#import <Social/Social.h>
#import "URL.h"

#define degreesToRadians(x) ((x) * M_PI / 180.0)

@interface DailyViewController ()

@end

@implementation DailyViewController
{
    CAShapeLayer *backcircle;
    CAShapeLayer *datacircle;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setbackframes];
    
    //fb logout
    blestatus=0;
    batstatus=0;
    syncstatus=0;
    laststep=0;
    user_step_goal=10000;
    user_dist_goal=3000;
    user_cal_goal=500;
    _sync=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"sync"] style:UIBarButtonItemStylePlain target:self action:@selector(getdeviceslist)];
    
    _stopsync=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"stopsync"] style:UIBarButtonItemStylePlain target:self action:@selector(getdeviceslist)];
    self.navigationItem.rightBarButtonItem=_sync;

   [FBSession.activeSession closeAndClearTokenInformation];
   
    self.view.backgroundColor=[self colorFromHexString:@"#f1edee"];
    [self buttonsetting];
    [self defaultcircle];
    [self setheaderdateandtime];
    counter=5;
    _sharedataarr=[[NSMutableArray alloc] init];
    [_steps addTarget:self action:@selector(setvalueonbuttonclick:) forControlEvents:UIControlEventTouchUpInside];
    [_calories addTarget:self action:@selector(setvalueonbuttonclick:) forControlEvents:UIControlEventTouchUpInside];
    [_distance addTarget:self action:@selector(setvalueonbuttonclick:) forControlEvents:UIControlEventTouchUpInside];
    
    _timer=[NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(dataupdate) userInfo:nil repeats:YES];
    [_timer fire];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePeripheralData:) name:ConstUpdatingDateNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(devicedisconnected:) name:@"disconnected" object:nil];
}

-(void)devicedisconnected:(NSNotification*)notification
{
    CBPeripheral *device=notification.object;
    batstatus=0;
    syncstatus=0;
    self.navigationItem.rightBarButtonItem=_sync;
    
    NSString *msg=[NSString stringWithFormat:@"Device Disconnected Device : %@",device.name];
    UIAlertView *ale=[[UIAlertView alloc] initWithTitle:@"Warning" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [ale show];
}

-(void)getdeviceslist
{
    NSString *device_id=[[NSUserDefaults standardUserDefaults] objectForKey:@"device_id"];
    if (device_id!=nil)
    {
        if (blestatus==0)
        {
            //activityIndicator codeing
            UIActivityIndicatorView *wait=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            wait.color=[self colorFromHexString:@"#bfdecc"];
            UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(80,4,150,20)];
            lbl.text=@"Connecting Device...";
            lbl.font=[UIFont fontWithName:@"oswald-regular" size:15.0f];
            lbl.textColor=[self colorFromHexString:@"#bfdecc"];
            
            UILabel *lbl1=[[UILabel alloc] initWithFrame:CGRectMake(90,23,150,13)];
            lbl1.text=@"Please Tap your device";
            lbl1.font=[UIFont fontWithName:@"oswald-regular" size:10.0f];
            lbl1.textColor=[UIColor greenColor];
            
            
            UIView *v=[[UIView alloc] initWithFrame:CGRectMake(0,0,100,80)];
            [v addSubview:wait];
            [v addSubview:lbl];
            [v addSubview:lbl1];
            wait.frame=CGRectMake(120,43,30,30);
            v.backgroundColor=[self colorFromHexString:@"#636467"];
            _waitale=[[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            [wait startAnimating];
            [_waitale setValue:v forKey:@"accessoryView"];
            [_waitale show];
            
            
            //end activityindicator
            
            [[BTLECentralClass sharedBTLECentralClass] initCentralMangager];
            [[BTLECentralClass sharedBTLECentralClass] scan];
            [BTLECentralClass sharedBTLECentralClass].returnPeripherlsArray=^(NSArray *list)
            {
                dispatch_async(dispatch_get_main_queue(),^{
                    
                    for (CBPeripheral *device in list)
                    {
                        if (device_id !=nil && [device_id isEqualToString:device.name])
                        {
                            [_waitale dismissWithClickedButtonIndex:0 animated:YES];
                            [[BTLECentralClass sharedBTLECentralClass] connectPeripheral:device];
                            blestatus=10;
                            
                            _peripheral=device;
                            syncstatus=1;
                            self.navigationItem.rightBarButtonItem=_stopsync;
                            _synctime.text=@"Connected";
                            
                            [[NSUserDefaults standardUserDefaults] setObject:@"connect" forKey:@"disconnect_from_Profile"];
                        }
                    }
                    
                });
            };
        }
        else
        {
            [self connectanddisconnect];
        }
    }
    else
    {
        //if we not found any stored device then search for new device
        NSString *msg=@"Currently No Device Found Do you want search new Device ?";
        
        //custom popup setting
        UIView *popview=[[UIView alloc] initWithFrame:CGRectMake(0,0,280,100)];
        popview.backgroundColor=[self colorFromHexString:@"#ececec"];
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"warning.png"]];
        image.frame=CGRectMake(20,28,35,60);
        [popview addSubview:image];
        
        UILabel *lbl2=[[UILabel alloc] initWithFrame:CGRectMake(70,5,130,30)];
        lbl2.font=[UIFont fontWithName:@"oswald-regular" size:20.0f];
        lbl2.text=@"Warning";
        lbl2.textColor=[self colorFromHexString:@"#f3a64c"];
        lbl2.textAlignment=NSTextAlignmentCenter;
        [popview insertSubview:lbl2 atIndex:4];
        
        UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(80,15,180,90)];
        lbl.font=[UIFont fontWithName:@"oswald-regular" size:12.0f];
        lbl.lineBreakMode=NSLineBreakByWordWrapping;
        lbl.numberOfLines=5;
        lbl.text=msg;
        lbl.textColor=[self colorFromHexString:@"#ff926a"];
        //lbl.textAlignment=NSTextAlignmentRight;
        [popview insertSubview:lbl atIndex:5];
        
        _adddeviceale=[[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"NO",@"YES", nil];
        [_adddeviceale setValue:popview forKey:@"accessoryView"];
        [_adddeviceale show];
        //end custom popup
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView==_adddeviceale)
    {
        if (buttonIndex==1)
        {
            
            AddDeviceViewController *search =(AddDeviceViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"adddeviceseg"];
            [self presentViewController:search animated:YES completion:nil];
        }
    }
    else if (alertView==_waitale)
    {
        [[BTLECentralClass sharedBTLECentralClass] stopCentralManagerScan];
    }
    
}
-(void)connectanddisconnect
{
    if (syncstatus==0)
    {
        if (_peripheral!=nil)
        {
            syncstatus=1;
            self.navigationItem.rightBarButtonItem=_stopsync;
            [[BTLECentralClass sharedBTLECentralClass] connectPeripheral:_peripheral];
            _synctime.text=@"Connected";
            [[NSUserDefaults standardUserDefaults] setObject:@"connect" forKey:@"disconnect_from_Profile"];
        }
        else
        {
            //if we not found any stored device then search for new device
            NSString *msg=@"Device Not Found";
            
            //custom popup setting
            UIView *popview=[[UIView alloc] initWithFrame:CGRectMake(0,0,280,100)];
            popview.backgroundColor=[self colorFromHexString:@"#ececec"];
            UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"warning.png"]];
            image.frame=CGRectMake(20,28,35,60);
            [popview addSubview:image];
            
            UILabel *lbl2=[[UILabel alloc] initWithFrame:CGRectMake(70,5,130,30)];
            lbl2.font=[UIFont fontWithName:@"oswald-regular" size:20.0f];
            lbl2.text=@"Info";
            lbl2.textColor=[self colorFromHexString:@"#f3a64c"];
            lbl2.textAlignment=NSTextAlignmentCenter;
            [popview insertSubview:lbl2 atIndex:4];
            
            UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(80,15,180,90)];
            lbl.font=[UIFont fontWithName:@"oswald-regular" size:12.0f];
            lbl.lineBreakMode=NSLineBreakByWordWrapping;
            lbl.numberOfLines=5;
            lbl.text=msg;
            lbl.textColor=[self colorFromHexString:@"#858585"];
            //lbl.textAlignment=NSTextAlignmentRight;
            [popview insertSubview:lbl atIndex:5];
            
            UIAlertView *ale=[[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [ale setValue:popview forKey:@"accessoryView"];
            [ale show];
            //end custom popup
        }
    }
    else if(syncstatus==1)
    {
        syncstatus=0;
        self.navigationItem.rightBarButtonItem=_sync;
        [[BTLECentralClass sharedBTLECentralClass]disconnectPeripheral];
        
        //last sync time store here
        NSDateFormatter *formater=[[NSDateFormatter alloc] init];
        [formater setDateFormat:@"yyyy-MM-dd"];
        [[NSUserDefaults standardUserDefaults] setObject:[formater stringFromDate:[NSDate date]] forKey:@"sync_date"];
        [formater setDateFormat:@"hh:mm"];
        [[NSUserDefaults standardUserDefaults] setObject:[formater stringFromDate:[NSDate date]] forKey:@"sync_time"];
        [self setheaderdateandtime];
    }
}

-(void)dataupdate
{
    
    //call sync database to server
    //[self senddatatoserver];
}
-(void)buttonsetting
{
    UIColor *color=[self colorFromHexString:@"#817e7e"];
    [_steps setTitleColor:color forState:UIControlStateNormal];
    [_calories setTitleColor:color forState:UIControlStateNormal];
    [_distance setTitleColor:color forState:UIControlStateNormal];
    [_sleeping setTitleColor:color forState:UIControlStateNormal];
    _steps.tintColor=color;
    
    _steps.titleLabel.font=[UIFont fontWithName:@"oswald-regular" size:15.0f];
    _calories.titleLabel.font=[UIFont fontWithName:@"oswald-regular" size:15.0f];
    _distance.titleLabel.font=[UIFont fontWithName:@"oswald-regular" size:15.0f];
    _sleeping.titleLabel.font=[UIFont fontWithName:@"oswald-regular" size:15.0f];
    
    //all label font size and name
    _header.font=[UIFont fontWithName:@"oswald-regular" size:20.0f];
    _synctime.font=[UIFont fontWithName:@"oswald-bold" size:13.0f];
    
    UIView *cir;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"screen"]intValue]==40)
    {
        cir=[[UIView alloc] initWithFrame:CGRectMake(90,165+30,150,140)];
    }
    else
    {
        cir=[[UIView alloc] initWithFrame:CGRectMake(90,165,150,140)];
    }
    
    _donestep=[[UILabel alloc] initWithFrame:CGRectMake(10,7,130,45)];
    _goal=[[UILabel alloc] initWithFrame:CGRectMake(10,80,130,45)];
    _point=[[UILabel alloc] initWithFrame:CGRectMake(50,55,80,20)];
    
    _donestep.text=@"000";
    _goal.text=@"000";
    _point.text=@"Points";
    
    
    _donestep.textAlignment=NSTextAlignmentCenter;
    _goal.textAlignment=NSTextAlignmentCenter;
    _point.textAlignment=NSTextAlignmentCenter;
    
    _donestep.textColor=color;
    _goal.textColor=color;
    _point.textColor=[self colorFromHexString:@"#1fd0ad"];
    
    _goal.font=[UIFont fontWithName:@"oswald-bold" size:42.0f];
    _donestep.font=[UIFont fontWithName:@"oswald-bold" size:42.0f];
    _point.font=[UIFont fontWithName:@"oswald-bold" size:13.0f];
    
    
    UIImageView *star=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"star.png"]];
    star.frame=CGRectMake(32,50,25,25);
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(3,76,135,1)];
    lineView.backgroundColor = color;
    
    [cir addSubview:lineView];
    [cir addSubview:star];
    [cir addSubview:_goal];
    [cir addSubview:_donestep];
    [cir addSubview:_point];
    
    [self.view addSubview:cir];
    
    //UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(175,55,1,33)];
    //lineView2.backgroundColor = color;
    //[self.view addSubview:lineView2];
}

-(void)defaultcircle
{
    [backcircle removeFromSuperlayer];
    UIBezierPath *blank=[[UIBezierPath alloc] init];
    UIColor *color=[self colorFromHexString:@"#efecec"];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"screen"]intValue]==40)
    {
        [blank addArcWithCenter:CGPointMake(160,230+30) radius:95 startAngle:degreesToRadians(105) endAngle:degreesToRadians(434) clockwise:YES];
    }
    else
    {
        [blank addArcWithCenter:CGPointMake(160,230) radius:95 startAngle:degreesToRadians(105) endAngle:degreesToRadians(434) clockwise:YES];
    }
    backcircle=[CAShapeLayer layer];
    backcircle.path=blank.CGPath;
    backcircle.fillColor=[UIColor clearColor].CGColor;
    backcircle.lineWidth=17.0f;
    backcircle.strokeColor=color.CGColor;
    backcircle.lineCap=kCALineCapRound;
    
    backcircle.shadowOffset = CGSizeMake(3,3);
    backcircle.shadowRadius = 3.0;
    backcircle.shadowColor = [UIColor blackColor].CGColor;
    backcircle.shadowOpacity = 1;
    
    [self.view.layer addSublayer:backcircle];
}

-(void)createcircle :(int) circledata
{
    [self defaultcircle];
    [datacircle removeFromSuperlayer];
    
    //int circledata=75;
    
    if (circledata<=1)
    {
        circledata=2;
    }
    if (circledata>100)
    {
        circledata=100;
    }
    
    float angle=circledata*334/100;
    angle+=100.0f;
    
    UIColor *color=[self colorFromHexString:@"#1fd0ad"]; //66E6CC
    
    UIBezierPath *blank=[[UIBezierPath alloc] init];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"screen"]intValue]==40)
    {
        [blank addArcWithCenter:CGPointMake(160,230+30) radius:95 startAngle:degreesToRadians(105) endAngle:degreesToRadians(angle) clockwise:YES];
    }
    else
    {
        [blank addArcWithCenter:CGPointMake(160,230) radius:95 startAngle:degreesToRadians(105) endAngle:degreesToRadians(angle) clockwise:YES];
    }
    
    datacircle=[CAShapeLayer layer];
    datacircle.path=blank.CGPath;
    datacircle.fillColor=[UIColor clearColor].CGColor;
    datacircle.lineWidth=17.0f;
    datacircle.strokeColor=color.CGColor;
    datacircle.lineCap=kCALineCapRound;
    
    [self.view.layer addSublayer:datacircle];
    [self drawanimation:datacircle];
}
-(void)drawanimation:(CALayer *)layer
{
    CABasicAnimation *bas=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    bas.duration=2;
    bas.fromValue=[NSNumber numberWithInt:0];
    bas.toValue=[NSNumber numberWithInt:1];
    bas.delegate=self;
    [layer addAnimation:bas forKey:@"key"];
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
    [super touchesBegan:touches withEvent:event];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super hidemenu];
}
-(void)viewDidAppear:(BOOL)animated
{
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(0,5,70,20)];
    title.text=@"TODAY";
    title.font=[UIFont fontWithName:@"oswald-regular" size:20.0f];
    title.textColor=[UIColor whiteColor];
    self.navigationItem.titleView=title;
    
    _batrycontainer=[[UIView alloc] initWithFrame:CGRectMake(270,107,40,20)];
    UIImageView *batery=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"batry"]];
    batery.frame=CGRectMake(1,3,42,20);
    
    [_batrycontainer addSubview:batery];
    [self.view addSubview:_batrycontainer];
    
    
    UIButton *share=[[UIButton alloc] initWithFrame:CGRectMake(5,104,40,40)];
    [share setImage:[UIImage imageNamed:@"socialshare.png"] forState:UIControlStateNormal];
    [share addTarget:self action:@selector(shareonsocial) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:share];
    
    //this used set sync button if is disconnce from profile
    NSString *dev=[[NSUserDefaults standardUserDefaults]objectForKey:@"disconnect_from_Profile"];
    if (dev!=nil && [dev isEqualToString:@"disconnect"])
    {
        syncstatus=0;
        self.navigationItem.rightBarButtonItem=_sync;
        [self setheaderdateandtime];
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"disconnect_from_Profile"] ;
    }
    [self searchingstatus];
    [super viewDidLoad];
    
    //set goal target
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(viewgoal) userInfo:nil repeats:NO];
}
-(void)searchingstatus
{
    NSString *sta=[[NSUserDefaults standardUserDefaults]objectForKey:@"addviewcontroller"];
    if ([sta isEqualToString:@"adddevice"])
    {
        blestatus=0;
        [[NSUserDefaults standardUserDefaults] setObject:@"done" forKey:@"addviewcontroller"];
    }
}
-(void)setbatery:(NSString *)value
{
    [_per removeFromSuperview];
    [_fill removeFromSuperview];
    float val=[value floatValue];
    float per=val/100*34;
    UIColor *color;
    if (val<11)
    {
        color=[UIColor redColor];
    }
    else
    {
        color=[self colorFromHexString:@"#0994a4"];
    }
    
    _fill=[[UIView alloc] initWithFrame:CGRectMake(3.7,6,per,14.2)];
    _fill.backgroundColor=color;  //[UIColor greenColor];
    _fill.layer.cornerRadius=1;
    [_batrycontainer addSubview:_fill];
    _per=[[UILabel alloc] initWithFrame:CGRectMake(5,5,30,15)];
    _per.textAlignment=NSTextAlignmentCenter;
    _per.font=[UIFont fontWithName:@"oswald-regular" size:8.0f];
    _per.textColor=[UIColor blackColor];
    _per.text=[NSString stringWithFormat:@"%@%%",value];
    [_batrycontainer addSubview:_per];
}
-(void)setbackframes
{
    UIView *v1=[[UIView alloc] initWithFrame:CGRectMake(3,50,314,50)];
    UIView *v2;
    UIView *v3;
    UIView *v4;
    UIView *v5;
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"screen"]intValue]==40)
    {
        v2=[[UIView alloc] initWithFrame:CGRectMake(3,105,314,250+90)];
        v3=[[UIView alloc] initWithFrame:CGRectMake(3,360+90,314,117)];
        v4=[[UIView alloc] initWithFrame:CGRectMake(3,422+90,314,1)];
        v5=[[UIView alloc] initWithFrame:CGRectMake(160,360+90,1,119)];
    }
    else
    {
        v2=[[UIView alloc] initWithFrame:CGRectMake(3,105,314,250)];
        v3=[[UIView alloc] initWithFrame:CGRectMake(3,360,314,119)];
        v4=[[UIView alloc] initWithFrame:CGRectMake(3,422,314,1)];
        v5=[[UIView alloc] initWithFrame:CGRectMake(160,360,1,119)];
    }
    
    v1.backgroundColor=[UIColor whiteColor];
    v1.layer.borderWidth=1;
    v1.layer.borderColor=[self colorFromHexString:@"#adadad"].CGColor;
    [self.view insertSubview:v1 atIndex:0];
    
    v2.backgroundColor=[UIColor whiteColor];
    v2.layer.borderWidth=1;
    v2.layer.borderColor=[self colorFromHexString:@"#adadad"].CGColor;
    [self.view insertSubview:v2 atIndex:0];
    
    v3.backgroundColor=[UIColor whiteColor];
    v3.layer.borderWidth=1;
    v3.layer.borderColor=[self colorFromHexString:@"#adadad"].CGColor;
    [self.view insertSubview:v3 atIndex:0];
    
    v4.backgroundColor=[self colorFromHexString:@"#adadad"];
    [self.view addSubview:v4];
    
    v5.backgroundColor=[self colorFromHexString:@"#adadad"];
    [self.view addSubview:v5];
}

//read data from devce
-(void)updatePeripheralData:(NSNotification*)notification
{
    id object = notification.object;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5* NSEC_PER_SEC)), dispatch_get_main_queue(),
                   ^{
                       if([object isKindOfClass:[StepModel class]])
                       {
                           [self updateStepCountView:object];
                           
                       }
                       else if ([object isKindOfClass:[BatteryVolumeModel class]])
                       {
                           [self updateBatteryVolmeView:object];
                       }
                   });
}
-(void)updateStepCountView:(id)object
{
    StepModel *stepModel = object;
    if(!stepModel) stepModel =[BraceletModel sharedBraceletModel].stepModel;
    
    if (stepModel.stepCount!=nil &&stepModel.walkDistance!=nil && stepModel.calorie!=nil)
    {
        [_sharedataarr removeAllObjects];
        [_sharedataarr addObject:stepModel.stepCount];
        [_sharedataarr addObject:stepModel.calorie];
        [_sharedataarr addObject:stepModel.walkDistance];
        //call save dat to local
        
        NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
        [dict setObject:stepModel.calorie forKey:@"calories"];
        [dict setObject:stepModel.walkDistance forKey:@"distance"];
        [dict setObject:stepModel.stepCount forKey:@"steps"];
        [dict setObject:@"Sleeping" forKey:@"activity_type"];
        [self savedatatolocaldatbase:dict];
        if (laststep!=[stepModel.stepCount intValue])
        {
            [super hidemenu];
            [self setvalueonbuttonclick:_steps];
            //[self setheaderdateandtime];
        }
    }
}

-(void)setvalueonbuttonclick:(UIButton *)btn
{
    if (_sharedataarr.count>0)
    {
        float steps=[[_sharedataarr objectAtIndex:0] intValue];
        float calories=[[_sharedataarr objectAtIndex:1] intValue];
        float distance=[[_sharedataarr objectAtIndex:2] intValue];
        
        laststep=steps;
        int per=0;
        if (btn==_steps)
        {
            per=steps/user_step_goal*100;
            _donestep.text=[NSString stringWithFormat:@"%d",(int)steps];
            _goal.text=[NSString stringWithFormat:@"%d",user_step_goal];
            _point.text=@"Steps";
        }
        else if (btn==_distance)
        {
            per=distance/user_dist_goal*100;
            _donestep.text=[NSString stringWithFormat:@"%d",(int)distance];
            _goal.text=[NSString stringWithFormat:@"%d",user_dist_goal];
            _point.text=@"Distance(M)";
        }
        else if (btn==_calories)
        {
            per=calories/user_cal_goal*100;
            _donestep.text=[NSString stringWithFormat:@"%d",(int)calories];;
            _goal.text=[NSString stringWithFormat:@"%d",user_cal_goal];
            _point.text=@"Calories";
        }
        [self createcircle:per];
    }
}
-(void)updateBatteryVolmeView:(id)object
{
    BatteryVolumeModel * batteryModel = object;
    if(!batteryModel) batteryModel =[BraceletModel sharedBraceletModel].batteryVolumeModel;
    int batry=[batteryModel.batteryVolume intValue];
    if (batstatus==0 || batstatus!=batry)
    {
        [self setbatery:batteryModel.batteryVolume];
    }
}

-(void)savedatatolocaldatbase:(NSDictionary *)Activitydict
{
    //data fromats
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *date=[formatter stringFromDate:[NSDate date]];
    [formatter setDateFormat:@"dd"];
    NSNumber *day=[NSNumber numberWithInt:[[formatter stringFromDate:[NSDate date]]intValue]];
    [formatter setDateFormat:@"hh"];
    NSNumber *hour=[NSNumber numberWithInt:[[formatter stringFromDate:[NSDate date]]intValue]];
    [formatter setDateFormat:@"mm"];
    NSNumber *minute=[NSNumber numberWithInt:[[formatter stringFromDate:[NSDate date]]intValue]];
    [formatter setDateFormat:@"MM"];
    NSNumber *month=[NSNumber numberWithInt:[[formatter stringFromDate:[NSDate date]]intValue]];
    [formatter setDateFormat:@"ss"];
    NSNumber *sec=[NSNumber numberWithInt:[[formatter stringFromDate:[NSDate date]]intValue]];
    [formatter setDateFormat:@"yyyy"];
    NSNumber *year=[NSNumber numberWithInt:[[formatter stringFromDate:[NSDate date]]intValue]];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components1 = [gregorian components:NSWeekOfYearCalendarUnit fromDate:[NSDate date]];
    //end  date
    
    [formatter setDateFormat:@"a"];
    
    AppDelegate *app=[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *contex=app.managedObjectContext;
    NSFetchRequest *req=[[NSFetchRequest alloc] initWithEntityName:@"NUMA_ACTIVITIES"];
    NSError *err;
    NSArray *uid=[contex executeFetchRequest:req error:&err];
    NSPredicate *pre=[NSPredicate predicateWithFormat:@"date=%@",date];
    [req setPredicate:pre];
    
    NSArray *data=[contex executeFetchRequest:req error:&err];
    if (data.count==0)
    {
        NSLog(@"new record");
        NUMA_ACTIVITIES *activty=[NSEntityDescription insertNewObjectForEntityForName:@"NUMA_ACTIVITIES" inManagedObjectContext:contex];
        activty.uid=[NSNumber numberWithInt:(int)uid.count+1];
        activty.user_id=[[NSUserDefaults standardUserDefaults] objectForKey:@"ID"];
        activty.activity_type=[Activitydict objectForKey:@"activity_type"];
        activty.date=date;
        activty.day=day;
        activty.hour=hour;
        activty.minute=minute;
        activty.month=month;
        activty.sec=sec;
        activty.sum=[NSNumber numberWithInt:50];
        activty.year=year;
        activty.calories=[NSNumber numberWithFloat:[[Activitydict objectForKey:@"calories"]floatValue]];
        activty.distance=[NSNumber numberWithFloat:[[Activitydict objectForKey:@"distance"]floatValue]];
        activty.steps=[NSNumber numberWithInt:[[Activitydict objectForKey:@"steps"]intValue]];
        activty.sync_flag=[NSNumber numberWithInt:1];
        activty.activity_start_time=hour;
        activty.activity_start_time_unit=[formatter stringFromDate:[NSDate date]];
        activty.activity_end_time=hour;
        activty.activity_end_time_unit=[formatter stringFromDate:[NSDate date]];
        activty.week=[NSNumber numberWithInt:(int)components1.weekOfYear];
    }
    else
    {
        NSLog(@"Update only");
        for (NUMA_ACTIVITIES *act in data)
        {
            [act setValue:hour forKey:@"hour"];
            [act setValue:minute forKey:@"minute"];
            [act setValue:sec forKey:@"sec"];
            [act setValue:[NSNumber numberWithFloat:[[Activitydict objectForKey:@"calories"]floatValue]] forKey:@"calories"];
            [act setValue:[NSNumber numberWithFloat:[[Activitydict objectForKey:@"distance"]floatValue]] forKey:@"distance"];
            [act setValue:[NSNumber numberWithInt:[[Activitydict objectForKey:@"steps"]intValue]] forKey:@"steps"];
            [act setValue:[NSNumber numberWithInt:1] forKey:@"sync_flag"];
            [act setValue:hour forKey:@"activity_end_time"];
            [act setValue:[formatter stringFromDate:[NSDate date]] forKey:@"activity_end_time_unit"];
        }
        
    }
    
    if ([contex hasChanges])
    {
        [contex save:&err];
    }
}


//this block of code send data to server and update sync flag in to local database
//this is one way sync local to server
-(void)senddatatoserver
{
    AppDelegate *app=[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *contex=app.managedObjectContext;
    NSFetchRequest *request=[[NSFetchRequest alloc] initWithEntityName:@"NUMA_ACTIVITIES"];
    NSPredicate *pre=[NSPredicate predicateWithFormat:@"sync_flag=1"];
    [request setPredicate:pre];
    NSError *err;
    NSArray *recordtoupdate=[contex executeFetchRequest:request error:&err];
    if (recordtoupdate.count>0)
    {
        [self syncdata:recordtoupdate];
    }
}
-(void)syncdata :(NSArray *)database
{
    //activityIndicator codeing
    UIActivityIndicatorView *wait=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    wait.color=[self colorFromHexString:@"#bfdecc"];
    UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(83,4,120,20)];
    lbl.text=@"Syncing data...";
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
    NSMutableDictionary *data=[[NSMutableDictionary alloc] init];
    AFHTTPRequestOperationManager *request=[AFHTTPRequestOperationManager manager];
    //NSMutableString *data=[[NSMutableString alloc] init];
    
    NSString *token=[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"];
    NSString *user_id=[[NSUserDefaults standardUserDefaults] objectForKey:@"ID"];
    
    [data setObject:token forKey:@"token"];
    [data setObject:user_id forKey:@"user_id"];
    
    for (int i=0;i<database.count;i++)
    {
        NUMA_ACTIVITIES *obj=[database objectAtIndex:i];
        [data setObject:@"Activity" forKey:[NSString stringWithFormat:@"activity[%d][track_type]",i]];
        [data setObject:obj.activity_type forKey:[NSString stringWithFormat:@"activity[%d][Activity_type]",i]];
        [data setObject:obj.date forKey:[NSString stringWithFormat:@"activity[%d][date]",i]];
        [data setObject:obj.day forKey:[NSString stringWithFormat:@"activity[%d][day]",i]];
        [data setObject:obj.hour forKey:[NSString stringWithFormat:@"activity[%d][hour]",i]];
        [data setObject:obj.minute forKey:[NSString stringWithFormat:@"activity[%d][minute]",i]];
        [data setObject:obj.month forKey:[NSString stringWithFormat:@"activity[%d][month]",i]];
        [data setObject:obj.sec forKey:[NSString stringWithFormat:@"activity[%d][sec]",i]];
        [data setObject:obj.sum forKey:[NSString stringWithFormat:@"activity[%d][sum]",i]];
        [data setObject:obj.year forKey:[NSString stringWithFormat:@"activity[%d][year]",i]];
        [data setObject:obj.calories forKey:[NSString stringWithFormat:@"activity[%d][calories_burnt]",i]];
        [data setObject:obj.distance forKey:[NSString stringWithFormat:@"activity[%d][distance]",i]];
        [data setObject:obj.steps forKey:[NSString stringWithFormat:@"activity[%d][steps]",i]];
        [data setObject:obj.activity_start_time forKey:[NSString stringWithFormat:@"activity[%d][activity_start_time]",i]];
        [data setObject:obj.activity_start_time_unit forKey:[NSString stringWithFormat:@"activity[%d][activity_start_time_unit]",i]];
        [data setObject:obj.activity_end_time forKey:[NSString stringWithFormat:@"activity[%d][activity_end_time]",i]];
        [data setObject:obj.activity_end_time_unit forKey:[NSString stringWithFormat:@"activity[%d][activity_end_time_unit]",i]];
    }
    
    [request POST:@"https://numa.simpliot.com/api/track/load" parameters:data success:^(AFHTTPRequestOperation *operation ,id Responceobject)
     {
         [waitale dismissWithClickedButtonIndex:0 animated:YES];
         NSArray *res=[Responceobject objectForKey:@"data"];
         NSDictionary *dict=[res objectAtIndex:0];
         NSLog(@"responce=%@",Responceobject);
         if ([[dict objectForKey:@"status"]integerValue]==200)
         {
             UIAlertView *ale=[[UIAlertView alloc] initWithTitle:@"Status" message:[dict objectForKey:@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [ale show];
             [self updatesyncflag:database];
         }
         
     }
          failure:^(AFHTTPRequestOperation *operation ,NSError *err)
     {
         NSLog(@"error=%@",err);
         [waitale dismissWithClickedButtonIndex:0 animated:YES];
     }];
}
-(void)updatesyncflag :(NSArray *)recordtoupdate
{
    AppDelegate *app=[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *contex=app.managedObjectContext;
    NSFetchRequest *request=[[NSFetchRequest alloc] initWithEntityName:@"NUMA_ACTIVITIES"];
    NSPredicate *pre=[NSPredicate predicateWithFormat:@"sync_flag=1"];
    [request setPredicate:pre];
    NSError *err;
    NSArray *database=[contex executeFetchRequest:request error:&err];
    
    for (int i=0;i<recordtoupdate.count;i++)
    {
        NUMA_ACTIVITIES *a=[recordtoupdate objectAtIndex:i];
        NUMA_ACTIVITIES *b=[database objectAtIndex:i];
        
        if ([a.date isEqualToString:b.date])
        {
            [b setValue:[NSNumber numberWithInt:0] forKey:@"sync_flag"];
        }
    }
    if ([contex hasChanges])
    {
        [contex save:&err];
        [self loaddatafromserver];
    }
    [self showdatabase];
}


//end this block


//this block of code recive  data from server and update sync flag in to local database
//this is way to sync server dataabse to local database

-(void)loaddatafromserver
{
    
    //activityIndicator codeing
    UIActivityIndicatorView *wait=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    wait.color=[self colorFromHexString:@"#bfdecc"];
    UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(83,4,120,20)];
    lbl.text=@"Loding data...";
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
    //NSMutableArray *dataarr=[[NSMutableArray alloc] init];
    NSString *token=[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"];
    NSString *user_id=[[NSUserDefaults standardUserDefaults] objectForKey:@"ID"];
    NSString *url=[NSString stringWithFormat:@"http://numa.simpliot.com/api/activities/stats?user_id=%@&token=%@",user_id,token];
    [request GET:url parameters:nil success:^(AFHTTPRequestOperation *operation ,id Responceobject)
     {
         [waitale dismissWithClickedButtonIndex:0 animated:YES];
         NSLog(@"got responce iN load=%@",Responceobject);
         if ([[Responceobject objectForKey:@"status"]integerValue]==200)
         {
             
         }
     }
         failure:^(AFHTTPRequestOperation *operation ,NSError *err)
     {
         NSLog(@"error=%@",err);
         [waitale dismissWithClickedButtonIndex:0 animated:YES];
     }];
}

-(void)setheaderdateandtime
{
    NSString *date=[[NSUserDefaults standardUserDefaults] objectForKey:@"sync_date"];
    NSString *time=[NSString stringWithFormat:@"%@  Minutes",[[NSUserDefaults standardUserDefaults] objectForKey:@"sync_time"]];
    if (date!=nil && time!=nil)
    {
        _date.text=date;
        _synctime.text=time;
    }
    else
    {
        _date.text=@"No Update";
        _synctime.text=@"No Update";
    }
}
-(void)setstartupdata
{
    NSString *date=[[NSUserDefaults standardUserDefaults] objectForKey:@"sync_date"];
    AppDelegate *app=[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *contex=app.managedObjectContext;
    NSFetchRequest *request=[[NSFetchRequest alloc] initWithEntityName:@"NUMA_ACTIVITIES"];
    
    NSPredicate *pre=[NSPredicate predicateWithFormat:@"date=%@",date];
    [request setPredicate:pre];
    NSError *err;
    NSArray *database=[contex executeFetchRequest:request error:&err];
    for (NUMA_ACTIVITIES *n in database)
    {
        [_sharedataarr addObject:n.steps];
        [_sharedataarr addObject:n.calories];
        [_sharedataarr addObject:n.distance];
        [self setvalueonbuttonclick:_steps];
    }
}
-(void)shareonsocial
{
    //fb sharing
    NSString *msg;
    if (_sharedataarr.count>0)
    {
        msg=[NSString stringWithFormat:@"Yeh !!!My today Activity Score \nStep : %@ \nDistance : %@ \nCalories : %@",[_sharedataarr objectAtIndex:0],[_sharedataarr objectAtIndex:1],[_sharedataarr objectAtIndex:2]];
    }
    else
    {
        msg=@"Sory you don't have any data to post";
    }
    
    SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    [controller setInitialText:msg];
    [controller addURL:[NSURL URLWithString:bandpurchaseurl]];
    [self presentViewController:controller animated:YES completion:Nil];
}
-(void)viewgoal

{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"stepsgoal"]==nil)
    {
        NSUserDefaults *pref =[NSUserDefaults standardUserDefaults];
        NSString *token = [pref objectForKey:@"Token"];
        NSString *Id =[pref objectForKey:@"ID"];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString * string = [NSString stringWithFormat:@"http://numaforce.herokuapp.com/api/goals?user_id=%@&token=%@",Id,token];
        string = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [manager GET: string parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSMutableArray *data =[responseObject valueForKeyPath:@"data"];
            
            for(NSDictionary *dic in data)
            {
                if(![[dic objectForKey:@"daily_steps"] isEqual:[NSNull null]])
                {
                    user_step_goal =[[NSString stringWithFormat:@"%@",[dic objectForKey:@"daily_steps"]] intValue];
                }
                
                if(![[dic objectForKey:@"daily_distance"] isEqual:[NSNull null]])
                {
                    
                    user_dist_goal = [[NSString stringWithFormat:@"%@",[dic objectForKey:@"daily_distance"]] intValue];
                }
                
                if(![[dic objectForKey:@"daily_calories"] isEqual:[NSNull null]])
                {
                    user_cal_goal = [[NSString stringWithFormat:@"%@",[dic objectForKey:@"daily_calories"]]intValue];
                }
                
                [pref setObject:[NSNumber numberWithInt:user_cal_goal] forKey:@"caloriegoal"];
                [pref setObject:[NSNumber numberWithInt:user_step_goal] forKey:@"stepsgoal"];
                [pref setObject:[NSNumber numberWithInt:user_dist_goal] forKey:@"distgoal"];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             NSLog(@"error in goal=%@",operation.responseObject);
         }];
    }
    else
    {
        user_step_goal=[[[NSUserDefaults standardUserDefaults]objectForKey:@"stepsgoal"] intValue];
        user_cal_goal= [[[NSUserDefaults standardUserDefaults]objectForKey:@"caloriegoal"] intValue];
        user_dist_goal=[[[NSUserDefaults standardUserDefaults]objectForKey:@"distgoal"] intValue];
    }
    [self setstartupdata];
}




//this is temporory code to check database

-(void)showdatabase
{
    AppDelegate *app=[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *contex=app.managedObjectContext;
    NSFetchRequest *request=[[NSFetchRequest alloc] initWithEntityName:@"NUMA_ACTIVITIES"];
    NSError *err;
    NSArray *database=[contex executeFetchRequest:request error:&err];
    for (NUMA_ACTIVITIES *n in database)
    {
        NSLog(@"Sync flag=%@",n.sync_flag);
        NSLog(@"week of months=%@",n.week);
    }
}
@end

