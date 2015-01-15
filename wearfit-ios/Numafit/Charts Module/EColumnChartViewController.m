//
//  EColumnChartViewController.m
//  EChart
//
//  Created by Efergy China on 11/12/13.
//  Copyright (c) 2013 Scott Zhu. All rights reserved.
//

#import "EColumnChartViewController.h"
#import "EColumnDataModel.h"
#import "EColumnChartLabel.h"
#import "EFloatBox.h"
#import "EColor.h"
#import "EColumn.h"
#import "AppDelegate.h"
#import "MonthlyViewController.h"
#include <stdlib.h>
#import "NUMA_ACTIVITIES.h"

@interface EColumnChartViewController ()

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) EFloatBox *eFloatBox;

@property (nonatomic, strong) EColumn *eColumnSelected;
@property (nonatomic, strong) UIColor *tempColor;

@end

@implementation EColumnChartViewController
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
    [[NSUserDefaults standardUserDefaults] setObject:@"#1fd0ad" forKey:@"color"];
    [super viewDidLoad];
    self.view.backgroundColor=[self colorFromHexString:@"#e4e1e1"];
    
    //set gestuer recognizer
    [self stegestures];
    
    _daylist=[NSArray arrayWithObjects:@"SUN",@"MON",@"TUE",@"WED",@"THU",@"FRI",@"SAT",nil];
    _segmentline=[[UIView alloc] init];
    [self adddaylabel];
    [self segmentsetting];
}
-(void)segmentsetting
{
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"oswald-regular" size:16.0f],NSForegroundColorAttributeName:[self colorFromHexString:@"#807e7f"]} forState:UIControlStateNormal];
    [_seg setSelectedSegmentIndex:0];
    [self segmentchange:_seg];
    [_seg addTarget:self action:@selector(segmentchange:) forControlEvents:UIControlEventValueChanged];
}
-(void)segmentchange:(UISegmentedControl *)seg
{
    
    _segmentline.backgroundColor=[self colorFromHexString:@"#f71e65"];
    if (seg.selectedSegmentIndex==0)
    {
        _segmentline.frame=CGRectMake(0,80,160,3);
        [self setweekcounter];
    }
    else if (seg.selectedSegmentIndex==1)
    {
        _segmentline.frame=CGRectMake(160,80,160,3);
        UINavigationController *navController = self.navigationController;
        [navController popViewControllerAnimated:NO];
        MonthlyViewController *month=(MonthlyViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"monmodule"];
        [navController pushViewController:month animated:NO];
    }
    [self.view addSubview:_segmentline];
    
}
-(void)drawgraph:(NSArray *)dict
{
    [_eColumnChart removeFromSuperview];
    
    NSMutableArray *keys=[[NSMutableArray alloc] init];
    NSMutableArray *values=[[NSMutableArray alloc] init];
    _weekdata=[NSArray arrayWithArray:dict];
    
    int totalvalu=0;
    for (NSArray *a in dict)
    {
        [keys addObject:[a objectAtIndex:3]];
        [values addObject:[a objectAtIndex:0]];
        totalvalu+=[[a objectAtIndex:0] intValue];
    }
    
    NSMutableArray *temp = [NSMutableArray array];
    for (int i = 0; i <keys.count; i++)
    {
      EColumnDataModel *eColumnDataModel = [[EColumnDataModel alloc] initWithLabel:[keys objectAtIndex:i] value:[[values objectAtIndex:i] intValue] index:i unit:@""];
        [temp addObject:eColumnDataModel];
    }
    _data = [NSArray arrayWithArray:temp];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"screen"]intValue]==40)
    {
        _eColumnChart = [[EColumnChart alloc] initWithFrame:CGRectMake(40,145,280,350)];
    }
    else
    {
        _eColumnChart = [[EColumnChart alloc] initWithFrame:CGRectMake(40,145,280,265)];
    }
    
    //add gestuer Recognizer here
    [_eColumnChart addGestureRecognizer:_leftswipe];
    [_eColumnChart addGestureRecognizer:_rightswipe];
    //[_eColumnChart setNormalColumnColor:[UIColor purpleColor]];
    // _eColumnChart.backgroundColor=[self colorFromHexString:@"#efecec"];
    [_eColumnChart setColumnsIndexStartFromLeft:YES];
    [_eColumnChart setDelegate:self];
    [_eColumnChart setDataSource:self];
    
    [self.view addSubview:_eColumnChart];
    
    //thsi function add goal for week ..
    [self addgoalline:totalvalu];
    
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
        return [self colorFromHexString:@"#1fd0ad"];//[UIColor redColor];
    }
    else
    {
        return [self colorFromHexString:@"#1fd0ad"];  //[UIColor redColor];
    }
}

