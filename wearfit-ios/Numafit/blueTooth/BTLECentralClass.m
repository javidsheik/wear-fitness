

#import "BTLECentralClass.h"
#include "common.h"
#import "TransferService.h"
#import "BraceletModel.h"


@interface BTLECentralClass ()<CBCentralManagerDelegate, CBPeripheralDelegate>
{
    BOOL _isAutoDisconnected;
}

@property (strong,nonatomic)  NSMutableArray  *peripheralsMArray;
@property (strong,nonatomic)  NSMutableArray  *discoverServicesMArray;
@property (strong,nonatomic)  CBUUID* dataReceiveUUID;
@property (strong,nonatomic)  CBUUID* dataSendUUID;
@property (strong,nonatomic)  NSMutableArray *saveConnectedMArray;

@end

@implementation BTLECentralClass singleton_implementation(BTLECentralClass)

-(void)initCentralMangager
{
    _peripheralsMArray =[NSMutableArray array];
    _discoverServicesMArray =[NSMutableArray array];
    dispatch_queue_t queue = dispatch_queue_create("scan queue", NULL);
    _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:queue];
    _saveConnectedMArray =[NSMutableArray array];
}

#pragma mark - Central Methods
/** centralManagerDidUpdateState is a required protocol method.
 *  Usually, you'd check for other states to make sure the current device supports LE, is powered on, etc.
 *  In this instance, we're just using it to wait for CBCentralManagerStatePoweredOn, which indicates
 *  the Central is ready to be used.
 */
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central.state == CBCentralManagerStatePoweredOn)
    {
         [self scan];
         NSLog(@"Device Scanning..... ");
    }
    else
    {
        NSLog(@"Device pOwerd off");
    }
    // We're in CBPeripheralManagerStatePoweredOn state...
}
/** Scan for peripherals - specifically for our service's 128bit CBUUID
 */
- (void)scan
{
    [_centralManager stopScan];
     NSArray	*uuidArray	= [NSArray arrayWithObjects:[CBUUID UUIDWithString:SPARK_BLE_DATA_COMMUNICATE_SERVIC_UUID], nil];
     NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], CBCentralManagerScanOptionAllowDuplicatesKey, nil];
    [self.centralManager scanForPeripheralsWithServices:uuidArray  options:options];
}
-(void)getConnectedPeripheral:(NSString *)uuidStr
{
    CBUUID * uuid =[CBUUID UUIDWithString:uuidStr];
    NSArray * array =[NSArray array];
      if(uuid)
      {
          array =  [_centralManager retrievePeripheralsWithIdentifiers:@[uuid]];
          if(array > 0)
          {
             
          }
          else
          {
           array =  [_centralManager retrieveConnectedPeripheralsWithServices:@[uuid]];
          }
          
          [_peripheralsMArray addObjectsFromArray:array];
           if(_returnPeripherlsArray)
            _returnPeripherlsArray(_peripheralsMArray);
       //[self performSelector:@selector(stopCentralManagerScan) withObject:nil afterDelay:5];
      }
}
/** This callback comes whenever a peripheral that is advertising the TRANSFER_SERVICE_UUID is discovered.
 *  We check the RSSI, to make sure it's close enough that we're interested in it, and if it is,
 *  we start the connection process
 */
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    // Reject if the signal strength is too low to be close enough (Close is around -22dB)
    if (RSSI.integerValue < -35) {
        return;
    }
    NSString * uuid = peripheral.identifier.UUIDString;
    if(![_saveConnectedMArray containsObject:uuid])
    {
        [_saveConnectedMArray addObject:uuid];
        [self getConnectedPeripheral:uuid];
      
        NSLog(@"Discovered uuid>>>>>>>> is %@ ", uuid);
    }
    NSLog(@"Discovered %@ at %@", peripheral.name, RSSI);
    // Ok, it's in range - have we already seen it?
}

-(void)stopCentralManagerScan
{
    [self.centralManager stopScan];
}
#pragma mark - Central Methods
/** We've connected to the peripheral, now we need to discover the services and characteristics to find the 'transfer' characteristic.
 */

/** If the connection fails for whatever reason, we need to deal with it.
 */
