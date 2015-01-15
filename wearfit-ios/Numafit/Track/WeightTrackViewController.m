//
//  WeightTrackViewController.m
//  Numafit
//
//  Created by apple on 07/11/14.
//  Copyright (c) 2014 sanhotrasoft. All rights reserved.
//

#import "WeightTrackViewController.h"
#import "AFNetworking.h"
#include "URL.h"
@interface WeightTrackViewController ()

@end

@implementation WeightTrackViewController

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
    
    _unitlist=[[NSArray alloc] initWithObjects:@"Kgs",@"Gms",@"Oz",@"Lbs",nil];
    [_timetext addTarget:self action:@selector(openpicker) forControlEvents:UIControlEventTouchUpInside];
    self.view.backgroundColor=[self colorFromHexString:@"#f3f0f0"];
    [self setcolorsetting];
    // Do any additional setup after loading the view.
}
-(void)setcolorsetting
{
    UIColor *color=[self colorFromHexString:@"#767373"];
    _qtylabel.font=[UIFont fontWithName:@"oswald-regular" size:19.0f];
    _qtylabel.textColor=color;
    
    _unitlabel.font=[UIFont fontWithName:@"oswald-regular" size:19.0f];
    _unitlabel.textColor=color;
    
    _todaylabel.font=[UIFont fontWithName:@"oswald-regular" size:19.0f];
    _todaylabel.textColor=[self colorFromHexString:@"#f643d9"];
    
    _timelabel.font=[UIFont fontWithName:@"oswald-regular" size:19.0f];
    _timelabel.textColor=color;
    
    _savebutton=[[UIButton alloc] init];
    _cancelbutton=[[UIButton alloc] init];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"screen"]intValue]==40)
    {
        _savebutton.frame=CGRectMake(35, 370+25, 251, 45);
        _cancelbutton.frame=CGRectMake(35, 425+40, 251, 45);
    }
    else
    {
        _savebutton.frame=CGRectMake(35, 370, 251, 45);
        _cancelbutton.frame=CGRectMake(35, 425, 251, 45);
    }
    
    [_savebutton setTitle:@"SAVE" forState:UIControlStateNormal];
    [_cancelbutton setTitle:@"CANCEL" forState:UIControlStateNormal];
    
    
    [_cancelbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _cancelbutton.titleLabel.font=[UIFont fontWithName:@"oswald-regular" size:19.0f];
    _cancelbutton.backgroundColor=[self colorFromHexString:@"#fa5e92"];
    _cancelbutton.layer.cornerRadius=5.0f;
    [_cancelbutton addTarget:self action:@selector(cancelbtnaction) forControlEvents:UIControlEventTouchUpInside];
    
    [_savebutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _savebutton.titleLabel.font=[UIFont fontWithName:@"oswald-regular" size:19.0f];
    _savebutton.backgroundColor=[self colorFromHexString:@"#30d4fd"];
    _savebutton.layer.cornerRadius=5.0f;
    [_savebutton addTarget:self action:@selector(saveuserdata) forControlEvents:UIControlEventTouchUpInside];
    
    _qtytext.layer.cornerRadius=5.0f;
    _qtytext.font=[UIFont fontWithName:@"oswald-regular" size:19.0f];
    _qtytext.textColor=[self colorFromHexString:@"#a9a6a6"];
    _qtytext.text=@"40";
    _timetext.layer.cornerRadius=5.0f;
    _timetext.titleLabel.font=[UIFont fontWithName:@"oswald-regular" size:19.0f];
    [_timetext setTitleColor:[self colorFromHexString:@"#a9a6a6"] forState:UIControlStateNormal];
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"hh"];
    [_timetext setTitle:[format stringFromDate:[NSDate date]] forState:UIControlStateNormal];
    
    [_timetype setTitleColor:[self colorFromHexString:@"#a9a6a6"] forState:UIControlStateNormal];
    _timetype.titleLabel.font=[UIFont fontWithName:@"oswald-regular" size:19.0f];
    _timetype.layer.cornerRadius=5.0f;
    [_timetype setTitle:@"AM" forState:UIControlStateNormal];
    
    [_watterunit setTitleColor:[self colorFromHexString:@"#a9a6a6"] forState:UIControlStateNormal];
    _watterunit.titleLabel.font=[UIFont fontWithName:@"oswald-regular" size:19.0f];
    _watterunit.layer.cornerRadius=5.0f;
    [_watterunit setTitle:@"Kgs" forState:UIControlStateNormal];
    [_watterunit addTarget:self action:@selector(popup:) forControlEvents:UIControlEventTouchUpInside];
    
    _cotainer.backgroundColor=[self colorFromHexString:@"#ddd9d9"];
    [self.view addSubview:_savebutton];
    [self.view addSubview:_cancelbutton];
}
-(void)cancelbtnaction
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)hide
{
    [_timetext resignFirstResponder];
}