#pragma -mark- EColumnChartDelegate
- (void)eColumnChart:(EColumnChart *)eColumnChart
     didSelectColumn:(EColumn *)eColumn
{
    // NSLog(@"Index: %d  Value: %f", eColumn.eColumnDataModel.index, eColumn.eColumnDataModel.value);
    
    if (_eColumnSelected)
    {
        _eColumnSelected.barColor = _tempColor;
    }
    _eColumnSelected = eColumn;
    _tempColor = eColumn.barColor;
    eColumn.barColor = [UIColor blackColor];
    
    NSArray *daydata=[_weekdata objectAtIndex:eColumn.eColumnDataModel.index];
    NSArray *lbllist=[NSArray arrayWithObjects:@"Steps :",@"Distance :",@"Calories :",@"Date :",nil];
    UIView *popview=[[UIView alloc] initWithFrame:CGRectMake(0,0,280,200)];
    popview.backgroundColor=[UIColor blackColor];
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"info.png"]];
    image.frame=CGRectMake(65,2,30,30);
    NSArray *day=[NSArray arrayWithObjects:@"SUNDAY",@"MONDAY",@"TUESDAY",@"WEDNESDAY",@"THURSDAY",@"FRIDAY",@"SATURDAY",nil];
    
    UILabel *lbl2=[[UILabel alloc] initWithFrame:CGRectMake(60,2,140,30)];
    lbl2.font=[UIFont fontWithName:@"oswald-regular" size:16.0f];
    lbl2.text=[NSString stringWithFormat:@"%@",[day objectAtIndex:eColumn.eColumnDataModel.index ]];
    lbl2.textColor=[UIColor greenColor];
    lbl2.textAlignment=NSTextAlignmentCenter;
    
    [popview addSubview:lbl2];
    [popview addSubview:image];
    int add=0;
    for (int i=0; i<4;i++)
    {
        UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(60,32+add,70,20)];
        lbl.font=[UIFont fontWithName:@"oswald-regular" size:13.0f];
        lbl.text=[lbllist objectAtIndex:i];
        lbl.textColor=[UIColor greenColor];
        lbl.textAlignment=NSTextAlignmentRight;
        
        UILabel *lbl1=[[UILabel alloc] initWithFrame:CGRectMake(140,32+add,100,20)];
        lbl1.font=[UIFont fontWithName:@"oswald-regular" size:13.0f];
        lbl1.text=[NSString stringWithFormat:@"%@",[daydata objectAtIndex:i]];
        lbl1.textColor=[UIColor greenColor];
        
         add+=20;
        [popview addSubview:lbl];
        [popview addSubview:lbl1];
    }
    
    UIAlertView *ale=[[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [ale setValue:popview forKey:@"accessoryView"];
    [ale show];
}

- (void)eColumnChart:(EColumnChart *)eColumnChart
fingerDidEnterColumn:(EColumn *)eColumn
{
    //NSLog(@"Finger did enter %d", eColumn.eColumnDataModel.index);
    CGFloat eFloatBoxX = eColumn.frame.origin.x + eColumn.frame.size.width * 1.25;
    CGFloat eFloatBoxY = eColumn.frame.origin.y + eColumn.frame.size.height * (1-eColumn.grade);
    
    float val=eColumn.eColumnDataModel.value;
    if (_eFloatBox)
    {
        [_eFloatBox removeFromSuperview];
        _eFloatBox.frame = CGRectMake(eFloatBoxX, eFloatBoxY, _eFloatBox.frame.size.width, _eFloatBox.frame.size.height);
        [_eFloatBox setValue:eColumn.eColumnDataModel.value];
        
        //this is tool tip text just remove fellowing commet to show it
        
    }
    else
    {
        _eFloatBox = [[EFloatBox alloc] initWithPosition:CGPointMake(eFloatBoxX, eFloatBoxY) value:eColumn.eColumnDataModel.value unit:@"Steps" title:@"Title"];
        _eFloatBox.alpha = 0.0;
        if (val>1)
        {
            [eColumnChart addSubview:_eFloatBox];
        }
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
        } completion:^(BOOL finished) {
            [_eFloatBox removeFromSuperview];
            _eFloatBox = nil;
        }];
    }
}
-(void)adddaylabel
{
    
    UIView *chartback;
    UIView *yxies;
    UIView *dayview;
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"screen"]intValue]==40)
    {
        chartback=[[UIView alloc] initWithFrame:CGRectMake(7,121,310,386)];
        yxies=[[UIView alloc] initWithFrame:CGRectMake(40,136,2,359)];
        dayview=[[UIView alloc] initWithFrame:CGRectMake(0,520,320,60)];
    }
    else
    {
        chartback=[[UIView alloc] initWithFrame:CGRectMake(7,121,310,301)];
        yxies=[[UIView alloc] initWithFrame:CGRectMake(40,136,2,274)];
        dayview=[[UIView alloc] initWithFrame:CGRectMake(0,435,320,60)];
    }
    
    chartback.backgroundColor=[self colorFromHexString:@"#ffffff"];
    chartback.layer.cornerRadius=5;
    [self.view addSubview:chartback];
    
    
    yxies.backgroundColor=[self colorFromHexString:@"#747272"];
    [self.view addSubview:yxies];
    
    int i=0;
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"EEEE"];
    NSString *dayname=[[[format stringFromDate:[NSDate date]] substringToIndex:3]uppercaseString];
    for (NSString *str in _daylist)
    {
        UILabel *day=[[UILabel alloc] initWithFrame:CGRectMake(46+i,4,35,25)];
        day.text=str;
        day.textColor=[UIColor grayColor];
        day.textAlignment=NSTextAlignmentCenter;
        day.font=[UIFont fontWithName:@"oswald-regular" size:13.0f];
        if ([dayname isEqualToString:str])
        {
            day.textColor=[self colorFromHexString:@"#1fd0ad"];
            day.backgroundColor=[UIColor  blackColor];
            day.layer.cornerRadius=5.0f;
            day.clipsToBounds=YES;
        }
        [dayview addSubview:day];
        i=i+39;
    }
    [self.view addSubview:dayview];
}
-(UIColor *)colorFromHexString:(NSString *)hexString
{
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1];
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

