//
//  BraceletModel.h
//  bracelet
//
//  Created by dehangsui on 14-11-10.
//  Copyright (c) 2014年 com.i.spark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "common.h"
#import "StepModel.h"
#import "EquptInformationModel.h"
#import  "BatteryVolumeModel.h"


@interface BraceletModel : NSObject
singleton_interface(BraceletModel)
@property(strong,nonatomic)StepModel *stepModel;
@property(strong,nonatomic)EquptInformationModel *equptInformationModel;
@property(strong,nonatomic)BatteryVolumeModel *batteryVolumeModel;
@property(assign,nonatomic) NSUInteger electricVolume;
@property(assign,nonatomic) double stepNumber;
@property(assign,nonatomic) double calorie;
@property(assign,nonatomic) double walkDistance;

-(void)postUpdateDataNotificationWithObject:(id)object;
@end