-(void)connectPeripheral:(CBPeripheral*)peripheral
{
    NSLog(@"device connect call..");
    [self.centralManager connectPeripheral:peripheral options:nil];
    self.discoveredPeripheral = nil;
}
-(void)disconnectPeripheral
{
   if(self.discoveredPeripheral)
    [self.centralManager cancelPeripheralConnection:self.discoveredPeripheral];
    _isAutoDisconnected = YES;
}
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Failed to connect to %@. (%@)", peripheral, [error localizedDescription]);
    [self cleanup];
}
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"Peripheral Connected");
        // Stop scanning
    [self.centralManager stopScan];
    NSLog(@"Scanning stopped");
    // Clear the data that we may already have
    self.discoveredPeripheral = peripheral;
    // Make sure we get the discovery callbacks
    peripheral.delegate = self;
    self.dataReceiveUUID= [CBUUID UUIDWithString:SPARK_BLE_DATA_RECEIVE_CHARACTER_UUID];
     self.dataSendUUID	= [CBUUID UUIDWithString:SPARK_BLE_DATA_SEND_CHARACTER_UUID];
    
	NSArray	*serviceArray	= @[[CBUUID UUIDWithString:SPARK_BLE_DATA_COMMUNICATE_SERVIC_UUID]];
    // Search only for services that match our UUID//[CBUUID UUIDWithString:SPARK_BLE_DATA_SEND_CHARACTER_UUID]
    [peripheral discoverServices:serviceArray];
    [[NSUserDefaults standardUserDefaults]setObject:@"connected" forKey:@"device_status"];
    
}

