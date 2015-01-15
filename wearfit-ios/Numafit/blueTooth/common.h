




#pragma mark -singletonClass

#define singleton_interface(className) \
+ (className *)shared##className;

// @implementation
#define singleton_implementation(className) \
static className *_instance; \
+ (id)allocWithZone:(NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
+ (className *)shared##className \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
}



#pragma mark -Common
#define appDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define KUIStoryBoard(name)   [UIStoryboard storyboardWithName:(name) bundle:nil]
#define kMainBundlePath  [[NSBundle mainBundle] bundlePath]
#define KNSstring(number) [NSString stringWithFormat:@"%@",number]
#define KGetRGB(r,g,b)  [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define iphone4H ([UIScreen mainScreen].bounds.size.height != 480)
#define iOS7  ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
#define iOS8  ([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0)

#define  kUIScreenBounds  [UIScreen mainScreen].bounds
#define  kAcessViewHeight  40
#define kDocumentFile(fileName)  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]stringByAppendingPathComponent:fileName]

#define kCachesFile(fileName)[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]stringByAppendingPathComponent:fileName]
#define kMusicFile(fileName) [NSSearchPathForDirectoriesInDomains(NSMusicDirectory, NSUserDomainMask, YES)[0]stringByAppendingPathComponent:fileName]



#define  MAX_PULSE_RATE_TIMEOUT     20      // Heart rate detection timeout
#define  INTERVAL_OF_MEASURE        2       // Heart rate detection interval


typedef enum tagDataHeaderFlag
{
    sparkBLEHeader_HeartRate        =   0x80,       // Heart Rate
    sparkBLEHeader_Step             =   0x81,       // Odograph
    sparkBLEHeader_Time             =   0x84,       // Time
    sparkBLEHeader_DataSync         =   0x90,       // Data Synchronization
    sparkBLEHeader_PersonalSet      =   0xb0,      // Personal information system environment settings app
    sparkBLEHeader_DeviceInfo       =   0xf0,       // Device Information
    sparkBLEHeader_Battery          =   0xf1,       // Battery charge
    sparkBLEHeader_Voice            =   0xe0,       // Baidu voice search
    sparkBLEHeader_TelePhoneWarning =   0x85,       // Calls to remind
    sparkBLEHeader_Log              =   0xf3,       // Journal
    sparkBLEHeader_AntiLost         =   0x83,      // Anti-lost
    sparkBLEHeader_ShortSleep       =   0x82,       // Short sleep
    
}DataHeaderFlag;

typedef enum tagHeartRateID
{
    HeartRateID_Switch  =   0x01,   // Heart rate switch
    HeartRateID_Range   =   0x02,   // Setting heart rate range
    HeartRateID_Value   =   0x81,   // The value of heart rate
}HeartRateID;

typedef enum _tagStepID
{
    StepID_Switch       =   0x01,   // Pedometer switch
    StepID_Goal         =   0x02,   // Step goal in mind
    StepID_Value        =   0x81,   // The value of real-time pedometer
}StepID;

typedef enum _tagTimeID
{
    TimeID_Value        =   0x01,   // Value of time
}TimeID;

typedef enum _tagDataSyncID
{
    DataSyncID_Start        =   0x01,   // app to initiate a sync request
    DataSyncID_Result       =   0x02,   // Historical data synchronization results
    DataSyncID_NoData       =   0x80,   // No historical data
    DataSyncID_DataStart    =   0x81,   // Sync start package
    DataSyncID_DataFlag     =   0x82,   // Isochronous packet id
    DataSyncID_DataEnd      =   0x83,   // End packet synchronization
    
}DataSyncID;

typedef enum _tagPersonalSetID
{
    PersonalSetID_Value        =   0x01,   // Personal Information set
}PersonalSetID;

typedef enum _tagDeviceInfoID
{
    DeviceInfoID_BLEInfo        =   0x81,   // Bluetooth peripheral device information
    DeviceInfoID_Manufacturer   =   0x82,   // Manufacturer information
    DeviceInfoID_SN             =   0x83,   // Serial Number
    
}DeviceInfoID;

typedef enum _tagBatteryID
{
    BatteryID_Switch            =   0x01,   // Battery test cycle switch
    BatteryID_Value             =   0x81,   // Battery power, status
}BatteryID;

typedef enum _tagVoiceSearchID
{
    VoiceSearchID_Start             =   0x81,   // Speech recognition start
    VoiceSearchID_End               =   0x82,   // End Speech Recognition
}VoiceSearchID;