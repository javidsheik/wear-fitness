#import "MonthlyViewController.h"
#import "EColumnDataModel.h"
#import "EColumnChartLabel.h"
#import "EFloatBox.h"
#import "EColor.h"
#import "AppDelegate.h"
#import "EColumnChartViewController.h"
#import "NUMA_ACTIVITIES.h"
#include <stdlib.h>

@interface MonthlyViewController ()

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) EFloatBox *eFloatBox;
@property (nonatomic, strong) EColumn *eColumnSelected;
@property (nonatomic, strong) UIColor *tempColor;

@end

@implementation MonthlyViewController
@synthesize tempColor = _tempColor;
@synthesize eFloatBox = _eFloatBox;
@synthesize eColumnChart = _eColumnChart;
@synthesize data = _data;
@synthesize eColumnSelected = _eColumnSelected;

#pragma -mark- ViewController Life Circle
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
    [[NSUserDefaults standardUserDefaults] setObject:@"#25869d" forKey:@"color"];
    [super viewDidLoad];
    
    [self stegestures];
     _monthlist=[[NSArray alloc] initWithObjects:@"January",@"February ",@"March",@"April",@"May",@"June",@"July",@"August",@"September",@"October",@"November",@"December",nil];
   
    self.view.backgroundColor=[self colorFromHexString:@"#e4e1e1"];
    _pointcount.textColor=[self colorFromHexString:@"#25869d"];
    _segmentline=[[UIView alloc] init];
    [self adddaylabel];
    [self segmentsetting];
    //show database
}
-(void)segmentsetting
{
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"oswald-regular" size:16.0f],NSForegroundColorAttributeName:[self colorFromHexString:@"#807e7f"]} forState:UIControlStateNormal];
    
    [_seg setSelectedSegmentIndex:1];
    [self segmentchange:_seg];
    [_seg addTarget:self action:@selector(segmentchange:) forControlEvents:UIControlEventValueChanged];
}
-(void)segmentchange:(UISegmentedControl *)seg
{
    _segmentline.backgroundColor=[self colorFromHexString:@"#f71e65"];
    if (seg.selectedSegmentIndex==0)
    {
        _segmentline.frame=CGRectMake(0,80,160,3);
        UINavigationController *navController = self.navigationController;
        [navController popViewControllerAnimated:NO];
        EColumnChartViewController *week=(EColumnChartViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"weeklymodule"];
        [navController pushViewController:week animated:NO];
    }
    else if (seg.selectedSegmentIndex==1)
    {
        _segmentline.frame=CGRectMake(160,80,160,3);
        NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy"];
        year=[[formatter stringFromDate:[NSDate date]]intValue];
        [self senddatatograph];
    }
    [self.view addSubview:_segmentline];
}
-(void)drawgraph:(NSArray *)keys values:(NSArray *)values
{
    [_eColumnChart removeFromSuperview];
    NSMutableArray *temp = [NSMutableArray array];
    for (int i = 0; i <keys.count; i++)
    {
        EColumnDataModel *eColumnDataModel = [[EColumnDataModel alloc] initWithLabel:[keys objectAtIndex:i] value:[[values objectAtIndex:i] intValue] index:i unit:@""];
        [temp addObject:eColumnDataModel];
    }
    _data = [NSArray arrayWithArray:temp];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"screen"]intValue]==40)
    {
        _eColumnChart = [[EColumnChart alloc] initWithFrame:CGRectMake(40,145, 280,305)];
    }
    else
    {
        _eColumnChart = [[EColumnChart alloc] initWithFrame:CGRectMake(40,145,280,235)];
    }
    
    //[_eColumnChart setNormalColumnColor:[UIColor purpleColor]];
    // _eColumnChart.backgroundColor=[self colorFromHexString:@"#efecec"];
    [_eColumnChart setColumnsIndexStartFromLeft:YES];
    [_eColumnChart setDelegate:self];
    [_eColumnChart setDataSource:self];
    
    [_eColumnChart addGestureRecognizer:_leftswipe];
    [_eColumnChart addGestureRecognizer:_rightswipe];
    _leftswipe.delegate=self;
    _rightswipe.delegate=self;
    [self.view addSubview:_eColumnChart];
}
-(void)senddatatograph
{
    AppDelegate *app=[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *contex=app.managedObjectContext;
    NSFetchRequest *requset=[[NSFetchRequest alloc] initWithEntityName:@"NUMA_ACTIVITIES"];
    NSPredicate *pre=[NSPredicate predicateWithFormat:@"year=%d",year];
    [requset setPredicate:pre];
    NSError *err;
    NSArray *yeardata=[contex executeFetchRequest:requset error:&err];
    
    if (yeardata.count==0)
    {
        NSString *msg=[NSString stringWithFormat:@"Data Not Available For Year :- %d",year];
        [self popup:msg Title:@"Info" image:@"nodata.png"];
        
        if (yearstatus==0)
        {
            year++;
            yearstatus=5;
            [self senddatatograph];
        }
        else if(yearstatus==1)
        {
            year--;
            yearstatus=5;
            [self senddatatograph];
        }
        
    }
    else
    {
        int m1=0,m2=0,m3=0,m4=0,m5=0,m6=0,m7=0,m8=0,m9=0,m10=0,m11=0,m12=0;
        for (NUMA_ACTIVITIES *n in yeardata)
        {
            int step=[[NSString stringWithFormat:@"%@",n.steps] intValue];
            int num=[[NSString stringWithFormat:@"%@",n.month] intValue];
            switch (num)
            {
                case 1:
                    m1+=step;
                    break;
                case 2:
                    m2+=step;
                    break;
                case 3:
                    m3+=step;
                    break;
                case 4:
                    m4+=step;
                    break;
                case 5:
                    m5+=step;
                    break;
                case 6:
                    m6+=step;
                    break;
                case 7:
                    m7+=step;
                    break;
                case 8:
                    m8+=step;
                    break;
                case 9:
                    m9+=step;
                    break;
                case 10:
                    m10+=step;
                    break;
                case 11:
                    m11+=step;
                    break;
                case 12:
                    m12+=step;
                    break;
                default:
                    break;
            }
            
        }
        NSArray *values=[[NSArray alloc] initWithObjects:[NSNumber numberWithInt:m1],[NSNumber numberWithInt:m2],[NSNumber numberWithInt:m3],[NSNumber numberWithInt:m4],[NSNumber numberWithInt:m5],[NSNumber numberWithInt:m6],[NSNumber numberWithInt:m7],[NSNumber numberWithInt:m8],[NSNumber numberWithInt:m9],[NSNumber numberWithInt:m10],[NSNumber numberWithInt:m11],[NSNumber numberWithInt:m12],nil];
        
        [self setyearlabel:year];
        [self drawgraph:_monthlist values:values];
    }
    
  }

- (void)viewDidAppear:(BOOL)animated
{
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(0,5,70,20)];
    title.text=@"ACTIVITY";
    title.font=[UIFont fontWithName:@"oswald-regular" size:20.0f];
    title.textColor=[UIColor whiteColor];
    self.navigationItem.titleView=title;
    [super viewDidLoad];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark- Actions
#pragma -mark- EColumnChartDataSource

- (NSInteger)numberOfColumnsInEColumnChart:(EColumnChart *)eColumnChart
{
    return [_data count];
}

- (NSInteger)numberOfColumnsPresentedEveryTime:(EColumnChart *)eColumnChart
{
    return _data.count;
}
- (EColumnDataModel *)highestValueEColumnChart:(EColumnChart *)eColumnChart
{
    EColumnDataModel *maxDataModel = nil;
    float maxValue = -FLT_MIN;
    for (EColumnDataModel *dataModel in _data)
    {
        if (dataModel.value > maxValue)
        {
            maxValue = dataModel.value;
            maxDataModel = dataModel;
        }
    }
    return maxDataModel;
}

- (EColumnDataModel *)eColumnChart:(EColumnChart *)eColumnChart valueForIndex:(NSInteger)index
{
    if (index >= [_data count] || index < 0) return nil;
    return [_data objectAtIndex:index];
}

- (UIColor *)colorForEColumn:(EColumn *)eColumn
{
    if (eColumn.eColumnDataModel.index < 8)
    {
        return [self colorFromHexString:@"#25869d"];
    }
    else
    {
        return [self colorFromHexString:@"#25869d"];
    }
    
}
- (void)eColumnChart:(EColumnChart *)eColumnChart
fingerDidEnterColumn:(EColumn *)eColumn
{
    //NSLog(@"Finger did enter %d", eColumn.eColumnDataModel.index);
    CGFloat eFloatBoxX = eColumn.frame.origin.x + eColumn.frame.size.width * 1.25;
    CGFloat eFloatBoxY = eColumn.frame.origin.y + eColumn.frame.size.height * (1-eColumn.grade);
    if (_eFloatBox)
    {
        [_eFloatBox removeFromSuperview];
        _eFloatBox.frame = CGRectMake(eFloatBoxX, eFloatBoxY, _eFloatBox.frame.size.width, _eFloatBox.frame.size.height);
        [_eFloatBox setValue:eColumn.eColumnDataModel.value];
        [eColumnChart addSubview:_eFloatBox];
    }
    else
    {
        _eFloatBox = [[EFloatBox alloc] initWithPosition:CGPointMake(eFloatBoxX, eFloatBoxY) value:eColumn.eColumnDataModel.value unit:@"Steps" title:@"Title"];
        _eFloatBox.alpha = 0.0;
        [eColumnChart addSubview:_eFloatBox];
        
    }
    eFloatBoxY -= (_eFloatBox.frame.size.height + eColumn.frame.size.width * 0.25);
    _eFloatBox.frame = CGRectMake(eFloatBoxX, eFloatBoxY, _eFloatBox.frame.size.width, _eFloatBox.frame.size.height);
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{_eFloatBox.alpha = 1.0;} completion:^(BOOL finished){}];
    
}

