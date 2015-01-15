//
//  TrackViewController.m
//  Numafit
//
//  Created by iHotra-LT-02 on 03/11/14.
//  Copyright (c) 2014 sanhotrasoft. All rights reserved.
//

#import "TrackViewController.h"
#import "FoodtrackViewController.h"
#import "ActivitytrackViewController.h"
#import "WaterTrackViewController.h"
#import "WeightTrackViewController.h"
#import "EventViewController.h"

@interface TrackViewController ()

@end

@implementation TrackViewController

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
    // Do any additional setup after loading the view.
    self.eventsview = [[UIView alloc]init];
    self.foodview = [[UIView alloc]init];
    self.weightview = [[UIView alloc]init];
    self.activityview = [[UIView alloc]init];
    self.waterview = [[UIView alloc]init];
    self.events =[[UILabel alloc]init];
    self.weight = [[UILabel alloc]init];
    self.food =[[UILabel alloc]init];
    self.water=[[UILabel alloc]init];
    self.activity1=[[UILabel alloc]init];
    self.foodimage =[[UIImageView alloc]init];
    self.weightimage = [[UIImageView alloc]init];
    self.waterimage = [[UIImageView alloc]init];
    self.activityimage = [[UIImageView alloc]init];
    self.eventimage = [[UIImageView alloc]init];
    self.foodimage1 = [[UIButton alloc]init];
    self.waterimage1 =[[UIButton alloc]init];
    self.weightimage1=[[UIButton alloc]init];
    self.activityimage1 =[[UIButton alloc]init];
    self.eventimage1 =[[UIButton alloc]init];
    CGSize result = [[UIScreen mainScreen] bounds].size;
    
    
    self.foodimage1.frame = CGRectMake(52, 40, 50, 60);
    [self.foodimage1 setImage:[UIImage imageNamed:@"Untitled-1_11"] forState:UIControlStateNormal];
    self.waterimage1.frame = CGRectMake(52, 40, 50, 60);
    [self.waterimage1 setImage:[UIImage imageNamed:@"Untitled-1_15"] forState:UIControlStateNormal];
    self.weightimage1.frame = CGRectMake(52, 40, 50, 60);
    [self.weightimage1 setImage:[UIImage imageNamed:@"Untitled-1_19"] forState:UIControlStateNormal];
    self.activityimage1.frame = CGRectMake(52, 40, 50, 60);
    [self.activityimage1 setImage:[UIImage imageNamed:@"Untitled-1_23"] forState:UIControlStateNormal];
    self.eventimage1.frame = CGRectMake(120, 25, 67, 67);
    [self.eventimage1 setImage:[UIImage imageNamed:@"Untitled-1_26"] forState:UIControlStateNormal];
    self.eventsview.frame = CGRectMake(11, 395, 300, 130);
    self.events.frame = CGRectMake(130, 95, 50, 40);
    self.events.text = @"EVENT";
    
    self.weight.frame = CGRectMake(45, 110, 70, 40);
    self.weight.text = @"WEIGHT";
    self.activity1.frame = CGRectMake(42, 110, 70, 40);
    self.activity1.text = @"ACTIVITY";
    self.food.frame = CGRectMake(55, 110, 50, 40);
    self.food.text = @"FOOD";
    
    self.water.frame = CGRectMake(46, 110, 50, 40);
    self.water.text = @"WATER";
    //        self.events.backgroundColor = [UIColor redColor];
    
    //        self.eventsview.frame = CGRectMake(158, 470, 262, 120);
    //  self.eventsview.backgroundColor = [self colorFromHexString:@"#b2b2ff"];
    self.weightview.frame = CGRectMake(11, 242, 145, 145);
    
    self.activityview.frame = CGRectMake(165, 242, 145, 145);
    self.waterview.frame = CGRectMake(165, 90, 145, 145);
    self.foodview.frame = CGRectMake(11, 90, 145, 145);
    
    
    if(result.height == 568)
        
    {
        
    }
    
    if(result.height ==480)
    {
        self.weightview.frame = CGRectMake(15, 209, 138, 135);
        
        self.activityview.frame = CGRectMake(165, 209, 138, 135);
        self.waterview.frame = CGRectMake(165, 65, 138, 135);
        self.foodview.frame = CGRectMake(15, 65, 138, 135);
        self.eventsview.frame = CGRectMake(15, 353, 287, 110);
        self.events.frame = CGRectMake(120, 72, 50, 40);
        self.events.text = @"EVENT";
        
        self.weight.frame = CGRectMake(42, 95, 70, 40);
        self.weight.text = @"WEIGHT";
        self.activity1.frame = CGRectMake(35, 95, 70, 40);
        self.activity1.text = @"ACTIVITY";
        self.food.frame = CGRectMake(47, 95, 50, 40);
        self.food.text = @"FOOD";
        
        self.water.frame = CGRectMake(43, 95, 50, 40);
        self.water.text = @"WATER";
        
        self.foodimage1.frame = CGRectMake(47, 35, 45, 55);
        [self.foodimage1 setImage:[UIImage imageNamed:@"Untitled-1_11"] forState:UIControlStateNormal];
        self.waterimage1.frame =CGRectMake(47, 35, 45, 55);
        [self.waterimage1 setImage:[UIImage imageNamed:@"Untitled-1_15"] forState:UIControlStateNormal];
        self.weightimage1.frame = CGRectMake(47, 35, 45, 55);
        [self.weightimage1 setImage:[UIImage imageNamed:@"Untitled-1_19"] forState:UIControlStateNormal];
        self.activityimage1.frame = CGRectMake(47, 35, 45, 55);
        [self.activityimage1 setImage:[UIImage imageNamed:@"Untitled-1_23"] forState:UIControlStateNormal];
        self.eventimage1.frame = CGRectMake(115, 20, 55, 55);
        [self.eventimage1 setImage:[UIImage imageNamed:@"Untitled-1_26"] forState:UIControlStateNormal];
        
    }
    self.foodview.backgroundColor = [self colorFromHexString:@"#ff8aec"];
    self.waterview.backgroundColor = [self colorFromHexString:@"#8ed4fb"];
    self.weightview.backgroundColor = [self colorFromHexString:@"#fb8ec4"];
    self.activityview.backgroundColor = [self colorFromHexString:@"#c9e1a7"];
    self.eventsview.backgroundColor = [self colorFromHexString:@"#b2b2ff"];
    self.view.backgroundColor = [self colorFromHexString:@"#efecec"];
    self.food.font = [UIFont fontWithName:@"oswald-regular" size:19.0f];
    self.food.font = [UIFont fontWithName:@"oswald-regular" size:19.0f];
    self.water.font = [UIFont fontWithName:@"oswald-regular" size:19.0f];
    self.weight.font = [UIFont fontWithName:@"oswald-regular" size:19.0f];
    self.activity1.font = [UIFont fontWithName:@"oswald-regular" size:19.0f];
    self.events.font = [UIFont fontWithName:@"oswald-regular" size:19.0f];
    self.events.textColor =[UIColor whiteColor];
    self.weight.textColor =[UIColor whiteColor];
    self.food.textColor =[UIColor whiteColor];
    self.water.textColor = [UIColor whiteColor];
    self.activity1.textColor = [UIColor whiteColor];
    
    
    [self.view addSubview:self.foodview];
    [self.foodview addSubview:self.food];
    [self.foodview addSubview:self.foodimage1];
    
    [self.view addSubview:self.waterview];
    [self.waterview addSubview:self.water];
    [self.waterview addSubview:self.waterimage1];
    
    [self.view addSubview:self.weightview];
    [self.weightview addSubview:self.weight];
    [self.weightview addSubview:self.weightimage1];
    
    [self.view addSubview:self.activityview];
    [self.activityview addSubview:self.activity1];
    [self.activityview addSubview:self.activityimage1];
    
    [self.view addSubview:self.eventsview];
    [self.eventsview addSubview:self.events];
    [self.eventsview addSubview:self.eventimage1];
    //button events
    [self.foodimage1 addTarget:self action:@selector(foodtrack) forControlEvents:UIControlEventTouchUpInside];
    [self.activityimage1 addTarget:self action:@selector(activitytrack) forControlEvents:UIControlEventTouchUpInside];
    [self.waterimage1 addTarget:self action:@selector(watertrack) forControlEvents:UIControlEventTouchUpInside];
    
    [self.weightimage1 addTarget:self action:@selector(weighttrack) forControlEvents:UIControlEventTouchUpInside];
    
    [self.eventimage1 addTarget:self action:@selector(eventtrack) forControlEvents:UIControlEventTouchUpInside];
    
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(foodtrack)];
    [self.foodview addGestureRecognizer:singleFingerTap];
    UITapGestureRecognizer *singleFingerTap1 =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(watertrack)];
    
    [self.waterview addGestureRecognizer:singleFingerTap1];
    UITapGestureRecognizer *singleFingerTap2 =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(weighttrack)];
    [self.weightview addGestureRecognizer:singleFingerTap2];
    UITapGestureRecognizer *singleFingerTap3 =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(activitytrack)];
    [self.activityview addGestureRecognizer:singleFingerTap3];
    
    UITapGestureRecognizer *singleFingerTap4 =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(eventtrack)];
    [self.eventsview addGestureRecognizer:singleFingerTap4];
    
    [self.eventimage1 addTarget:self action:@selector(eventtrack) forControlEvents:UIControlEventTouchUpInside];
    
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    return YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(0,5,70,20)];
    title.text=@"Track";
    title.font=[UIFont fontWithName:@"oswald-regular" size:20.0f];
    title.textColor=[UIColor whiteColor];
    self.navigationItem.titleView=title;
    [super viewDidLoad];
}

- (void)foodtrack
{
    FoodtrackViewController *track=(FoodtrackViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"foodtrack"];
    [self.navigationController pushViewController:track animated:YES];
    
}

- (void)activitytrack {
    ActivitytrackViewController *track=(ActivitytrackViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"activity"];
    [self.navigationController pushViewController:track animated:YES];
}

- (void)watertrack {
    
    WaterTrackViewController *track=(WaterTrackViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"water"];
    [self.navigationController pushViewController:track animated:YES];
}
- (void)weighttrack
{
    WeightTrackViewController *track=(WeightTrackViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"weight"];
    [self.navigationController pushViewController:track animated:YES];
    
}
- (void)eventtrack
{
    EventViewController *event=(EventViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"event"];
    [self.navigationController pushViewController:event animated:YES];
}

-(UIColor *)colorFromHexString:(NSString *)hexString
{
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
    
}
-(BOOL)prefersStatusBarHidden
{
    
    return YES;
}

@end
