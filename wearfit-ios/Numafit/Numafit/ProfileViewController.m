//
//  ProfileViewController.m
//  Numafit
//
//  Created by iHotra-LT-02 on 19/11/14.
//  Copyright (c) 2014 sanhotrasoft. All rights reserved.
//

#import "ProfileViewController.h"
#import "AFNetworking.h"
#import "BTLECentralClass.h"
#import "AddDeviceViewController.h"
#import "URL.h"
@interface ProfileViewController ()

@end

@implementation ProfileViewController

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
    
    findmydevicestatus=0;
    
    self.view1.backgroundColor =[self colorFromHexString:@"#22c3f1"];
    
    [[self.personald titleLabel] setFont:[UIFont fontWithName:@"oswald-regular" size:16.0f]];
    //    [self.breakefast setTitleColor:[self colorFromHexString:@"#4c4a4b"] forState:UIControlStateNormal];
    self.personald.backgroundColor = [self colorFromHexString:@"#0491b9"];
    
    [[self.contactd titleLabel] setFont:[UIFont fontWithName:@"oswald-regular" size:16.0f]];
    //    [self.breakefast setTitleColor:[self colorFromHexString:@"#4c4a4b"] forState:UIControlStateNormal];
    [self.contactd setTitleColor:[self colorFromHexString:@"#4fcff4"] forState:UIControlStateNormal];
    self.contactd.backgroundColor = [self colorFromHexString:@"#036a88"];
    
    [[self.bandd titleLabel] setFont:[UIFont fontWithName:@"oswald-regular" size:16.0f]];
    //    [self.breakefast setTitleColor:[self colorFromHexString:@"#4c4a4b"] forState:UIControlStateNormal];
    [self.bandd setTitleColor:[self colorFromHexString:@"#4fcff4"] forState:UIControlStateNormal];
    self.bandd.backgroundColor = [self colorFromHexString:@"#036a88"];
    
    self.view.backgroundColor =[self colorFromHexString:@"#efecec"];
    
    
    
    
    self.genderb.enabled =NO;
    self.feetb.enabled = NO;
    self.heighttext.enabled =NO;
    self.weighttext.enabled=NO;
    self.kgb.enabled=NO;
    self.personald.selected=YES;
    self.contactd.selected=NO;
    self.bandd.selected=NO;
    
    
    
    
    self.save =[[UIButton alloc]init];
    self.cancel=[[UIButton alloc]init];
    self.save.frame =CGRectMake(45, 470, 100, 45);
    self.cancel.frame =CGRectMake(180, 470, 100, 45);
    [self.save setTitle:@"SAVE" forState:UIControlStateNormal];
    [self.cancel setTitle:@"EDIT" forState:UIControlStateNormal];
    self.save.backgroundColor = [self colorFromHexString:@"#0ef791"];
    self.cancel.backgroundColor = [self colorFromHexString:@"#ff7376"];
    CALayer *btnLayer = [self.save layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
    CALayer *btnLayer1 = [self.cancel layer];
    [btnLayer1 setMasksToBounds:YES];
    [btnLayer1 setCornerRadius:5.0f];
    
    [[self.save titleLabel] setFont:[UIFont fontWithName:@"oswald-bold" size:16.0f]];
    [[self.cancel titleLabel] setFont:[UIFont fontWithName:@"oswald-bold" size:16.0f]];
    CGSize result = [[UIScreen mainScreen] bounds].size;
    
    if(result.height == 480)
    {
        self.save.frame =CGRectMake(45, 430, 100, 40);
        self.cancel.frame =CGRectMake(180, 430, 100, 40);
        
    }
    
    [self.view addSubview:self.save];
    [self.view addSubview:self.cancel];
    self.save.enabled =NO;
    [self.cancel addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
    self.cancel.showsTouchWhenHighlighted =YES;
    [self.save addTarget:self action:@selector(savedata) forControlEvents:UIControlEventTouchUpInside];
    self.genderimg.hidden=YES;
    self.feetimg.hidden=YES;
    self.kgimg.hidden=YES;
    self.personald.selected=YES;
    NSUserDefaults *def =[NSUserDefaults standardUserDefaults];
    self.firstname.text = [NSString stringWithFormat:@"%@ %@",[def objectForKey:@"firstname"],[def objectForKey:@"last_name"]];
    self.city.text=[[def objectForKey:@"city"] uppercaseString];
    self.country.text=[[def objectForKey:@"country"]uppercaseString];
    self.dobtext.text =[def objectForKey:@"dob"];
    [self.genderb setTitle:[def objectForKey:@"gender"] forState:UIControlStateNormal];
    self.heighttext.text=[def objectForKey:@"height"];
    self.weighttext.text=[def objectForKey:@"weight"];
    [self.feetb setTitle:[def objectForKey:@"height_unit"] forState:UIControlStateNormal];
    [self.kgb setTitle:[def objectForKey:@"weight_unit"] forState:UIControlStateNormal];
    self.ziptext.text =[def objectForKey:@"zip"];
    self.phtext.text =[def objectForKey:@"phone"];
      self.tableView1=[[UITableView alloc]init];
    self.tableView1.delegate=self;
    self.tableView1.dataSource=self;
     self.arr =[[NSMutableArray alloc]init];
    
}


-(UIColor *)colorFromHexString:(NSString *)hexString
{
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}
-(void)viewDidAppear:(BOOL)animated
{
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(0,5,70,20)];
    title.text=@"Profile";
    title.font=[UIFont fontWithName:@"oswald-regular" size:20.0f];
    title.textColor=[UIColor whiteColor];
    self.navigationItem.titleView=title;
    [super viewDidLoad];
    self.dobtext.delegate =self;
    self.weighttext.delegate=self;
    self.heighttext.delegate=self;
    self.pic = [[UIDatePicker alloc]initWithFrame:CGRectMake(40.0, 20.0, 170.0, 250.0)];
    self.pic.datePickerMode = UIDatePickerModeDate;
    [ self.pic setDate:[NSDate date]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [self.dobtext setInputView: self.pic];
    [ self.pic addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
    
    [self.firstname setFont: [UIFont fontWithName:@"oswald-regular" size:20.0f]];
    [self.country setFont: [UIFont fontWithName:@"oswald-regular" size:17.0f]];
    [self.city setFont: [UIFont fontWithName:@"oswald-regular" size:17.0f]];
    self.city.textColor =[self colorFromHexString:@"#89e2fb"];
    self.country.textColor =[self colorFromHexString:@"#89e2fb"];
    
    self.profilepic.layer.cornerRadius = self.profilepic.frame.size.width /2;
    self.profilepic.layer.masksToBounds = YES;
    self.profilepic.layer.borderWidth = 5.0f;
    self.view.backgroundColor =[self colorFromHexString:@"#efecec"];
    self.profilepic.layer.borderColor = [self colorFromHexString:@"#60d3f4"].CGColor;
    self.doblab.font = [UIFont fontWithName:@"oswald-regular" size:17.0f];
    self.genderlab.font = [UIFont fontWithName:@"oswald-regular" size:17.0f];
    self.heightlab.font = [UIFont fontWithName:@"oswald-regular" size:17.0f];
    self.weightlab.font = [UIFont fontWithName:@"oswald-regular" size:17.0f];
    self.doblab.textColor = [self colorFromHexString:@"#6f6969"];
    self.genderlab.textColor = [self colorFromHexString:@"#6f6969"];
    self.heightlab.textColor = [self colorFromHexString:@"#6f6969"];
    self.weightlab.textColor = [self colorFromHexString:@"#6f6969"];
    
    self.dobtext.enabled =NO;
    self.dobtext.layer.masksToBounds=YES;
    self.dobtext.layer.borderColor=[[self colorFromHexString:@"#cecbcb"]CGColor];
    self.dobtext.layer.borderWidth= 1.0f;
    self.weighttext.layer.masksToBounds=YES;
    self.weighttext.layer.borderColor=[[self colorFromHexString:@"#cecbcb"]CGColor];
    self.weighttext.layer.borderWidth= 1.0f;
    self.heighttext.layer.masksToBounds=YES;
    self.heighttext.layer.borderColor=[[self colorFromHexString:@"#cecbcb"]CGColor];
    self.heighttext.layer.borderWidth= 1.0f;
    
    self.genderb.enabled =NO;
    self.genderb.layer.masksToBounds=YES;
    self.genderb.layer.borderColor=[[self colorFromHexString:@"#cecbcb"]CGColor];
    self.genderb.layer.borderWidth= 1.0f;
    self.feetb.enabled = NO;
    self.heighttext.enabled =NO;
    self.weighttext.enabled=NO;
    self.kgb.enabled=NO;
    self.feetb.layer.masksToBounds=YES;
    self.feetb.layer.borderColor=[[self colorFromHexString:@"#cecbcb"]CGColor];
    self.feetb.layer.borderWidth= 1.0f;
    self.kgb.layer.masksToBounds=YES;
    self.kgb.layer.borderColor=[[self colorFromHexString:@"#cecbcb"]CGColor];
    self.kgb.layer.borderWidth= 1.0f;
    
    self.dobtext.font = [UIFont fontWithName:@"oswald-light" size:16.0f];
    self.dobtext.textColor =[self colorFromHexString:@"#6f6969"];
    [self.dobtext setEnabled:NO];
    self.heighttext.font = [UIFont fontWithName:@"oswald-light" size:16.0f];
    self.heighttext.textColor =[self colorFromHexString:@"#6f6969"];
    [self.heighttext setEnabled:NO];
    self.weighttext.font = [UIFont fontWithName:@"oswald-light" size:16.0f];
    self.weighttext.textColor =[self colorFromHexString:@"#6f6969"];
    [self.weighttext setEnabled:NO];
    [self.genderb setEnabled:NO];
    [self.genderb setTitleColor:[self colorFromHexString:@"#6f6969"] forState:UIControlStateNormal];
    [[self.genderb titleLabel] setFont:[UIFont fontWithName:@"oswald-light" size:16.0f]];
    [self.feetb setEnabled:NO];
    [self.feetb setTitleColor:[self colorFromHexString:@"#6f6969"] forState:UIControlStateNormal];
    [[self.feetb titleLabel] setFont:[UIFont fontWithName:@"oswald-light" size:16.0f]];
    [self.kgb setEnabled:NO];
    [self.kgb setTitleColor:[self colorFromHexString:@"#6f6969"] forState:UIControlStateNormal];
    [[self.kgb titleLabel] setFont:[UIFont fontWithName:@"oswald-light" size:16.0f]];
    
    
    //    [self getProfile];
    [self.activity stopAnimating];
    [self.activity removeFromSuperview];
    self.activity =nil;
    self.maflab.text=@"";
    NSString *device_id=[[NSUserDefaults standardUserDefaults]objectForKey:@"device_id"];
    if (device_id!=nil)
    {
        [self.disconnect setTitle:@"DISCONNECT" forState:UIControlStateNormal];
        devicestatus=1;
        self.maflab.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"device_id"];
    }
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    
    return YES;
}

-(void)updateTextField:(id)sender
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    self.dobtext.text = [formatter stringFromDate:_pic.date];
    
    
}
- (IBAction)feetclick:(id)sender {
    
    [self.tableView1 removeFromSuperview];
    self.tableView1=[[UITableView alloc]init];
    self.tableView1.frame = CGRectMake(228, 365, 67, 85);
    self.tableView1.backgroundColor = [self colorFromHexString:@"#ddd9d9"];
    [self.view addSubview:self.tableView1];
    self.tableView1.separatorColor = [UIColor clearColor];
    self.arr = [[NSMutableArray alloc]init];
    NSArray * arr = [[NSArray alloc]initWithObjects:@"cms",@"inches", nil];
    [self.arr removeAllObjects];
    [self.arr addObjectsFromArray:arr];
    self.tableView1.delegate=self;
    self.tableView1.dataSource=self;
    self.feetb.selected=YES;
    self.kgb.selected=NO;
    self.genderb.selected=NO;
    NSLog(@"array %@",self.arr);
    
}

