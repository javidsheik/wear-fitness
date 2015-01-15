//
//  File.h
//  SmartNavigationSystem
//
//  Created by mac13 on 14-6-19.
//  Copyright (c) 2014年 APM. All rights reserved.
//


#define kDeclareConstStringValue(name) extern NSString * const name;//
#define kDeclareConstIntValue(name)    extern const NSUInteger name;
#define kDeclareConstCGfloatValue(name) extern const CGFloat name;
#define kDeclareConstUINT16Value(name)  extern const UInt16 name;



#pragma mark -declareMyPeripheralFileKey

kDeclareConstStringValue(ConstPeripheralConfigKey)
#pragma mark -declareNotificationKey
kDeclareConstStringValue(ConstUpdatingDateNotification)

kDeclareConstStringValue(ConstUserHeightKey)
kDeclareConstStringValue(ConstUserWeightKey)
kDeclareConstStringValue(ConstUserSexKey)
kDeclareConstStringValue(ConstUserBirthdayKey)

#pragma mark -declareAnimationTime

kDeclareConstCGfloatValue(ConstAnimationTime)

#pragma mark  - declareBraceletFun

kDeclareConstStringValue(ConstFunCountStep)
kDeclareConstStringValue(ConstFunSleep)
kDeclareConstStringValue(ConstFunAntiLost)
kDeclareConstStringValue(ConstFunTimeClock)
kDeclareConstStringValue(ConstFunPhoneAndSMS)
kDeclareConstStringValue(ConstFunHistorySys)
kDeclareConstStringValue(ConstFunPersonInformation)
kDeclareConstStringValue(ConstFunBlueTooth)
kDeclareConstStringValue(ConstFunEquptInfomation)
kDeclareConstStringValue(ConstFunEquptLog)
kDeclareConstStringValue(ConstFunBatteryVolume)
