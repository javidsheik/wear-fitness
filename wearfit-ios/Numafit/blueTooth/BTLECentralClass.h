typedef void(^PeripheralsBlock)(NSArray *Peripherals);

#import <Foundation/Foundation.h>
#import "common.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface BTLECentralClass : NSObject singleton_interface(BTLECentralClass)
@property(copy,nonatomic)PeripheralsBlock returnPeripherlsArray;
@property (strong,nonatomic)  CBCharacteristic    *dataReceiveCharacter;
@property (strong,nonatomic)  CBCharacteristic    *dataSendCharacter;
@property (strong, nonatomic) CBCentralManager    *centralManager;
@property (strong, nonatomic) CBPeripheral        *discoveredPeripheral;

-(void)initCentralMangager;
-(void)connectPeripheral:(CBPeripheral*)peripheral;
-(void)disconnectPeripheral;
-(void)scan;
-(void)stopCentralManagerScan;
-(void)findmydevice;
- (void)canceldevicefind;
-(void)Alarmwrite:(int)hour Minuts:(int)minute Day:(int)day;

uint8_t writeProtocolDataBytes(uint8_t *s,uint8_t N,uint8_t *d);
uint8_t readProtocolDataBytes(uint8_t L_1,uint8_t *s,uint8_t *d);
void checkSumByte(char *buf,int len);
bool isCheckSumValid(unsigned char *rcvBuff,int rcvLen);
@end
