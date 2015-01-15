//
//  BraceletModel.m
//  bracelet
//
//  Created by dehangsui on 14-11-10.
//  Copyright (c) 2014年 com.i.spark. All rights reserved.
//

#import "BraceletModel.h"
#import "common.h"
#import "constVar.h"
@implementation BraceletModel
singleton_implementation(BraceletModel)
- (instancetype)init
{
    self = [super init];
    if (self) {
       
        self.equptInformationModel = [[EquptInformationModel alloc] init];
         self.batteryVolumeModel = [[BatteryVolumeModel alloc] init];
        self.stepModel =[[StepModel alloc] init];
       
    }
    return self;
}

-(void)setStepModel:(StepModel *)stepModel
{
    _stepModel = stepModel;
    [self postUpdateDataNotificationWithObject:_stepModel];
}
-(void)setBatteryVolumeModel:(BatteryVolumeModel *)batteryVolumeModel
{
    _batteryVolumeModel = batteryVolumeModel;
      [self postUpdateDataNotificationWithObject:_batteryVolumeModel];
}
-(void)setEquptInformationModel:(EquptInformationModel *)equptInformationModel
{
    _equptInformationModel = equptInformationModel;
    [self postUpdateDataNotificationWithObject:_equptInformationModel];
}
-(void)postUpdateDataNotificationWithObject:(id)object
{
[[NSNotificationCenter defaultCenter] postNotificationName:ConstUpdatingDateNotification object:object];
}


@end
