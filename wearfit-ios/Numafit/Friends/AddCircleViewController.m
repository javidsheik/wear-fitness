//
//  AddCircleViewController.m
//  Numafit
//
//  Created by iHotra-LT-02 on 22/11/14.
//  Copyright (c) 2014 sanhotrasoft. All rights reserved.
//

#import "AddCircleViewController.h"
#import "AFNetworking.h"
#import "AddCircleCell.h"
#import "CircleListViewController.h"
#import "URL.h"

@interface AddCircleViewController ()

@end

@implementation AddCircleViewController

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
    self.name.delegate=self;
    self.desc.delegate=self;
    self.tag.delegate=self;
    self.save =[[UIButton alloc]init];
    self.cancel=[[UIButton alloc]init];
    self.firstname =[[NSMutableArray alloc]init];
    self.lastname =[[NSMutableArray alloc]init];
    self.email =[[NSMutableArray alloc]init];
    [self.firstname removeAllObjects];
    [self.lastname removeAllObjects];
    [self.email removeAllObjects];
    _array1 = [[NSMutableArray alloc]init];
    _arrayCellChecked1= [[NSMutableArray alloc]init];
    _frnds =  [[NSMutableArray alloc]init];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.view.backgroundColor =[self colorFromHexString:@"#e2e0e0"];
    self.view3.backgroundColor =[self colorFromHexString:@"#11a4ff"];
    CALayer *btnLayer = [self.view2 layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
    
    CALayer *btnLayer1 = [self.tableView layer];
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
    
    
    CALayer *btnLayer4 = [self.name layer];
    [btnLayer4 setMasksToBounds:YES];
    [btnLayer4 setCornerRadius:5.0f];
    
    CALayer *btnLayer5 = [self.desc layer];
    [btnLayer5 setMasksToBounds:YES];
    [btnLayer5 setCornerRadius:5.0f];
    
    
    CALayer *btnLayer6 = [self.tag layer];
    [btnLayer6 setMasksToBounds:YES];
    [btnLayer6 setCornerRadius:5.0f];
    
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0,20, 20)];
    self.name.leftView = paddingView1;
    self.name.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0,20, 20)];
    self.desc.leftView = paddingView2;
    self.desc.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0,20, 20)];
    self.tag.leftView = paddingView3;
    self.tag.leftViewMode = UITextFieldViewModeAlways;
    
    self.name.layer.masksToBounds=YES;
    self.name.layer.borderColor=[[self colorFromHexString:@"#dedede"]CGColor];
    self.name.layer.borderWidth= 1.0f;
    self.name.font =  [UIFont fontWithName:@"oswald-regular" size:16.0f];
    self.desc.font= [UIFont fontWithName:@"oswald-regular" size:16.0f];
    self.tag.font= [UIFont fontWithName:@"oswald-regular" size:16.0f];
    self.name.textColor =[self colorFromHexString:@"#abaaab"];
    self.desc.textColor=[self colorFromHexString:@"#abaaab"];
    self.tag.textColor =[self colorFromHexString:@"#abaaab"];
    
    self.desc.layer.masksToBounds=YES;
    self.desc.layer.borderColor=[[self colorFromHexString:@"#dedede"]CGColor];
    self.desc.layer.borderWidth= 1.0f;
    
    
    self.tag.layer.masksToBounds=YES;
    self.tag.layer.borderColor=[[self colorFromHexString:@"#dedede"]CGColor];
    self.tag.layer.borderWidth= 1.0f;
    
    [[self.save titleLabel] setFont:[UIFont fontWithName:@"oswald-bold" size:16.0f]];
    [[self.cancel titleLabel] setFont:[UIFont fontWithName:@"oswald-bold" size:16.0f]];
    [self.view addSubview:self.save];
    [self.view addSubview:self.cancel];
    
    self.pickfrnd.font = [UIFont fontWithName:@"oswald-regular" size:16.0f];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIColor *color = [self colorFromHexString:@"#abaaab"];
    self.name.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"Circle Name"
                                    attributes:@{
                                                 NSForegroundColorAttributeName: color,
                                                 NSFontAttributeName : [UIFont fontWithName:@"oswald-regular" size:16.0]
                                                 }
     ];
    
    
    self.desc.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"Description"
                                    attributes:@{
                                                 NSForegroundColorAttributeName: color,
                                                 NSFontAttributeName : [UIFont fontWithName:@"oswald-regular" size:16.0]
                                                 }
     ];
    
    
    
    self.tag.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"Tag"
                                    attributes:@{
                                                 NSForegroundColorAttributeName: color,
                                                 NSFontAttributeName : [UIFont fontWithName:@"oswald-regular" size:16.0]
                                                 }
     ];
    
    [self.save addTarget:self action:@selector(saveclick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.cancel addTarget:self action:@selector(cancelclick) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)cancelclick
{
    
    [self.navigationController popViewControllerAnimated:YES];
}


-(UIColor *)colorFromHexString:(NSString *)hexString
{
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1];
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}
-(void) viewDidAppear:(BOOL)animated
{
    [self getfriends];
    
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(0,5,70,20)];
    title.text=@"Add Circle";
    title.font=[UIFont fontWithName:@"oswald-regular" size:19.0f];
    title.textColor=[UIColor whiteColor];
    self.navigationItem.titleView=title;
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            NSLog(@"friends %@",data);
            NSMutableArray *friendlist = [[NSMutableArray alloc]init];
            
            NSDictionary *frndinfo = [[NSDictionary alloc]init];
            
            NSMutableArray *finfo = [[NSMutableArray alloc]init];
            
            for( NSDictionary *dic in friends)
            {
                [self.email addObject:[dic objectForKey:@"friend_id"]];
                [friendlist addObject:[dic objectForKey:@"user"]];
            }
            
            //            NSLog(@"id %@",self.email);
            NSMutableArray *remove = [[NSMutableArray alloc]init];
            for(int i=0;i<friendlist.count;i++)
            {
                finfo = [friendlist objectAtIndex:i];
                frndinfo = [finfo objectAtIndex:0];
                if([[frndinfo objectForKey:@"linked"]integerValue]==1)
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
            NSMutableArray *removed = [[NSMutableArray alloc]init];
            
            for(int i=0;i<remove.count;i++)
            {
                
                int j = [[remove objectAtIndex:i]intValue];
                
                [removed addObject:[self.email objectAtIndex:j]];
                
            }
            
            [self.email removeObjectsInArray:removed];
            //            NSLog(@"email %@",self.email);
            
            [self.tableView reloadData];
            [waitale dismissWithClickedButtonIndex:0 animated:YES];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.firstname count];
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"] ;
        
    }
    
    self.tableView.separatorColor=[UIColor clearColor];
    
    
    if(tableView==self.tableView)
    {
        
        AddCircleCell *cell = (AddCircleCell *)[self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
        
        cell.layer.cornerRadius=5;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        NSString *string =[NSString stringWithFormat:@"%@ %@", [self.firstname objectAtIndex:indexPath.row],[self.lastname objectAtIndex:indexPath.row]];
        cell.frndname.text=string;
        cell.emailid.text = [self.email objectAtIndex:indexPath.row];
        cell.frndname.font=[UIFont fontWithName:@"oswald-regular" size:20.0f];
        cell.frndname.textColor =[UIColor blackColor];
        
        cell.checkmark.tag =indexPath.row;
        
        
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




- (void)saveclick
{
    
    
    NSUserDefaults *pref =[NSUserDefaults standardUserDefaults];
    NSString *token = [pref objectForKey:@"Token"];
    NSString *ID = [pref objectForKey:@"ID"];
    
    NSLog(@"token %@",token);
    NSLog(@"id %@",ID);
    NSString *trimmedString = [self.name.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSURL *url = [NSURL URLWithString:@"http://www.google.com"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    if(trimmedString.length == 0)
    {
        
        [self popup:@"Enter circle name to save" Title:@"Message" image:@"info.png"];
        
    }
    
    
    else if( trimmedString.length >0 &&  data.length > 0)
    {
        
        
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
        self.waitale=[[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
        [wait startAnimating];
        [self.waitale setValue:v forKey:@"accessoryView"];
        [self.waitale show];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        
        NSDictionary *params = @{@"user_id":ID,
                                 @"name":trimmedString,
                                 @"description":self.desc.text,
                                 @"tags":self.tag.text,
                                 @"token":token
                                 };
        
        
        [manager POST:CreateCircle parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //            NSLog(@"JSON: %@", responseObject);
            
            NSDictionary * data =[responseObject valueForKeyPath:@"data"];
            NSDictionary *circle = [data objectForKey:@"circle"];
            self.circleid = [circle objectForKey:@"_id"];
            
            if(_array1.count > 0)
            {
                [self addfrndtocircle];
                
            }
            else
            {
                
                [self.waitale dismissWithClickedButtonIndex:0 animated:YES];
               
               
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

            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            
            [self popup:@"Error saving try again later" Title:@"Status" image:@"error.png"];
           [self.waitale dismissWithClickedButtonIndex:0 animated:YES];
        }];
        
    }
    else
    {
        
       [self popup:OfflineMsg Title:OfflineTitle image:@"offline.png"];
        
    }
    
}



-(void)buttonClicked1:(id)sender
{
    CGPoint touchPoint = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:touchPoint];
    
    AddCircleCell *thisCell = (AddCircleCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    if(thisCell.checkmark.selected == YES)
    {
        [thisCell.checkmark setImage:[UIImage imageNamed:@"checkbox_03.png"] forState:UIControlStateNormal];
        
        [self.array1 addObject:thisCell.emailid.text];
        [thisCell.checkmark setSelected:NO];
        [_arrayCellChecked1 addObject:[NSString stringWithFormat:@"%ld",(long)thisCell.checkmark.tag]];
        
        NSLog(@"array %@",_arrayCellChecked1);
        
    }
    
    else if(thisCell.checkmark.selected == NO)
    {
        [thisCell.checkmark setImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
        [_arrayCellChecked1 removeObject:[NSString stringWithFormat:@"%ld",(long)thisCell.checkmark.tag]];
        long n=[self.array1 indexOfObject:thisCell.emailid.text];
        if(n<[self.array1 count])
            [self.array1 removeObjectAtIndex:n];
        [thisCell.checkmark setSelected:YES];
    }
    
}


-(void)addfrndtocircle
{

    NSUserDefaults *pref =[NSUserDefaults standardUserDefaults];
    NSString *token = [pref objectForKey:@"Token"];
    NSString *ID = [pref objectForKey:@"ID"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    NSDictionary *params = @{@"user_id":ID,
                             @"friend_id":self.array1,
                             @"circle_id":self.circleid,
                             @"token":token
                             };
    
    
    [manager POST:AddFriend parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        NSDictionary * data =[responseObject valueForKeyPath:@"data"];
        [self.waitale dismissWithClickedButtonIndex:0 animated:YES];
       
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
        ale.tag=2;
        [ale show];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
               [self.waitale dismissWithClickedButtonIndex:0 animated:YES];
        [self popup:message_503  Title:title_503 image:@"ServerError.png"];
        
    }];
    
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    if(alertView.tag==1 || alertView.tag==2)
    {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}
-(BOOL)prefersStatusBarHidden
{
    
    return YES;
}
@end
