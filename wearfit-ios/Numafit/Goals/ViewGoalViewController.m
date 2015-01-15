//
//  ViewGoalViewController.m
//  Numafit
//
//  Created by iHotra-LT-02 on 06/12/14.
//  Copyright (c) 2014 sanhotrasoft. All rights reserved.
//

#import "ViewGoalViewController.h"
#import "CreateGoalViewController.h"
#import  "AFNetworking.h"
#import "URL.h"

@interface ViewGoalViewController ()

@end

@implementation ViewGoalViewController

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
    
    self.view.backgroundColor =[self colorFromHexString:@"#ddd9d9"];
    self.view2.backgroundColor = [ self colorFromHexString:@"#f3f0f0"];
    CALayer *btnLayer1 = [self.view2 layer];
    [btnLayer1 setMasksToBounds:YES];
    [btnLayer1 setCornerRadius:5.0f];
    self.tableView=[[UITableView alloc]init];
    self.goaltype=[[NSMutableArray alloc]init];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
   
    self.typelab.textColor = [self colorFromHexString:@"#767373"];
    self.typelab.font = [UIFont fontWithName:@"oswald-regular" size:19.0f];
    self.points.textColor = [self colorFromHexString:@"#767373"];
    self.points.font = [UIFont fontWithName:@"oswald-regular" size:19.0f];
    self.points1.textColor = [self colorFromHexString:@"#036a88"];
    self.points1.font = [UIFont fontWithName:@"oswald-regular" size:19.0f];
    self.goaltype1.textColor = [self colorFromHexString:@"#036a88"];
    self.goaltype1.font = [UIFont fontWithName:@"oswald-regular" size:19.0f];
    
//    self.goaltype1.layer.masksToBounds=YES;
//    self.goaltype1.layer.borderColor=[[self colorFromHexString:@"#cecbcb"]CGColor];
//    self.goaltype1.layer.borderWidth= 1.0f;
//    self.points1.layer.masksToBounds=YES;
//    self.points1.layer.borderColor=[[self colorFromHexString:@"#cecbcb"]CGColor];
//    self.points1.layer.borderWidth= 1.0f;
     self.points1.textAlignment=NSTextAlignmentCenter;
     self.goaltype1.textAlignment=NSTextAlignmentCenter;
    
//    self.daily_per.layer.masksToBounds=YES;
//    self.daily_per.layer.borderColor=[[self colorFromHexString:@"#cecbcb"]CGColor];
//    self.daily_per.layer.borderWidth= 1.0f;
//    self.cal.layer.masksToBounds=YES;
//    self.cal.layer.borderColor=[[self colorFromHexString:@"#cecbcb"]CGColor];
//    self.cal.layer.borderWidth= 1.0f;
    self.cal.textAlignment=NSTextAlignmentCenter;
    self.daily_per.textAlignment=NSTextAlignmentCenter;
    self.daily_per.textColor = [self colorFromHexString:@"#036a88"];
    self.daily_per.font = [UIFont fontWithName:@"oswald-regular" size:19.0f];
    self.cal.textColor = [self colorFromHexString:@"#036a88"];
    self.cal.font = [UIFont fontWithName:@"oswald-regular" size:19.0f];
    self.caloriegoal.textColor = [self colorFromHexString:@"#767373"];
    self.caloriegoal.font = [UIFont fontWithName:@"oswald-regular" size:19.0f];
    self.dailyper.textColor = [self colorFromHexString:@"#767373"];
    self.dailyper.font = [UIFont fontWithName:@"oswald-regular" size:19.0f];


    
    self.save = [[UIButton alloc]init];
//    self.cancel = [[UIButton alloc]init];
    self.save.frame =CGRectMake(35, 385, 251, 45);
//    self.cancel.frame =CGRectMake(35, 460, 251, 45);
    [self.save setTitle:@"ADD GOAL" forState:UIControlStateNormal];
//    [self.cancel setTitle:@"CANCEL" forState:UIControlStateNormal];
    CGSize result = [[UIScreen mainScreen] bounds].size;
    self.save.showsTouchWhenHighlighted=YES;
//    self.cancel.showsTouchWhenHighlighted=YES;
    if(result.height ==480)
    {
        self.save.frame =CGRectMake(35, 370, 251, 45);
//        self.cancel.frame =CGRectMake(35, 425, 251, 45);
        
    }
    
    CALayer *btnLayer2 = [self.save layer];
    [btnLayer2 setMasksToBounds:YES];
    [btnLayer2 setCornerRadius:5.0f];