/** The Transfer Service was discovered
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error) {
        NSLog(@"Error discovering services: %@", [error localizedDescription]);
        [self cleanup];
        return;
    }
    
    // Discover the characteristic we want...
    NSLog(@"find the didDiscoverServices the peripheral is %@",peripheral);
    // Loop through the newly filled peripheral.services array, just in case there's more than one.

    
    for (CBService *service in peripheral.services)
    {
        [peripheral discoverCharacteristics:@[self.dataReceiveUUID,self.dataSendUUID] forService:service];
    }
}

/** The Transfer characteristic was discovered.
 *  Once this has been found, we want to subscribe to it, which lets the peripheral know we want the data it contains
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    // Deal with errors (if any)
    if (error) {
        NSLog(@"Error discovering characteristics: %@", [error localizedDescription]);
        [self cleanup];
        return;
    }
     NSLog(@"find the didDiscoverCharacteristicsForService %@",service.characteristics);
    // Again, we loop through the array, just in case.
    for (CBCharacteristic *characteristic in service.characteristics)
    {
          CBUUID *uuid  = [characteristic UUID];
        if ([[uuid UUIDString]isEqual:[_dataReceiveUUID UUIDString]])
        {
           // NSLog(@"data Recive charastics match");
            self.dataReceiveCharacter = characteristic;
            [peripheral readValueForCharacteristic:characteristic];
        }
        else if([[uuid UUIDString] isEqual:[_dataSendUUID UUIDString]])
        {
             [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            self.dataSendCharacter = characteristic;
            [self peripheralSendSystemTime];
            [self AntilostDistance:0x01];//anti clse alaram set on;
            [self AntilostDistance:0x02];//vibrate when device goes out on rang

        }
    }
    // Once this is complete, we just need to wait for the data to come in.
}


// Send the system time
- (void)peripheralSendSystemTime
{
    if (self.centralManager.state != CBCentralManagerStatePoweredOn)
    {
        NSLog(@"centralManager power off!!!!!\n");
        return;
    }
    /*
     NSCalendarUnitEra                = kCFCalendarUnitEra,
     NSCalendarUnitYear               = kCFCalendarUnitYear,
     NSCalendarUnitMonth              = kCFCalendarUnitMonth,
     NSCalendarUnitDay                = kCFCalendarUnitDay,
     NSCalendarUnitHour               = kCFCalendarUnitHour,
     NSCalendarUnitMinute             = kCFCalendarUnitMinute,
     NSCalendarUnitSecond             = kCFCalendarUnitSecond,
     */
    NSDateComponents *componets = [[NSCalendar autoupdatingCurrentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:[NSDate date]];
    
    unsigned char oridata[8] = {0};
    oridata[0] = TimeID_Value;
    *((unsigned short*)&oridata[1]) = [componets year];
    oridata[3] = [componets month];
    oridata[4] = [componets day];
    oridata[5] = [componets hour];
    oridata[6] = [componets minute];
    oridata[7] = [componets second];
    unsigned char protoalData[20] = {0};
    unsigned char count = writeProtocolDataBytes(oridata, 8, protoalData);
    char *data = NULL;
    data = (char*)malloc(count+3);
    memset(data, 0x00, count+3);
    data[0] = sparkBLEHeader_Time;
    data[1] = count+1;
    memcpy(&data[2], protoalData, count);
    checkSumByte(data, count+2);
    NSData *chunk = [NSData dataWithBytes:data length:count+3];
    if (data)
    {
        free(data);
        data = NULL;
    }
    
  //wirte data to device
    
  [self.discoveredPeripheral writeValue:chunk forCharacteristic:self.dataReceiveCharacter type:CBCharacteristicWriteWithResponse];
}
/** This callback lets us know more data has arrived via notification on the characteristic
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"Error discovering characteristics: %@", [error localizedDescription]);
        return;
    }
    [self receiveCharacteristicFrom:characteristic];
}


//Central receives a write request feature, read and displayed
- (void)receiveCharacteristicFrom:(CBCharacteristic *)characteristic
{
    
    unsigned char gReceiveBuffer[128] = {0};
    unsigned short gReceivedLength = 0;
        // 4f 4b == Ok
        char tmpBuffer[64] = {0};
        unsigned char bufferHead = 0;
        int iTmpLen = 0;
        [characteristic.value getBytes:tmpBuffer];
        iTmpLen =[characteristic.value length];
        NSString *showMsg = @"Receive data";
        
        bufferHead = tmpBuffer[0];
        if ((bufferHead & 0x80) && gReceivedLength == 0)
        {
            // If you receive a larger than 0x80 is a new piece of data
            memset(gReceiveBuffer, 0x00, sizeof(gReceiveBuffer));
            memcpy(gReceiveBuffer, tmpBuffer, iTmpLen);
            gReceivedLength = iTmpLen;
        }
        else
        {
            if (gReceiveBuffer[0] & 0x80)
            {
                // Only the head of the data was to be received, or else abandon all
                if (gReceivedLength+iTmpLen <= 128)
                {
                    // Received the residual data is added to the master data re-entry parsing
                    memcpy(gReceiveBuffer+gReceivedLength, tmpBuffer, iTmpLen);
                    gReceivedLength += iTmpLen;
                }
                else
                {
                    gReceivedLength = 0;
                    memset(gReceiveBuffer, 0x00, sizeof(gReceiveBuffer));
                }
            }
            else
            {
                gReceivedLength = 0;
                 memset(gReceiveBuffer, 0x00, sizeof(gReceiveBuffer));
            }
        }
    
        BOOL isFullData = NO;
        if (gReceiveBuffer[1]+2 <= gReceivedLength && isCheckSumValid(gReceiveBuffer, gReceiveBuffer[1]+2))
        {
            isFullData = YES;
        }
        
        // After receipt of the complete data into the analytical
         NSString * receiveCharUUID = characteristic.UUID.UUIDString;
         NSString * equiptRecvUUID = self.dataSendCharacter.UUID.UUIDString;
    
        if ([receiveCharUUID isEqual:equiptRecvUUID])
        {
            showMsg = @"Receive data";
            int iFullDataLength = gReceiveBuffer[1]+2;
            while (isFullData && isCheckSumValid(gReceiveBuffer, iFullDataLength))
            {
                char receiveData[20] = {0};
                unsigned char dataHeader = gReceiveBuffer[0];
                unsigned char valueLen = gReceiveBuffer[1];
                int iReceiveDataLen = 0;
                iReceiveDataLen = readProtocolDataBytes(valueLen-1, (unsigned char*)(gReceiveBuffer+2), (unsigned char*)receiveData);
                unsigned char valueID = receiveData[0];
                
                switch (dataHeader)
                {
                case sparkBLEHeader_Step:
                    {
//here we are getting actual data like steps calories..
                        
                        if (valueID == StepID_Value)
                        {
                            NSUInteger byteCount = 2;
                            NSUInteger startCount = 1;
                            StepModel * stepModel =[BraceletModel sharedBraceletModel].stepModel;
                            
                            unsigned char TempValue[2] = {0};
                            NSNumber *numStepValue  = [self getNumberWithDes:TempValue srcValue:&receiveData[startCount] count:byteCount];
                             startCount += byteCount;
                          
                            NSNumber *numCaloriValue  = [self getNumberWithDes:TempValue srcValue:&receiveData[startCount] count:byteCount];
                            startCount += byteCount;
                            
                            
                           NSNumber *numDistanceValue  = [self getNumberWithDes:TempValue srcValue:&receiveData[startCount] count:byteCount];
                            startCount += byteCount;
                            
                            NSNumber *numWalkDuration  = [self getNumberWithDes:TempValue srcValue:&receiveData[startCount] count:byteCount];
                           
                            stepModel.stepCount =KNSstring(numStepValue) ;
                            stepModel.calorie =KNSstring(numCaloriValue) ;
                            stepModel.walkDistance =KNSstring(numDistanceValue);
                            stepModel.MovingDuration =KNSstring(numWalkDuration);
                            
                            [BraceletModel sharedBraceletModel].stepModel = stepModel;
                            NSLog(@ "Received a record-step information, the number of steps:%@, Calories:%@, distance:%@", numStepValue, numCaloriValue, numDistanceValue);
                        }
                        
                    }
 //end this block
                    break;
                    
                    case sparkBLEHeader_DeviceInfo:
                    {
//here we are getting  Device Information
                        
                        EquptInformationModel * equptInfoModel = [BraceletModel sharedBraceletModel].equptInformationModel;
                        
                        if (valueID == DeviceInfoID_BLEInfo)
                        {
                            NSString *firmwareVer = nil;
                            NSString *hardwareVer = nil;
                            NSString *receiveString = [NSString stringWithFormat:@"%s", &receiveData[1]];
                            firmwareVer = [receiveString substringToIndex:3];
                            hardwareVer = [receiveString substringFromIndex:3];
                            NSLog(@ "Firmware version -%@, hardware version -%@.", firmwareVer, hardwareVer);
                            equptInfoModel.firmwareVer = firmwareVer;
                            equptInfoModel.hardwareVer = hardwareVer;
                            
                        }
                        else if (valueID == DeviceInfoID_Manufacturer)
                        {
                            NSString *manufacturer = [NSString stringWithFormat:@"%s", &receiveData[1]];
                            NSLog(@"Production capacity at home -%@ ", manufacturer);
                            equptInfoModel.manufacturer = manufacturer;
                        }
                        else if (valueID == DeviceInfoID_SN)
                        {
                            NSString *snNo = [NSString stringWithFormat:@"%s", &receiveData[1]];
                            NSLog(@ "Serial number -%@", snNo);
                            equptInfoModel.snNo = snNo;
                        }
                        
                        [BraceletModel sharedBraceletModel].equptInformationModel = equptInfoModel;
                    }
                        break;
//end this block
                    case sparkBLEHeader_Battery:
                    {
// Device battery related information charging status
                        
                        if (valueID == BatteryID_Value)
                        {
                            unsigned char ucBatteryStatus = receiveData[1];
                            unsigned char ucBatteryValue = receiveData[2];
                            NSNumber *numBatteryStatus = [NSNumber numberWithInt:ucBatteryStatus];
                            NSNumber *numBatteryValue = [NSNumber numberWithInt:ucBatteryValue];
                            BatteryVolumeModel * batteryModel =[[BatteryVolumeModel alloc] init];
                            batteryModel.batteryVolume = KNSstring(numBatteryValue);
                            
                            batteryModel.batteryState =[self getBatteryState:numBatteryStatus];
                            [BraceletModel sharedBraceletModel].batteryVolumeModel =batteryModel;
                            NSLog(@ "Battery:% d, state:%d.", ucBatteryValue, ucBatteryStatus);
                        }
                    }
                        break;
                        
                        
                    default:
                        break;
                }
//end this block
                
// View the follow-up data if there is a complete or partial data?
                if (iFullDataLength < gReceivedLength)
                {
                    unsigned char headFlag = gReceiveBuffer[iFullDataLength];
                    // Trying to find a protocol header, is greater than or equal 0x80 head
                    while (headFlag < 0x80 && iFullDataLength < gReceivedLength)
                    {
                        iFullDataLength++;
                        headFlag = gReceiveBuffer[iFullDataLength];
                    }
                    //Found at the end did not find the head is discarded junk data
                    if (iFullDataLength >= gReceivedLength)
                    {
                        isFullData = NO;
                        memset(gReceiveBuffer, 0x00, sizeof(gReceiveBuffer));
                        gReceivedLength = 0;
                    }
                    else
                    {
                        //Find the header, then rejoin
                        unsigned char usTempBuf[20] = {0};
                        int iTempBufLen = gReceivedLength-iFullDataLength;
                        memcpy(usTempBuf, gReceiveBuffer+iFullDataLength, iTempBufLen);
                        memset(gReceiveBuffer, 0x00, sizeof(gReceiveBuffer));
                        memcpy(gReceiveBuffer, usTempBuf, iTempBufLen);
                        iFullDataLength = gReceiveBuffer[1]+2;
                        gReceivedLength = iTempBufLen;
                        if (iFullDataLength <= gReceivedLength)
                        {
                            isFullData = YES;
                        }
                        else
                        {
                            isFullData = NO;
                        }
                    }
                }
                else
                {
                    isFullData = NO;
                    memset(gReceiveBuffer, 0x00, sizeof(gReceiveBuffer));
                    gReceivedLength = 0;
                }
            }
// Cleanup invalid data
            if (gReceiveBuffer[0] >= 0x80 && gReceivedLength >= gReceiveBuffer[1]+2)
            {
                // There are a bunch of already stored data integrity agreement, if the check is all but abandoned
                if (!isCheckSumValid(gReceiveBuffer, gReceiveBuffer[1]+2))
                {
                    memset(gReceiveBuffer, 0x00, sizeof(gReceiveBuffer));
                    gReceivedLength = 0;
                }
            }
        }
}

/** The peripheral letting us know whether our subscribe/unsubscribe happened or not
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"Error changing notification state: %@", error.localizedDescription);
    }
    
// Exit if it's not the transfer characteristic
    if (![characteristic.UUID isEqual:self.dataSendCharacter]||![characteristic.UUID isEqual:self.dataReceiveCharacter]) {
        return;
    }
    
// Notification has started
    if (characteristic.isNotifying) {
        NSLog(@"Notification began on %@", characteristic);
    }
else {
        // so disconnect from the peripheral
        NSLog(@"Notification stopped on %@.  Disconnecting", characteristic);
        [self.centralManager cancelPeripheralConnection:peripheral];
    }
}

//value write Status Information like is value is written in devce or not.

- (void) peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    /* When a write occurs, need to set off a re-read of the local CBCharacteristic to update its value */
    if(error)
    {
        NSLog(@"write value is %@",error);
    }
    else
    {
     NSLog(@"didWriteValueForCharacteristic value is successful ");
    }
    
    [peripheral readValueForCharacteristic:characteristic];
    /* Upper or lower bounds changed */
    if ([characteristic.UUID isEqual:self.dataReceiveCharacter] || [characteristic.UUID isEqual:self.dataSendCharacter]) {
     
    }
}
/** Once the disconnection happens, we need to clean up our local copy of the peripheral
 */
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
   // NSLog(@"Peripheral Disconnected");
    [self.discoverServicesMArray removeObject:peripheral];
    self.discoveredPeripheral = nil;
    
    if(!_isAutoDisconnected)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"disconnected" object:peripheral];
        //[self scan];
    }
    else
    {
        _isAutoDisconnected = NO;
    }
    [[NSUserDefaults standardUserDefaults]setObject:@"disconnected" forKey:@"device_status"];
    // We're disconnected, so start scanning again
}
- (void)centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals
{
   
    for (CBPeripheral *peripheral in peripherals)
    {
       
         NSLog(@"connected device %@",peripheral.name);
         NSLog(@"connected RSSI %@",peripheral.RSSI);
         NSLog(@"connected Identifier %@",peripheral.identifier);
    }
}
/** Call this when things either go wrong, or you're done with the connection.
 *  This cancels any subscriptions if there are any, or straight disconnects if not.
 *  (didUpdateNotificationStateForCharacteristic will cancel the connection if a subscription is involved)
 */
