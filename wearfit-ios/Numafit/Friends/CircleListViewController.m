//
//  CircleListViewController.m
//  Numafit
//
//  Created by iHotra-LT-02 on 21/11/14.
//  Copyright (c) 2014 sanhotrasoft. All rights reserved.
//

#import "CircleListViewController.h"
#import "AFNetworking.h"
#import "AddCircleViewController.h"
#import "CircleDetailViewController.h"
#import "URL.h"

int kLoadingCellTag;
@interface CircleListViewController ()

@end

@implementation CircleListViewController

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
    
    self.array=[[NSArray alloc]initWithObjects:@"#00b1b1",@"#339595",@"#06c175",@"#076bbf",@"#bfc100",nil];
    self.circlename =[[NSMutableArray alloc]init];
    self.circledesc=[[NSMutableArray alloc]init];
    self.circletag=[[NSMutableArray alloc]init];
    self.friendcount=[[NSMutableArray alloc]init];
    [self.circlename removeAllObjects];
    [self.friendcount removeAllObjects];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    
    
    
}
-(void)getcircle

{
    
    
    NSUserDefaults *pref =[NSUserDefaults standardUserDefaults];
    NSString *token = [pref objectForKey:@"Token"];
    NSString *userid =[pref objectForKey:@"ID"];
    
    NSLog(@"user id %@ and token %@",token,userid);
    UIActivityIndicatorView *wait=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    wait.color=[self colorFromHexString:@"#bfdecc"];
    UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(105,4,150,20)];
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
    NSURL *url = [NSURL URLWithString:Netcheckurl];
    NSData *data = [NSData dataWithContentsOfURL:url];
    if(data)
    {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSLog(@"current page %d",self.currentPage);
    NSString * string = [NSString stringWithFormat:@"http://numa.simpliot.com/api/circles?page=%d&user_id=%@&token=%@",self.currentPage,userid,token];
    string = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager GET: string parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *data =[responseObject valueForKeyPath:@"data"];
        self.circles =[[NSMutableArray alloc]init];
        self.circles =[data objectForKey:@"circles"];
        self.circlecount = [[data objectForKey:@"count"]intValue];
        for(NSDictionary *circle in self.circles)
        {
            [self.circlename addObject:[circle objectForKey:@"name"]];
            [self.circledesc addObject:[circle objectForKey:@"description"]];
            [self.circletag addObject:[circle objectForKey:@"tags"]];
            [self.friendcount addObject:[circle objectForKey:@"friends"]];
            
        }
        
        
        if(self.circlename.count!=0)
        {
            
            [self.tableView reloadData];
            
        }
        
        
        [waitale dismissWithClickedButtonIndex:0 animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", operation.error);
       
        [self popup:message_503  Title:title_503 image:@"ServerError.png"];
        
        [waitale dismissWithClickedButtonIndex:0 animated:YES];

        
        
    }];
    }
    
    else
    {
        
        [self popup:OfflineMsg Title:OfflineTitle image:@"offline.png"];
        [waitale dismissWithClickedButtonIndex:0 animated:YES];
        
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated
{
    
    [self.circlename removeAllObjects];
    [self.friendcount removeAllObjects];
    _currentPage = 1;
    [self.tableView reloadData];
    [self getcircle];
    
    
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(0,5,70,20)];
    title.text=@"Circles";
    title.font=[UIFont fontWithName:@"oswald-regular" size:20.0f];
    title.textColor=[UIColor whiteColor];
    self.navigationItem.titleView=title;
    
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addcircle)];
    [self.navigationController setNavigationBarHidden:NO];
    
    
    
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    //    [self.circlename removeAllObjects];
    //    [self.tableView reloadData];
    
    
}
-(void)addcircle
{
    UINavigationController *navController = self.navigationController;
    AddCircleViewController *addcircle=(AddCircleViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"addcircle"];
    [navController pushViewController:addcircle animated:YES];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.menulist)
    {
        
        return [self.imagelist count];
    }
    else if(tableView == self.tableView && self.circlename.count !=0)
    {
        return ([self.circlename count]*2);
        
        
        
    }
    else
        
        return NO;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //     UITableViewCell *cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.accessoryType =  UITableViewCellAccessoryNone;
    cell.backgroundColor=[UIColor clearColor];
    self.tableView.separatorColor=[UIColor clearColor];
    if (cell == nil ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] ;
        
    }
    
    if(tableView == self.tableView)
    {
        for (id object in cell.contentView.subviews)
        {
            [object removeFromSuperview];
        }
        
        if(self.circlename.count >0)
        {
            if (indexPath.row%2==0)
            {
                cell.layer.cornerRadius=5;
                circlelabel=[[UILabel alloc]initWithFrame:CGRectMake(90,40,150,70)];
                circlelabel.text=[[self.circlename objectAtIndex:indexPath.row/2] uppercaseString];
                circlelabel.font=[UIFont fontWithName:@"oswald-regular" size:20.0f];
                circlelabel.lineBreakMode=NSLineBreakByWordWrapping;
                circlelabel.numberOfLines =0;
                circlelabel.textColor =[UIColor whiteColor];
                
                
                [cell.contentView addSubview:circlelabel];
                cell.backgroundColor =[self colorFromHexString:[_array objectAtIndex:indexPath.row %5]];
                
                
                UILabel *count=[[UILabel alloc]initWithFrame:CGRectMake(200,90,70,20)];
                NSMutableArray *array = [[NSMutableArray alloc]init];
                NSMutableArray *array1 = [[NSMutableArray alloc]init];
                [array addObject:[self.friendcount objectAtIndex:indexPath.row/2]];
                NSString *arraycount =[[NSString alloc]init];
                for (array1 in array)
                {
                    arraycount =[NSString stringWithFormat:@" Friends %lu",(unsigned long)array1.count];
                    
                }
                count.text= arraycount;
                count.font=[UIFont fontWithName:@"oswald-regular" size:14.0f];
                count.textColor =[UIColor whiteColor];
                [cell.contentView addSubview:count];
                
                UIButton *myAccessoryButton = [[UIButton alloc] initWithFrame:CGRectMake(250, 55, 10, 20)];
                [myAccessoryButton setImage:[UIImage imageNamed:@"arrow_"] forState:UIControlStateNormal];
                [cell.contentView addSubview:myAccessoryButton];
                
            }
            
        }
        return cell;
    }
    if (tableView == self.menulist) {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
        NSLog(@"cell");
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(tableView== self.menulist)
    {
        
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
        
    }
    
    if(tableView== self.tableView)
    {
        NSDictionary *circledetail = [self.circles objectAtIndex:indexPath.row/2];
        NSArray *frndarray =[[NSArray alloc]init];
        NSMutableArray *frndid =[[NSMutableArray alloc]init];
        NSMutableArray *userid = [[NSMutableArray alloc]init];
        frndarray =[circledetail objectForKey:@"friends"];
        for(int i=0;i<frndarray.count;i++)
        {
            NSDictionary *dic = [frndarray objectAtIndex:i];
            [frndid addObject: [dic objectForKey:@"_id"]];
            [userid addObject:[dic objectForKey:@"user_id"]];
            
        }
        
        NSString *string = [circledetail objectForKey:@"_id"];
        CircleDetailViewController *detail=(CircleDetailViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"detail"];
        detail.circlename= [self.circlename objectAtIndex:indexPath.row/2];
        detail.circleid= string;
        detail.userid = [[NSMutableArray alloc]initWithArray:userid];
        detail.frndid =[[NSMutableArray alloc]initWithArray:frndid];
        [self.navigationController pushViewController:detail animated:YES];
        
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==self.tableView)
    {
        if (indexPath.row%2==0)
        {
            return 120.0f;
        }
        else
        {
            return 15.0f;
        }
        
    }
    else
        return 45.0f;
    
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.circlename.count!=self.circlecount)
    {
        if ([indexPath isEqual:[NSIndexPath indexPathForRow:[self tableView:self.tableView numberOfRowsInSection:0]-1 inSection:0]])
        {
            self.currentPage++;
            [self getcircle];
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

@end
