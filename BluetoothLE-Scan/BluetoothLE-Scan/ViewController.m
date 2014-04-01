//
//  ViewController.m
//  BluetoothLE-Connect
//
//  Created by danny on 2014/04/1.
//  Copyright (c) 2014年 danny. All rights reserved.
//

#import "ViewController.h"


@interface ViewController () {
    CBPeripheral *connectPeripheral;
}
@end


@implementation ViewController

@synthesize CM;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    CM= [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)centralManagerDidUpdateState:(CBCentralManager*)cManager
{
    NSMutableString* nsmstring=[NSMutableString stringWithString:@"UpdateState:"];
    BOOL isWork=FALSE;
    switch (cManager.state) {
        case CBCentralManagerStateUnknown:
            [nsmstring appendString:@"Unknown\n"];
            break;
        case CBCentralManagerStateUnsupported:
            [nsmstring appendString:@"Unsupported\n"];
            break;
        case CBCentralManagerStateUnauthorized:
            [nsmstring appendString:@"Unauthorized\n"];
            break;
        case CBCentralManagerStateResetting:
            [nsmstring appendString:@"Resetting\n"];
            break;
        case CBCentralManagerStatePoweredOff:
            [nsmstring appendString:@"PoweredOff\n"];
            break;
        case CBCentralManagerStatePoweredOn:
            [nsmstring appendString:@"PoweredOn\n"];
            isWork=TRUE;
            break;
        default:
            [nsmstring appendString:@"none\n"];
            break;
    }
    NSLog(@"%@",nsmstring);
}



- (IBAction)buttonScanAndConnect:(id)sender {
    [CM stopScan];
    [CM scanForPeripheralsWithServices:nil options:nil];
    NSLog(@"Scan And Connect");
    
}

- (IBAction)buttonStop:(id)sender {
    
    [CM stopScan];
    NSLog(@"stopScan");
    
    if (connectPeripheral == NULL){
        NSLog(@"connectPeripheral == NULL");
        return;
    }
    
    if (connectPeripheral.state == CBPeripheralStateConnected) {
        [CM cancelPeripheralConnection:connectPeripheral];
        NSLog(@"disconnect-1");

    }
/*
    if ([connectPeripheral isConnected]) {
        [CM cancelPeripheralConnection:connectPeripheral];
        NSLog(@"disconnect-1");
    }
*/
}



- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {

    NSLog(@"peripheral\n%@\n",peripheral);
    NSLog(@"advertisementData\n%@\n",advertisementData);
    NSLog(@"RSSI\n%@\n",RSSI);
    
    NSString *localName = [advertisementData objectForKey:CBAdvertisementDataLocalNameKey];
    
    NSLog(@"localName:%@",localName);
    //if ([peripheral.name length] && [peripheral.name rangeOfString:@"DannySimpleBLE"].location != NSNotFound) {
    if ([localName length] && [localName rangeOfString:@"DannySimpleBLE"].location != NSNotFound) {
        //抓到週邊後就立即停子Scan
        [CM stopScan];
        NSLog(@"stopScan");
        connectPeripheral = peripheral;
        [CM connectPeripheral:peripheral options:nil];
        NSLog(@"connect to %@",peripheral.name);
    }
    
}

-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    
    NSLog(@"%@",@"connected");
}

-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"%@",@"disconnect-2");
}

@end
