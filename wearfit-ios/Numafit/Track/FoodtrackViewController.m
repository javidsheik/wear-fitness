//
//  FoodtrackViewController.m
//  Numafit
//
//  Created by iHotra-LT-02 on 04/11/14.
//  Copyright (c) 2014 sanhotrasoft. All rights reserved.
//

#import "FoodtrackViewController.h"
#import "TrackViewController.h"
#import "AFNetworking.h"
#import "URL.h"

@interface FoodtrackViewController ()

@end

@implementation FoodtrackViewController

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
    
    self.save = [[UIButton alloc]init];
    self.cancel = [[UIButton alloc]init];
    self.save.frame =CGRectMake(35, 400, 251, 45);
    self.cancel.frame =CGRectMake(35, 470, 251, 45);
    [self.save setTitle:@"SAVE" forState:UIControlStateNormal];
    [self.cancel setTitle:@"CANCEL" forState:UIControlStateNormal];
    
    self.view1.backgroundColor = [ self colorFromHexString:@"#efecec"];
    self.save.backgroundColor = [self colorFromHexString:@"#31d4fd"];
    self.cancel.backgroundColor = [self colorFromHexString:@"#fb5e93"];
    
    self.today.font = [UIFont fontWithName:@"oswald-regular" size:17.0f];
    self.today.textColor = [self colorFromHexString:@"#f745db"];
    self.view2.backgroundColor = [self colorFromHexString:@"#292727"];
    
    
    
    CALayer *btnLayer = [self.save layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
    CALayer *btnLayer1 = [self.cancel layer];
    [btnLayer1 setMasksToBounds:YES];
    [btnLayer1 setCornerRadius:5.0f];
    [[self.save titleLabel] setFont:[UIFont fontWithName:@"oswald-regular" size:16.0f]];
    [[self.cancel titleLabel] setFont:[UIFont fontWithName:@"oswald-regular" size:16.0f]];
    
    
    [[self.breakefast titleLabel] setFont:[UIFont fontWithName:@"oswald-regular" size:14.0f]];
    //    [self.breakefast setTitleColor:[self colorFromHexString:@"#4c4a4b"] forState:UIControlStateNormal];
    [self.breakefast setTitleColor:[ self colorFromHexString:@"#f93877"] forState:UIControlStateNormal];
    self.breakefast.backgroundColor = [UIColor clearColor];
    
    self.lunch.backgroundColor = [self colorFromHexString:@"#c3bfc0"];
    [[self.lunch titleLabel] setFont:[UIFont fontWithName:@"oswald-regular" size:14.0f]];
    [self.lunch setTitleColor:[self colorFromHexString:@"#4c4a4b"] forState:UIControlStateNormal];
    
    
    self.snacks.backgroundColor = [self colorFromHexString:@"#c3bfc0"];
    [[self.snacks titleLabel] setFont:[UIFont fontWithName:@"oswald-regular" size:14.0f]];
    [self.snacks setTitleColor:[self colorFromHexString:@"#4c4a4b"] forState:UIControlStateNormal];
    
    
    self.dinner.backgroundColor = [self colorFromHexString:@"#c3bfc0"];
    [[self.dinner titleLabel] setFont:[UIFont fontWithName:@"oswald-regular" size:14.0f]];
    [self.dinner setTitleColor:[self colorFromHexString:@"#4c4a4b"] forState:UIControlStateNormal];
    
    self.arrayofnames =[[NSMutableArray alloc]init];
    self.name.font = [UIFont fontWithName:@"oswald-regular" size:18.0f];
    self.quantity.font = [UIFont fontWithName:@"oswald-regular" size:18.0f];
    self.calorie.font = [UIFont fontWithName:@"oswald-regular" size:18.0f];
    [[self.select titleLabel] setFont:[UIFont fontWithName:@"oswald-regular" size:18.0f]];
    self.select.layer.masksToBounds=YES;
    self.select.layer.borderColor=[[self colorFromHexString:@"#d1d1d1"]CGColor];
    self.select.layer.borderWidth= 1.0f;
    [self.select setTitleColor:[self colorFromHexString:@"#767373"] forState:UIControlStateNormal];
    self.name.textColor = [self colorFromHexString:@"#767373"];
    self.calorie.textColor = [self colorFromHexString:@"#767373"];
    self.quantity.textColor = [self colorFromHexString:@"#767373"];
    self.tableView =[[UITableView alloc]init];
    self.arr=[[NSMutableArray alloc]init];
    self.tableView.dataSource =self;
    self.tableView.delegate=self;
    autocompleteTableView.dataSource=self;
    autocompleteTableView.delegate=self;
    
    
    
    
    
    
    CGSize result = [[UIScreen mainScreen] bounds].size;
    
    if(result.height ==480)
    {
        self.save.frame =CGRectMake(35, 370, 251, 45);
        self.cancel.frame =CGRectMake(35, 425, 251, 45);
        
    }
    
    self.name.delegate =self;
    self.quantity.delegate=self;
    self.calorie.delegate=self;
    [self.view addSubview:self.save];
    [self.view addSubview:self.cancel];
    [self.save addTarget:self action:@selector(savefood:) forControlEvents:UIControlEventTouchUpInside];
    [self.cancel addTarget:self action:@selector(cancelclick) forControlEvents:UIControlEventTouchUpInside];
    
    UIActivityIndicatorView *wait=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    wait.color=[self colorFromHexString:@"#bfdecc"];
    UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(105,4,150,20)];
    lbl.text=@"Loading...";
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
-(void)viewDidAppear:(BOOL)animated
{
    
    
    self.name.layer.masksToBounds=YES;
    self.name.layer.borderColor=[[self colorFromHexString:@"#d1d1d1"]CGColor];
    self.name.layer.borderWidth= 1.0f;
    self.quantity.layer.masksToBounds=YES;
    self.quantity.layer.borderColor=[[self colorFromHexString:@"#d1d1d1"]CGColor];
    self.quantity.layer.borderWidth= 1.0f;
    self.calorie.layer.masksToBounds=YES;
    self.calorie.layer.borderColor=[[self colorFromHexString:@"#d1d1d1"]CGColor];
    self.calorie.layer.borderWidth= 1.0f;
    
    
    
    UIColor *color = [self colorFromHexString:@"#ada9a9"];
    self.name.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"Food Name"
                                    attributes:@{
                                                 NSForegroundColorAttributeName: color,
                                                 NSFontAttributeName : [UIFont fontWithName:@"oswald-regular" size:18.0]
                                                 }];
    
    self.quantity.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"Quantity"
                                    attributes:@{
                                                 NSForegroundColorAttributeName: color,
                                                 NSFontAttributeName : [UIFont fontWithName:@"oswald-regular" size:18.0]
                                                 }];
    
    self.calorie.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"Calorie"
                                    attributes:@{
                                                 NSForegroundColorAttributeName: color,
                                                 NSFontAttributeName : [UIFont fontWithName:@"oswald-regular" size:18.0]
                                                 }];

    
    self.arrayofnames =[[NSMutableArray alloc]init];
    self.name.font = [UIFont fontWithName:@"oswald-regular" size:18.0f];
    self.quantity.font = [UIFont fontWithName:@"oswald-regular" size:18.0f];
    self.calorie.font = [UIFont fontWithName:@"oswald-regular" size:18.0f];
    [[self.select titleLabel] setFont:[UIFont fontWithName:@"oswald-regular" size:18.0f]];
    self.select.layer.masksToBounds=YES;
    self.select.layer.borderColor=[[self colorFromHexString:@"#d1d1d1"]CGColor];
    self.select.layer.borderWidth= 1.0f;
    [self.select setTitleColor:[self colorFromHexString:@"#767373"] forState:UIControlStateNormal];
    self.name.textColor = [self colorFromHexString:@"#767373"];
    self.calorie.textColor = [self colorFromHexString:@"#767373"];
    self.quantity.textColor = [self colorFromHexString:@"#767373"];
    self.tableView =[[UITableView alloc]init];
    self.arr=[[NSMutableArray alloc]init];
    self.tableView.dataSource =self;
    self.tableView.delegate=self;
    
    
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(0,5,70,20)];
    title.text=@"Food Track";
    title.font=[UIFont fontWithName:@"oswald-regular" size:19.0f];
    title.textColor=[UIColor whiteColor];
    self.navigationItem.titleView=title;
    self.navigationController.navigationBar.backItem.title=@"Track";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    
    
    
    NSURL *url = [NSURL URLWithString:Netcheckurl];
    NSData *data = [NSData dataWithContentsOfURL:url];
    if (data)
    {
        
        [self.waitale dismissWithClickedButtonIndex:0 animated:YES];
    }
    else
    {
        
        [self popup:OfflineMsg Title:OfflineTitle image:@"offline.png"];
        [self.waitale dismissWithClickedButtonIndex:0 animated:YES];
       
    }
    
    
}

