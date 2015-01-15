//
//  NUMA_ACTIVITIES.h
//  Numafit
//
//  Created by apple on 08/12/14.
//  Copyright (c) 2014 sanhotrasoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface NUMA_ACTIVITIES : NSManagedObject

@property (nonatomic, retain) NSNumber * activity_end_time;
@property (nonatomic, retain) NSString * activity_end_time_unit;
@property (nonatomic, retain) NSNumber * activity_start_time;
@property (nonatomic, retain) NSString * activity_start_time_unit;
@property (nonatomic, retain) NSString * activity_type;
@property (nonatomic, retain) NSNumber * calories;
@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSNumber * day;
@property (nonatomic, retain) NSNumber * distance;
@property (nonatomic, retain) NSNumber * hour;
@property (nonatomic, retain) NSNumber * minute;
@property (nonatomic, retain) NSNumber * month;
@property (nonatomic, retain) NSNumber * sec;
@property (nonatomic, retain) NSNumber * steps;
@property (nonatomic, retain) NSNumber * sum;
@property (nonatomic, retain) NSNumber * sync_flag;
@property (nonatomic, retain) NSNumber * uid;
@property (nonatomic, retain) NSString * user_id;
@property (nonatomic, retain) NSNumber * year;
@property (nonatomic, retain) NSNumber * week;

@end