-(void)popup:(UIButton *)btn
{
    [_pop removeFromSuperview];
    _pop=[[UITableView alloc]initWithFrame:CGRectMake(204,187,96,44*2) style:UITableViewStylePlain];
    _pop.frame=CGRectMake(204,187,96,44*2);
    _pop.delegate=self;
    _pop.dataSource=self;
    _pop.layer.cornerRadius=5.0f;
    [self.view addSubview:_pop];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _unitlist.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text=[_unitlist objectAtIndex:indexPath.row];
    cell.textLabel.font=[UIFont fontWithName:@"oswald-regular" size:15.0f];
    cell.backgroundColor=[self colorFromHexString:@"#edebeb"];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_watterunit setTitle:[_unitlist objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    [_pop removeFromSuperview];
}
-(UIColor *)colorFromHexString:(NSString *)hexString
{
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1];
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}
-(void)openpicker
{
    [_pic removeFromSuperview];
    _pic=[[UIDatePicker alloc] init];
    [_pic setFrame:CGRectMake(20,277,160,20)];
    _pic.datePickerMode=UIDatePickerModeTime;
    _pic.timeZone=[NSTimeZone localTimeZone];
    _pic.backgroundColor=[self colorFromHexString:@"#edebeb"];
    _pic.layer.cornerRadius=5.0f;
    _pic.clipsToBounds=YES;
    [self.view addSubview:_pic];
    [_pic addTarget:self action:@selector(done) forControlEvents:UIControlEventValueChanged];
}
-(void)done
{
    NSDateFormatter *f=[[NSDateFormatter alloc] init];
    [f setDateFormat:@"hh"];
    [_timetext setTitle:[f stringFromDate:_pic.date] forState:UIControlStateNormal];
    [f setDateFormat:@"a"];
    [_timetype setTitle:[f stringFromDate:_pic.date] forState:UIControlStateNormal];
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_pop removeFromSuperview];
    [_pic removeFromSuperview];
    [_qtytext resignFirstResponder];
}
-(BOOL)prefersStatusBarHidden
{
    return YES;
}
-(void)viewDidAppear:(BOOL)animated
{
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(0,5,70,25)];
    title.text=@"Weight Track";
    title.font=[UIFont fontWithName:@"oswald-regular" size:19.0f];
    title.textColor=[UIColor whiteColor];
    self.navigationItem.titleView=title;
    self.navigationController.navigationBar.backItem.title=@"Track";
}
-(void)saveuserdata
{
    NSURL *url = [NSURL URLWithString:Netcheckurl];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    if (data)
    {
        //activityIndicator codeing
        UIActivityIndicatorView *wait=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        wait.color=[self colorFromHexString:@"#bfdecc"];
        UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(105,4,80,20)];
        lbl.text=@"Saving Info...";
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
        
        if ([_qtytext.text intValue]<251)
        {
            AFHTTPRequestOperationManager *request=[AFHTTPRequestOperationManager manager];
            NSString *userid=[[NSUserDefaults standardUserDefaults] objectForKey:@"ID"];
            NSString *token=[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"];
            NSDictionary *postdata=@{@"user_id":userid,@"track_type":@"Weight",
                                     @"unit":[_watterunit.titleLabel.text lowercaseString],
                                     @"consumed_value":_qtytext.text,@"token":token,
                                     @"consumed_time":_timetext.titleLabel.text,
                                     @"consumed_time_unit":_timetype.titleLabel.text};
            
            [request POST:WeightTrack parameters:postdata success:^(AFHTTPRequestOperation *operation, id responseObject)
             {
                 [waitale dismissWithClickedButtonIndex:0 animated:YES];
                 if ([[responseObject objectForKey:@"status"]intValue]==200)
                 {
                     NSDictionary *data=[responseObject objectForKey:@"data"];
                     if ([[data objectForKey:@"status"]intValue]==200)
                     {
                        [self popup:[data objectForKey:@"message"]  Title:@"Status" image:@"sucess.png"];
                     }
                     else
                     {
                        [self popup:[data objectForKey:@"message"]  Title:@"Status" image:@"error.png"];
                     }
                 }
                 
                
             } failure:^(AFHTTPRequestOperation *operation,NSError *err)
             {
                 [self popup:message_503  Title:title_503 image:@"ServerError.png"];
             }];
            
            
        } else
        {
             [waitale dismissWithClickedButtonIndex:0 animated:YES];
            [self popup:@"Your Weight Between 5-250"  Title:@"Warning" image:@"warning.png"];
        }
    }
    else
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
