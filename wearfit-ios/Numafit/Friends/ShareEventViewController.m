//
//  ShareEventViewController.m
//  Numafit
//
//  Created by apple on 26/11/14.
//  Copyright (c) 2014 sanhotrasoft. All rights reserved.
//

#import "ShareEventViewController.h"
#import "AFNetworking.h"
#include "URL.h"
@interface ShareEventViewController ()

@end

@implementation ShareEventViewController

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
    _cellcolorlist=[[NSArray alloc]initWithObjects:@"#00b1b1",@"#339595",@"#06c175",@"#076bbf",@"#bfc100",nil];
    _circlelisttable=[[UITableView alloc] initWithFrame:CGRectMake(20,50,280,self.view.frame.size.height-50) style:UITableViewStylePlain];
    _circlelisttable.delegate=self;
    _circlelisttable.dataSource=self;
    _circlelisttable.showsVerticalScrollIndicator=NO;
    [self.view addSubview:_circlelisttable];
    _circlelist=[[NSMutableArray alloc] init];
    recordcount=0;
    pageno=1;
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(getcirclelist) userInfo:nil repeats:NO];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _circlelist.count*2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor clearColor];
    self.circlelisttable.separatorColor=[UIColor clearColor];
    if (cell == nil )
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] ;
        
    }
    for (id object in cell.contentView.subviews)
    {
        [object removeFromSuperview];
    }
    
    if (indexPath.row%2==0)
    {
        NSDictionary *dict=[_circlelist objectAtIndex:indexPath.row/2];
        cell.layer.cornerRadius=5;
        UILabel *circlelabel=[[UILabel alloc]initWithFrame:CGRectMake(40,30,200,35)];
        circlelabel.text=[dict objectForKey:@"name"];
        circlelabel.font=[UIFont fontWithName:@"oswald-regular" size:25.0f];
        circlelabel.textColor =[UIColor whiteColor];
        circlelabel.lineBreakMode=NSLineBreakByWordWrapping;
        circlelabel.numberOfLines=2;
        [cell.contentView addSubview:circlelabel];
        
        NSArray *frie=[dict objectForKey:@"friends"];
        UILabel *friends=[[UILabel alloc]initWithFrame:CGRectMake(150,70,100,20)];
        friends.text=[NSString stringWithFormat:@"Friends : %lu",(unsigned long)frie.count];
        friends.font=[UIFont fontWithName:@"oswald-regular" size:14.0f];
        friends.textColor =[UIColor whiteColor];
        [cell.contentView addSubview:friends];
        cell.backgroundColor =[self colorFromHexString:[_cellcolorlist objectAtIndex:indexPath.row %5]];
    }
    // cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict=[_circlelist objectAtIndex:indexPath.row/2];
    [self shareevent:[dict objectForKey:@"_id"]];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row%2)
    {
        return 10.0f;
    }
    else
    {
        return 120.0f;
    }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.row/2)==_circlelist.count-2)
    {
        if (recordcount>_circlelist.count)
        {
            pageno++;
            [self getcirclelist];
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
-(void)getcirclelist
{
    NSURL *url = [NSURL URLWithString:Netcheckurl];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    if (data)
    {
        //activityIndicator codeing
        UIActivityIndicatorView *wait=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        wait.color=[self colorFromHexString:@"#bfdecc"];
        UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(80,4,150,20)];
        lbl.text=@"Reciveing Circles...";
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
        
        NSString *url=[NSString stringWithFormat:@"https://numa.simpliot.com/api/circles?user_id=%@&token=%@&page=%d",userid,token,pageno];
        
        [request GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             [waitale dismissWithClickedButtonIndex:0 animated:YES];
             if ([[responseObject objectForKey:@"status"]intValue]==200)
             {
                 NSDictionary *data=[responseObject objectForKey:@"data"];
                 if ([[data objectForKey:@"count"]intValue]>0)
                 {
                     recordcount=[[data objectForKey:@"count"]intValue];
                     [_circlelist addObjectsFromArray:[data objectForKey:@"circles"]];     //[[NSArray alloc] initWithArray:[data objectForKey:@"circles"]];
                     [_circlelisttable reloadData];
                 }
                 else
                 {
                     [self popup:@"There is no Circle Found"  Title:@"Status" image:@"warning.png"];
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
-(void)viewDidAppear:(BOOL)animated
{
    self.navigationController.navigationBar.backItem.title=@"EventList";
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(0,5,70,25)];
    title.text=@"Share Event";
    title.font=[UIFont fontWithName:@"oswald-regular" size:19.0f];
    title.textColor=[UIColor whiteColor];
    self.navigationItem.titleView=title;
    self.navigationItem.hidesBackButton=NO;
}

//this function share event in circle friends
-(void)shareevent:(NSString *)circleid
{
    NSURL *url = [NSURL URLWithString:Netcheckurl];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    if (data)
    {
        //activityIndicator codeing
        UIActivityIndicatorView *wait=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        wait.color=[self colorFromHexString:@"#bfdecc"];
        UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(80,4,150,20)];
        lbl.text=@"Sharing Event...";
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
        
        NSDictionary *postdata=@{@"token":token,
                                 @"user_id":userid,
                                 @"circle_id":circleid,
                                 @"event_id":_eventid};
        
        [request POST:ShareEventurl parameters:postdata success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSDictionary *data=[responseObject objectForKey:@"data"];
             [waitale dismissWithClickedButtonIndex:0 animated:YES];
             if ([[responseObject objectForKey:@"status"]intValue]==200)
             {
                 [self popup:[data objectForKey:@"message"]  Title:@"Status" image:@"sucess.png"];
             }
             else
             {
                 [self popup:[data objectForKey:@"message"]  Title:@"Status" image:@"error.png"];
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
