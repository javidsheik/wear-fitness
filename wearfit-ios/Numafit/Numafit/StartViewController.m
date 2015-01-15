//
//  StartViewController.m
//  Numafit
//
//  Created by iHotra-LT-02 on 11/11/14.
//  Copyright (c) 2014 sanhotrasoft. All rights reserved.
//

#import "StartViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "DailyViewController.h"

@interface StartViewController ()

@end

@implementation StartViewController

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
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[self colorFromHexString:@"#8E388E"] CGColor], (id)[[self colorFromHexString:@"#EE799F"] CGColor],nil];
    [self.view.layer insertSublayer:gradient atIndex:0];
//    self.view.backgroundColor = [self colorFromHexString:@"#88187e"];
     [[self.login titleLabel] setFont:[UIFont fontWithName:@"oswald-regular" size:18.0f]];
    CALayer *btnLayer1 = [self.login layer];
    [btnLayer1 setMasksToBounds:YES];
    [btnLayer1 setCornerRadius:5.0f];
    [self.login setBackgroundColor:[self colorFromHexString:@"#8E388E"]];
    
    UIImageView *logo = [[UIImageView alloc]init];
    logo.frame = CGRectMake(0, 150, 307, 279);
    logo.image = [UIImage imageNamed:@"bandimage"];
    
    CGSize result = [[UIScreen mainScreen] bounds].size;
    
    if(result.height==480)
    {
        
        logo.frame = CGRectMake(0, 110, 307, 279);
        
    }
 
   [self.view addSubview:logo];
    
    [UIView animateWithDuration:2.0 animations:^{
      logo.transform = CGAffineTransformMakeScale(0.5, 0.5);
    }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:2.0 animations:^{
                             logo.transform = CGAffineTransformMakeScale(1, 1);
                         }];
                     }];
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
    NSString *device=[[NSUserDefaults standardUserDefaults]objectForKey:@"device_id"];
    NSUserDefaults *pref =[NSUserDefaults standardUserDefaults];
    NSString *token = [pref objectForKey:@"Token"];
    NSString *ID = [pref objectForKey:@"ID"];
    if(token.length!=0 && ID.length!=0 && device!=nil)
    {
        DailyViewController *daily=(DailyViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"daily"];
        [self presentViewController:daily animated:YES completion:nil];
    }
}
-(BOOL)prefersStatusBarHidden
{
    
    return YES;
}
@end
