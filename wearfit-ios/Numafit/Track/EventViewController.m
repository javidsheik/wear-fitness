//
//  EventViewController.m
//  Numafit
//
//  Created by apple on 14/11/14.
//  Copyright (c) 2014 sanhotrasoft. All rights reserved.
//

#import "EventViewController.h"
#import "AddEventViewController.h"
#import "AFNetworking.h"
#import "EventdetailsViewController.h"
#include "URL.h"
@interface EventViewController ()

@end

@implementation EventViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[self colorFromHexString:@"#e4e1e1"];
    serstatus=0;
    
    _search=[[UITextField alloc] initWithFrame:CGRectMake(0,45,320,35)];
    _search.delegate=self;
    _search.layer.cornerRadius=5;
    _search.layer.borderWidth=1;
    _searcharr=[[NSMutableArray alloc] init];
    [_search setPlaceholder:@"Search Event"];
    _search.textAlignment=NSTextAlignmentCenter;
    UIImageView *searchicon=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Searching-image"]];
    searchicon.frame=CGRectMake(280,5,25,25);
    [_search addSubview:searchicon];
    
    [_search addTarget:self action:@selector(searchstr) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_search];
}

-(void)searchstr
{
    [_searcharr removeAllObjects];
    serstatus=1;
    NSString *search=[[_search.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]lowercaseString];
    for (NSDictionary *d in _events)
    {
        NSString *str=[[d objectForKey:@"name"] lowercaseString];
        if ([str rangeOfString:search].location!=NSNotFound)
        {
            [_searcharr addObject:d];
        }
    }
    if (search.length==0)
    {
        serstatus=0;
    }
    [_devicelist reloadData];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    _search.text=@"";
    serstatus=0;
    [_search resignFirstResponder];
    [_devicelist reloadData];
    return YES;
}
-(void)sendreq
{
    [_devicelist removeFromSuperview];
    [self geteventlist];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"screen"]intValue]==40)
    {
        _devicelist=[[UITableView alloc] initWithFrame:CGRectMake(10,80,300,485) style:UITableViewStylePlain];
    }
    else
    {
        _devicelist=[[UITableView alloc] initWithFrame:CGRectMake(10,80,300,390) style:UITableViewStylePlain];
    }
    
    _devicelist.showsVerticalScrollIndicator=NO;
    _devicelist.delegate=self;
    _devicelist.dataSource=self;
    _devicelist.backgroundColor=[UIColor clearColor];
    _devicelist.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_devicelist];
}
-(void)openaddeventview
{
    AddEventViewController *addevent=(AddEventViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"addevent"];
    [self.navigationController pushViewController:addevent animated:YES];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (serstatus==1)
    {
        return _searcharr.count;
    }
    else
    {
        return _events.count;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.backgroundColor=[UIColor clearColor];
    cell.layer.borderWidth=0.3f;
    cell.layer.cornerRadius=6;
    
    NSDictionary *event;
    if (serstatus==1)
    {
        event=[_searcharr objectAtIndex:indexPath.row];
    }
    else
    {
        event=[_events objectAtIndex:indexPath.row];
    }
    
    UILabel *eventname=[[UILabel alloc]initWithFrame:CGRectMake(30,12,200,40)];
    eventname.text=[event objectForKey:@"name"];
    eventname.font=[UIFont fontWithName:@"oswald-regular" size:20.0f];
    eventname.textColor=[self colorFromHexString:@"#817e7e"];
    [cell addSubview:eventname];
    
    UILabel *eventdis=[[UILabel alloc]initWithFrame:CGRectMake(30,40,200,30)];
    eventdis.text=[event objectForKey:@"description"];
    eventdis.font=[UIFont fontWithName:@"oswald-regular" size:12.0f];
    eventdis.textColor=[self colorFromHexString:@"#b7b5b5"];
    [cell addSubview:eventdis];
    
    UILabel *date=[[UILabel alloc]initWithFrame:CGRectMake(210,53,70,30)];
    date.text=[[event objectForKey:@"event_date"] substringToIndex:10];
    date.font=[UIFont fontWithName:@"oswald-regular" size:16.0f];
    date.textColor=[self colorFromHexString:@"#b7b5b5"];
    [cell addSubview:date];
    
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor=[self colorFromHexString:@"#efecec"];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (serstatus !=1)
    {
        if (indexPath.row==_events.count-2)
        {
            if (recordcount>_events.count)
            {
                pageno++;
                [self sendreq];
            }
        }
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
-(void)viewDidAppear:(BOOL)animated
{
    self.navigationController.navigationBar.backItem.title=@"Track";
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(0,5,70,25)];
    title.text=@"Track My Event";
    title.font=[UIFont fontWithName:@"oswald-regular" size:19.0f];
    title.textColor=[UIColor whiteColor];
    self.navigationItem.titleView=title;
    self.navigationItem.hidesBackButton=NO;
    //navigation Add event button setting
    UIBarButtonItem *addevent=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(openaddeventview)];
    self.navigationItem.rightBarButtonItem=addevent;
    
    recordcount=0;
    pageno=1;
    _events=[[NSMutableArray alloc] init];
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(sendreq) userInfo:nil repeats:NO];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.navigationItem.hidesBackButton=YES;
    if (serstatus==1)
    {
        [self performSegueWithIdentifier:@"eventdetails" sender:[_searcharr objectAtIndex:indexPath.row]];
    }
    else
    {
        [self performSegueWithIdentifier:@"eventdetails" sender:[_events objectAtIndex:indexPath.row]];
    }
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    EventdetailsViewController *eve=(EventdetailsViewController *)segue.destinationViewController;
    eve.dict=sender;
}
-(void)geteventlist
{
    NSURL *url = [NSURL URLWithString:Netcheckurl];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    if (data)
    {
        //activityIndicator codeing
        UIActivityIndicatorView *wait=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        wait.color=[self colorFromHexString:@"#bfdecc"];
        UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(80,4,150,20)];
        lbl.text=@"Reciveing Events...";
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
        
        NSString *url=[NSString stringWithFormat:@"https://numa.simpliot.com/api/events?user_id=%@&token=%@&page=%d",userid,token,pageno];
        
        [request GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             [waitale dismissWithClickedButtonIndex:0 animated:YES];
             if ([[responseObject objectForKey:@"status"]intValue]==200)
             {
                 NSDictionary *data=[responseObject objectForKey:@"data"];
                 if ([[data objectForKey:@"count"]intValue]>0)
                 {
                     recordcount=[[data objectForKey:@"count"]intValue];
                     [_events addObjectsFromArray:[data objectForKey:@"events"]];
                     [_devicelist reloadData];
                 }
                 else
                 {
                     [self popup:@"There is no event"  Title:@"Status" image:@"warning.png"];
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