- (IBAction)kgclick:(id)sender {
    
    [self.tableView1 removeFromSuperview];
    self.tableView1=[[UITableView alloc]init];
    self.tableView1.frame = CGRectMake(228, 420, 67, 85);
    self.tableView1.backgroundColor = [self colorFromHexString:@"#ddd9d9"];
    [self.view addSubview:self.tableView1];
    self.tableView1.separatorColor = [UIColor clearColor];
     self.arr = [[NSMutableArray alloc]init];
    NSArray * arr = [[NSArray alloc]initWithObjects:@"kgs",@"lbs", nil];
      [self.arr removeAllObjects];
    [self.arr addObjectsFromArray:arr];
    self.tableView1.delegate=self;
    self.tableView1.dataSource=self;
    self.kgb.selected=YES;
    self.feetb.selected=NO;
    self.genderb.selected=NO;
    NSLog(@"array %@",self.arr);
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.dobtext resignFirstResponder];
    [self.weighttext resignFirstResponder];
    [self.heighttext resignFirstResponder];
    [self.phtext resignFirstResponder];
    [self.ziptext resignFirstResponder];
    [self.addview resignFirstResponder];
    [self.tableView1 removeFromSuperview];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)edit: (UIButton *)sender
{
    self.save.enabled=YES;
    self.cancel.selected=YES;
    if(self.personald.selected==YES)
    {
        
        self.dobtext.enabled = YES;
        [self.dobtext becomeFirstResponder];
        self.genderb.enabled=YES;
        self.feetb.enabled = YES;
        self.heighttext.enabled =YES;
        self.weighttext.enabled=YES;
        self.kgb.enabled=YES;
        self.genderimg.hidden=NO;
        self.feetimg.hidden=NO;
        self.kgimg.hidden=NO;
        
    }
    
    if(self.contactd.selected==YES)
    {
        
        [self.addview  performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.1f];
        self.phtext.enabled=YES;
        self.ziptext.enabled=YES;
        self.addview.editable=YES;
        
    }
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if(textField == self.weighttext || textField == self.heighttext || textField == self.phtext || textField == self.ziptext)
    {
        
        [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-150, self.view.frame.size.width, self.view.frame.size.height)];
        
    }
    
}