- (void)eColumnChart:(EColumnChart *)eColumnChart fingerDidLeaveColumn:(EColumn *)eColumn
{
   
    
}
- (void)fingerDidLeaveEColumnChart:(EColumnChart *)eColumnChart
{
    if (_eFloatBox)
    {
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
            _eFloatBox.alpha = 0.0;
            _eFloatBox.frame = CGRectMake(_eFloatBox.frame.origin.x, _eFloatBox.frame.origin.y + _eFloatBox.frame.size.height, _eFloatBox.frame.size.width, _eFloatBox.frame.size.height);
        } completion:^(BOOL finished)
         {
             [_eFloatBox removeFromSuperview];
             _eFloatBox = nil;
         }];
    }
}
-(void)adddaylabel
{
    UIView *chartback;
    UIView *yxies;
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"screen"]intValue]==40)
    {
        //4 inch screen Iphone-5
        chartback=[[UIView alloc] initWithFrame:CGRectMake(7,121,310,359)];
        yxies=[[UIView alloc] initWithFrame:CGRectMake(40,133,2,318)];
    }
    else
    {
        chartback=[[UIView alloc] initWithFrame:CGRectMake(7,121,310,272)];
        yxies=[[UIView alloc] initWithFrame:CGRectMake(40,133,2,250)];
    }
    
    chartback.backgroundColor=[self colorFromHexString:@"#ffffff"];
    chartback.layer.cornerRadius=5;
    [self.view addSubview:chartback];
    
    
    yxies.backgroundColor=[self colorFromHexString:@"#747272"];
    [self.view addSubview:yxies];
    
    _pointview.layer.cornerRadius=5;
    _cupview.layer.cornerRadius=5;
    _pointview.backgroundColor=[self colorFromHexString:@"#ffffff"];
    _cupview.backgroundColor=[self colorFromHexString:@"#ffffff"];
    //add months label
    [self addmonthslabel];
    
}
-(UIColor *)colorFromHexString:(NSString *)hexString
{
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1];
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}
-(void)eColumnChart:(EColumnChart *)eColumnChart didSelectColumn:(EColumn *)eColumn
{
    if (_eColumnSelected)
    {
        _eColumnSelected.barColor = _tempColor;
    }
    
    AppDelegate *app=[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *contex=app.managedObjectContext;
    NSFetchRequest *req=[[NSFetchRequest alloc] initWithEntityName:@"NUMA_ACTIVITIES"];
    NSPredicate *pre=[NSPredicate predicateWithFormat:@"month=%d",eColumn.eColumnDataModel.index+1];
    [req setPredicate:pre];
    NSError *err;
    NSArray *database=[contex executeFetchRequest:req error:&err];
    
    int steps=0;
    int cal=0;
    int dist=0;
    
    for (NUMA_ACTIVITIES *n in database)
    {
        steps+=[[NSString stringWithFormat:@"%@",n.steps] intValue];
        cal+=[[NSString stringWithFormat:@"%@",n.calories] intValue];
        dist+=[[NSString stringWithFormat:@"%@",n.distance] intValue];
    }
    _eColumnSelected = eColumn;
    _tempColor = eColumn.barColor;
    eColumn.barColor = [UIColor blackColor];
    
    NSArray *lbllist=[NSArray arrayWithObjects:@"Steps :",@"Distance :",@"Calories :",nil];
    UIView *popview=[[UIView alloc] initWithFrame:CGRectMake(0,0,280,200)];
    popview.backgroundColor=[UIColor blackColor];
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"info.png"]];
    image.frame=CGRectMake(65,2,30,30);
    
