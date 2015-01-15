//
//  EquptInformationModel.m
//  bracelet
//
//  Created by dehangsui on 14-11-11.
//  Copyright (c) 2014年 com.i.spark. All rights reserved.
//

#import "EquptInformationModel.h"
#import "BTLECentralClass.h"

@implementation EquptInformationModel
-(void)sendEquptRequestInformation
{
    if ([BTLECentralClass sharedBTLECentralClass].centralManager.state != CBCentralManagerStatePoweredOn)
    {
        NSLog(@"centralManager power off!!!!!\n");
        return;
    }
    
    unsigned char oridata[1] = {0};
     oridata[0] = 0x01;
    unsigned char protoalData[10] = {0};
    unsigned char count = writeProtocolDataBytes(oridata, 1, protoalData);
    char *data = NULL;
    data = (char*)malloc(count+3);
    memset(data, 0x00, count+3);
    data[0] = sparkBLEHeader_DeviceInfo;
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
