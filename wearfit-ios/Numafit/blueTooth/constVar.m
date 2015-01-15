//
//  File.cpp
//  SmartNavigationSystem
//
//  Created by mac13 on 14-6-19.
//  Copyright (c) 2014年 APM. All rights reserved.
//
#define kSetConstStringValue(name,value) NSString * const name = @#value;
#define kSetConstIntValue(name,value)    const  NSUInteger name = value;
#define kSetConstCGfloatValue(name,value) const CGFloat   name = value;
#define ksetConstUINT16Value(name,value)   const UInt16   name = value;



kSetConstStringValue(ConstPeripheralConfigKey,ConstPeripheralConfigKey)
#pragma mark -declareNotificationKey

kSetConstStringValue(ConstUpdatingDateNotification,UpdatingDateNotification)

kSetConstStringValue(ConstUserHeightKey,ConstUserHeightKey)
kSetConstStringValue(ConstUserWeightKey,ConstUserWeightKey)
kSetConstStringValue(ConstUserSexKey,ConstUserSexKey)
kSetConstStringValue(ConstUserBirthdayKey,ConstUserBirthdayKey)

kSetConstCGfloatValue(ConstAnimationTime,0.25)


kSetConstStringValue(ConstFunCountStep,Pedometer)
kSetConstStringValue(ConstFunSleep,Short sleep)
kSetConstStringValue(ConstFunAntiLost,Anti-lost)
kSetConstStringValue(ConstFunTimeClock,Time Alarm)
kSetConstStringValue(ConstFunPhoneAndSMS,Call or SMS alerts)
kSetConstStringValue(ConstFunHistorySys,Synchronization history)
kSetConstStringValue(ConstFunPersonInformation,Personal information)
kSetConstStringValue(ConstFunBlueTooth,Bluetooth settings)
kSetConstStringValue(ConstFunEquptInfomation,Device Information)
kSetConstStringValue(ConstFunBatteryVolume,Battery charge)
kSetConstStringValue(ConstFunEquptLog,Equipment Log)