- (void)cleanup
{
    // Don't do anything if we're not connected
    if (!self.discoveredPeripheral.isConnected) {
        return;
    }
    
    // See if we are subscribed to a characteristic on the peripheral
    if (self.discoveredPeripheral.services != nil) {
        for (CBService *service in self.discoveredPeripheral.services) {
            if (service.characteristics != nil) {
                for (CBCharacteristic *characteristic in service.characteristics) {
                    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:SPARK_BLE_DATA_RECEIVE_CHARACTER_UUID]]||
                        [characteristic.UUID isEqual:[CBUUID UUIDWithString:SPARK_BLE_DATA_SEND_CHARACTER_UUID]]) {
                        if (characteristic.isNotifying) {
                            // It is notifying, so unsubscribe
                        [self.discoveredPeripheral setNotifyValue:NO forCharacteristic:characteristic];
                            
                            // And we're done.
                            return;
                        }
                    }
                }
            }
        }
    }
    
    // If we've got this far, we're connected, but we're not subscribed, so we just disconnect
    [self.centralManager cancelPeripheralConnection:self.discoveredPeripheral];
}

#pragma mark - 数据处理
//s: Bytes of data to be transmitted storage location
//N：The number of data bytes sent
//d: After the shift processing, data storage location
//count: After the shift processing, the new length of the data
//After the data shift processing, before sending an array of add header H, L is set to count + 1, add a check at the end, you can directly issue
uint8_t writeProtocolDataBytes(uint8_t *s,uint8_t N,uint8_t *d)
{
	uint8_t n = 0;
	uint8_t i,j,leastBit = 0;
	uint8_t bit7 = 0;
	uint8_t count = (N*8+7-1)/7;
	for(i = 0;i < count ;i++)
	{
		d[i] = 0;
	}
    
	for(i = 0;i < N; i++)
	{
		for(j = 0;j < 8; j++)
		{
			leastBit = (s[i]>>j)&0x01;
            d[n] |= leastBit <<(bit7 ++);
			if(7 == bit7)
			{
				bit7 = 0;
				n ++;
			}
		}
	}
	return count;
}