-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    
    if(textField == self.weighttext || textField == self.heighttext || textField == self.phtext || textField == self.ziptext)
    {
        [self.view setFrame:CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y+150, self.view.frame.size.width, self.view.frame.size.height)];
        
    }
    
    
    
    if(textField==self.phtext)
    {
        
        NSUserDefaults * def =[NSUserDefaults standardUserDefaults];
        [def setObject:self.phtext.text forKey:@"phone"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    
    if(textField==self.ziptext)
    {
        
        NSUserDefaults * def =[NSUserDefaults standardUserDefaults];
        [def setObject:self.ziptext.text forKey:@"zip"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    if(textField==self.dobtext)
    {
        
        NSUserDefaults * def =[NSUserDefaults standardUserDefaults];
        [def setObject:self.dobtext.text forKey:@"dob"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    if(textField==self.heighttext)
    {
        
        NSUserDefaults * def =[NSUserDefaults standardUserDefaults];
        [def setObject:self.heighttext.text forKey:@"height"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    if(textField==self.weighttext)
    {
        
        NSUserDefaults * def =[NSUserDefaults standardUserDefaults];
        [def setObject:self.weighttext.text forKey:@"weight"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
 
    
    
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    
    if(textView==self.addview)
    {
        
        NSUserDefaults * def =[NSUserDefaults standardUserDefaults];
        [def setObject:self.addview.text forKey:@"address"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}

- (IBAction)personal:(id)sender {
    
    self.personald.selected =YES;
    self.contactd.selected=NO;
    self.bandd.selected=NO;
    
    [self.add removeFromSuperview];
    [self.zipcode removeFromSuperview];
    [self.phno removeFromSuperview];
    self.genderb.enabled =NO;
    self.kgb.enabled=NO;
    self.feetb.enabled=NO;
    [self.addview removeFromSuperview];
    [self.phtext removeFromSuperview];
    [self.ziptext removeFromSuperview];
    [self.devicemodel removeFromSuperview];
    [self.devicemaf removeFromSuperview];
    [self.deviceid removeFromSuperview];
    [self.dlab removeFromSuperview];
    [self.molab removeFromSuperview];
    [self.maflab removeFromSuperview];
    [self.hour removeFromSuperview];
    [self.min removeFromSuperview];
    [self.days removeFromSuperview];
    [self.finddevice removeFromSuperview];
    [self.disconnect removeFromSuperview];
    [self.checkmark removeFromSuperview];
    [self.hour removeFromSuperview];
    [self.tableView1 removeFromSuperview];
    [self.min removeFromSuperview];
    [self.days removeFromSuperview];
    [self.onoffsegement removeFromSuperview];
    [self.finddevice removeFromSuperview];

    [[self.personald titleLabel] setFont:[UIFont fontWithName:@"oswald-regular" size:16.0f]];
    self.personald.backgroundColor = [self colorFromHexString:@"#0491b9"];
    [self.personald setTitleColor:[self colorFromHexString:@"#ffffff"] forState:UIControlStateNormal];
    [[self.contactd titleLabel] setFont:[UIFont fontWithName:@"oswald-regular" size:16.0f]];
    [self.contactd setTitleColor:[self colorFromHexString:@"#4fcff4"] forState:UIControlStateNormal];
    self.contactd.backgroundColor = [self colorFromHexString:@"#036a88"];
    
    [[self.bandd titleLabel] setFont:[UIFont fontWithName:@"oswald-regular" size:16.0f]];
    [self.bandd setTitleColor:[self colorFromHexString:@"#4fcff4"] forState:UIControlStateNormal];
    self.bandd.backgroundColor = [self colorFromHexString:@"#036a88"];
    self.save.hidden=NO;
    self.cancel.hidden=NO;
    
    self.dobtext.hidden=NO;
    self.doblab.hidden=NO;
    self.genderb.hidden=NO;
    self.genderlab.hidden=NO;
    self.heighttext.hidden=NO;
    self.heightlab.hidden=NO;
    self.feetb.hidden=NO;
    self.kgb.hidden=NO;
    self.weighttext.hidden=NO;
    self.weightlab.hidden=NO;
    self.genderimg.hidden=YES;
    self.feetimg.hidden=YES;
    self.kgimg.hidden=YES;
    self.save.enabled =NO;
    self.cancel.selected=NO;
    self.camera.selected=NO;
    
    
    [super hidemenu];
    if(self.personald.selected==YES)
    {
        
    }
    
    
    
}

- (IBAction)contact:(id)sender {
    
    self.personald.selected =NO;
    self.contactd.selected=YES;
    self.bandd.selected=NO;
    
    [self.tableView1 removeFromSuperview];
    [self.devicemodel removeFromSuperview];
    [self.devicemaf removeFromSuperview];
    [self.deviceid removeFromSuperview];
    [self.dlab removeFromSuperview];
    [self.molab removeFromSuperview];
    [self.maflab removeFromSuperview];
    [self.hour removeFromSuperview];
    [self.min removeFromSuperview];
    [self.days removeFromSuperview];
    [self.finddevice removeFromSuperview];
    [self.disconnect removeFromSuperview];
    [self.checkmark removeFromSuperview];
    [self.onoffsegement removeFromSuperview];
    [self.add removeFromSuperview];
    [self.zipcode removeFromSuperview];
    [self.phno removeFromSuperview];
    [self.hour removeFromSuperview];
    [self.min removeFromSuperview];
    [self.days removeFromSuperview];
    [self.onoffsegement removeFromSuperview];
    [self.finddevice removeFromSuperview];
    [self.addview removeFromSuperview];
    [self.phtext removeFromSuperview];
    [self.ziptext removeFromSuperview];
    [self.devicemodel removeFromSuperview];
    [self.devicemaf removeFromSuperview];
    [self.deviceid removeFromSuperview];
    [self.dlab removeFromSuperview];
    [self.molab removeFromSuperview];
    [self.maflab removeFromSuperview];
    [self.disconnect removeFromSuperview];
        self.save.enabled =NO;
    self.cancel.selected=NO;
    self.save.hidden=NO;
    self.cancel.hidden=NO;
    
    
    self.camera.selected=NO;
    self.dobtext.hidden=YES;
    self.doblab.hidden=YES;
    self.genderb.hidden=YES;
    self.genderlab.hidden=YES;
    self.heighttext.hidden=YES;
    self.heightlab.hidden=YES;
    self.feetb.hidden=YES;
    self.kgb.hidden=YES;
    self.weighttext.hidden=YES;
    self.weightlab.hidden=YES;
    self.genderimg.hidden=YES;
    self.feetimg.hidden=YES;
    self.kgimg.hidden=YES;
    
    [[self.personald titleLabel] setFont:[UIFont fontWithName:@"oswald-regular" size:16.0f]];
    self.personald.backgroundColor = [self colorFromHexString:@"#036a88"];
    [self.personald setTitleColor:[self colorFromHexString:@"#4fcff4"] forState:UIControlStateNormal];
    
    [[self.contactd titleLabel] setFont:[UIFont fontWithName:@"oswald-regular" size:16.0f]];
    [self.contactd setTitleColor:[self colorFromHexString:@"#ffffff"] forState:UIControlStateNormal];
    self.contactd.backgroundColor = [self colorFromHexString:@"#0491b9"];
    
    [[self.bandd titleLabel] setFont:[UIFont fontWithName:@"oswald-regular" size:16.0f]];
    [self.bandd setTitleColor:[self colorFromHexString:@"#4fcff4"] forState:UIControlStateNormal];
    self.bandd.backgroundColor = [self colorFromHexString:@"#036a88"];
    
    [super hidemenu];
    if (self.contactd.selected==YES)
    {
        
        self.add=[[UILabel alloc]init];
        self.zipcode=[[UILabel alloc]init];
        self.phno=[[UILabel alloc]init];
        self.addview=[[UITextView alloc]init];
        self.phtext=[[UITextField alloc]init];
        self.ziptext=[[UITextField alloc]init];
        NSUserDefaults *def =[NSUserDefaults standardUserDefaults];
        
        self.add.frame = CGRectMake(15, 260, 70,21);
        self.add.text=@"Address";
        self.add.font = [UIFont fontWithName:@"oswald-regular" size:17.0f];
        self.add.textColor =[self colorFromHexString:@"#6f6969"];
        [self.view addSubview:self.add];
        
        self.zipcode.frame = CGRectMake(15, 340, 70,21);
        self.zipcode.text=@"Zipcode";
        self.zipcode.font = [UIFont fontWithName:@"oswald-regular" size:17.0f];
        self.zipcode.textColor =[self colorFromHexString:@"#6f6969"];
        [self.view addSubview:self.zipcode];
        
        
        self.phno.frame = CGRectMake(15, 390, 70,21);
        self.phno.text=@"Phone no";
        self.phno.font = [UIFont fontWithName:@"oswald-regular" size:17.0f];
        self.phno.textColor =[self colorFromHexString:@"#6f6969"];
        [self.view addSubview:self.phno];
        self.addview.frame = CGRectMake(80, 230, 230, 87);
        self.addview.text = [def objectForKey:@"address"];
        self.addview.font = [UIFont fontWithName:@"oswald-light" size:16.0f];
        self.addview.textColor =[self colorFromHexString:@"#6f6969"];
        self.addview.backgroundColor =[UIColor whiteColor];
        [self.view addSubview:self.addview];
        self.addview.delegate=self;
        self.addview.editable=NO;
        
        self.phtext.frame = CGRectMake(80, 384, 230, 35);
        self.phtext.text =[def objectForKey:@"phone"];
        self.phtext.font = [UIFont fontWithName:@"oswald-light" size:16.0f];
        self.phtext.textColor =[self colorFromHexString:@"#6f6969"];
        [self.view addSubview:self.phtext];
        self.phtext.backgroundColor =[UIColor whiteColor];
        self.phtext.enabled=NO;
        self.phtext.textAlignment=NSTextAlignmentCenter;
        self.phtext.keyboardType=UIKeyboardTypePhonePad;
        
        self.ziptext.frame = CGRectMake(80, 334, 230, 35);
        self.ziptext.text = [def objectForKey:@"zip"];
        self.ziptext.font = [UIFont fontWithName:@"oswald-light" size:16.0f];
        self.ziptext.textColor =[self colorFromHexString:@"#6f6969"];
        self.ziptext.backgroundColor =[UIColor whiteColor];
        [self.view addSubview:self.ziptext];
        self.ziptext.textAlignment=NSTextAlignmentCenter;
        self.ziptext.keyboardType=UIKeyboardTypePhonePad;
        
        self.ziptext.enabled=NO;
        
        self.ziptext.layer.masksToBounds=YES;
        self.ziptext.layer.borderColor=[[self colorFromHexString:@"#cecbcb"]CGColor];
        self.ziptext.layer.borderWidth= 1.0f;
        
        self.addview.layer.masksToBounds=YES;
        self.addview.layer.borderColor=[[self colorFromHexString:@"#cecbcb"]CGColor];
        self.addview.layer.borderWidth= 1.0f;
        
        self.phtext.layer.masksToBounds=YES;
        self.phtext.layer.borderColor=[[self colorFromHexString:@"#cecbcb"]CGColor];
        self.phtext.layer.borderWidth= 1.0f;
        self.phtext.delegate=self;
        self.ziptext.delegate=self;
        
        
        
    }
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (IBAction)genderclick:(id)sender {
    
    
    [self.tableView1 removeFromSuperview];
    self.tableView1=[[UITableView alloc]init];
    self.tableView1.frame = CGRectMake(130, 310, 165, 85);
    self.tableView1.backgroundColor = [self colorFromHexString:@"#ddd9d9"];
    [self.view addSubview:self.tableView1];
    self.tableView1.separatorColor = [UIColor clearColor];
    self.arr = [[NSMutableArray alloc]init];
    NSArray * arr = [[NSArray alloc]initWithObjects:@"Male",@"Female", nil];
    [self.arr removeAllObjects];
    [self.arr addObjectsFromArray:arr];
    self.tableView1.delegate=self;
    self.tableView1.dataSource=self;
    self.kgb.selected=NO;
    self.feetb.selected=NO;
    self.genderb.selected=YES;
}

- (IBAction)band:(id)sender {
    
    self.personald.selected =NO;
    self.contactd.selected=NO;
    self.bandd.selected=YES;
    
    [[self.personald titleLabel] setFont:[UIFont fontWithName:@"oswald-regular" size:16.0f]];
    self.personald.backgroundColor = [self colorFromHexString:@"#036a88"];
    [self.personald setTitleColor:[self colorFromHexString:@"#4fcff4"] forState:UIControlStateNormal];
    
    [[self.contactd titleLabel] setFont:[UIFont fontWithName:@"oswald-regular" size:16.0f]];
    [self.contactd setTitleColor:[self colorFromHexString:@"#4fcff4"] forState:UIControlStateNormal];
    self.contactd.backgroundColor = [self colorFromHexString:@"#036a88"];
    
    [[self.bandd titleLabel] setFont:[UIFont fontWithName:@"oswald-regular" size:16.0f]];
    [self.bandd setTitleColor:[self colorFromHexString:@"#ffffff"] forState:UIControlStateNormal];
    self.bandd.backgroundColor = [self colorFromHexString:@"#0491b9"];
    
    
    [self.add removeFromSuperview];
    [self.zipcode removeFromSuperview];
    [self.phno removeFromSuperview];
    [self.addview removeFromSuperview];
    [self.phtext removeFromSuperview];
    [self.ziptext removeFromSuperview];
    [self.devicemodel removeFromSuperview];
    [self.devicemaf removeFromSuperview];
    [self.deviceid removeFromSuperview];
    [self.dlab removeFromSuperview];
    [self.molab removeFromSuperview];
    [self.maflab removeFromSuperview];
    [self.disconnect removeFromSuperview];
    [self.tableView1 removeFromSuperview];
    self.dobtext.hidden=YES;
    self.doblab.hidden=YES;
    self.genderb.hidden=YES;
    self.genderlab.hidden=YES;
    self.heighttext.hidden=YES;
    self.heightlab.hidden=YES;
    self.feetb.hidden=YES;
    self.kgb.hidden=YES;
    self.weighttext.hidden=YES;
    self.weightlab.hidden=YES;
    self.save.hidden=YES;
    self.cancel.hidden=YES;
    self.genderimg.hidden=YES;
    self.feetimg.hidden=YES;
    self.kgimg.hidden=YES;
    self.cancel.selected=NO;
    self.camera.selected=NO;
    [super hidemenu];
    
    if(self.bandd.selected == YES)
    {
        
        
        self.deviceid=[[UILabel alloc]init];
        self.devicemodel=[[UILabel alloc]init];
        self.devicemaf=[[UILabel alloc]init];
        self.dlab=[[UILabel alloc]init];
        self.molab=[[UILabel alloc]init];
        self.maflab=[[UILabel alloc]init];
        self.hour = [[UIButton alloc]init];
        self.min = [[UIButton alloc]init];
        self.days = [[UIButton alloc]init];
        self.finddevice=[[UIButton alloc]init];
        self.checkmark =[[UIButton alloc]init];
        
        
        
        self.deviceid.frame = CGRectMake(15, 335,100,21);
        self.deviceid.text=@"Find My Device";
        self.deviceid.font = [UIFont fontWithName:@"oswald-regular" size:17.0f];
        self.deviceid.textColor =[self colorFromHexString:@"#6f6969"];
        [self.view addSubview:self.deviceid];
        
        self.devicemodel.frame = CGRectMake(15, 230, 100,21);
        self.devicemodel.text=@"Alarm";
        self.devicemodel.font = [UIFont fontWithName:@"oswald-regular" size:17.0f];
        self.devicemodel.textColor =[self colorFromHexString:@"#6f6969"];
        [self.view addSubview:self.devicemodel];
        
        
        self.devicemaf.frame = CGRectMake(15, 385, 100,21);
        self.devicemaf.text=@"Device ID";
        self.devicemaf.font = [UIFont fontWithName:@"oswald-regular" size:17.0f];
        self.devicemaf.textColor =[self colorFromHexString:@"#6f6969"];
        [self.view addSubview:self.devicemaf];
         NSUserDefaults *def  =[NSUserDefaults standardUserDefaults];
        
        if([def objectForKey:@"alarmhour"]==NULL)
        {
            
            [def setObject:@"Hour" forKey:@"alarmhour"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
        }
        
        if([def objectForKey:@"alarmmin"]==NULL)
        {
            
            [def setObject:@"Min" forKey:@"alarmmin"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
        }
        
        
        if([def objectForKey:@"alarmday"]==NULL)
        {
            
            [def setObject:@"Day" forKey:@"alarmday"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
        }
        
        self.hour.frame=CGRectMake(120, 210, 59, 40);
        [[self.hour titleLabel] setFont:[UIFont fontWithName:@"oswald-light" size:18.0f]];
        self.hour.backgroundColor =[UIColor whiteColor];
        self.hour.layer.masksToBounds=YES;
        self.hour.layer.borderColor=[[self colorFromHexString:@"#d1d1d1"]CGColor];
        self.hour.layer.borderWidth= 1.0f;
        [self.hour setTitle:[def objectForKey:@"alarmhour"] forState:UIControlStateNormal];
        [self.hour setTitleColor:[self colorFromHexString:@"#6f6969"] forState:UIControlStateNormal];
        [self.view addSubview:self.hour];
         [self.hour addTarget:self action:@selector(hourclick) forControlEvents:UIControlEventTouchUpInside];
        
        self.min.frame=CGRectMake(180, 210, 59, 40);
        [[self.min titleLabel] setFont:[UIFont fontWithName:@"oswald-light" size:18.0f]];
        self.min.backgroundColor =[UIColor whiteColor];
        self.min.layer.masksToBounds=YES;
        self.min.layer.borderColor=[[self colorFromHexString:@"#d1d1d1"]CGColor];
        self.min.layer.borderWidth= 1.0f;
        [self.min setTitle: [def objectForKey:@"alarmmin"] forState:UIControlStateNormal];
        [self.min setTitleColor:[self colorFromHexString:@"#6f6969"] forState:UIControlStateNormal];
         [self.min addTarget:self action:@selector(minclick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.min];
        
        
        self.days.frame=CGRectMake(240, 210, 59, 40);
        [[self.days titleLabel] setFont:[UIFont fontWithName:@"oswald-light" size:18.0f]];
        self.days.backgroundColor =[UIColor whiteColor];
        self.days.layer.masksToBounds=YES;
        self.days.layer.borderColor=[[self colorFromHexString:@"#d1d1d1"]CGColor];
        self.days.layer.borderWidth= 1.0f;
        [self.view addSubview:self.days];
        [self.days setTitle:[def objectForKey:@"alarmday"] forState:UIControlStateNormal];
        [self.days setTitleColor:[self colorFromHexString:@"#6f6969"] forState:UIControlStateNormal];
         [self.days addTarget:self action:@selector(dayclick) forControlEvents:UIControlEventTouchUpInside];
        
               
        
        NSArray *mySegments = [[NSArray alloc] initWithObjects: @"ON",
                               @"OFF", nil];
    
        self.onoffsegement = [[UISegmentedControl alloc] initWithItems:mySegments];
        self.onoffsegement.frame = CGRectMake(120,262, 100.0f, 30.0f);

        self.onoffsegement.tintColor = [self colorFromHexString:@"#036a88"];
        
        [[[self.onoffsegement subviews] objectAtIndex:0] setTintColor:[self colorFromHexString:@"#036a88"]];
        if([[def objectForKey:@"alarmvalue"]isEqualToString:@"on"])
        {
        [self.onoffsegement setSelectedSegmentIndex:0];
        }
        else
        {
            
             [self.onoffsegement setSelectedSegmentIndex:1];
        }
            
        
        [self.onoffsegement addTarget:self
                                    action:@selector(checked)
                          forControlEvents:UIControlEventValueChanged];
        
        [self.view addSubview:self.onoffsegement];
        
    

        self.finddevice.frame = CGRectMake(120, 330, 150,40);
        [[self.finddevice titleLabel] setFont:[UIFont fontWithName:@"oswald-light" size:18.0f]];
        self.finddevice.backgroundColor =[UIColor whiteColor];
        self.finddevice.layer.masksToBounds=YES;
        self.finddevice.layer.borderColor=[[self colorFromHexString:@"#d1d1d1"]CGColor];
        self.finddevice.layer.borderWidth= 1.0f;
        [self.view addSubview:self.finddevice];
        [self.finddevice setTitle:@"Start" forState:UIControlStateNormal];
        [self.finddevice setTitleColor:[self colorFromHexString:@"#6f6969"] forState:UIControlStateNormal];
        [self.finddevice addTarget:self action:@selector(searchdevice) forControlEvents:UIControlEventTouchUpInside];
        
        
        self.maflab.frame = CGRectMake(120, 380, 150,40);
        self.maflab.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"device_id"];
        self.maflab.font = [UIFont fontWithName:@"oswald-light" size:16.0f];
        self.maflab.textColor =[self colorFromHexString:@"#6f6969"];
        self.maflab.backgroundColor =[UIColor whiteColor];
        [self.view addSubview:self.maflab];
        self.maflab.textAlignment=NSTextAlignmentCenter;
        self.maflab.layer.masksToBounds=YES;
        self.maflab.layer.borderColor=[[self colorFromHexString:@"#cecbcb"]CGColor];
        self.maflab.layer.borderWidth= 1.0f;
        
        self.disconnect =[[UIButton alloc]init];
        self.disconnect.frame =CGRectMake(85, 470, 150, 45);
        
        NSString *device_id=[[NSUserDefaults standardUserDefaults]objectForKey:@"device_id"];
        if (device_id!=nil)
        {
            
            [self.disconnect setTitle:@"DISCONNECT" forState:UIControlStateNormal];
            devicestatus=1;
        }
        else
        {
            [self.disconnect setTitle:@"CONNECT" forState:UIControlStateNormal];
            devicestatus=0;
        }
        
        self.disconnect.backgroundColor = [self colorFromHexString:@"#ff7376"];
        CALayer *btnLayer = [self.disconnect layer];
        [btnLayer setMasksToBounds:YES];
        [btnLayer setCornerRadius:5.0f];
        [[self.disconnect titleLabel] setFont:[UIFont fontWithName:@"oswald-bold" size:16.0f]];
        CGSize result = [[UIScreen mainScreen] bounds].size;
        
        if(result.height ==480)
        {
            self.disconnect.frame =CGRectMake(85, 430, 150, 40);
        }
        [self.view addSubview:self.disconnect];
        [_disconnect addTarget:self action:@selector(disconnectdevice) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

-(void)findmydevicebtnsetting
{
     NSLog(@"Timer caledd");
    [self.finddevice setTitle:@"Start" forState:UIControlStateNormal];
    findmydevicestatus=0;
    
}
-(void)searchdevice
{
     //find my device functionality
    NSString *dev=[[NSUserDefaults standardUserDefaults]objectForKey:@"device_status"];
    if (dev!=nil && [dev isEqualToString:@"connected"])
    {
        //find mydevice setting label
        if (findmydevicestatus==0)
        {
            findmydevicestatus=1;
            [[BTLECentralClass sharedBTLECentralClass] findmydevice];
            [NSTimer scheduledTimerWithTimeInterval:12 target:self selector:@selector(findmydevicebtnsetting) userInfo:nil repeats:NO];
            [self.finddevice setTitle:@"Stop" forState:UIControlStateNormal];
        }
        else
        {
            [[BTLECentralClass sharedBTLECentralClass]canceldevicefind];
            [self.finddevice setTitle:@"Start" forState:UIControlStateNormal];
            findmydevicestatus=0;
        }
    }
    else
    {
        [self devicenotconnectedpopup];
       
    }
}
-(void)devicenotconnectedpopup
{
    NSString *msg=@"Device is not Connected !!!";
    //custom popup setting
    UIView *popview=[[UIView alloc] initWithFrame:CGRectMake(0,0,200,70)];
    popview.backgroundColor=[self colorFromHexString:@"#ececec"];
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"warning.png"]];
    image.frame=CGRectMake(30,22,25,40);
    [popview addSubview:image];
    
    UILabel *lbl2=[[UILabel alloc] initWithFrame:CGRectMake(73,5,130,30)];
    lbl2.font=[UIFont fontWithName:@"oswald-regular" size:20.0f];
    lbl2.text=@"Warning";
    lbl2.textColor=[self colorFromHexString:@"#f3a64c"];
    lbl2.textAlignment=NSTextAlignmentCenter;
    [popview insertSubview:lbl2 atIndex:4];
    
    UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(80,30,150,30)];
    lbl.font=[UIFont fontWithName:@"oswald-regular" size:12.0f];
    lbl.lineBreakMode=NSLineBreakByWordWrapping;
    lbl.numberOfLines=5;
    lbl.text=msg;
    lbl.textColor=[self colorFromHexString:@"#858585"];
    [popview insertSubview:lbl atIndex:5];
    
    UIAlertView *ale=[[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [ale setValue:popview forKey:@"accessoryView"];
    [ale show];
    //end custom popup
    
}


-(void)popup
{
    NSString *msg=@"Hey Do you want to Search Numa Band ?";
    //custom popup setting
    UIView *popview=[[UIView alloc] initWithFrame:CGRectMake(0,0,200,100)];
    popview.backgroundColor=[self colorFromHexString:@"#ececec"];
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"info.png"]];
    image.frame=CGRectMake(30,31,30,50);
    [popview addSubview:image];
    
    UILabel *lbl2=[[UILabel alloc] initWithFrame:CGRectMake(73,5,130,30)];
    lbl2.font=[UIFont fontWithName:@"oswald-regular" size:20.0f];
    lbl2.text=@"Info";
    lbl2.textColor=[self colorFromHexString:@"#f3a64c"];
    lbl2.textAlignment=NSTextAlignmentCenter;
    [popview insertSubview:lbl2 atIndex:4];
    
    UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(80,15,150,90)];
    lbl.font=[UIFont fontWithName:@"oswald-regular" size:12.0f];
    lbl.lineBreakMode=NSLineBreakByWordWrapping;
    lbl.numberOfLines=5;
    lbl.text=msg;
    lbl.textColor=[self colorFromHexString:@"#858585"];
    [popview insertSubview:lbl atIndex:5];
    
    _buyale=[[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"NO",@"YES",nil];
    [_buyale setValue:popview forKey:@"accessoryView"];
    [_buyale show];
    //end custom popup
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView==_buyale)
    {
        if (buttonIndex==1)
        {
            devicestatus=1;
         AddDeviceViewController *search =(AddDeviceViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"adddeviceseg"];
            [self presentViewController:search animated:YES completion:nil];
        }
    }
}

-(void)disconnectdevice
{
    if (devicestatus==1)
    {
        self.maflab.text=@"";
        [[BTLECentralClass sharedBTLECentralClass] disconnectPeripheral];
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"device_id"];
        [self.disconnect setTitle:@"CONNECT" forState:UIControlStateNormal];
        devicestatus=0;
        [[NSUserDefaults standardUserDefaults] setObject:@"disconnect" forKey:@"disconnect_from_Profile"];
    }
    else if(devicestatus==0)
    {
        [self popup];
    }
    
}

-(void)checked
{
     NSUserDefaults *def =[NSUserDefaults standardUserDefaults];
    if(self.onoffsegement.selectedSegmentIndex == 0)
    {
      
        [def setObject:@"on" forKey:@"alarmvalue"];
        int hour=[_hour.titleLabel.text intValue];
        int minut=[_min.titleLabel.text intValue];
        int day =0x00;
        if([self.days.titleLabel.text isEqualToString:@"Mon"])
        {
             day=0x02;
        }
        
        else if([self.days.titleLabel.text isEqualToString:@"Tue"])
        {
            day=0x04;
        }
        
        else if([self.days.titleLabel.text isEqualToString:@"Wed"])
        {
            day=0x08;
        }
        
        else if([self.days.titleLabel.text isEqualToString:@"Thu"])
        {
            day=0x10;
        }
        
        else if([self.days.titleLabel.text isEqualToString:@"Fri"])
        {
            day=0x20;
        }
        
        else if([self.days.titleLabel.text isEqualToString:@"Sat"])
        {
            day=0x40;
        }
        
        else if([self.days.titleLabel.text isEqualToString:@"Sun"])
        {
            day=0x01;
        }
        
        else if([self.days.titleLabel.text isEqualToString:@"All"])
        {
            day=0x3E;
        }
        
        NSString *dev=[[NSUserDefaults standardUserDefaults]objectForKey:@"device_status"];
        if (dev!=nil && [dev isEqualToString:@"connected"])
        {
           [[BTLECentralClass sharedBTLECentralClass] Alarmwrite:hour Minuts:minut Day:day];
            NSInteger selectedIndex = [self.onoffsegement selectedSegmentIndex];
            
            NSString *select =
            [self.onoffsegement titleForSegmentAtIndex:selectedIndex];
            NSLog(@"Segment at position %li with %@ text is selected",
                  (long)selectedIndex, select);

        }
        else
        {
            [self devicenotconnectedpopup];
        }
        
    }
    else if(self.onoffsegement.selectedSegmentIndex == 1)
    {
        NSString *dev=[[NSUserDefaults standardUserDefaults]objectForKey:@"device_status"];
        if (dev!=nil && [dev isEqualToString:@"connected"])
        {
        
            [def setObject:@"off" forKey:@"alarmvalue"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [[BTLECentralClass sharedBTLECentralClass] Alarmwrite:0  Minuts:0 Day:0x00];
        }
        else
        {
            [self devicenotconnectedpopup];
        }
    }
}
-(void)hourclick
{
    [self.tableView1 removeFromSuperview];
    self.tableView1.frame = CGRectMake(120,251, 59, 80);
    self.tableView1.backgroundColor = [self colorFromHexString:@"#ddd9d9"];
    [self.view addSubview:self.tableView1];
    self.tableView1.separatorColor = [UIColor clearColor];
    NSArray * arr = [[NSArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24", nil];
    [self.arr removeAllObjects];
    [self.arr addObjectsFromArray:arr];
    [self.hour setSelected:YES];
    [self.min setSelected:NO];
    [self.days setSelected:NO];
    self.kgb.selected=NO;
    self.feetb.selected=NO;
    self.genderb.selected=NO;
    self.days.selected=NO;
    self.min.selected=NO;
    [self.tableView1 reloadData];
}

-(void)minclick
{
    [self.tableView1 removeFromSuperview];
    self.tableView1.frame = CGRectMake(180,251, 59, 80);
    self.tableView1.backgroundColor = [self colorFromHexString:@"#ddd9d9"];
    [self.view addSubview:self.tableView1];
    self.tableView1.separatorColor = [UIColor clearColor];
    NSArray * arr = [[NSArray alloc]initWithObjects:@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59",nil];

    [self.arr removeAllObjects];
    [self.arr addObjectsFromArray:arr];
    [self.hour setSelected:NO];
    [self.min setSelected:NO];
    [self.days setSelected:NO];
    self.kgb.selected=NO;
    self.feetb.selected=NO;
    self.genderb.selected=NO;
    self.min.selected=YES;
    self.days.selected=NO;
    [self.tableView1 reloadData];
}


-(void)dayclick
{
    [self.tableView1 removeFromSuperview];
    self.tableView1.frame = CGRectMake(240,251, 59,80);
    self.tableView1.backgroundColor = [self colorFromHexString:@"#ddd9d9"];
    [self.view addSubview:self.tableView1];
    self.tableView1.separatorColor = [UIColor clearColor];
    NSArray * arr = [[NSArray alloc]initWithObjects:@"Mon",@"Tue",@"Wed",@"Thu",@"Fri",@"Sat",@"Sun",@"All",nil];
    [self.arr removeAllObjects];
    [self.arr addObjectsFromArray:arr];
    [self.hour setSelected:NO];
    [self.min setSelected:NO];
    [self.days setSelected:NO];
    self.kgb.selected=NO;
    self.feetb.selected=NO;
    self.genderb.selected=NO;
    self.min.selected=NO;
    self.days.selected=YES;
    [self.tableView1 reloadData];
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section {
    
    if(tableView == self.tableView1)
    {
        return [self.arr count];
    }
    
    if(tableView == self.menulist)
    {
        return [self.imagelist count];
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
    
    if(tableView==self.tableView1)
    {
        
        cell.textLabel.text = [self.arr objectAtIndex:indexPath.row];
        cell.textLabel.font =[UIFont fontWithName:@"oswald-regular" size:14.0f];
        cell.textLabel.textColor = [self colorFromHexString:@"#6f6969"];
        
        return cell;
        
    }
    
    if (tableView == self.menulist) {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
}
#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    NSUserDefaults *def =[NSUserDefaults standardUserDefaults];
    if(tableView==self.tableView1)
    {
        if(self.feetb.selected == YES)
        {
            [self.feetb setTitle:selectedCell.textLabel.text forState:UIControlStateNormal];
            [def setObject:selectedCell.textLabel.text forKey:@"height_unit"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [self.tableView1 removeFromSuperview];
        }
        
        if(self.kgb.selected == YES)
        {
            [self.kgb setTitle:selectedCell.textLabel.text forState:UIControlStateNormal];
            [def setObject:selectedCell.textLabel.text forKey:@"weight_unit"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [self.tableView1 removeFromSuperview];
        }
        
        if(self.genderb.selected == YES)
        {
            [self.genderb setTitle:selectedCell.textLabel.text forState:UIControlStateNormal];
            [def setObject:selectedCell.textLabel.text forKey:@"gender"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [self.tableView1 removeFromSuperview];
        }
        
        if(self.hour.selected == YES)
        {
            [self.hour setTitle:selectedCell.textLabel.text forState:UIControlStateNormal];
            [def setObject:selectedCell.textLabel.text forKey:@"alarmhour"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [self.tableView1 removeFromSuperview];

        }
        
        if(self.min.selected == YES)
        {
            [self.min setTitle:selectedCell.textLabel.text forState:UIControlStateNormal];
            [def setObject:selectedCell.textLabel.text forKey:@"alarmmin"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [self.tableView1 removeFromSuperview];
            
        }
        if(self.days.selected == YES)
        {
            [self.days setTitle:selectedCell.textLabel.text forState:UIControlStateNormal];
            [def setObject:selectedCell.textLabel.text forKey:@"alarmday"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [self.tableView1 removeFromSuperview];
            
        }
        
    }
    
    if(tableView== self.menulist)
    {
        
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
    
}

- (IBAction)didtap:(id)sender
{
    self.camera.selected=YES;
    self.save.enabled=YES;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle: nil
                                                             delegate: self
                                                    cancelButtonTitle: @"Cancel"
                                               destructiveButtonTitle: nil
                                                    otherButtonTitles: @"Take a new photo",
                                  @"Choose from existing", nil];
    [actionSheet showInView:self.view];
}



- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self takeNewPhotoFromCamera];
            break;
        case 1:
            [self choosePhotoFromExistingImages];
        default:
            break;
    }
}

- (void)takeNewPhotoFromCamera
{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        controller.allowsEditing = NO;
        controller.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: UIImagePickerControllerSourceTypeCamera];
        controller.delegate = self;
        [self presentViewController:controller animated:YES completion:nil];
        
    }
}

-(void)choosePhotoFromExistingImages
{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        controller.allowsEditing = NO;
        controller.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: UIImagePickerControllerSourceTypePhotoLibrary];
        controller.delegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    }
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self.navigationController dismissViewControllerAnimated: YES completion: nil];
    UIImage *image = [info valueForKey: UIImagePickerControllerOriginalImage];
    NSData *imageData = UIImagePNGRepresentation(image);
    
    if(picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imagePath =[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",@"cached"]];
    
    NSLog((@"pre writing to file"));
    if (![imageData writeToFile:imagePath atomically:NO])
    {
        NSLog((@"Failed to cache image data to disk"));
    }
    else
    {
        NSLog(@"the cachedImagedPath is %@",imagePath);
        self.imagepath= imagePath;
    }
    
    self.profilepic.image =[UIImage imageWithData:imageData];
    
    NSLog(@"image path %@",self.imagepath);
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


-(void) savedata
{
    
    UIActivityIndicatorView *wait=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    wait.color=[self colorFromHexString:@"#bfdecc"];
    UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(105,4,150,20)];
    lbl.text=@"Saving Profile...";
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
        NSUserDefaults *pref =[NSUserDefaults standardUserDefaults];
        NSString *token = [pref objectForKey:@"Token"];
        NSString *ID = [pref objectForKey:@"ID"];
        NSLog(@"token %@",token);
        NSLog(@"id %@",ID);
        
        
        NSUserDefaults *def =[NSUserDefaults standardUserDefaults];
        NSString *zip = [def objectForKey:@"zip"];
        NSString *phone =[def objectForKey:@"phone"];
        NSString *address =[def objectForKey:@"address"];
        NSString *heightlab = [[NSString alloc]init];
        NSString *weightlab = [[NSString alloc]init];
        NSString *deviceid =[[NSString alloc]init];
        heightlab = self.feetb.titleLabel.text;
        weightlab =self.kgb.titleLabel.text;
        NSLog(@"zip code %@",zip);
        NSLog(@"phone %@",phone);
        NSLog(@"address %@",address);
        NSLog(@"id %@",ID);
        NSLog(@"token %@",token);
        deviceid = [def objectForKey:@"device_id"];
        if(zip == (id)[NSNull null] || zip.length == 0)
        {
            zip =@"";
            NSLog(@"zip %@",zip);
        }
        
        if(phone == (id)[NSNull null] || phone.length == 0)
        {
            
            phone=@"";
        }
        
        if(address == (id)[NSNull null] || address.length == 0)
        {
            address=@"";
            
        }
        
        if(self.feetb.titleLabel.text == (id)[NSNull null] || self.feetb.titleLabel.text.length == 0)
        {
            heightlab=@"";
            
        }
        
        if(self.kgb.titleLabel.text == (id)[NSNull null] || self.kgb.titleLabel.text.length == 0)
        {
            
            weightlab=@"";
        }
        
        if(self.imagepath == (id)[NSNull null] || self.imagepath.length == 0)
        {
            
            self.imagepath =@"1234";
            NSLog(@"imagepath %@",self.imagepath);
        }
        if(deviceid==nil)
        {
            deviceid = @"";
            
        }
        
        NSLog(@"button label %@",self.feetb.titleLabel.text);
        NSLog(@"birth date %@",self.dobtext.text);
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *parameters = @{@"user_id":ID,
                                     @"first_name":[def objectForKey:@"firstname"],
                                     @"last_name":[def objectForKey:@"last_name"],
                                     @"gender":self.genderb.titleLabel.text,
                                     @"date_of_birth":self.dobtext.text,
                                     @"height":self.heighttext.text,
                                     @"weight":self.weighttext.text,
                                     @"height_unit":heightlab,
                                     @"weight_unit":weightlab,
                                     @"address":address,
                                     @"city":self.city.text,
                                     @"state":@"",
                                     @"zip":zip,
                                     @"mobile":phone,
                                     @"device_id":deviceid,
                                     @"doc.device_model":@"",
                                     @"doc.device_manufacturer":@"",
                                     @"token":token,
                                     };
        NSURL *filePath = [NSURL fileURLWithPath:self.imagepath];
        NSString * string = [NSString stringWithFormat:@"http://numaforce.herokuapp.com/api/user/profile"];
        [manager POST:string parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileURL:filePath name:@"profile_photo" error:nil];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Success: %@", responseObject);
            NSUserDefaults * def =[NSUserDefaults standardUserDefaults];
            [def setObject:self.dobtext.text forKey:@"dob"];
            [def setObject:self.heighttext.text forKey:@"height"];
            [def setObject:self.weighttext.text forKey:@"weight"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            [waitale dismissWithClickedButtonIndex:0 animated:YES];
            [self popup:Profileupdatemessage  Title:@"Status" image:@"sucess.png"];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@",error);
            
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

@end
