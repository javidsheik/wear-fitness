//
//  EventdetailsViewController.m
//  Numafit
//
//  Created by apple on 25/11/14.
//  Copyright (c) 2014 sanhotrasoft. All rights reserved.
//

#import "EventdetailsViewController.h"
#import "ShareEventViewController.h"
#include "URL.h"
#import "AFNetworking.h"
#import <GoogleMaps/GoogleMaps.h>
@interface EventdetailsViewController ()
{
    GMSMapView *map;
}

@end

@implementation EventdetailsViewController

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
    [self opendetailedview:_dict];
    NSString *date=[NSString stringWithFormat:@"%@",[[_dict objectForKey:@"event_date"] substringToIndex:10]];
    NSString *st=[NSString stringWithFormat:@"%@  %@",[_dict objectForKey:@"start_time"],[_dict objectForKey:@"start_time_unit"]];
    NSString *et=[NSString stringWithFormat:@"%@  %@",[_dict objectForKey:@"end_time"],[_dict objectForKey:@"end_time_unit"]];
    
    _dislist=[[NSArray alloc] initWithObjects:@"",[_dict objectForKey:@"name"],[_dict objectForKey:@"description"],date,st,et,nil];
    
    _namelist=[[NSArray alloc] initWithObjects:@"PARTICIPATED",@"EVENT NAME",@"EVENT DISCRIPTION",@"EVENT DATE",@"START TIME",@"END TIME", nil];
    _colorlist=[[NSArray alloc] initWithObjects:@"#00ddef",@"#00ef5a",@"ff5cd8",@"#39adb7",@"#f3883d",@"#f3453d",nil];
    
    _iconlist=[[NSArray alloc] initWithObjects:@"map_event_title.png",@"map_event_title.png",@"map_event_description.png",@"map_event_date.png",@"map_event_time.png",@"map_event_time.png", nil];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"screen"]intValue]==40)
    {
        _eventdis=[[UITableView alloc] initWithFrame:CGRectMake(0,250,320,230+88) style:UITableViewStylePlain];
    }
    else
    {
        _eventdis=[[UITableView alloc] initWithFrame:CGRectMake(0,250,320,230) style:UITableViewStylePlain];
    }
    
    [self.view addSubview:_eventdis];
    _eventdis.delegate=self;
    _eventdis.dataSource=self;
    _eventdis.showsVerticalScrollIndicator=NO;
    //event id setting to share event
    _eventid=[NSString stringWithFormat:@"%@",[_dict objectForKey:@"_id"]];
    
    _switchbutton=[[UISwitch alloc] initWithFrame:CGRectMake(230,15,50,50)];
    
    [_switchbutton addTarget:self action:@selector(addeventparticipation:) forControlEvents:UIControlEventValueChanged];
    [_switchbutton setSelected:NO];
}

-(void)opendetailedview :(NSDictionary *)dict
{
    map=[[GMSMapView alloc] initWithFrame:CGRectMake(2,45,316,200)];
    map.layer.borderWidth=3;
    map.layer.cornerRadius=2;
    map.layer.borderColor=[self colorFromHexString:@"#c7c2c2"].CGColor;
    map.myLocationEnabled = YES;
    [self.view addSubview:map];
    [self addroute:dict];
}

-(void)addroute:(NSDictionary *)dict
{
    CLLocationCoordinate2D start=CLLocationCoordinate2DMake([[dict objectForKey:@"start_latitude"]floatValue], [[dict objectForKey:@"start_longitude"]floatValue]);
    CLLocationCoordinate2D end=CLLocationCoordinate2DMake([[dict objectForKey:@"end_latitude"]floatValue], [[dict objectForKey:@"end_longitude"]floatValue]);
    
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
             
             NSDictionary *startloc=[location objectForKey:@"start_location"];
             NSDictionary *endloc=[location objectForKey:@"end_location"];
             
             [self addmaeker:[[startloc objectForKey:@"lat"]floatValue] lng:[[startloc objectForKey:@"lng"]floatValue] name:[location objectForKey:@"start_address"]];
             
             [self addmaeker:[[endloc objectForKey:@"lat"]floatValue] lng:[[endloc objectForKey:@"lng"]floatValue] name:[location objectForKey:@"end_address"]];
             
         }
         
     } failure:^(AFHTTPRequestOperation *operation,NSError *err)
     {
         NSLog(@"error=%@",err);
     }];
}
-(void)addmaeker:(float)lat lng:(float)lng name:(NSString *)locationname
{
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(lat,lng);
    marker.title =locationname;
    marker.map =map;
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:lat longitude:lng zoom:10];
    [map animateToCameraPosition:camera];
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