//fellowing code pass week data to graph
-(void)setweekcounter
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components1 = [gregorian components:NSWeekOfYearCalendarUnit fromDate:[NSDate date]];
    originalweekstart=(int)components1.weekOfYear;
    startweek=(int)components1.weekOfYear;
    [self setendweek];
    [self senddatatograph:startweek];
}
-(void)senddatatograph:(int)weeknumber
{
    AppDelegate *app=[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *ctx=app.managedObjectContext;
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    int year=[[formatter stringFromDate:[NSDate date]] intValue];
    NSFetchRequest *req=[[NSFetchRequest alloc] initWithEntityName:@"NUMA_ACTIVITIES"];
    NSPredicate *pre=[NSPredicate predicateWithFormat:@"week=%d AND year=%d",weeknumber,year];
    [req setPredicate:pre];
    req.sortDescriptors=@[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
    NSError *err;
    NSArray *arr=[NSArray arrayWithArray:[ctx executeFetchRequest:req error:&err]];
    if (arr.count!=0)
    {
        NSMutableArray *weekdates= [[NSMutableArray alloc] initWithArray:[self getweekdates:weeknumber year:year]];
        
        NSMutableDictionary *datadict=[[NSMutableDictionary alloc] init];
        for (NSString  *date1 in weekdates)
        {
        NSArray *objdata=[NSArray arrayWithObjects:[NSNumber numberWithInt:1],[NSNumber numberWithInt:0],[NSNumber numberWithInt:0],date1,nil];
            [datadict setObject:objdata forKey:date1];
        }
        for (NUMA_ACTIVITIES *n in arr)
        {
            NSArray *objdata=[NSArray arrayWithObjects:n.steps,n.distance,n.calories,n.date,nil];
            [datadict setObject:objdata forKey:n.date];
        }
        NSMutableArray *temp=[[NSMutableArray alloc] init];
        for (NSString *date in weekdates)
        {
            [temp addObject:[datadict objectForKey:date]];
        }
        [self drawgraph:temp];
    }
   else
    {
        [self popup:@"Data Not Available" Title:@"Info" image:@"nodata.png"];
    }
}

-(NSMutableArray *)getweekdates:(int)weeknumber year:(int)year
{
    //code to get start date of selected week..
    NSCalendar *gregorian1 = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps1 = [[NSDateComponents alloc] init];
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [comps1 setYear:year];
    [comps1 setWeekOfYear:weeknumber];
    [comps1 setWeekday:1];
    NSDate *weekstart = [gregorian1 dateFromComponents:comps1];
    
    [comps1 setYear:year];
    [comps1 setWeekOfYear:weeknumber];
    [comps1 setWeekday:7];
    NSDate *weekend = [gregorian1 dateFromComponents:comps1];
    
    //code to get all date between two dates
    NSMutableArray *alldates=[[NSMutableArray alloc] init];
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];
    NSDateComponents *days = [[NSDateComponents alloc] init];
    NSInteger dayCount = 0;
    [alldates addObject:[formatter stringFromDate:weekstart]];
    while ( TRUE )
    {
        [days setDay: ++dayCount];
        NSDate *date = [gregorianCalendar dateByAddingComponents: days toDate:weekstart options: 0];
        if ( [date  compare: weekend] == NSOrderedDescending )
            break;
        [alldates addObject:[formatter stringFromDate:date]];
    }
    [self addweekdates:[alldates objectAtIndex:0] enddate:[alldates objectAtIndex:6]];
    return alldates;
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
    if (ges==_rightswipe)
    {
        startweek++;
        if(startweek==originalweekstart+1)
        {
            startweek=originalweekstart;
            [self popup:@"Current Week Information.. " Title:@"Info" image:@"info.png"];
        }
        [self senddatatograph:startweek];
    }
    else
    {
        startweek--;
        if (startweek==endweek)
        {
            startweek++;
            [self senddatatograph:endweek];
            [self popup:@"Last Week Information.. " Title:@"Info" image:@"info.png"];
        }
        else
        {
            [self senddatatograph:startweek];
        }
      
    }
}

-(void)setendweek
{
    AppDelegate *app=[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *ctx=app.managedObjectContext;
    NSError *err;
    NSFetchRequest *req=[[NSFetchRequest alloc] initWithEntityName:@"NUMA_ACTIVITIES"];
    NSArray *database=[ctx executeFetchRequest:req error:&err];
    NSDateFormatter *formater=[[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd"];
    if ([database count]>0)
    {
        NSMutableArray *mydates=[[NSMutableArray alloc] init];
        for (NUMA_ACTIVITIES *b in database)
        {
            [mydates addObject:[formater dateFromString:b.date]];
        }
        NSDate *lastdate=[mydates valueForKeyPath:@"@min.self"];
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components1 = [gregorian components:NSWeekOfYearCalendarUnit fromDate:lastdate];
        endweek=(int)components1.weekOfYear;
    }
    else
    {
        endweek=startweek;
    }
}

-(void)addgoalline:(int)totalstep
{
    [_line removeFromSuperview];
    float per=(totalstep*100)/22000;
    float cahrthei=_eColumnChart.frame.size.height;
    float hei=(cahrthei/100)*per;
    hei=cahrthei-hei;
    _line=[[UIView alloc] initWithFrame:CGRectMake(0,hei,280,1)];
    _line.backgroundColor=[self colorFromHexString:@"#81b3e5"];
    [_eColumnChart addSubview:_line];
}
-(void)addweekdates:(NSString *)startdate enddate:(NSString *)enddate
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
    label.font=[UIFont fontWithName:@"oswald-regular" size:15.0f];
    label.text=[NSString stringWithFormat:@"%@   to   %@",startdate,enddate];
    label.textColor=[UIColor whiteColor];
    label.layer.cornerRadius=3;
    label.clipsToBounds=YES;
    label.textAlignment=NSTextAlignmentCenter;
    [topbar addSubview:label];
    
    [self.view addSubview:topbar];
    
    UIView *ind1=[[UIView alloc] initWithFrame:CGRectMake(220,128,12,12)];
    ind1.backgroundColor=[self colorFromHexString:@"#1fd0ad"];
    UILabel *ste=[[UILabel alloc] initWithFrame:CGRectMake(237,126,50,15)];
    ste.font=[UIFont fontWithName:@"oswald-regular" size:11.0f];
    ste.textColor=[self colorFromHexString:@"#1fd0ad"];
    ste.text=@"Steps";
    [self.view addSubview:ind1];
    [self.view addSubview:ste];
    
    UIView *ind2=[[UIView alloc] initWithFrame:CGRectMake(270,128,12,12)];
    ind2.backgroundColor=[self colorFromHexString:@"#81b3e5"];
    UILabel *ste2=[[UILabel alloc] initWithFrame:CGRectMake(285,126,50,15)];
    ste2.font=[UIFont fontWithName:@"oswald-regular" size:11.0f];
    ste2.textColor=[self colorFromHexString:@"#81b3e5"];
    ste2.text=@"Avg";
    [self.view addSubview:ind2];
    [self.view addSubview:ste2];
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
