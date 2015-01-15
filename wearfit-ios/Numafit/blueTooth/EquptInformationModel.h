//
//  EquptInformationModel.h
//  bracelet
//
//  Created by dehangsui on 14-11-11.
//  Copyright (c) 2014年 com.i.spark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EquptInformationModel : NSObject

@property(strong,nonatomic) NSString *firmwareVer;
@property(strong,nonatomic) NSString *hardwareVer;
@property(strong,nonatomic) NSString *manufacturer;
@property(strong,nonatomic) NSString *snNo;

-(void)sendEquptRequestInformation;
    
@end
