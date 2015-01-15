//
//  stepModel.h
//  bracelet
//
//  Created by dehangsui on 14-11-11.
//  Copyright (c) 2014年 com.i.spark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StepModel : NSObject
@property(strong,nonatomic) NSString *stepCount;
@property(strong,nonatomic) NSString *calorie;
@property(strong,nonatomic) NSString *walkDistance;
@property(strong,nonatomic) NSString *MovingDuration;
@property(strong,nonatomic) NSString *goalValue;
@property(strong,nonatomic) NSString *stepType;
@property(assign,nonatomic) BOOL setStepSwitch;
@property(assign,nonatomic) double setStepGoal;
@property(assign,nonatomic) BOOL setStepGoalType;
- (void)peripheralSetWalkStepCount;
- (void)peripheralSetSwitch;
@end
