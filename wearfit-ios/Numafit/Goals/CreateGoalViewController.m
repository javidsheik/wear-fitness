//
//  CreateGoalViewController.m
//  Numafit
//
//  Created by iHotra-LT-02 on 01/12/14.
//  Copyright (c) 2014 sanhotrasoft. All rights reserved.
//

#import "CreateGoalViewController.h"
#import "AFNetworking.h"
#import "ViewGoalViewController.h"
#import "URL.h"

@interface CreateGoalViewController ()

@end

@implementation CreateGoalViewController

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
    self.view1.backgroundColor = [ self colorFromHexString:@"#f3f0f0"];
    self.view.backgroundColor =[self colorFromHexString:@"#ddd9d9"];
    CALayer *btnLayer = [self.view1 layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
    
    
    self.AP.textColor = [self colorFromHexString:@"#767373"];
     self.goaldis.textColor = [self colorFromHexString:@"#767373"];
     self.goalstep.textColor = [self colorFromHexString:@"#767373"];
    self.Dailyper.textColor = [self colorFromHexString:@"#767373"];
    self.weightlab.textColor = [self colorFromHexString:@"#767373"];
    [self.Activity_Points setTextColor: [self colorFromHexString:@"#767373"]];
    [self.Daily_Percent setTextColor: [self colorFromHexString:@"#767373"]];
    [self.goalsteps setTextColor: [self colorFromHexString:@"#767373"]];
    [self.goaldist setTextColor: [self colorFromHexString:@"#767373"]];
    [self.weighttext setTextColor: [self colorFromHexString:@"#767373"]];
    [self.meter setTextColor: [self colorFromHexString:@"#767373"]];
    [self.percent setTextColor: [self colorFromHexString:@"#767373"]];
    self.Activity_Points.layer.masksToBounds=YES;
    self.Activity_Points.layer.borderColor=[[self colorFromHexString:@"#d1d1d1"]CGColor];
    self.Activity_Points.layer.borderWidth= 1.0f;
    
    self.Daily_Percent.layer.masksToBounds=YES;
    self.Daily_Percent.layer.borderColor=[[self colorFromHexString:@"#d1d1d1"]CGColor];
    self.Daily_Percent.layer.borderWidth= 1.0f;
    
    
    self.unit.layer.masksToBounds=YES;
    self.unit.layer.borderColor=[[self colorFromHexString:@"#d1d1d1"]CGColor];
    self.unit.layer.borderWidth= 1.0f;
    
    self.goaldist.layer.masksToBounds=YES;
    self.goaldist.layer.borderColor=[[self colorFromHexString:@"#d1d1d1"]CGColor];
    self.goaldist.layer.borderWidth= 1.0f;

    
    self.goalsteps.layer.masksToBounds=YES;
    self.goalsteps.layer.borderColor=[[self colorFromHexString:@"#d1d1d1"]CGColor];
    self.goalsteps.layer.borderWidth= 1.0f;

    
    self.weighttext.layer.masksToBounds=YES;
    self.weighttext.layer.borderColor=[[self colorFromHexString:@"#d1d1d1"]CGColor];
    self.weighttext.layer.borderWidth= 1.0f;
    self.Dailyper.font = [UIFont fontWithName:@"oswald-regular" size:19.0f];
    self.AP.font = [UIFont fontWithName:@"oswald-regular" size:19.0f];
    self.weightlab.font = [UIFont fontWithName:@"oswald-regular" size:19.0f];
     self.goaldis.font = [UIFont fontWithName:@"oswald-regular" size:19.0f];
     self.goalstep.font = [UIFont fontWithName:@"oswald-regular" size:19.0f];
    self.meter.font = [UIFont fontWithName:@"oswald-regular" size:19.0f];
     self.percent.font = [UIFont fontWithName:@"oswald-regular" size:19.0f];
    
    
    self.goaldist.font = [UIFont fontWithName:@"oswald-regular" size:18.0f];
    self.goalsteps.font = [UIFont fontWithName:@"oswald-regular" size:18.0f];
    
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0,20, 20)];
    self.Daily_Percent.leftView = paddingView1;
    self.Daily_Percent.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0,20, 20)];
    self.Activity_Points.leftView = paddingView2;
    self.Activity_Points.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0,20, 20)];
    self.weighttext.leftView = paddingView3;
    self.weighttext.leftViewMode = UITextFieldViewModeAlways;
    
    [self.unit setTitleColor:[self colorFromHexString:@"#767373"] forState:UIControlStateNormal];
    [[self.unit titleLabel] setFont:[UIFont fontWithName:@"oswald-regular" size:18.0f]];
    self.weighttext.font =[UIFont fontWithName:@"oswald-regular" size:18.0f];
    
    self.save = [[UIButton alloc]init];
    self.cancel = [[UIButton alloc]init];
    self.save.frame =CGRectMake(35, 385, 251, 45);
    self.cancel.frame =CGRectMake(35, 460, 251, 45);
    [self.save setTitle:@"SAVE" forState:UIControlStateNormal];
    [self.cancel setTitle:@"CANCEL" forState:UIControlStateNormal];
    CGSize result = [[UIScreen mainScreen] bounds].size;
    self.save.showsTouchWhenHighlighted=YES;
    self.cancel.showsTouchWhenHighlighted=YES;
    self.Activity_Points.font =[UIFont fontWithName:@"oswald-regular" size:18.0f];
    self.Daily_Percent.font =[UIFont fontWithName:@"oswald-regular" size:18.0f];
    if(result.height ==480)
    {
        self.save.frame =CGRectMake(35, 370, 251, 45);
        self.cancel.frame =CGRectMake(35, 425, 251, 45);
        
    }
    
    CALayer *btnLayer2 = [self.save layer];
    [btnLayer2 setMasksToBounds:YES];
    [btnLayer2 setCornerRadius:5.0f];
    CALayer *btnLayer1 = [self.cancel layer];
    [btnLayer1 setMasksToBounds:YES];
    [btnLayer1 setCornerRadius:5.0f];
    [[self.save titleLabel] setFont:[UIFont fontWithName:@"oswald-regular" size:16.0f]];
    [[self.cancel titleLabel] setFont:[UIFont fontWithName:@"oswald-regular" size:16.0f]];
    self.save.backgroundColor = [self colorFromHexString:@"#31d4fd"];
    self.cancel.backgroundColor = [self colorFromHexString:@"#fb5e93"];
    [self.view addSubview:self.save];
    [self.view addSubview:self.cancel];
    
    self.Activity_Points.delegate=self;
    self.Daily_Percent.delegate=self;
    self.weighttext.delegate=self;
    self.goaltype = [[NSMutableArray alloc]init];
    self.tableView =[[UITableView alloc]init];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.unit.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.unit.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [self.save addTarget:self action:@selector(savegoal) forControlEvents:UIControlEventTouchUpInside];
    [self.cancel  addTarget:self action:@selector(cancelgoal) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)cancelgoal
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewDidAppear:(BOOL)animated
{
    
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(0,5,70,20)];
    title.text=@"Add Goal";
    title.font=[UIFont fontWithName:@"oswald-regular" size:20.0f];
    title.textColor=[UIColor whiteColor];
    self.navigationItem.titleView=title;
    
}