//    CALayer *btnLayer3 = [self.cancel layer];
//    [btnLayer3 setMasksToBounds:YES];
//    [btnLayer3 setCornerRadius:5.0f];
    [[self.save titleLabel] setFont:[UIFont fontWithName:@"oswald-regular" size:16.0f]];
//    [[self.cancel titleLabel] setFont:[UIFont fontWithName:@"oswald-regular" size:16.0f]];
    self.save.backgroundColor = [self colorFromHexString:@"#fb5e93"];
//    self.cancel.backgroundColor = [self colorFromHexString:@"#fb5e93"];
//    [self.view addSubview:self.save];
//    [self.view addSubview:self.cancel];
    [self.save addTarget:self action:@selector(viewgoal) forControlEvents:UIControlEventTouchUpInside];
//    [self.cancel  addTarget:self action:@selector(cancelgoal) forControlEvents:UIControlEventTouchUpInside];

 
}

//-(void)cancelgoal
//{
//    
//    [self.navigationController popViewControllerAnimated:YES];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    
    return YES;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)viewDidAppear:(BOOL)animated
{
    
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(0,5,70,30)];
    title.text=@"Your Daily Goal";
    title.font=[UIFont fontWithName:@"oswald-regular" size:20.0f];
    title.textColor=[UIColor whiteColor];
    self.navigationItem.titleView=title;
    
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(viewgoal)];
    [self.navigationController setNavigationBarHidden:NO];
    [self checkgoal];
    
}
-(void)viewgoal
{
    UINavigationController *navController = self.navigationController;
    CreateGoalViewController *goal=(CreateGoalViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"goal"];
    [navController pushViewController:goal animated:YES];
    
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


-(void) checkgoal
{
    
    NSUserDefaults *pref =[NSUserDefaults standardUserDefaults];
    NSString *token = [pref objectForKey:@"Token"];
    NSString *Id =[pref objectForKey:@"ID"];
    
    UIActivityIndicatorView *wait=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    wait.color=[self colorFromHexString:@"#bfdecc"];
    UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(105,4,150,20)];
    lbl.text=@"Checking...";
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
    NSString * string = [NSString stringWithFormat:@"http://numaforce.herokuapp.com/api/goals?user_id=%@&token=%@",Id,token];
    string = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager GET: string parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *data =[responseObject valueForKeyPath:@"data"];
        NSLog(@"data is %@",data);
        
        for(NSDictionary *dic in data)
        {
            
           if(![[dic objectForKey:@"daily_steps"] isEqual:[NSNull null]])
           {
               self.goaltype1.text =[NSString stringWithFormat:@"%@",[dic objectForKey:@"daily_steps"]];

               
           }
           else
           {
               self.goaltype1.text =@"0";
               
           }
            if(![[dic objectForKey:@"daily_distance"] isEqual:[NSNull null]])
            {
                
                self.points1.text = [NSString stringWithFormat:@"%@ M",[dic objectForKey:@"daily_distance"]];
            }
            
            else
            {
                self.points1.text =@"0";
                
            }
            
            if(![[dic objectForKey:@"daily_calories"] isEqual:[NSNull null]])
            {
                  self.cal.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"daily_calories"]];
                
            }
            
            else
            {
                
                self.cal.text = @"0";
            }
            
           if(![[dic objectForKey:@"daily_percent"] isEqual:[NSNull null]])
               {
                   
                     self.daily_per.text =[NSString stringWithFormat:@"%@ %%",[dic objectForKey:@"daily_percent"]];
               }
          
            else
            {
                
                self.cal.text = @"0";
            }
            [pref setObject:self.cal.text forKey:@"caloriegoal"];
            [pref setObject:self.goaltype1.text forKey:@"stepsgoal"];
            [pref setObject:self.points1.text forKey:@"distgoal"];
            [[NSUserDefaults standardUserDefaults]synchronize];

        }
       
        
        [waitale dismissWithClickedButtonIndex:0 animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"response %@",operation.responseObject);
        
        
        NSString *message =[operation.responseObject objectForKey:@"message"];
        
        [self popup:message  Title:@"Status" image:@"ServerError.png"];
        [waitale dismissWithClickedButtonIndex:0 animated:YES];
      
        }];
     }
    
    else
    {
        
        [self popup:OfflineMsg Title:OfflineTitle image:@"offline.png"];
        [waitale dismissWithClickedButtonIndex:0 animated:YES];
    }
}

@end