-(void)viewDidAppear:(BOOL)animated
{
    self.navigationController.navigationBar.backItem.title=@"EventList";
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(0,5,70,25)];
    title.text=[_dict objectForKey:@"name"];
    title.font=[UIFont fontWithName:@"oswald-regular" size:19.0f];
    title.textColor=[UIColor whiteColor];
    self.navigationItem.titleView=title;
    self.navigationItem.hidesBackButton=NO;
    
    //navigation Add event button setting
    UIBarButtonItem *shareevent=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"shareicon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(openshareeventview)];
    self.navigationItem.rightBarButtonItem=shareevent;
}
-(void)openshareeventview
{
    [self performSegueWithIdentifier:@"share" sender:_eventid];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ShareEventViewController *share=(ShareEventViewController *)segue.destinationViewController;
    share.eventid=(NSString *)sender;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    if (indexPath.row==0)
    {
        [cell addSubview:[self createlabel:[_namelist objectAtIndex:indexPath.row] color:[_colorlist objectAtIndex:3] le:1]];
        UIView *vi=[[UIView alloc] initWithFrame:CGRectMake(0,0,10,70)];
        vi.backgroundColor=[self colorFromHexString:[_colorlist objectAtIndex:3]];
        [cell addSubview:vi];
        [cell addSubview:_switchbutton];
    }
    else
    {
        UIImageView *img=[[UIImageView alloc] initWithImage:[UIImage imageNamed:[_iconlist objectAtIndex:indexPath.row]]];
        img.frame=CGRectMake(35,15,20,20);
        
        [cell addSubview:img];
        [cell addSubview:[self createlabel:[_namelist objectAtIndex:indexPath.row] color:[_colorlist objectAtIndex:indexPath.row] le:1]];
        
        int i=2;
        int j=0;
        if (indexPath.row==2)
        {
            i=5;
            j=50;
        }
        [cell addSubview:[self createlabel:[_dislist objectAtIndex:indexPath.row] color:@"#868a8a" le:i]];
        
        UIView *vi=[[UIView alloc] initWithFrame:CGRectMake(0,0,10,70+j)];
        vi.backgroundColor=[self colorFromHexString:[_colorlist objectAtIndex:indexPath.row]];
        [cell addSubview:vi];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==2)
    {
        return 120;
    }
    else
    {
        return 70;
    }
}
-(UILabel *)createlabel :(NSString *)eventname color:(NSString *)color le:(int)no
{
    UILabel *lbl;
    if (no==1)
    {
        lbl=[[UILabel alloc] initWithFrame:CGRectMake(70,5,240,40)];
        lbl.font=[UIFont fontWithName:@"oswald-regular" size:20.0f];
    }
    else if (no==5)
    {
        lbl=[[UILabel alloc] initWithFrame:CGRectMake(70,23,240,95)];
        lbl.lineBreakMode=NSLineBreakByWordWrapping;
        lbl.numberOfLines=7;
        lbl.font=[UIFont fontWithName:@"oswald-regular" size:12.0f];
    }
    else
    {
        lbl=[[UILabel alloc] initWithFrame:CGRectMake(70,30,240,40)];
        lbl.font=[UIFont fontWithName:@"oswald-regular" size:16.0f];
    }
    
    lbl.text=eventname;
    lbl.textColor=[self colorFromHexString:color];
    
    return lbl;
}

-(void)addeventparticipation :(UISwitch *)swit
{
    if (swit.isOn)
    {
        NSURL *url = [NSURL URLWithString:Netcheckurl];
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        if (data)
        {
            //activityIndicator codeing
            UIActivityIndicatorView *wait=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            wait.color=[self colorFromHexString:@"#bfdecc"];
            UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(50,4,200,20)];
            lbl.text=@"Completing Paticipation...";
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
                                     @"track_type":@"Event",
                                     @"event_id":_eventid,
                                     @"token":token,
                                     @"event_status":@"Participated",};
            
            [request POST:Eventtrackurl parameters:postdata success:^(AFHTTPRequestOperation *operation, id responseObject)
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
                 [waitale dismissWithClickedButtonIndex:0 animated:YES];
                 [self popup:message_503  Title:title_503 image:@"ServerError.png"];
             }];
        }
        else
        {
            [self popup:OfflineMsg Title:OfflineTitle image:@"offline.png"];
        }
        
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

-(void)addroutedistance :(NSString *)distance
{
    UILabel *dist=[[UILabel alloc] initWithFrame:CGRectMake(205,217,110,25)];
    dist.font=[UIFont fontWithName:@"oswald-regular" size:12.0f];
    dist.backgroundColor=[self colorFromHexString:@"#E0F8F1"];
    dist.text=distance;
    dist.textAlignment=NSTextAlignmentCenter;
    dist.tintColor=[UIColor whiteColor];
    dist.layer.cornerRadius=5;
    dist.clipsToBounds=YES;
    [self.view insertSubview:dist atIndex:5];
}

@end
