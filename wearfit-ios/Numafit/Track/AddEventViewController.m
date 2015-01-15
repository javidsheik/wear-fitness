//
//  AddEventViewController.m
//  Numafit
//
//  Created by apple on 17/11/14.
//  Copyright (c) 2014 sanhotrasoft. All rights reserved.
//

#import "AddEventViewController.h"
#import "AFNetworking.h"
#import "ShareEventViewController.h"
#include "URL.h"
#import <GoogleMaps/GoogleMaps.h>

@interface AddEventViewController ()
{
    GMSMapView *map;
}
@end

@implementation AddEventViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    srcstatus=0;
    deststatus=0;
    self.view.backgroundColor=[self colorFromHexString:@"#ffffff"];
    _pic=[[UIDatePicker alloc] init];
    _locationlist=[[NSMutableArray alloc] init];
    // Do any additional setup after loading the view.
    [_savebtn addTarget:self action:@selector(savedata) forControlEvents:UIControlEventTouchUpInside];
    _savebtn.titleLabel.font=[UIFont fontWithName:@"oswald-regular" size:19.0f];
    _savebtn.layer.cornerRadius=5.0f;
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86 longitude:151.20  zoom:6];
    map =[GMSMapView mapWithFrame:CGRectMake(2,120,316,160) camera:camera];
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    
    map.myLocationEnabled = YES;
    CLLocation *loc=map.myLocation;
    marker.position = CLLocationCoordinate2DMake(loc.coordinate.latitude,loc.coordinate.longitude);
    marker.title = @"MY location";
    marker.snippet = @"";
    map.layer.borderWidth=3;
    map.layer.cornerRadius=2;
    map.layer.borderColor=[self colorFromHexString:@"#c7c2c2"].CGColor;
    
    GMSCameraPosition *camera2 = [GMSCameraPosition cameraWithLatitude:loc.coordinate.latitude
                                                             longitude:loc.coordinate.longitude
                                                                  zoom:10];
    
    [map setCamera:camera2];
    marker.map =map;
    [self.view addSubview:map];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"screen"]intValue]==40)
    {
        _scroll=[[UIScrollView alloc] initWithFrame:CGRectMake(0,285,320,200+83)];
        rect=CGRectMake(0,285,320,200+83);
    }
    else
    {
        _scroll=[[UIScrollView alloc] initWithFrame:CGRectMake(0,285,320,200)];
        rect=CGRectMake(0,285,320,200);
    }
    _scroll.delegate=self;
    _scroll.showsVerticalScrollIndicator=NO;
    [self mapcode];
    [self allinputfield];
}
-(void)allinputfield
{
    _contailner=[[UIView alloc] init];
    _contailner.frame=CGRectMake(0,0,320,400);
    _contailner.backgroundColor=[self colorFromHexString:@"#ffffff"];
    UIColor *color=[self colorFromHexString:@"#747171"];
    UIColor *bor=[self colorFromHexString:@"#c7c2c2"];
    UILabel *n=[[UILabel alloc] initWithFrame:CGRectMake(20,2,180,25)];
    n.text=@"Event Name";
    n.font=[UIFont fontWithName:@"oswald-regular" size:16.0f];
    n.textColor=color;
    [_contailner addSubview:n];
    
    _name=[[UITextField alloc] initWithFrame:CGRectMake(20,30,280,30)];
    _name.layer.cornerRadius=3.0f;
    _name.layer.borderWidth=1;
    _name.layer.borderColor=bor.CGColor;
    _name.font=[UIFont fontWithName:@"oswald-regular" size:14.0f];
    
    
    UILabel *d=[[UILabel alloc] initWithFrame:CGRectMake(20,67,180,25)];
    d.text=@"Event Discription";
    d.font=[UIFont fontWithName:@"oswald-regular" size:16.0f];
    d.textColor=color;
    [_contailner addSubview:d];
    
    _discription=[[UITextField alloc] initWithFrame:CGRectMake(20,93,280,30)];
    _discription.layer.cornerRadius=3.0f;
    _discription.layer.borderWidth=1;
    _discription.layer.borderColor=bor.CGColor;
    _discription.font=[UIFont fontWithName:@"oswald-regular" size:14.0f];
    
    
    UILabel *da=[[UILabel alloc] initWithFrame:CGRectMake(20,127,180,25)];
    da.text=@"Event Date";
    da.font=[UIFont fontWithName:@"oswald-regular" size:16.0f];
    da.textColor=color;
    [_contailner addSubview:da];
    
    _date=[[UIButton alloc] initWithFrame:CGRectMake(20,153,280,30)];
    _date.layer.cornerRadius=3.0f;
    _date.layer.borderWidth=1;
    _date.layer.borderColor=bor.CGColor;
    _date.titleLabel.font=[UIFont fontWithName:@"oswald-regular" size:14.0f];
    [_date addTarget:self action:@selector(openpicker:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *s=[[UILabel alloc] initWithFrame:CGRectMake(20,190,180,25)];
    s.text=@"Start Time";
    s.font=[UIFont fontWithName:@"oswald-regular" size:16.0f];
    s.textColor=color;
    [_contailner addSubview:s];
    
    _starttime=[[UIButton alloc] initWithFrame:CGRectMake(20,215,130,30)];
    _starttime.layer.cornerRadius=3.0f;
    _starttime.layer.borderWidth=1;
    _starttime.layer.borderColor=bor.CGColor;
    _starttime.titleLabel.font=[UIFont fontWithName:@"oswald-regular" size:14.0f];
    [_starttime addTarget:self action:@selector(openpicker:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *e=[[UILabel alloc] initWithFrame:CGRectMake(170,190,180,25)];
    e.text=@"End Time";
    e.font=[UIFont fontWithName:@"oswald-regular" size:16.0f];
    e.textColor=color;
    [_contailner addSubview:e];
    
    _endtime=[[UIButton alloc] initWithFrame:CGRectMake(170,215,130,30)];
    _endtime.layer.cornerRadius=3.0f;
    _endtime.layer.borderWidth=1;
    _endtime.layer.borderColor=bor.CGColor;
    _endtime.titleLabel.font=[UIFont fontWithName:@"oswald-regular" size:14.0f];
    [_endtime addTarget:self action:@selector(openpicker:) forControlEvents:UIControlEventTouchUpInside];
    
    _savebtn=[[UIButton alloc] initWithFrame:CGRectMake(20,260,130,35)];
    _savebtn.layer.cornerRadius=3.0f;
    [_savebtn setTitle:@"SAVE" forState:UIControlStateNormal];
    _savebtn.titleLabel.font=[UIFont fontWithName:@"oswald-regular" size:19.0f];
    _savebtn.backgroundColor=[self colorFromHexString:@"#06f9d4"];
    [_savebtn addTarget:self action:@selector(savedata:) forControlEvents:UIControlEventTouchUpInside];
    
    _cancel=[[UIButton alloc] initWithFrame:CGRectMake(170,260,130,35)];
    _cancel.layer.cornerRadius=3.0f;
    [_cancel setTitle:@"CANCEL" forState:UIControlStateNormal];
    _cancel.titleLabel.font=[UIFont fontWithName:@"oswald-regular" size:19.0f];
    _cancel.backgroundColor=[self colorFromHexString:@"#f9597b"];
    [_cancel addTarget:self action:@selector(savedata:) forControlEvents:UIControlEventTouchUpInside];
    
    [_contailner addSubview:_name];
    [_contailner addSubview:_discription];
    
    [_contailner addSubview:_starttime];
    [_contailner addSubview:_endtime];
    
    [_contailner addSubview:_date];
    [_contailner addSubview:_savebtn];
    [_contailner addSubview:_cancel];
    
    
    _scroll.contentSize=CGSizeMake(_contailner.frame.size.width, _contailner.frame.size.height);
    _scroll.showsHorizontalScrollIndicator=YES;
    _scroll.scrollEnabled=YES;
    _scroll.userInteractionEnabled=YES;
    _name.delegate=self;
    _discription.delegate=self;
    [_scroll addSubview:_contailner];
    [self.view addSubview:_scroll];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField==_name || textField==_discription)
    {
        _scroll.frame=CGRectMake(_scroll.frame.origin.x,_scroll.frame.origin.y-100,_scroll.frame.size.width,_scroll.frame.size.height);
    }
}
//get user location and allow user to search location form map
-(void)savedata:(UIButton *)btn
{
    if (btn==_savebtn)
    {
        if (start.latitude==0.000000)
        {
            [self popup:@"Source Location Not Added"  Title:@"Warning" image:@"warning.png"];
        }
        else if(end.latitude==0.000000)
        {
            [self popup:@"Destination Location Not Added"  Title:@"Warning" image:@"warning.png"];
        }
        else if (_discription.text.length==0 || _name.text.length==0 || _date.titleLabel.text.length==0)
        {
            [self popup:@"All Field Are Compulsory"  Title:@"Warning" image:@"warning.png"];
        }
        else
        {
            [self senddatatoserver];
        }
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}
-(void)senddatatoserver
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
        
        NSDateFormatter *f=[[NSDateFormatter alloc] init];
        [f setDateFormat:@"hh a"];
        
        NSDate *d1=[f dateFromString:_starttime.titleLabel.text];
        NSDate *d2=[f dateFromString:_endtime.titleLabel.text];
        
        [f setDateFormat:@"hh"];
        NSString *sh=[f stringFromDate:d1];
        NSString *eh=[f stringFromDate:d2];
        
        [f setDateFormat:@"a"];
        
        
        NSString *st=[f stringFromDate:d1];
        NSString *et=[f stringFromDate:d2];
        
        
        AFHTTPRequestOperationManager *request=[AFHTTPRequestOperationManager manager];
        NSString *userid=[[NSUserDefaults standardUserDefaults] objectForKey:@"ID"];
        NSString *token=[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"];
        NSDictionary *postdata=@{@"user_id":userid,
                                 @"description":_discription.text,
                                 @"name":_name.text,
                                 @"start_longitude":[NSString stringWithFormat:@"%f",start.longitude],
                                 @"end_longitude":[NSString stringWithFormat:@"%f",end.longitude],
                                 @"start_latitude":[NSString stringWithFormat:@"%f",start.latitude],
                                 @"end_latitude":[NSString stringWithFormat:@"%f",end.latitude],
                                 @"event_date":_date.titleLabel.text,
                                 @"start_time":sh,
                                 @"start_time_unit":st,
                                 @"end_time":eh,
                                 @"end_time_unit":et,
                                 @"token":token
                                 };
        
        [request POST:Addeventurl parameters:postdata success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             [waitale dismissWithClickedButtonIndex:0 animated:YES];
             if ([[responseObject objectForKey:@"status"]intValue]==200)
             {
                 NSDictionary *data=[responseObject objectForKey:@"data"];
                 if ([[data objectForKey:@"status"]intValue]==200)
                 {
                     if ([[data objectForKey:@"message"] isEqualToString:@"Event created successfully"])
                     {
                         [self popup:[data objectForKey:@"message"]  Title:@"Status" image:@"sucess.png"];
                         data=[data objectForKey:@"event"];
                         _eventid=[data objectForKey:@"_id"];
                         
                     }
                     else
                     {
                         UIAlertView *ale=[[UIAlertView alloc] initWithTitle:@"Status" message:[data objectForKey:@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                         [ale show];
                         
                     }
                     
                 }
                 else
                 {
                    [self popup:[data objectForKey:@"message"]  Title:@"Status" image:@"error.png"];
                 }
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
-(void)mapcode
{
    
    _done.enabled=YES;
    _result=[[UITableView alloc] init];
    _result.delegate=self;
    _result.dataSource=self;
    _result.layer.cornerRadius=5.0f;
    
    [self.view addSubview:map];
    
    UIView *back=[[UIView alloc] initWithFrame:CGRectMake(0,44,320,73)];
    
    UIImageView *img1=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"map1.png"]];
    img1.frame=CGRectMake(10,7,12,15);
    [back addSubview:img1];
    
    UIImageView *img2=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"map2.png"]];
    img2.frame=CGRectMake(14,27,4,16);
    [back addSubview:img2];
    
    UIImageView *img3=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"map3.png"]];
    img3.frame=CGRectMake(10,48,13,21);
    [back addSubview:img3];
    
    _sourceloc=[[UITextField alloc] initWithFrame:CGRectMake(45,2,260,36)];
    _sourceloc.delegate=self;
    _sourceloc.placeholder=@"Source Location";
    _sourceloc.textAlignment=NSTextAlignmentCenter;
    _sourceloc.font=[UIFont fontWithName:@"oswald-regular" size:14.0f];
    [back addSubview:_sourceloc];
    
    UIView *line1=[[UIView alloc] initWithFrame:CGRectMake(45,34,251,1)];
    line1.backgroundColor=[self colorFromHexString:@"#c7c2c2"];
    [back addSubview:line1];
    
    UIView *v1=[[UIView alloc] initWithFrame:CGRectMake(45,26,1,8)];
    v1.backgroundColor=[self colorFromHexString:@"#c7c2c2"];
    [back addSubview:v1];
    
    UIView *v2=[[UIView alloc] initWithFrame:CGRectMake(295,26,1,8)];
    v2.backgroundColor=[self colorFromHexString:@"#c7c2c2"];
    [back addSubview:v2];
    
    _destinationloc=[[UITextField alloc] initWithFrame:CGRectMake(45,36,260,36)];
    _destinationloc.delegate=self;
    _destinationloc.placeholder=@"Destination Location";
    _destinationloc.textAlignment=NSTextAlignmentCenter;
    _destinationloc.font=[UIFont fontWithName:@"oswald-regular" size:14.0f];
    [back addSubview:_destinationloc];
    
    UIView *line2=[[UIView alloc] initWithFrame:CGRectMake(45,67,251,1)];
    line2.backgroundColor=[self colorFromHexString:@"#c7c2c2"];
    [back addSubview:line2];
    
    UIView *v3=[[UIView alloc] initWithFrame:CGRectMake(45,60,1,8)];
    v3.backgroundColor=[self colorFromHexString:@"#c7c2c2"];
    [back addSubview:v3];
    
    UIView *v4=[[UIView alloc] initWithFrame:CGRectMake(295,60,1,8)];
    v4.backgroundColor=[self colorFromHexString:@"#c7c2c2"];
    [back addSubview:v4];
    
    [self.view addSubview:back];
}
-(void)savedata
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewDidAppear:(BOOL)animated
{
    self.navigationController.navigationBar.backItem.title=@"Event List";
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(0,5,70,25)];
    title.text=@"Add Event";
    title.font=[UIFont fontWithName:@"oswald-regular" size:19.0f];
    title.textColor=[UIColor whiteColor];
    self.navigationItem.titleView=title;
    
    NSURL *url = [NSURL URLWithString:Netcheckurl];
    NSData *data = [NSData dataWithContentsOfURL:url];
    if (!data)
    {
        [self popup:OfflineMsg Title:OfflineTitle image:@"offline.png"];
    }
}
-(BOOL)prefersStatusBarHidden
{
    return YES;
}
-(void)startsearch:(NSString *)searchdata
{
    [_locationlist removeAllObjects];
    [_result removeFromSuperview];
    if (srcstatus==1)
    {
        _result.frame=CGRectMake(42,76,255,100);
    }
    else
    {
        _result.frame=CGRectMake(42,73+40,255,100);
    }
    
    
    AFHTTPRequestOperationManager *request=[AFHTTPRequestOperationManager manager];
    NSString *url=[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/textsearch/json?query=%@&key=AIzaSyCU2gb91_tYe8_C-dPiDGeHVRbAreuSKw0",searchdata];
    [request GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if ([[responseObject objectForKey:@"status"] isEqualToString:@"OK"])
         {
             NSArray *arr=[responseObject objectForKey:@"results"];
             for (NSDictionary *dict in arr)
             {
                 NSMutableDictionary *data=[[NSMutableDictionary alloc] init];
                 [data setObject:[dict objectForKey:@"formatted_address"] forKey:@"formatted_address"];
                 NSDictionary *dict1=[dict objectForKey:@"geometry"];
                 dict1=[dict1 objectForKey:@"location"];
                 
                 [data setObject:[dict1 objectForKey:@"lat"] forKey:@"lat"];
                 [data setObject:[dict1 objectForKey:@"lng"] forKey:@"lng"];
                 
                 [_locationlist addObject:data];
             }
         }
         if (_locationlist.count>0)
         {
             [_result removeFromSuperview];
             [self.view addSubview:_result];
             [_result reloadData];
         }
         
     } failure:^(AFHTTPRequestOperation *operation,NSError *err)
     {
         NSLog(@"error=%@",err);
     }];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _locationlist.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    NSDictionary *data=[_locationlist objectAtIndex:indexPath.row];
    
    cell.textLabel.text=[data objectForKey:@"formatted_address"];
    cell.textLabel.lineBreakMode=NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines=4;
    cell.textLabel.font=[UIFont fontWithName:@"oswald-regular" size:14.0f];
    cell.backgroundColor=[self colorFromHexString:@"#eae6e6"];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField==_sourceloc)
    {
        NSString *str=_sourceloc.text;
        str=[str stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        [self startsearch:str];
        srcstatus=1;
        deststatus=0;
    }
    else if (textField==_destinationloc)
    {
        
        NSString *str=_destinationloc.text;
        str=[str stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        [self startsearch:str];
        
        srcstatus=0;
        deststatus=1;
    }
    return YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *data=[_locationlist objectAtIndex:indexPath.row];
    
    [self setcamera:data];
    
    if (srcstatus==1)
    {
        start.latitude=[[data objectForKey:@"lat"]floatValue];
        start.longitude=[[data objectForKey:@"lng"]floatValue];
        _sourceloc.text=[data objectForKey:@"formatted_address"];
    }
    else if(deststatus==1)
    {
        end.latitude=[[data objectForKey:@"lat"]floatValue];
        end.longitude=[[data objectForKey:@"lng"]floatValue];
        _destinationloc.text=[data objectForKey:@"formatted_address"];
        [self getroute];
    }
    [_result removeFromSuperview];
}

-(void)setcamera :(NSDictionary *)dict
{
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake([[dict objectForKey:@"lat"]floatValue],[[dict objectForKey:@"lng"]floatValue]);
    marker.title =[dict objectForKey:@"formatted_address"];
    marker.snippet = @" ";
    marker.map =map;
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[[dict objectForKey:@"lat"]floatValue]
                                                            longitude:[[dict objectForKey:@"lng"]floatValue]
                                                                 zoom:12];
    [map animateToCameraPosition:camera];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_sourceloc resignFirstResponder];
    [_destinationloc resignFirstResponder];
    [_name resignFirstResponder];
    [_discription resignFirstResponder];
    [_sourceloc resignFirstResponder];
    [_result removeFromSuperview];
    [_destinationloc resignFirstResponder];
    [_pic removeFromSuperview];
    _scroll.frame=rect;
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [_name resignFirstResponder];
    [_discription resignFirstResponder];
    [_sourceloc resignFirstResponder];
    [_destinationloc resignFirstResponder];
    
    _scroll.frame=rect;
    return YES;
}
-(UIColor *)colorFromHexString:(NSString *)hexString
{
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1];
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}
-(void)getroute
{
    [_result removeFromSuperview];
    AFHTTPRequestOperationManager *request=[AFHTTPRequestOperationManager manager];
    
    
    NSString *url=[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%f,%f&sensor=false&mode=driving&alternatives=true",start.latitude,start.longitude,end.latitude,end.longitude];
    
    
    [request GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if ([[responseObject objectForKey:@"status"] isEqualToString:@"OK"])
         {
             NSArray *routes=[responseObject objectForKey:@"routes"];
             GMSPath *path = [GMSPath pathFromEncodedPath:routes[0][@"overview_polyline"]  [@"points"]];
             GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
             polyline.strokeColor = [UIColor blueColor];
             polyline.strokeWidth = 5.f;
             polyline.map =map;
             
             
             NSDictionary *location=[routes objectAtIndex:0];
             NSArray *legs=[location objectForKey:@"legs"];
             location=[legs objectAtIndex:0];
             
             NSDictionary *dis=[location objectForKey:@"distance"];
             NSDictionary *time=[location objectForKey:@"duration"];
             NSString *info=[NSString stringWithFormat:@" %@  %@",[dis objectForKey:@"text"],[time objectForKey:@"text"]];
             [self addroutedistance:info];
         }
         
     } failure:^(AFHTTPRequestOperation *operation,NSError *err)
     {
         NSLog(@"error=%@",err);
     }];
}