//L_1:  Extracted frame length L -1: That subsequent byte parity bit length after length removed
//src：  The original position of the frame data bytes received before the processing, i.e. addresses D0
//dst:  Byte frame processing storage location, save the data after the shift processing
//count: The actual number of bytes returned after treatment
//The receiver will shift data handler L_1 length, restore the original data, and returns
uint8_t readProtocolDataBytes(uint8_t L_1,uint8_t *s,uint8_t *d)
{
	uint8_t n = 0;
	uint8_t bit8 = 0;
	uint8_t i,j;
	uint8_t leastBit = 0;
	uint8_t count = L_1*7/8;
	
	for(i = 0;i< L_1;i++)
		d[i] = 0;
	
	for(i = 0;i < L_1;i++)
	{
		for(j = 0;j < 7;j++)
		{
			leastBit= (s[i] >> j)&0x01;
			d[n] |= leastBit<< (bit8 ++);
		    if(8 == bit8)
			{
				bit8 = 0;
				n++;
			}
		}
	}
	return count;
}

//buf: Address data to be verified, including H + L + D data fields
//len: Data length to be verified, including the length H + L + D, i.e. len (D) +2, noted that the length D of the length of the shift should be here after
//Verify the sender filled function
void checkSumByte(char *buf,int len)
{
	char checksum;
	int i;
	checksum = 0;
	for(i = 0;i<len;i++)
		checksum = (char)(checksum + buf[i]);
	checksum = (char)(((~checksum)+1)&0x7F);
	buf[len] = checksum;
}

