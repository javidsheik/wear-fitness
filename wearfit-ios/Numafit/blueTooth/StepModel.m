//
//  stepModel.m
//  bracelet
//
//  Created by dehangsui on 14-11-11.
//  Copyright (c) 2014年 com.i.spark. All rights reserved.
//

#import "StepModel.h"
#import "BTLECentralClass.h"
@implementation StepModel
- (void)peripheralSetSwitch
{
    if ([BTLECentralClass sharedBTLECentralClass].centralManager.state != CBCentralManagerStatePoweredOn)
    {
        NSLog(@"centralManager power off!!!!!\n");
        return;
    }
    
    unsigned char oridata[2] = {0};
    oridata[0] = StepID_Switch;

    oridata[1] = self.setStepSwitch;
    unsigned char protoalData[10] = {0};
    unsigned char count = writeProtocolDataBytes(oridata, 2, protoalData);
    char *data = NULL;
    data = (char*)malloc(count+3);
    memset(data, 0x00, count+3);
    data[0] = sparkBLEHeader_Step;
    data[1] = count+1;
    memcpy(&data[2], protoalData, count);
    checkSumByte(data, count+2);
    NSData *chunk = [NSData dataWithBytes:data length:count+3];
    if (data)
    {
        free(data);
        data = NULL;
    }
    
    [[BTLECentralClass sharedBTLECentralClass].discoveredPeripheral writeValue:chunk forCharacteristic:[BTLECentralClass sharedBTLECentralClass].dataReceiveCharacter type:CBCharacteristicWriteWithResponse];
}


- (void)peripheralSetWalkStepCount
{
    if ([BTLECentralClass sharedBTLECentralClass].centralManager.state != CBCentralManagerStatePoweredOn)
    {
        NSLog(@"centralManager power off!!!!!\n");
        return;
    }
    
    unsigned char config[10] = {0};
    config[0] = StepID_Goal;
    config[1] = (char)self.setStepGoalType;

     *((unsigned long*)&config[2]) = 10000;
     *((unsigned long*)&config[6]) =  15000;
   
    unsigned char protoalData[20] = {0};
    unsigned char count = writeProtocolDataBytes(config, 10, protoalData);
    char *data = NULL;
    data = (char*)malloc(count+3);
    memset(data, 0x00, count+3);
    data[0] = StepID_Value;
    data[1] = count+1;
    memcpy(&data[2], protoalData, count);
    checkSumByte(data, count+2);
    NSData *chunk = [NSData dataWithBytes:data length:count+3];
  
    if (data)
    {
        free(data);
        data = NULL;
    }
    
    [[BTLECentralClass sharedBTLECentralClass].discoveredPeripheral writeValue:chunk forCharacteristic:[BTLECentralClass sharedBTLECentralClass].dataReceiveCharacter type:CBCharacteristicWriteWithResponse];
    
    
}
@end
