//
//  ActivitytrackViewController.m
//  Numafit
//
//  Created by iHotra-LT-02 on 06/11/14.
//  Copyright (c) 2014 sanhotrasoft. All rights reserved.
//

#import "ActivitytrackViewController.h"
#import "AFNetworking.h"
#import "URL.h"

@interface ActivitytrackViewController ()

@end

@implementation ActivitytrackViewController

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
    self.namelab.font = [UIFont fontWithName:@"oswald-regular" size:19.0f];
    self.starttimelab.font = [UIFont fontWithName:@"oswald-regular" size:19.0f];
    self.endtimelab.font = [UIFont fontWithName:@"oswald-regular" size:19.0f];
    self.calorielab.font = [UIFont fontWithName:@"oswald-regular" size:19.0f];
    CALayer *btnLayer = [self.view1 layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
    self.namelab.textColor = [self colorFromHexString:@"#767373"];
    self.starttimelab.textColor = [self colorFromHexString:@"#767373"];
    self.endtimelab.textColor = [self colorFromHexString:@"#767373"];
    self.calorielab.textColor = [self colorFromHexString:@"#767373"];
    self.nametext.layer.masksToBounds=YES;
    self.nametext.layer.borderColor=[[self colorFromHexString:@"#d1d1d1"]CGColor];
    self.nametext.layer.borderWidth= 1.0f;
    self.hourtext.layer.masksToBounds=YES;
    self.hourtext.layer.borderColor=[[self colorFromHexString:@"#d1d1d1"]CGColor];
    self.hourtext.layer.borderWidth= 1.0f;
    self.mintext.layer.masksToBounds=YES;
    self.mintext.layer.borderColor=[[self colorFromHexString:@"#d1d1d1"]CGColor];
    self.mintext.layer.borderWidth= 1.0f;
    self.hourtext1.layer.masksToBounds=YES;
    self.hourtext1.layer.borderColor=[[self colorFromHexString:@"#d1d1d1"]CGColor];
    self.hourtext1.layer.borderWidth= 1.0f;
    self.mintext1.layer.masksToBounds=YES;
    self.mintext1.layer.borderColor=[[self colorFromHexString:@"#d1d1d1"]CGColor];
    self.mintext1.layer.borderWidth= 1.0f;
    self.amtext.layer.masksToBounds=YES;
    self.amtext.layer.borderColor=[[self colorFromHexString:@"#d1d1d1"]CGColor];
    self.amtext.layer.borderWidth= 1.0f;
    self.amtext1.layer.masksToBounds=YES;
    self.amtext1.layer.borderColor=[[self colorFromHexString:@"#d1d1d1"]CGColor];
    self.amtext1.layer.borderWidth= 1.0f;
    self.calorietext.layer.masksToBounds=YES;
    self.calorietext.layer.borderColor=[[self colorFromHexString:@"#d1d1d1"]CGColor];
    self.calorietext.layer.borderWidth= 1.0f;
    self.calorietext.layer.masksToBounds=YES;
    self.calorietext.layer.borderColor=[[self colorFromHexString:@"#d1d1d1"]CGColor];
    self.calorietext.layer.borderWidth= 1.0f;
    self.nametext.delegate=self;
    self.calorietext.delegate=self;
    self.tableView = [[UITableView alloc]init];
    self.tableView.dataSource =self;
    self.tableView.delegate=self;
    self.arr = [[NSMutableArray alloc]init];
    [[self.hourtext1 titleLabel] setFont:[UIFont fontWithName:@"oswald-regular" size:18.0f]];
    [[self.hourtext titleLabel] setFont:[UIFont fontWithName:@"oswald-regular" size:18.0f]];
    [[self.mintext1 titleLabel] setFont:[UIFont fontWithName:@"oswald-regular" size:18.0f]];
    [[self.mintext titleLabel] setFont:[UIFont fontWithName:@"oswald-regular" size:18.0f]];
    [[self.amtext1 titleLabel] setFont:[UIFont fontWithName:@"oswald-regular" size:18.0f]];
    [[self.amtext titleLabel] setFont:[UIFont fontWithName:@"oswald-regular" size:18.0f]];
    [self.nametext setFont:[UIFont fontWithName:@"oswald-regular" size:19.0f]];
    [self.calorietext setFont:[UIFont fontWithName:@"oswald-regular" size:18.0f]];
    self.save = [[UIButton alloc]init];
    self.cancel = [[UIButton alloc]init];
    self.save.frame =CGRectMake(35, 385, 251, 45);
    self.cancel.frame =CGRectMake(35, 460, 251, 45);
    [self.save setTitle:@"SAVE" forState:UIControlStateNormal];
    [self.cancel setTitle:@"CANCEL" forState:UIControlStateNormal];
    self.todaylab.font = [UIFont fontWithName:@"oswald-regular" size:17.0f];
    self.todaylab.textColor = [self colorFromHexString:@"#f745db"];
    
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0,20, 20)];
    self.nametext.leftView = paddingView1;
    self.nametext.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0,20, 20)];
    self.calorietext.leftView = paddingView2;
    self.calorietext.leftViewMode = UITextFieldViewModeAlways;
    
    CGSize result = [[UIScreen mainScreen] bounds].size;
    
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
    
    [self.nametext setTextColor: [self colorFromHexString:@"#c3bfc0"]];
    [self.calorietext setTextColor: [self colorFromHexString:@"#c3bfc0"]];
    [self.save addTarget:self action:@selector(saveactivity:) forControlEvents:UIControlEventTouchUpInside];
    [self.cancel addTarget:self action:@selector(cancelclick) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.hourtext setTitleColor:[self colorFromHexString:@"#c3bfc0"] forState:UIControlStateSelected];
    [self.hourtext setTitleColor:[self colorFromHexString:@"#c3bfc0"] forState:UIControlStateNormal];
    
    [self.hourtext1 setTitleColor:[self colorFromHexString:@"#c3bfc0"] forState:UIControlStateSelected];
    [self.hourtext1 setTitleColor:[self colorFromHexString:@"#c3bfc0"] forState:UIControlStateNormal];
    
    
    [self.mintext setTitleColor:[self colorFromHexString:@"#c3bfc0"] forState:UIControlStateSelected];
    [self.mintext setTitleColor:[self colorFromHexString:@"#c3bfc0"] forState:UIControlStateNormal];
    
    [self.mintext1 setTitleColor:[self colorFromHexString:@"#c3bfc0"] forState:UIControlStateSelected];
    [self.mintext1 setTitleColor:[self colorFromHexString:@"#c3bfc0"] forState:UIControlStateNormal];
    
    [self.amtext setTitleColor:[self colorFromHexString:@"#c3bfc0"] forState:UIControlStateSelected];
    [self.amtext setTitleColor:[self colorFromHexString:@"#c3bfc0"] forState:UIControlStateNormal];
    
    [self.amtext1 setTitleColor:[self colorFromHexString:@"#c3bfc0"] forState:UIControlStateSelected];
    [self.amtext1 setTitleColor:[self colorFromHexString:@"#c3bfc0"] forState:UIControlStateNormal];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getActivityname
{
    
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
    UIAlertView *waitale=[[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    [wait startAnimating];
    [waitale setValue:v forKey:@"accessoryView"];
    [waitale show];
    
    NSUserDefaults *pref =[NSUserDefaults standardUserDefaults];
    NSString *token = [pref objectForKey:@"Token"];
    NSURL *url = [NSURL URLWithString:Netcheckurl];
    NSData *data = [NSData dataWithContentsOfURL:url];

    if(data)
    {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString * string = [NSString stringWithFormat:@"http://numa.simpliot.com/api/activities/types?token=%@",token];
    string = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager GET: string parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *data =[responseObject valueForKeyPath:@"data"];
        self.activities = [[ NSMutableArray alloc]init];
        self.activities = [data objectForKey:@"activity_types"];
        [waitale dismissWithClickedButtonIndex:0 animated:YES];
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"response %@",operation.responseObject);
        
        
        
    
        [waitale dismissWithClickedButtonIndex:0 animated:YES];
        [self popup:message_503  Title:title_503 image:@"ServerError.png"];
        
        
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
-(void)saveactivity: (UIButton *)sender
{
    
    NSUserDefaults *pref =[NSUserDefaults standardUserDefaults];
    NSString *token = [pref objectForKey:@"Token"];
    NSString *ID = [pref objectForKey:@"ID"];
    NSString * starthour = self.hourtext.titleLabel.text;
    NSString * startmin =self.mintext.titleLabel.text;
    NSString *starttime;
    NSString *endtime;
    NSString *trimmedString = [self.nametext.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(![starthour isEqualToString:@"hrs"] && ![startmin isEqualToString:@"mins"])
    {
        starttime = [NSString stringWithFormat:@"%@.%@",starthour,startmin];
    }
    else if(![startmin isEqualToString:@"mins"] && [starthour isEqualToString:@"hrs"])
    {
        
        starttime = [NSString stringWithFormat:@"00.%@",startmin];
    }
    
    else if(![starthour isEqualToString:@"hrs"] && [startmin isEqualToString:@"mins"])
    {
        
        starttime = [NSString stringWithFormat:@"%@.00",starthour];
    }
    
    NSString * endhour = self.hourtext1.titleLabel.text;
    NSString * endmin =self.mintext1.titleLabel.text;
    if(![endhour isEqualToString:@"hrs"] && ![endmin isEqualToString:@"mins"])
    {
        endtime = [NSString stringWithFormat:@"%@.%@",endhour,endmin];
    }
    else if(![endmin isEqualToString:@"mins"] && [endhour isEqualToString:@"hrs"])
    {
        
        endtime = [NSString stringWithFormat:@"00.%@",endmin];
    }
    
    else if(![endhour isEqualToString:@"hrs"] && [endmin isEqualToString:@"mins"])
    {
        
        endtime = [NSString stringWithFormat:@"%@.00",endhour];
    }
    
    NSString *startam = self.amtext.titleLabel.text;
    NSString *endam = self.amtext1.titleLabel.text;
    NSLog(@"start time %@",starttime);
    NSURL *url = [NSURL URLWithString:Netcheckurl];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    if(trimmedString.length == 0 || self.calorietext.text.length==0)
    {
        
        
        [self popup:@"Enter all the fields to save" Title:@"Message" image:@"warning.png"];
        
    }
    
    else if([starthour isEqualToString:@"hrs" ] && [startmin isEqualToString:@"mins"])
    {
        
        [self popup:@"Enter start time to save" Title:@"Message" image:@"warning.png"];
    }
    
    else if ([endhour isEqualToString:@"hrs" ] && [endmin isEqualToString:@"mins"])
    {
        
        [self popup:@"Enter end time to save" Title:@"Message" image:@"warning.png"];
    }
    
    
    else if(data)
    {
        UIActivityIndicatorView *wait=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        wait.color=[self colorFromHexString:@"#bfdecc"];
        UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(105,4,150,20)];
        lbl.text=@"Saving Activity...";
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
        
        
        NSDictionary *params = @{@"user_id":ID,
                                 @"track_type":@"Activity",
                                 @"calories_burnt":self.calorietext.text,
                                 @"token":token,
                                 @"activity_start_time":starttime,
                                 @"activity_start_time_unit":startam,
                                 @"activity_end_time":endtime,
                                 @"activity_end_time_unit":endam,
                                 @"activity_type":trimmedString};
        
        [manager POST:Track parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            
            NSDictionary * data =[responseObject valueForKeyPath:@"data"];
            NSString *message = [data objectForKey:@"message"];
            [waitale dismissWithClickedButtonIndex:0 animated:YES];
            if([[data objectForKey:@"status" ] isEqualToString:@"200"])
            {
                [self popup:message Title:@"Status" image:@"sucess.png"];
            }
            else
            {
                
                [self popup:message  Title:@"Status" image:@"error.png"];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            
            [waitale dismissWithClickedButtonIndex:0 animated:YES];
            
            [self popup:message_503  Title:title_503 image:@"ServerError.png"];
            
        }];
    }
    else
    {
        
        [self popup:OfflineMsg Title:OfflineTitle image:@"offline.png"];
        
        
    }
    
}
-(void)viewDidAppear:(BOOL)animated
{
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(0,5,70,20)];
    title.text=@"Activity Track";
    title.font=[UIFont fontWithName:@"oswald-regular" size:19.0f];
    title.textColor=[UIColor whiteColor];
    self.navigationItem.titleView=title;
    self.navigationController.navigationBar.backItem.title=@"Track";
    self.navigationController.navigationBar.barTintColor=[UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    autocompleteTableView = [[UITableView alloc] initWithFrame:CGRectMake(114, 165,178,160) style:UITableViewStylePlain];
    autocompleteTableView.delegate = self;
    autocompleteTableView.dataSource = self;
    autocompleteTableView.scrollEnabled = YES;
    autocompleteTableView.hidden = YES;
    autocompleteTableView.separatorColor=[UIColor clearColor];
    autocompleteTableView.backgroundColor = [self colorFromHexString:@"#ddd9d9"];
    [self.view addSubview:autocompleteTableView];
    autocompleteTableView.delegate=self;
    autocompleteTableView.dataSource=self;
    self.autocomplete =[[NSMutableArray alloc]init];
    [self getActivityname];
    
}

- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring {
    
    [_autocomplete removeAllObjects];
    for(NSString *curString in self.activities) {
        if ([curString rangeOfString:substring].location != NSNotFound)
        {
            
            [_autocomplete addObject:curString];
        }
    }
    
    [autocompleteTableView reloadData];
}

#pragma mark UITextFieldDelegate methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    //    if(textField==self.nametext)
    //    {
    //    autocompleteTableView.hidden = NO;
    //
    //    NSString *substring = [[NSString stringWithString:textField.text]capitalizedString];
    //    substring = [substring stringByReplacingCharactersInRange:range withString:string];
    //    [self searchAutocompleteEntriesWithSubstring:substring];
    //        return YES;
    //    }
    if(textField ==self.calorietext)
    {
        if(self.calorietext.text.length > 5 && range.length==0)
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
    if(textField==self.nametext)
    {
        
        NSString * match = self.nametext.text;
        NSMutableArray *listFiles = [[NSMutableArray alloc]  init];
        NSPredicate *sPredicate = [NSPredicate predicateWithFormat:
                                   @"SELF CONTAINS[cd] %@", match];
        listFiles = [NSMutableArray arrayWithArray:[self.activities
                                                    filteredArrayUsingPredicate:sPredicate]];
        self.autocomplete = [[NSMutableArray alloc]initWithArray: [listFiles
                                                                   sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]];
        
        if(self.autocomplete.count==0)
        {
            [autocompleteTableView setHidden:YES];
        }
        else
        {
        [autocompleteTableView setHidden:NO];
        [autocompleteTableView reloadData];
        }
        return YES;
    }
    
    return YES;
}



-(void)cancelclick
{
    
    self.nametext.text=@"";
    self.calorietext.text=@"";
    [self.hourtext1 setTitle:@"hrs" forState:UIControlStateNormal];
    [self.hourtext setTitle:@"hrs" forState:UIControlStateNormal];
    [self.mintext setTitle:@"mins" forState:UIControlStateNormal];
    [self.mintext1 setTitle:@"mins" forState:UIControlStateNormal];
    [self.amtext setTitle:@"AM" forState:UIControlStateNormal];
    [self.amtext1 setTitle:@"AM" forState:UIControlStateNormal];
    [self.navigationController popViewControllerAnimated:YES];
    
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
-(UIColor *)colorFromHexString:(NSString *)hexString
{
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    [self.tableView removeFromSuperview];
    
    autocompleteTableView.hidden = YES;
    if(textField == self.calorietext)
    {
        
        [self.view1 setFrame:CGRectMake(self.view1.frame.origin.x, self.view1.frame.origin.y-120, self.view1.frame.size.width, self.view1.frame.size.height)];
        
    }
    
    if(textField == self.nametext)
    {
        
        [self.view1 setFrame:CGRectMake(self.view1.frame.origin.x, self.view1.frame.origin.y-30, self.view1.frame.size.width, self.view1.frame.size.height)];
        autocompleteTableView.frame = CGRectMake(114, 135,178,160);
        
    }
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    
    [self.calorietext resignFirstResponder];
    [self.nametext resignFirstResponder];
    [self.tableView removeFromSuperview];
    autocompleteTableView.hidden = YES;
    
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if(textField == self.calorietext)
    {
        [self.view1 setFrame:CGRectMake(self.view1.frame.origin.x,self.view1.frame.origin.y+120, self.view1.frame.size.width, self.view1.frame.size.height)];
    }
    
    if(textField == self.nametext)
    {
        
        [self.view1 setFrame:CGRectMake(self.view1.frame.origin.x, self.view1.frame.origin.y+30, self.view1.frame.size.width, self.view1.frame.size.height)];
         autocompleteTableView.frame = CGRectMake(114, 165,178,160);
        
    }
}
-(BOOL)prefersStatusBarHidden
{
    
    return YES;
}
- (IBAction)starthour:(id)sender {
    [self.tableView removeFromSuperview];
    self.tableView.frame = CGRectMake(106, 105, 59, 75);
    self.tableView.backgroundColor = [self colorFromHexString:@"#ddd9d9"];
    [self.view1 addSubview:self.tableView];
    self.tableView.separatorColor = [UIColor clearColor];
    NSArray * arr = [[NSArray alloc]initWithObjects:@"00",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12", nil];
    [self.arr removeAllObjects];
    [self.arr addObjectsFromArray:arr];
    
    
    [self.hourtext setSelected:YES];
    [self.mintext setSelected:NO];
    [self.hourtext1 setSelected:NO];
    [self.mintext1 setSelected:NO];
    [self.amtext setSelected:NO];
    [self.amtext1 setSelected:NO];
    [self.tableView reloadData];
    
}

- (IBAction)startmin:(id)sender {
    [self.tableView removeFromSuperview];
    [self.calorietext resignFirstResponder];
    [self.nametext resignFirstResponder];
    
    self.tableView.frame = CGRectMake(166, 105, 59, 75);
    
    self.tableView.backgroundColor = [self colorFromHexString:@"#ddd9d9"];
    self.tableView.separatorColor = [UIColor clearColor];
    [self.view1 addSubview:self.tableView];
    NSArray * arr1 = [[NSArray alloc]initWithObjects:@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59",nil];
    
    [self.arr removeAllObjects];
    [self.arr addObjectsFromArray:arr1];
    
    [self.hourtext setSelected:NO];
    [self.mintext setSelected:YES];
    [self.hourtext1 setSelected:NO];
    [self.mintext1 setSelected:NO];
    [self.amtext setSelected:NO];
    [self.amtext1 setSelected:NO];
    [self.tableView reloadData];
}

- (IBAction)startam:(id)sender {
    [self.tableView removeFromSuperview];
    [self.calorietext resignFirstResponder];
    [self.nametext resignFirstResponder];
    
    
    self.tableView.frame = CGRectMake(226, 105, 59, 75);
    self.tableView.backgroundColor = [self colorFromHexString:@"#ddd9d9"];
    self.tableView.separatorColor = [UIColor clearColor];
    [self.view1 addSubview:self.tableView];
    NSArray *arr1 =[[NSArray alloc]initWithObjects:@"AM",@"PM",nil];
    [self.arr removeAllObjects];
    [self.arr addObjectsFromArray:arr1];
    
    [self.hourtext setSelected:NO];
    [self.mintext setSelected:NO];
    [self.hourtext1 setSelected:NO];
    [self.mintext1 setSelected:NO];
    [self.amtext setSelected:YES];
    [self.amtext1 setSelected:NO];
    [self.tableView reloadData];
    
}
- (IBAction)endam:(id)sender {
    
    [self.tableView removeFromSuperview];
    [self.calorietext resignFirstResponder];
    [self.nametext resignFirstResponder];
    
    self.tableView.frame = CGRectMake(226, 165, 59, 65);
    self.tableView.backgroundColor =[self colorFromHexString:@"#ddd9d9"];
    self.tableView.separatorColor = [UIColor clearColor];
    [self.view1 addSubview:self.tableView];
    NSArray *arr = [[NSArray alloc]initWithObjects:@"AM",@"PM",nil];
    [self.arr removeAllObjects];
    [self.arr addObjectsFromArray:arr];
    
    [self.hourtext setSelected:NO];
    [self.mintext setSelected:NO];
    [self.hourtext1 setSelected:NO];
    [self.mintext1 setSelected:NO];
    [self.amtext setSelected:NO];
    [self.amtext1 setSelected:YES];
    
    
    [self.tableView reloadData];
    
}

- (IBAction)endhour:(id)sender {
    
    [self.tableView removeFromSuperview];
    [self.calorietext resignFirstResponder];
    [self.nametext resignFirstResponder];
    
    self.tableView.frame = CGRectMake(106, 165, 59, 65);
    self.tableView.backgroundColor =[self colorFromHexString:@"#ddd9d9"];
    [self.view1 addSubview:self.tableView];
    self.tableView.separatorColor = [UIColor clearColor];
    NSArray * arr = [[NSArray alloc]initWithObjects:@"00",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12", nil];
    [self.arr removeAllObjects];
    [self.arr addObjectsFromArray:arr];
    [self.hourtext1 setSelected:YES];
    [self.mintext setSelected:NO];
    [self.mintext1 setSelected:NO];
    [self.hourtext setSelected:NO];
    [self.amtext setSelected:NO];
    [self.amtext1 setSelected:NO];
    [self.tableView reloadData];
}

- (IBAction)endmin:(id)sender {
    
    [self.tableView removeFromSuperview];
    [self.calorietext resignFirstResponder];
    [self.nametext resignFirstResponder];
    
    self.tableView.frame = CGRectMake(166, 165, 59, 65);
    self.tableView.backgroundColor =[self colorFromHexString:@"#ddd9d9"];
    self.tableView.separatorColor = [UIColor clearColor];
    [self.view1 addSubview:self.tableView];
    NSArray * arr1 = [[NSArray alloc]initWithObjects:@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59",nil];
    
    [self.arr removeAllObjects];
    [self.arr addObjectsFromArray:arr1];
    
    [self.hourtext setSelected:NO];
    [self.mintext1 setSelected:YES];
    [self.hourtext1 setSelected:NO];
    [self.mintext setSelected:NO];
    [self.amtext setSelected:NO];
    [self.amtext1 setSelected:NO];
    [self.tableView reloadData];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView== autocompleteTableView)
    {
        
        return self.autocomplete.count;
    }
    else
    {
        return self.arr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if(tableView == self.tableView)
    {
        cell.textLabel.text= [self.arr objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont fontWithName:@"oswald-regular" size:18.0f];
        cell.textLabel.textColor = [self colorFromHexString:@"#767373"];
        return cell;
    }
    
    if(tableView == autocompleteTableView)
    {
        
        cell.textLabel.text =[self.autocomplete objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont fontWithName:@"oswald-regular" size:18.0f];
        cell.textLabel.textColor = [self colorFromHexString:@"#767373"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *cellText = selectedCell.textLabel.text;
    
    if(tableView==autocompleteTableView)
    {
        
        self.nametext.text=cellText;
        autocompleteTableView.hidden = YES;
        
        
    }
    if(tableView==self.tableView)
    {
        if(self.hourtext.selected ==YES)
        {
            [self.hourtext setTitle:cellText forState:UIControlStateNormal];
            [self.hourtext setTitleColor:[self colorFromHexString:@"#c3bfc0"] forState:UIControlStateSelected];
            [self.hourtext setTitleColor:[self colorFromHexString:@"#c3bfc0"] forState:UIControlStateNormal];
            
            [self.tableView removeFromSuperview];
        }
        
        if(self.mintext.selected ==YES)
        {
            [self.mintext setTitle:cellText forState:UIControlStateNormal];
            [self.mintext setTitleColor:[self colorFromHexString:@"#c3bfc0"] forState:UIControlStateSelected];
            [self.mintext setTitleColor:[self colorFromHexString:@"#c3bfc0"] forState:UIControlStateNormal];
            [self.tableView removeFromSuperview];
        }
        
        if(self.hourtext1.selected ==YES)
        {
            [self.hourtext1 setTitle:cellText forState:UIControlStateNormal];
            [self.hourtext1 setTitleColor:[self colorFromHexString:@"#c3bfc0"] forState:UIControlStateSelected];
            [self.hourtext1 setTitleColor:[self colorFromHexString:@"#c3bfc0"] forState:UIControlStateNormal];
            [self.tableView removeFromSuperview];
        }
        
        if(self.mintext1.selected ==YES)
        {
            [self.mintext1 setTitle:cellText forState:UIControlStateNormal];
            [self.mintext1 setTitleColor:[self colorFromHexString:@"#c3bfc0"] forState:UIControlStateSelected];
            [self.mintext1 setTitleColor:[self colorFromHexString:@"#c3bfc0"] forState:UIControlStateNormal];
            [self.tableView removeFromSuperview];
        }
        
        if(self.amtext.selected ==YES)
        {
            [self.amtext setTitle:cellText forState:UIControlStateNormal];
            [self.amtext setTitleColor:[self colorFromHexString:@"#c3bfc0"] forState:UIControlStateSelected];
            [self.amtext setTitleColor:[self colorFromHexString:@"#c3bfc0"] forState:UIControlStateNormal];
            [self.tableView removeFromSuperview];
        }
        if(self.amtext1.selected ==YES)
        {
            [self.amtext1 setTitle:cellText forState:UIControlStateNormal];
            [self.amtext1 setTitleColor:[self colorFromHexString:@"#c3bfc0"] forState:UIControlStateSelected];
            [self.amtext1 setTitleColor:[self colorFromHexString:@"#c3bfc0"] forState:UIControlStateNormal];
            [self.tableView removeFromSuperview];
        }
    }
    
    
    
}
@end