-(UIColor *)colorFromHexString:(NSString *)hexString
{
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    
    if (textField==self.weighttext) {
        
        NSString *value = [self.weighttext.text stringByReplacingCharactersInRange:range withString:string];
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        [f setPositiveFormat:@"0.##"];
        NSNumber *valuechanged = [f numberFromString:value];
        
        if(self.weighttext.text.length > 10 && range.length==0)
        {
            return NO;
            
        }
        
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        NSString *expression = @"^([0-9]+)?(\\.([0-9]{1,2})?)?$";
        
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:nil];
        NSUInteger numberOfMatches = [regex numberOfMatchesInString:newString
                                                            options:0
                                                              range:NSMakeRange(0, [newString length])];
        if (numberOfMatches == 0)
        {
            return NO;
        }
        
        if([self.unit.titleLabel.text isEqualToString:@"Kg"])
        {
            NSNumber *calorieschanged = [NSNumber numberWithFloat:([valuechanged floatValue] * 7700)];
            
            self.Activity_Points.text = [f stringFromNumber:[NSNumber numberWithFloat:[calorieschanged floatValue]]];
            
            NSString *value = self.Activity_Points.text;
            NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
            [f setNumberStyle:NSNumberFormatterDecimalStyle];
            [f setPositiveFormat:@"0.##"];
            
            NSNumber *valuechanged = [f numberFromString:value];
            NSNumber *steps = [NSNumber numberWithFloat:([valuechanged floatValue] * 24)];
            NSNumber *distance = [NSNumber numberWithFloat:([valuechanged floatValue] * 9)];
            
            self.goalsteps.text = [f stringFromNumber:[NSNumber numberWithFloat:[steps floatValue]]];
            self.goaldist.text = [NSString stringWithFormat:@"%@ M",[f stringFromNumber:[NSNumber numberWithFloat:[distance floatValue]]]];

            
        }
        
        if([self.unit.titleLabel.text isEqualToString:@"Lb"])
        {
            
            NSNumber *calorieschanged = [NSNumber numberWithFloat:([valuechanged floatValue] * 3500)];
            
            self.Activity_Points.text = [f stringFromNumber:[NSNumber numberWithFloat:[calorieschanged floatValue]]];
            NSString *value = self.Activity_Points.text;
            NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
            [f setNumberStyle:NSNumberFormatterDecimalStyle];
            [f setPositiveFormat:@"0.##"];
            
            NSNumber *valuechanged = [f numberFromString:value];
            NSNumber *steps = [NSNumber numberWithFloat:([valuechanged floatValue] * 24)];
            NSNumber *distance = [NSNumber numberWithFloat:([valuechanged floatValue] * 9)];
            
            self.goalsteps.text = [f stringFromNumber:[NSNumber numberWithFloat:[steps floatValue]]];
           self.goaldist.text =[f stringFromNumber:[NSNumber numberWithFloat:[distance floatValue]]];
            
        }
        
    }
    
    if(textField==self.Activity_Points)
    {
        NSString *value = [self.Activity_Points.text stringByReplacingCharactersInRange:range withString:string];
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        [f setPositiveFormat:@"0.##"];
        
        if(self.Activity_Points.text.length > 10 && range.length==0)
        {
            return NO;
            
        }
        
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        NSString *expression = @"^([0-9]+)?(\\.([0-9]{1,2})?)?$";
        
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:nil];
        NSUInteger numberOfMatches = [regex numberOfMatchesInString:newString
                                                            options:0
                                                              range:NSMakeRange(0, [newString length])];
        if (numberOfMatches == 0)
        {
            return NO;
        }


        NSNumber *valuechanged = [f numberFromString:value];
        NSNumber *steps = [NSNumber numberWithFloat:([valuechanged floatValue] * 24)];
        NSNumber *distance = [NSNumber numberWithFloat:([valuechanged floatValue] * 9)];
        self.goalsteps.text = [f stringFromNumber:[NSNumber numberWithFloat:[steps floatValue]]];
        self.goaldist.text =[f stringFromNumber:[NSNumber numberWithFloat:[distance floatValue]]];

        if([self.unit.titleLabel.text isEqualToString:@"Kg"])
        {
        NSNumber *weight =[NSNumber numberWithFloat:([valuechanged floatValue]*0.0001298)];
        self.weighttext.text = [f stringFromNumber:[NSNumber numberWithFloat:[weight floatValue]]];
        }
        else
        {
            
            NSNumber *weight =[NSNumber numberWithFloat:([valuechanged floatValue]*0.0002857)];
            self.weighttext.text = [f stringFromNumber:[NSNumber numberWithFloat:[weight floatValue]]];
        }
        
        
    }
    
    if(textField==self.Daily_Percent)
    {
    
        
        if(self.Daily_Percent.text.length > 10 && range.length==0)
        {
            return NO;
            
        }
        
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        NSString *expression = @"^([0-9]+)?(\\.([0-9]{1,2})?)?$";
        
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:nil];
        NSUInteger numberOfMatches = [regex numberOfMatchesInString:newString
                                                            options:0
                                                              range:NSMakeRange(0, [newString length])];
        if (numberOfMatches == 0)
        {
            return NO;
        }

    }
    
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    
    [self.Activity_Points resignFirstResponder];
    [self.Daily_Percent resignFirstResponder];
    [self.weighttext resignFirstResponder];
    [self.tableView removeFromSuperview];
    
    
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    [self.tableView removeFromSuperview];
}
-(BOOL)prefersStatusBarHidden
{
    
    return YES;
}
-(void)savegoal
{
    
    UIActivityIndicatorView *wait=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    wait.color=[self colorFromHexString:@"#bfdecc"];
    UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(105,4,150,20)];
    lbl.text=@"Creating Goal...";
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
    
    NSUserDefaults *pref =[NSUserDefaults standardUserDefaults];
    NSString *token = [pref objectForKey:@"Token"];
    NSString *ID = [pref objectForKey:@"ID"];
    NSLog(@"token %@",token);
    NSLog(@"id %@",ID);
    
    
    
    NSURL *url = [NSURL URLWithString:Netcheckurl];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    NSString * dailyincrement = [[NSString alloc]init];
    dailyincrement = self.Daily_Percent.text;
    if(self.Daily_Percent.text.length==0)
    {
        dailyincrement = @"0";
        
    }
  
        if(self.Activity_Points.text.length == 0)
        {
            
           
            [waitale dismissWithClickedButtonIndex:0 animated:YES];
             [self popup:@"Enter Calories to save" Title:@"Invalid" image:@"invalid.png"];
            
            
            
        }
    
        else if([self.Activity_Points.text isEqualToString:@"0"])
        {
            
            
            [waitale dismissWithClickedButtonIndex:0 animated:YES];
            [self popup:@"Enter valid Calories to save" Title:@"Invalid" image:@"invalid.png"];
            
            
            
        }

        
        else  if(self.Activity_Points.text.length >0 && data.length > 0 && ![self.Activity_Points.text isEqualToString:@"0"])
        {
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            
            
            NSDictionary *params = @{@"user_id":ID,
                                     @"daily_percent":dailyincrement,
                                     @"daily_calories":self.Activity_Points.text,
                                     @"daily_distance":self.self.goaldist.text,
                                     @"daily_steps" : self.goalsteps.text,
                                     @"token":token
                                     };
            
            
            [manager POST:creategoal parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"JSON: %@", responseObject);
                [pref setObject:self.Activity_Points.text forKey:@"caloriegoal"];
                [pref setObject:self.goalsteps.text forKey:@"stepsgoal"];
                [pref setObject:self.goaldist.text forKey:@"distgoal"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                NSDictionary * data =[responseObject valueForKeyPath:@"data"];
                [waitale dismissWithClickedButtonIndex:0 animated:YES];
                [self popup:[data objectForKey:@"message"]  Title:@"Status" image:@"sucess.png"];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                  [self popup:message_503  Title:title_503 image:@"ServerError.png"];
                [waitale dismissWithClickedButtonIndex:0 animated:YES];
            }];
            
        }
        else if(data.length==0)
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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return self.goaltype.count;
    
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text= [self.goaltype objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"oswald-regular" size:18.0f];
    cell.textLabel.textColor = [self colorFromHexString:@"#767373"];
    return cell;
    
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(tableView==self.tableView)
    {
        UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
        NSString *cellText;
        cellText = selectedCell.textLabel.text;
        NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
        [fmt setPositiveFormat:@"0.##"];
        if(self.unit.selected == YES)
        {
            
            [self.unit setTitle:cellText forState:UIControlStateNormal];
            [self.unit setTitleColor:[self colorFromHexString:@"#767373"] forState:UIControlStateSelected];
            [self.unit setTitleColor:[self colorFromHexString:@"#767373"] forState:UIControlStateNormal];
            [self.tableView removeFromSuperview];
            
            if([cellText isEqualToString:@"Kg"])
            {
                
                
                NSNumber *calorieschanged = [NSNumber numberWithFloat:([self.weighttext.text floatValue] * 7700)];
                self.Activity_Points.text = [fmt stringFromNumber:[NSNumber numberWithFloat:[calorieschanged floatValue]]];
                NSString *value = self.Activity_Points.text;
                NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
                [f setNumberStyle:NSNumberFormatterDecimalStyle];
                [f setPositiveFormat:@"0.##"];
                
                NSNumber *valuechanged = [f numberFromString:value];
                NSNumber *steps = [NSNumber numberWithFloat:([valuechanged floatValue] * 24)];
                NSNumber *distance = [NSNumber numberWithFloat:([valuechanged floatValue] * 9)];
                
                self.goalsteps.text = [f stringFromNumber:[NSNumber numberWithFloat:[steps floatValue]]];
               self.goaldist.text = [f stringFromNumber:[NSNumber numberWithFloat:[distance floatValue]]];
            }
            
            else if([cellText isEqualToString:@"Lb"])
            {
                
                
                NSNumber *calorieschanged = [NSNumber numberWithFloat:([self.weighttext.text floatValue] * 3500)];
                self.Activity_Points.text = [fmt stringFromNumber:[NSNumber numberWithFloat:[calorieschanged floatValue]]];
                NSString *value = self.Activity_Points.text;
                NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
                [f setNumberStyle:NSNumberFormatterDecimalStyle];
                [f setPositiveFormat:@"0.##"];
                
                NSNumber *valuechanged = [f numberFromString:value];
                NSNumber *steps = [NSNumber numberWithFloat:([valuechanged floatValue] * 24)];
                NSNumber *distance = [NSNumber numberWithFloat:([valuechanged floatValue] * 9)];
                
                self.goalsteps.text = [f stringFromNumber:[NSNumber numberWithFloat:[steps floatValue]]];
               self.goaldist.text =[f stringFromNumber:[NSNumber numberWithFloat:[distance floatValue]]];
                
            }
            
            
        }
                
    }
    
    
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
- (IBAction)unitclick:(id)sender {
    [self.tableView removeFromSuperview];
    [self.Activity_Points resignFirstResponder];
    [self.Daily_Percent resignFirstResponder];
    [self.weighttext resignFirstResponder];
    self.unit.selected=YES;
    self.tableView.frame = CGRectMake(220,150,60,105);
    self.tableView.backgroundColor =[self colorFromHexString:@"#ddd9d9"];
    [self.view1 addSubview:self.tableView];
    self.tableView.separatorColor = [UIColor clearColor];
    NSArray * arr = [[NSArray alloc]initWithObjects:@"Kg",@"Lb",nil];
    [self.goaltype removeAllObjects];
    [self.goaltype addObjectsFromArray:arr];
    [self.tableView reloadData];
}
@end