// rcvBuff: Storing the received address entire frame
// rcvLen: The entire length of the received frame, including the header and the checksum of length
//Receiving side validation function
bool isCheckSumValid(unsigned char *rcvBuff,int rcvLen)
{
	char checksum;
	int i = 0;
	checksum = rcvBuff[0];
	for(i = 1;i < rcvLen;i++)
	{
		if((unsigned char)(rcvBuff[i]) >= 0x80)
			return false;
		checksum = (char)(checksum + rcvBuff[i]);
	}
	checksum  &= 0x7F;
	if(0 == checksum)
		return true;
	return false;
}

-(NSNumber *)getNumberWithDes:( unsigned char *)des srcValue:(char *)src count:(NSUInteger)count
{
    memcpy(des, src, count);
  
    unsigned short usDes = (*(unsigned short*)des);
    NSNumber *numDes = [NSNumber numberWithInt:usDes];
    
    return numDes;
}

-(NSString *)getWalkSportType:(NSNumber *)typeNumber
{
    NSArray *valueArray =@[@ "Rest", @ "walk", @ "running", @ "not set"];
    NSUInteger type =[typeNumber integerValue];
    if(type < 3)
    {
        return valueArray[type];
    }
    else
    {
    return valueArray[3];
    }
}
-(NSString *)getBatteryState:(NSNumber *)number
{
NSArray *valueArray =@[@ "Not Charging", @ "charging", @ "full"];
    NSUInteger state =[number integerValue];
    if(state < 3)
    {
        return valueArray[state];
    }
    return @"Unknown";
}