-(void)cancelclick
{
    
    self.name.text=@"";
    self.quantity.text=@"";
    self.calorie.text=@"";
    [self.navigationController popViewControllerAnimated:YES];
    
    
    
}
-(void)savefood: (UIButton *)sender
{
    
    NSUserDefaults *pref =[NSUserDefaults standardUserDefaults];
    NSString *token = [pref objectForKey:@"Token"];
    NSString *ID = [pref objectForKey:@"ID"];
    NSString *foodid = [pref objectForKey:@"foodid"];
    NSLog(@"token %@",token);
    NSLog(@"id %@",ID);
    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
    
    [dateformate setDateFormat:@"YYYY-MM-dd"];
    
    NSString *date_String=[dateformate stringFromDate:[NSDate date]];
    
    NSString *unit =self.select.titleLabel.text;
    UIActivityIndicatorView *wait=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    wait.color=[self colorFromHexString:@"#bfdecc"];
    UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(105,4,150,20)];
    lbl.text=@"Saving Food...";
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
    
    if(self.quantity.text.length == 0 || self.name.text.length == 0 || self.calorie.text.length == 0)
    {
        
        
        [waitale dismissWithClickedButtonIndex:0 animated:YES];
        [self popup:@"Enter all the fields to save" Title:@"Warning" image:@"warning.png"];
        
        
        
    }
    else if (foodid.length==0 || unit.length==0)
    {
        
    
        [waitale dismissWithClickedButtonIndex:0 animated:YES];
         [self popup:Foodtrackmessage  Title:@"Invalid" image:@"invalid.png"];
        
        
    }
    
    
    else if(self.quantity.text.length > 0 && self.name.text.length > 0 && unit.length > 0 && self.calorie.text.length >0 && data.length > 0 && foodid.length >0)
    {
        
        
        
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        
        NSDictionary *params = @{@"user_id":ID,
                                 @"track_type":@"Food",
                                 @"food_id":foodid,
                                 @"unit":unit,
                                 @"consumed_value":self.quantity.text,
                                 @"token":token,
                                 @"activity_date":date_String,
                                 @"calories_consumed":self.calorie.text};
        
        
        [manager POST:Track parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            
            NSDictionary * data =[responseObject valueForKeyPath:@"data"];
            NSString *message = [data objectForKey:@"message"];
            
            [waitale dismissWithClickedButtonIndex:0 animated:YES];
            [self popup:message  Title:@"Status" image:@"sucess.png"];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            
            [self popup:@"Error saving try again later" Title:@"Status" image:@"error.png"];
            [waitale dismissWithClickedButtonIndex:0 animated:YES];
        }];
        
    }
    else
    {
       
        [self popup:OfflineMsg Title:OfflineTitle image:@"offline.png"];
        [waitale dismissWithClickedButtonIndex:0 animated:YES];
       
        
    }
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    [self.tableView removeFromSuperview];
    
    if(textField == self.calorie)
    {
        
        [self.view1 setFrame:CGRectMake(self.view1.frame.origin.x, self.view1.frame.origin.y-90, self.view1.frame.size.width, self.view1.frame.size.height)];
        
    }
    if(textField == self.quantity || textField == self.calorie)
    {
        
        autocompleteTableView.hidden=YES;
    }
    

    if(textField==self.name && self.name.text.length==0)
    {

        [autocompleteTableView removeFromSuperview];
    }
    
    if(textField==self.name)
    {
        
        
    }
    
    
    
}


 