NSArray *monthhdata=[NSArray arrayWithObjects:[NSNumber numberWithInt:steps],[NSNumber numberWithInt:dist],[NSNumber numberWithInt:cal], nil];
    UILabel *lbl2=[[UILabel alloc] initWithFrame:CGRectMake(60,2,140,30)];
    lbl2.font=[UIFont fontWithName:@"oswald-regular" size:16.0f];
    lbl2.text=[NSString stringWithFormat:@"%@",[_monthlist objectAtIndex:eColumn.eColumnDataModel.index ]];
    lbl2.textColor=[UIColor greenColor];
    lbl2.textAlignment=NSTextAlignmentCenter;
    
    [popview addSubview:lbl2];
    [popview addSubview:image];
    int add=0;
    for (int i=0; i<3;i++)
    {
        UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(60,35+add,70,20)];
        lbl.font=[UIFont fontWithName:@"oswald-regular" size:15.0f];
        lbl.text=[lbllist objectAtIndex:i];
        lbl.textColor=[UIColor greenColor];
        lbl.textAlignment=NSTextAlignmentRight;
        
        UILabel *lbl1=[[UILabel alloc] initWithFrame:CGRectMake(140,35+add,100,20)];
        lbl1.font=[UIFont fontWithName:@"oswald-regular" size:15.0f];
        lbl1.text=[NSString stringWithFormat:@"%@",[monthhdata objectAtIndex:i]];
        lbl1.textColor=[UIColor greenColor];
        
        add+=25;
        [popview addSubview:lbl];
        [popview addSubview:lbl1];
    }
    
    UIAlertView *ale=[[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [ale setValue:popview forKey:@"accessoryView"];
    [ale show];
}

-(void)addmonthslabel
{
    
    UIView *monthsview;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"screen"]intValue]==40)
    {
        monthsview=[[UIView alloc] initWithFrame:CGRectMake(34,455,280,15)];
    }
    else
    {
         monthsview=[[UIView alloc] initWithFrame:CGRectMake(34,380,280,15)];
    }
    int x=10;
    for (NSString *mon in _monthlist)
    {
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(x,0,17,15)];
        label.font=[UIFont fontWithName:@"oswald-regular" size:9.0f];
        label.text=[[mon substringToIndex:3]uppercaseString];
        label.textColor=[UIColor grayColor];
        label.textAlignment=NSTextAlignmentCenter;
        x+=23.4;
        [monthsview addSubview:label];
    }
   
    [self.view insertSubview:monthsview atIndex:10];
}