-(void)openpicker:(UIButton *)btn
{
    [_pic removeFromSuperview];
    if (btn==_starttime)
    {
        [_pic setFrame:CGRectMake(18,215+28,134,70)];
        picstatus=1;
        _pic.timeZone=[NSTimeZone localTimeZone];
        _pic.datePickerMode=UIDatePickerModeTime;
    }
    else if (btn==_endtime)
    {
        [_pic setFrame:CGRectMake(168,215+28,134,70)];
        picstatus=2;
        _pic.timeZone=[NSTimeZone localTimeZone];
        _pic.datePickerMode=UIDatePickerModeTime;
    }
    else if (btn==_date)
    {
        [_pic setFrame:CGRectMake(20,153+30,280,70)];
        _pic.datePickerMode=UIDatePickerModeDate;
        picstatus=3;
    }
    _pic.backgroundColor=[self colorFromHexString:@"#edebeb"];
    _pic.layer.cornerRadius=5.0f;
    _pic.clipsToBounds=YES;
    [_contailner addSubview:_pic];
    [_pic addTarget:self action:@selector(donelabel) forControlEvents:UIControlEventValueChanged];
}
-(void)donelabel
{
    NSDateFormatter *f=[[NSDateFormatter alloc] init];
    [f setDateFormat:@"hh a"];
    if (picstatus==1)
    {
         _starttime.titleLabel.textColor=[UIColor blackColor];
        [_starttime setTitle:[f stringFromDate:_pic.date] forState:UIControlStateNormal];
    }
    else if(picstatus==2)
    {
        _endtime.titleLabel.textColor=[UIColor blackColor];
        [_endtime setTitle:[f stringFromDate:_pic.date] forState:UIControlStateNormal];
    }
    else if(picstatus==3)
    {
        [f setDateFormat:@"yyyy-MM-dd"];
         _date.titleLabel.textColor=[UIColor blackColor];
        [_date setTitle:[f stringFromDate:_pic.date] forState:UIControlStateNormal];
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_pic removeFromSuperview];
}