-(BOOL)textFieldShouldClear:(UITextField *)textField{
    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    autocompleteTableView.hidden =YES;
    if(textField == self.calorie)
    {
        [self.view1 setFrame:CGRectMake(self.view1.frame.origin.x,self.view1.frame.origin.y+90, self.view1.frame.size.width, self.view1.frame.size.height)];
    }
    
    
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [self.tableView removeFromSuperview];
    [autocompleteTableView removeFromSuperview];
    [self.name resignFirstResponder];
    [self.quantity resignFirstResponder];
    [self.calorie resignFirstResponder];
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
    if(textField == self.quantity || textField == self.calorie)
    {
        autocompleteTableView.hidden=YES;
    }
    if(textField == self.name && self.name.text.length >0)
    {
        
        autocompleteTableView.hidden=NO;
    }
    return YES;
    
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *value =[self.name.text stringByReplacingCharactersInRange:range withString:string];
    if(textField == self.name)
    {
        [autocompleteTableView removeFromSuperview];
        if (value.length==0) {
            NSLog(@"value %@",value);
            self.quantity.text= @"";
            self.calorie.text=@"";
            
        }
        
        else if (value.length >0)
        {
            
            [self getDataUsingText:value];
            autocompleteTableView.hidden=YES;
            
            
        }
        
    }
    
    if(textField==self.calorie)
    {
        if(self.calorie.text.length > 10 && range.length==0)
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
    
    
    
    if (textField==self.quantity) {
        
        NSString *value = [self.quantity.text stringByReplacingCharactersInRange:range withString:string];
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        [f setPositiveFormat:@"0.##"];
        NSNumber *valuechanged = [f numberFromString:value];
        
        if(self.quantity.text.length > 10 && range.length==0)
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
        if(self.arr.count>0)
        {
        if([self.select.titleLabel.text isEqualToString:[self.arr objectAtIndex:0]])
        {
            if(![self.ozqn isEqual:[NSNull null]] && self.ozqn!=0)
            {
                
                NSNumber * valueforone = [NSNumber numberWithFloat:([self.calories floatValue] / [self.ozqn floatValue])];
                NSNumber *calorieschanged = [NSNumber numberWithFloat:([valuechanged floatValue] * [valueforone floatValue])];
                if(self.arrayofnames.count > 0)
                {
                    self.calorie.text = [f stringFromNumber:[NSNumber numberWithFloat:[calorieschanged floatValue]]];
                }
            }
        }
        
       else if([self.select.titleLabel.text isEqualToString:[self.arr objectAtIndex:1]])
        {
            if(![self.gmqn isEqual:[NSNull null]] && self.gmqn!=0)
            {
                NSNumber * valueforone = [NSNumber numberWithFloat:([self.calories floatValue] / [self.gmqn floatValue])];
                NSNumber *calorieschanged = [NSNumber numberWithFloat:([valuechanged floatValue] * [valueforone floatValue])];
                if(self.arrayofnames.count > 0)
                {
                    self.calorie.text = [f stringFromNumber:[NSNumber numberWithFloat:[calorieschanged floatValue]]];
                }
            }
        }
        
        }
        
    }
    return YES;
    
}

-(void)getDataUsingText:(NSString *)text
{
    
    [autocompleteTableView removeFromSuperview];
    if(text.length > 0)
    {
        
        NSUserDefaults *pref =[NSUserDefaults standardUserDefaults];
        NSString *token = [pref objectForKey:@"Token"];
          [pref setObject:@"" forKey:@"foodid"];
        self.ozqn=0;
        self.gmqn=0;
        [[NSUserDefaults standardUserDefaults]synchronize];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString * string = [NSString stringWithFormat:@"http://numa.simpliot.com/api/foods/search/%@?token=%@",text,token];
        
        string = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [manager GET: string parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *data =[responseObject valueForKeyPath:@"data"];
            self.foods = [[NSArray alloc]init];
            self.foods = [data valueForKey:@"foods"];
            [self.arrayofnames removeAllObjects];
            for(NSDictionary *name in self.foods)
            {
                
                
                NSString *string = [name objectForKey:@"name"];
                [self.arrayofnames addObject:string];
                
            }
            
            if (self.arrayofnames.count == 0 || self.arrayofnames == nil) {
                
                [autocompleteTableView removeFromSuperview];
                self.ozqn=0;
                self.gmqn = 0;
                self.calories = 0;
                NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
                [def setObject:NULL forKey:@"foodid"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
            }
            else if (self.arrayofnames.count>0)
            {
                [autocompleteTableView removeFromSuperview];
                autocompleteTableView = [[UITableView alloc] initWithFrame:CGRectMake(35, 200,249,140) style:UITableViewStylePlain];
                autocompleteTableView.scrollEnabled = YES;
                autocompleteTableView.dataSource=self;
                autocompleteTableView.delegate=self;
                [self.view addSubview:autocompleteTableView];
                [autocompleteTableView reloadData];
                autocompleteTableView.hidden = NO;
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
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

- (IBAction)Breakfastclick:(id)sender {
    
    [self.breakefast setTitleColor:[ self colorFromHexString:@"#fb5e93"] forState:UIControlStateNormal];
    
    self.breakefast.backgroundColor = [UIColor clearColor];
    [self.lunch setTitleColor:[ self colorFromHexString:@"#4c4a4b"] forState:UIControlStateNormal];
    
    self.lunch.backgroundColor = [self colorFromHexString:@"#c3bfc0"];
    self.dinner.backgroundColor = [self colorFromHexString:@"#c3bfc0"];
    
    [self.dinner setTitleColor:[ self colorFromHexString:@"#4c4a4b"] forState:UIControlStateNormal];
    
    self.snacks.backgroundColor = [self colorFromHexString:@"#c3bfc0"];
    
    [self.snacks setTitleColor:[ self colorFromHexString:@"#4c4a4b"] forState:UIControlStateNormal];
    self.name.text=@"";
    self.calorie.text=@"";
    self.quantity.text=@"";
    [self.select setTitle:@"" forState:UIControlStateNormal];
    [self.select setTitle:@"" forState:UIControlStateSelected];
    [self.arr removeAllObjects];
    
    
}
- (IBAction)Lunchclick:(id)sender {
    
    [self.lunch setTitleColor:[ self colorFromHexString:@"#fb5e93"] forState:UIControlStateNormal];
    
    self.lunch.backgroundColor = [UIColor clearColor];
    [self.breakefast setTitleColor:[ self colorFromHexString:@"#4c4a4b"] forState:UIControlStateNormal];
    self.breakefast.backgroundColor = [self colorFromHexString:@"#c3bfc0"];
    self.dinner.backgroundColor = [self colorFromHexString:@"#c3bfc0"];
    [self.dinner setTitleColor:[ self colorFromHexString:@"#4c4a4b"] forState:UIControlStateNormal];
    self.snacks.backgroundColor = [self colorFromHexString:@"#c3bfc0"];
    [self.snacks setTitleColor:[ self colorFromHexString:@"#4c4a4b"] forState:UIControlStateNormal];
    self.name.text=@"";
    self.calorie.text=@"";
    self.quantity.text=@"";
    [self.select setTitle:@"" forState:UIControlStateNormal];
    [self.select setTitle:@"" forState:UIControlStateSelected];
    [self.arr removeAllObjects];


    
}
- (IBAction)Snacksclick:(id)sender {
    
    [self.snacks setTitleColor:[ self colorFromHexString:@"#fb5e93"] forState:UIControlStateNormal];
    
    self.snacks.backgroundColor = [UIColor clearColor];
    [self.breakefast setTitleColor:[ self colorFromHexString:@"#4c4a4b"] forState:UIControlStateNormal];
    self.breakefast.backgroundColor = [self colorFromHexString:@"#c3bfc0"];
    self.dinner.backgroundColor = [self colorFromHexString:@"#c3bfc0"];
    [self.dinner setTitleColor:[ self colorFromHexString:@"#4c4a4b"] forState:UIControlStateNormal];
    self.lunch.backgroundColor = [self colorFromHexString:@"#c3bfc0"];
    [self.lunch setTitleColor:[ self colorFromHexString:@"#4c4a4b"] forState:UIControlStateNormal];
    self.name.text=@"";
    self.calorie.text=@"";
    self.quantity.text=@"";
    [self.select setTitle:@"" forState:UIControlStateNormal];
    [self.select setTitle:@"" forState:UIControlStateSelected];
    [self.arr removeAllObjects];

}

- (IBAction)Dinnerclick:(id)sender {
    
    [self.dinner setTitleColor:[ self colorFromHexString:@"#fb5e93"] forState:UIControlStateNormal];
    self.dinner.backgroundColor = [UIColor clearColor];
    [self.breakefast setTitleColor:[ self colorFromHexString:@"#4c4a4b"] forState:UIControlStateNormal];
    self.breakefast.backgroundColor = [self colorFromHexString:@"#c3bfc0"];
    self.lunch.backgroundColor = [self colorFromHexString:@"#c3bfc0"];
    [self.lunch setTitleColor:[ self colorFromHexString:@"#4c4a4b"] forState:UIControlStateNormal];
    self.snacks.backgroundColor = [self colorFromHexString:@"#c3bfc0"];
    [self.snacks setTitleColor:[ self colorFromHexString:@"#4c4a4b"] forState:UIControlStateNormal];
    self.name.text=@"";
    self.calorie.text=@"";
    self.quantity.text=@"";
    [self.select setTitle:@"" forState:UIControlStateNormal];
     [self.select setTitle:@"" forState:UIControlStateSelected];
    [self.arr removeAllObjects];

}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section {
    if(tableView == autocompleteTableView)
    {
        return self.arrayofnames.count;
    }
    
    if(tableView == self.tableView)
    {
        
        return [self.arr count];
        
    }
    return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    static NSString *AutoCompleteRowIdentifier = @"AutoCompleteRowIdentifier";
    cell = [tableView dequeueReusableCellWithIdentifier:AutoCompleteRowIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AutoCompleteRowIdentifier];
    }
    if(tableView == autocompleteTableView)
    {
        cell.textLabel.text = [self.arrayofnames objectAtIndex:indexPath.row];
        cell.textLabel.font =[UIFont fontWithName:@"oswald-regular" size:15.0f];
        cell.textLabel.lineBreakMode =  NSLineBreakByWordWrapping;
        cell.textLabel.numberOfLines =0;
        return cell;
    }
    if(tableView==self.tableView)
    {
        
        cell.textLabel.text = [self.arr objectAtIndex:indexPath.row];
        cell.textLabel.font =[UIFont fontWithName:@"oswald-regular" size:18.0f];
        cell.textLabel.textColor = [self colorFromHexString:@"#ada9a9"];
        cell.textLabel.font = [UIFont fontWithName:@"oswald-regular" size:18.0f];
        cell.textLabel.textColor = [self colorFromHexString:@"#767373"];
        
        return cell;
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
}
#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    if(tableView ==autocompleteTableView)
    {
        [self.arr removeAllObjects];
        self.name.text= selectedCell.textLabel.text;
        
        NSDictionary *dict = [self.foods objectAtIndex:indexPath.row];
        NSLog(@"dict %@",dict);
        
        self.ozqn = [dict objectForKey:@"servingSize"];
        self.gmqn = [dict objectForKey:@"servingSizeAlt"];
        [self.arr addObject:[dict objectForKey: @"servingSizeUnits"]];
        [self.arr addObject:[dict objectForKey:@"servingSizeAltUnits"]];
        
        self.calories = [dict objectForKey:@"calories"];
        NSString *foodid = [dict objectForKey:@"_id"];
        NSLog(@"food id %@",foodid);
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        [def setObject:foodid forKey:@"foodid"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.calorie.text = [self.calories stringValue];
        self.quantity.text = [self.ozqn stringValue];
        [self.select setTitle:[self.arr objectAtIndex:0] forState:UIControlStateNormal];
        autocompleteTableView.hidden=YES;
        [self.quantity becomeFirstResponder];
    }
    if(tableView==self.tableView)
    {
        [self.select setTitle:selectedCell.textLabel.text forState:UIControlStateNormal];
        NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
        [fmt setPositiveFormat:@"0.##"];
        if(self.arrayofnames.count > 0)
        {
            if ([selectedCell.textLabel.text isEqualToString:[self.arr objectAtIndex:0]]) {
                if(![self.ozqn isEqual:[NSNull null]] && self.ozqn!=0)
                {
                    self.calorie.text = [self.calories stringValue];
                    NSNumber * valueforone = [NSNumber numberWithFloat:([self.calories floatValue] / [self.ozqn floatValue])];
                    NSNumber *calorieschanged = [NSNumber numberWithFloat:([self.quantity.text floatValue] * [valueforone floatValue])];
                    self.calorie.text = [fmt stringFromNumber:[NSNumber numberWithFloat:[calorieschanged floatValue]]];
                }
                else if([self.ozqn isEqual:[NSNull null]] || self.ozqn==0)
                {
                    
                    self.calorie.text = @"0";
                }
            }
            if ([selectedCell.textLabel.text isEqualToString:[self.arr objectAtIndex:1]]) {
                NSLog(@" selected object %@",[self.arr objectAtIndex:0]);
                if(![self.gmqn isEqual:[NSNull null]] && self.gmqn!=0)
                {
                    NSNumber * valueforone = [NSNumber numberWithFloat:([self.calories floatValue] / [self.gmqn floatValue])];
                    NSNumber *calorieschanged = [NSNumber numberWithFloat:([self.quantity.text floatValue] * [valueforone floatValue])];
                    self.calorie.text = [fmt stringFromNumber:[NSNumber numberWithFloat:[calorieschanged floatValue]]];
                }
                else if([self.gmqn isEqual:[NSNull null]] || self.gmqn ==0)
                {
                    
                    self.calorie.text = @"0";
                }
                
            }
            
            
            
        }
        [self.tableView removeFromSuperview];
        
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == autocompleteTableView)
    {
        return 70;
    }
    else
        return 40;
    
}


- (IBAction)selectqn:(id)sender {
    
    [self.tableView removeFromSuperview];
    if(self.arr.count>0)
    {
    self.tableView.frame = CGRectMake(195, 140, 88, 85);
    self.tableView.backgroundColor = [self colorFromHexString:@"#ddd9d9"];
    [self.view1 addSubview:self.tableView];
    self.tableView.separatorColor = [UIColor clearColor];
    //    [self.arr removeAllObjects];
    //    NSArray * arr = [[NSArray alloc]initWithObjects:@"oz",@"gms", nil];
    //    [self.arr addObjectsFromArray:arr];
    [self.tableView reloadData];
    NSLog(@"array %@",self.arr);
    }
}
@end