-(void)stegestures
{
    _leftswipe=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(statechange:)];
    [_leftswipe setDirection:UISwipeGestureRecognizerDirectionLeft];
    _leftswipe.delegate=self;
    
    _rightswipe=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(statechange:)];
    [_rightswipe setDirection:UISwipeGestureRecognizerDirectionRight];
    _rightswipe.delegate=self;
}
-(void)statechange:(UISwipeGestureRecognizer *)ges
{
    if (ges==_leftswipe)
    {
         year--;
         yearstatus=0;
         [self senddatatograph];
    }
    else if(ges==_rightswipe)
    {
         year++;
         yearstatus=1;
         [self senddatatograph];
    }
}
-(void)setyearlabel :(int)yer
{
    UIView *topbar=[[UIView alloc] initWithFrame:CGRectMake(0,82,320,33)];
    topbar.backgroundColor=[self colorFromHexString:@"#0097bf"];

    UIImageView *left=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_left"]];
    left.frame=CGRectMake(5,3,28,28);
    [topbar addSubview:left];
    
    UIImageView *right=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right"]];
    right.frame=CGRectMake(290,3,28,28);
    [topbar addSubview:right];
    
    
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(60,6,200,20)];
    label.font=[UIFont fontWithName:@"oswald-regular" size:20.0f];
    label.text=[NSString stringWithFormat:@"%d",yer];
    label.textColor=[UIColor whiteColor];
    label.layer.cornerRadius=3;
    label.clipsToBounds=YES;
    label.textAlignment=NSTextAlignmentCenter;
    [topbar addSubview:label];
    
    [self.view addSubview:topbar];
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