//code to share event with circle friends code start here

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView==_shareale)
    {
        if (buttonIndex==0)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [self openshareeventview];
        }
    }
}
-(void)openshareeventview
{
    [self performSegueWithIdentifier:@"saveandshare" sender:_eventid];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ShareEventViewController *share=(ShareEventViewController *)segue.destinationViewController;
    share.eventid=(NSString *)sender;
}

-(void)addroutedistance :(NSString *)distance
{
    UILabel *dist=[[UILabel alloc] initWithFrame:CGRectMake(205,252,110,25)];
    dist.font=[UIFont fontWithName:@"oswald-regular" size:12.0f];
    dist.backgroundColor=[self colorFromHexString:@"#E0F8F1"];
    dist.text=distance;
    dist.textAlignment=NSTextAlignmentCenter;
    dist.tintColor=[UIColor whiteColor];
    dist.layer.cornerRadius=5;
    dist.clipsToBounds=YES;
    [self.view insertSubview:dist atIndex:5];
}


-(void)popup :(NSString *)msg Title:(NSString *)Title image:(NSString *)url
{
    //custom popup setting
    UIView *popview=[[UIView alloc] initWithFrame:CGRectMake(0,0,200,90)];
    popview.backgroundColor=[self colorFromHexString:@"#ececec"];
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:url]];
    image.frame=CGRectMake(30,34,30,40);
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