//find my device devie will Vibrate when this function execute
- (void)findmydevice
{
    if (self.centralManager.state != CBCentralManagerStatePoweredOn)
    {
        NSLog(@"centralManager power off!!!!!\n");
        return;
    }
    
    unsigned char oridata[2] = {0};
    oridata[0] = TimeID_Value;
    oridata[0] = TimeID_Value;//0x00 to stop device find;
    
    *((unsigned short*)&oridata[1]) =1;
    unsigned char protoalData[20] = {0};
    unsigned char count = writeProtocolDataBytes(oridata,2, protoalData);
    char *data = NULL;
    data = (char*)malloc(count+3);
    memset(data, 0x00, count+3);
    data[0] = sparkBLEHeader_AntiLost;
    data[1] = count+1;
    memcpy(&data[2], protoalData, count);
    checkSumByte(data, count+2);
    NSData *chunk = [NSData dataWithBytes:data length:count+3];
    if (data)
    {
        free(data);
        data = NULL;
    }
    
    [self.discoveredPeripheral writeValue:chunk forCharacteristic:self.dataReceiveCharacter type:CBCharacteristicWriteWithResponse];
}

//stop device vibration which is activated by find my device
- (void)canceldevicefind
{
    NSLog(@"cancel find called BTLE");
    if (self.centralManager.state != CBCentralManagerStatePoweredOn)
    {
        NSLog(@"centralManager power off!!!!!\n");
        return;
    }
    
    unsigned char oridata[2] = {0};
    oridata[0] = 0x01;
    oridata[1] = 0x00;
    unsigned char protoalData[20] = {0};
    unsigned char count = writeProtocolDataBytes(oridata, 2, protoalData);
    char *data = NULL;
    data = (char*)malloc(count+3);
    memset(data, 0x00, count+3);
    data[0] = 0x83;
    data[1] = count+1;
    memcpy(&data[2], protoalData, count);
    checkSumByte(data, count+2);
    NSData *chunk = [NSData dataWithBytes:data length:count+3];
    if (data)
    {
        free(data);
        data = NULL;
    }
    
    [self.discoveredPeripheral writeValue:chunk forCharacteristic:self.dataReceiveCharacter type:CBCharacteristicWriteWithResponse];
    NSLog(@"writing");
    
}

//alram Writng code start here

- (void)Alarmwrite:(int)hour Minuts:(int)minute Day:(int)day
{
    if (self.centralManager.state != CBCentralManagerStatePoweredOn)
    {
        NSLog(@"centralManager power off!!!!!\n");
        return;
    }
   
    NSLog(@" value of hour %ld",(long)hour);
    NSLog(@" value of minute %ld",(long)minute);
    
    unsigned char oridata[5] = {0};
    oridata [0] = 0x02;
    oridata [1] = 0x02;
    oridata [2] = day;     //day value 0x02 monday
    oridata [3] = hour;
    oridata [4] = minute;
    unsigned char protoalData[20] = {0};
    unsigned char count = writeProtocolDataBytes(oridata, 5, protoalData);
    char *data = NULL;
    data = (char*)malloc(count+3);
    memset(data, 0x00, count+3);
    data[0] = sparkBLEHeader_Time;
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
    NSLog(@"writing Aalram Doene");
}

//distance anitlost Alaram setting here

- (void)AntilostDistance:(int)value
{
    if (self.centralManager.state != CBCentralManagerStatePoweredOn)
    {
        NSLog(@"centralManager power off!!!!!\n");
        return;
    }
    
    unsigned char oridata[2] = {0};
    oridata[0] = 0x02;
    oridata[1] = value;
    unsigned char protoalData[20] = {0};
    unsigned char count = writeProtocolDataBytes(oridata, 2, protoalData);
    char *data = NULL;
    data = (char*)malloc(count+3);
    memset(data, 0x00, count+3);
    data[0] = 0x83;
    data[1] = count+1;
    memcpy(&data[2], protoalData, count);
    checkSumByte(data, count+2);
    NSData *chunk = [NSData dataWithBytes:data length:count+3];
    if (data)
    {
        free(data);
        data = NULL;
    }
    
    [self.discoveredPeripheral writeValue:chunk forCharacteristic:self.dataReceiveCharacter type:CBCharacteristicWriteWithResponse];
}
@end
