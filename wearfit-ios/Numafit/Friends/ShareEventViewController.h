//
//  ShareEventViewController.h
//  Numafit
//
//  Created by apple on 26/11/14.
//  Copyright (c) 2014 sanhotrasoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareEventViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    int recordcount;
    int pageno;
}
@property (strong, nonatomic)UITableView *circlelisttable;
@property (nonatomic,retain) NSArray *cellcolorlist;
@property (nonatomic,retain) NSMutableArray *circlelist;
@property (nonatomic,retain) NSString *eventid;


@end
