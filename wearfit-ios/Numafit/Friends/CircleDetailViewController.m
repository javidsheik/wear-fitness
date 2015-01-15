//
//  CircleDetailViewController.m
//  Numafit
//
//  Created by iHotra-LT-02 on 26/11/14.
//  Copyright (c) 2014 sanhotrasoft. All rights reserved.
//

#import "CircleDetailViewController.h"
#import "AddfrndsTableViewCell.h"
#import "CirclefrndsTableViewCell.h"
#import "AFNetworking.h"
#import "CircleListViewController.h"
#import "URL.h"

@interface CircleDetailViewController ()

@end

@implementation CircleDetailViewController

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
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableview1.delegate=self;
    self.tableview1.dataSource=self;
    self.tableview2.delegate=self;
    self.tableview2.dataSource=self;
    self.view2.backgroundColor=[self colorFromHexString:@"#31d4fd"];
    self.label2.font = [UIFont fontWithName:@"oswald-regular" size:20.0f];
    self.view.backgroundColor =[self colorFromHexString:@"#efecec"];
    self.tableview1.separatorColor =[UIColor clearColor];
    self.tableview2.separatorColor=[UIColor clearColor];
    self.save=[[UIButton alloc]init];
    self.cancel =[[UIButton alloc]init];
    CALayer *btnLayer = [self.tableview2 layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
    
    CALayer *btnLayer1 = [self.tableview1 layer];
    [btnLayer1 setMasksToBounds:YES];
    [btnLayer1 setCornerRadius:5.0f];
    
    self.save.frame =CGRectMake(25, 460, 120, 50);
    self.cancel.frame =CGRectMake(170, 460, 120, 50);
    CGSize result = [[UIScreen mainScreen] bounds].size;
    if(result.height == 480)
    {
        self.save.frame =CGRectMake(45, 430, 100, 40);
        self.cancel.frame =CGRectMake(180, 430, 100, 40);
        
    }
    
    
    [self.save setTitle:@"SAVE" forState:UIControlStateNormal];
    [self.cancel setTitle:@"CANCEL" forState:UIControlStateNormal];
    self.save.backgroundColor = [self colorFromHexString:@"#00f978"];
    self.cancel.backgroundColor = [self colorFromHexString:@"#da5950"];
    CALayer *btnLayer2 = [self.save layer];
    [btnLayer2 setMasksToBounds:YES];
    [btnLayer2 setCornerRadius:5.0f];
    CALayer *btnLayer3 = [self.cancel layer];
    [btnLayer3 setMasksToBounds:YES];
    [btnLayer3 setCornerRadius:5.0f];
    
    [self.view addSubview:self.save];
    [self.view addSubview:self.cancel];
    self.myfrndid =[[NSMutableArray alloc]init];
    self.firstname =[[NSMutableArray alloc]init];
    self.lastname=[[NSMutableArray alloc]init];
    self.addedfname =[[NSMutableArray alloc]init];
    self.addedlname=[[NSMutableArray alloc]init];
    self.addfrndid =[[NSMutableArray alloc]init];
    self.array1=[[NSMutableArray alloc]init];
    self.arrayCellChecked1=[[NSMutableArray alloc]init];
    
    [self.save addTarget:self action:@selector(addfrndtocircle) forControlEvents:UIControlEventTouchUpInside];
    [self.cancel addTarget:self action:@selector(cancelclick) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)cancelclick
{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewDidAppear:(BOOL)animated
{
    
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(0,5,70,40)];
    title.text=self.circlename;
    title.font=[UIFont fontWithName:@"oswald-regular" size:19.0f];
    title.textColor=[UIColor whiteColor];
    self.navigationItem.titleView=title;
    [self getfriends];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
-(void) getfriends
{
    
    NSUserDefaults *pref =[NSUserDefaults standardUserDefaults];
    NSString *token = [pref objectForKey:@"Token"];
    NSString *ID = [pref objectForKey:@"ID"];
    NSURL *url = [NSURL URLWithString:Netcheckurl];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    
    
    if(data)
    {
        
        UIActivityIndicatorView *wait=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        wait.color=[self colorFromHexString:@"#bfdecc"];
        UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(105,4,150,20)];
        lbl.text=@"loading...";
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
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString * string = [NSString stringWithFormat:@"http://numa.simpliot.com/api/friends?user_id=%@&token=%@",ID,token];
        
        string = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [manager GET: string parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *data =[responseObject valueForKeyPath:@"data"];
            NSArray *friends = [[NSArray alloc]init];
            friends =[data objectForKey:@"friends"];
            NSMutableArray *friendlist = [[NSMutableArray alloc]init];
            
            NSDictionary *frndinfo = [[NSDictionary alloc]init];
            
            NSMutableArray *finfo = [[NSMutableArray alloc]init];
            //            NSLog(@"friend %@",friends);
            for( NSDictionary *dic in friends)
            {
                [friendlist addObject:[dic objectForKey:@"user"]];
                [self.addfrndid addObject:[dic objectForKey:@"friend_id"]];
                
            }
            
            
            
            for(int i=0;i<friendlist.count;i++)
            {
                
                finfo = [friendlist objectAtIndex:i];
                frndinfo = [finfo objectAtIndex:0];
                [self.myfrndid addObject:[frndinfo objectForKey:@"id"]];
            }
            NSLog(@"frnd list %@",friendlist);
            for(int j=0;j<self.userid.count;j++)
            {
                
                NSString *string =[self.userid objectAtIndex:j];
                for(int i=0;i<friendlist.count;i++)
                {
                    
                    finfo = [friendlist objectAtIndex:i];
                    frndinfo = [finfo objectAtIndex:0];
                    if([[frndinfo objectForKey:@"id"] isEqualToString:string])
                    {
                        [self.addedfname addObject:[frndinfo objectForKey:@"first_name"]];
                        [self.addedlname addObject: [frndinfo objectForKey:@"last_name"]];
                    }
                    
                    
                }
            }
            
            [self.myfrndid removeObjectsInArray:self.userid];
            
            //            NSLog(@"my frnd list %@",frndinfo);
            NSMutableArray *remove = [[NSMutableArray alloc]init];
            
            for(int j=0;j<self.myfrndid.count;j++)
            {
                
                NSString *string =[self.myfrndid objectAtIndex:j];
                for(int i=0;i<friendlist.count;i++)
                {
                    
                    finfo = [friendlist objectAtIndex:i];
                    frndinfo = [finfo objectAtIndex:0];
                    if([[frndinfo objectForKey:@"id"] isEqualToString:string]&& [[frndinfo objectForKey:@"linked"]integerValue]==1)
                    {
                        [self.firstname addObject:[frndinfo objectForKey:@"first_name"]];
                        [self.lastname addObject: [frndinfo objectForKey:@"last_name"]];
                    }
                    else  if([[frndinfo objectForKey:@"linked"]integerValue]==0)
                        
                    {
                        
                        NSString * string =[NSString stringWithFormat:@"%d",i];
                        [remove addObject:string];
                        //                    [self.email removeObjectAtIndex:j];
                        
                        
                        
                    }
                }
            }
            NSMutableArray *removed = [[NSMutableArray alloc]init];
            
            for(int i=0;i<remove.count;i++)
            {
                
                int j = [[remove objectAtIndex:i]intValue];
                
                [removed addObject:[self.addfrndid objectAtIndex:j]];
                
            }
            
            [self.addfrndid removeObjectsInArray:removed];
            [self.addfrndid removeObjectsInArray:self.frndid];
            
            
            
            
            //            NSLog(@"add frnd id %@",self.addfrndid);
            [self.tableview1 reloadData];
            [self.tableview2 reloadData];
            [waitale dismissWithClickedButtonIndex:0 animated:YES];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
             [self popup:message_503  Title:title_503 image:@"ServerError.png"];
            [waitale dismissWithClickedButtonIndex:0 animated:YES];
            
        }];
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView==self.tableview1)
    {
        
        return self.addedfname.count;
    }
    
    if(tableView==self.tableview2)
    {
        
        return self.firstname.count;
    }
    else
        return NO;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"] ;
        
    }
    
    if(tableView==self.tableview1)
    {
        
        CirclefrndsTableViewCell *cell = (CirclefrndsTableViewCell *)[self.tableview1 dequeueReusableCellWithIdentifier:@"Cell"];
        
        cell.layer.cornerRadius=5;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        NSString *string = [NSString stringWithFormat:@"%@ %@",[self.addedfname objectAtIndex:indexPath.row],[self.addedlname objectAtIndex:indexPath.row]];
        cell.firstname.text = string;
        cell.firstname.font=[UIFont fontWithName:@"oswald-regular" size:20.0f];
        
        
        return cell;
    }
    if(tableView==self.tableview2)
    {
        
        AddfrndsTableViewCell *cell = (AddfrndsTableViewCell *)[self.tableview2 dequeueReusableCellWithIdentifier:@"Cell"];
        
        cell.layer.cornerRadius=5;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        NSString *string = [NSString stringWithFormat:@"%@ %@",[self.firstname objectAtIndex:indexPath.row],[self.lastname objectAtIndex:indexPath.row]];
        cell.addfirstname.text = string;
        cell.addfirstname.font=[UIFont fontWithName:@"oswald-regular" size:20.0f];
        cell.checkmark.tag =indexPath.row;
        cell.addid.text =[self.addfrndid objectAtIndex:indexPath.row];
        
        if(![_arrayCellChecked1 containsObject:[NSString stringWithFormat:@"%ld",(long)cell.checkmark.tag]])
        {
            
            [cell.checkmark setImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
            [cell.checkmark setSelected:YES];
            
        }
        
        if([_arrayCellChecked1 containsObject:[NSString stringWithFormat:@"%ld",(long)cell.checkmark.tag]])
        {
            
            [cell.checkmark setImage:[UIImage imageNamed:@"checkbox_03.png"] forState:UIControlStateNormal];
            [cell.checkmark setSelected:NO];
            
        }
        

        [cell.checkmark addTarget:self action:@selector(buttonClicked1:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    
    
    
    return cell;
    
}


-(void)buttonClicked1:(id)sender
{
    CGPoint touchPoint = [sender convertPoint:CGPointZero toView:self.tableview2];
    NSIndexPath *indexPath = [self.tableview2 indexPathForRowAtPoint:touchPoint];
    
    AddfrndsTableViewCell *thisCell = (AddfrndsTableViewCell *)[self.tableview2 cellForRowAtIndexPath:indexPath];
    if(thisCell.checkmark.selected == YES)
    {
        [thisCell.checkmark setImage:[UIImage imageNamed:@"checkbox_03.png"] forState:UIControlStateNormal];
        
        [self.array1 addObject:thisCell.addid.text];
        [thisCell.checkmark setSelected:NO];
        [_arrayCellChecked1 addObject:[NSString stringWithFormat:@"%ld",(long)thisCell.checkmark.tag]];
        NSLog(@"records insert%@",_arrayCellChecked1);
        
        
        
    }
    
    else if(thisCell.checkmark.selected == NO)
    {
        [thisCell.checkmark setImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
        [_arrayCellChecked1 removeObject:[NSString stringWithFormat:@"%ld",(long)thisCell.checkmark.tag]];
        long n=[self.array1 indexOfObject:thisCell.addid.text];
        if(n<[self.array1 count])
        [self.array1 removeObjectAtIndex:n];
        NSLog(@"records delete%@",self.array1);
        [thisCell.checkmark setSelected:YES];
    }
    
    
    
    
}


-(void)addfrndtocircle
{
    
    NSUserDefaults *pref =[NSUserDefaults standardUserDefaults];
    NSString *token = [pref objectForKey:@"Token"];
    NSString *ID = [pref objectForKey:@"ID"];
    NSURL *url = [NSURL URLWithString:@"http://www.google.com"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    

    if(self.array1.count>0 && data)
    {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        UIActivityIndicatorView *wait=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        wait.color=[self colorFromHexString:@"#bfdecc"];
        UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(105,4,150,20)];
        lbl.text=@"Adding Circles...";
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
        
        
        NSDictionary *params = @{@"user_id":ID,
                                 @"friend_id":self.array1,
                                 @"circle_id":self.circleid,
                                 @"token":token
                                 };
        
        
        [manager POST:AddFriend parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            
            NSDictionary * data =[responseObject valueForKeyPath:@"data"];
      
            UIView *popview=[[UIView alloc] initWithFrame:CGRectMake(0,0,200,90)];
            popview.backgroundColor=[self colorFromHexString:@"#ececec"];
            UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sucess.png"]];
            image.frame=CGRectMake(30,34,40,40);
            [popview addSubview:image];
            
            UILabel *lbl2=[[UILabel alloc] initWithFrame:CGRectMake(48,3,165,30)];
            lbl2.font=[UIFont fontWithName:@"oswald-regular" size:20.0f];
            lbl2.text=@"status";
            lbl2.textColor=[self colorFromHexString:@"#f3a64c"];
            lbl2.textAlignment=NSTextAlignmentCenter;
            [popview insertSubview:lbl2 atIndex:4];
            
            UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(80,22,150,60)];
            lbl.font=[UIFont fontWithName:@"oswald-regular" size:12.0f];
            lbl.lineBreakMode=NSLineBreakByWordWrapping;
            lbl.numberOfLines=5;
            lbl.text=[data objectForKey:@"message"];
            lbl.textColor=[self colorFromHexString:@"#858585"];
            [popview insertSubview:lbl atIndex:5];
            
            UIAlertView *ale=[[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
            [ale setValue:popview forKey:@"accessoryView"];
            ale.tag=1;
            [ale show];

            [waitale dismissWithClickedButtonIndex:0 animated:YES];
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            
            [waitale dismissWithClickedButtonIndex:0 animated:YES];
           [self popup:message_503  Title:title_503 image:@"ServerError.png"];
            
        }];
        
    }
    
    
    else if(self.array1.count==0 && data)
        
    {
        
    
        [self popup:@"Please select friends to add" Title:@"Message" image:@"info.png"];
    }
    
    else if(!data)
    {
        
        [self popup:OfflineMsg Title:OfflineTitle image:@"offline.png"];
    }

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    if(alertView.tag==1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

@end
