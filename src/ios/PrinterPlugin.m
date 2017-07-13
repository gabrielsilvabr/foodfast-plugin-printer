
#import "PrinterPlugin.h"
#import "PrinterSDK.h"
#import <Cordova/CDVAvailability.h>

@interface PrinterPlugin ()
@property (nonatomic) NSUInteger printersFound;
@property (nonatomic) Boolean printerConnected;
@property (nonatomic) Printer* printer;

//    - (void) sendError:(int)errorStatus textForShow:(NSString*)text command:(CDVInvokedUrlCommand*)command;
    - (void) sendError:(NSString*)text command:(CDVInvokedUrlCommand*)command;
@end

@implementation PrinterPlugin

@synthesize printersFound;
@synthesize printerConnected;
@synthesize printer;

- (void) pluginInitialize {
    printerConnected = false;
}

- (void) initBluetooth:(CDVInvokedUrlCommand *)command {
    NSLog(@"INIT - CALLED");
    
    [PrinterSDK defaultPrinterSDK];
    [[PrinterSDK defaultPrinterSDK] disconnect];
    
    
}

- (void) startScanningPrinters:(CDVInvokedUrlCommand*)command {
    NSLog(@"SCAN - CALLED");
    printersFound = 0;
    
    [[PrinterSDK defaultPrinterSDK] scanPrintersWithCompletion:^(Printer* printerFound)
     {
         NSLog(@"SCANNING");
         NSLog(@"----------");
         printersFound++;
         
         if (printersFound == 1) {
             NSLog(@"PRINTER NAME >> %@", printerFound.name);
             NSLog(@"PRINTER UUID >> %@", printerFound.UUIDString);
             
             printer = printerFound;
             [[PrinterSDK defaultPrinterSDK] stopScanPrinters];
         }
     }];
}

- (void) stopScanningPrinters:(CDVInvokedUrlCommand*)command {
    NSLog(@"SCAN - STOPPED");
    [[PrinterSDK defaultPrinterSDK] stopScanPrinters];
}

- (void) connectPrinter:(CDVInvokedUrlCommand*)command {
    NSLog(@"CONNECT - CALLED");
//    [[PrinterSDK defaultPrinterSDK] stopScanPrinters];
    [[PrinterSDK defaultPrinterSDK] connectBT:printer];
    
//    double delayInSeconds = 1.0f;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
//    {
//       [[PrinterSDK defaultPrinterSDK] printTestPaper];
//    });
}

- (void) disconnectPrinter:(CDVInvokedUrlCommand*)command {
    NSLog(@"DISCONNECT - CALLED");
    [[PrinterSDK defaultPrinterSDK] disconnect];
}

- (void) print:(CDVInvokedUrlCommand*)command {
    NSLog(@"PRINT - CALLED");
    NSLog(@"----------");
    NSLog(@"PRINTER NAME >> %@", printer.name);
    NSLog(@"PRINTER UUID >> %@", printer.UUIDString);
    
    if (!printerConnected) {
        printerConnected = true;
        [[PrinterSDK defaultPrinterSDK] connectBT:printer];
        
        
        double delayInSeconds = 1.0f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
        {
           //       [[PrinterSDK defaultPrinterSDK] printTestPaper];
            [[PrinterSDK defaultPrinterSDK] printText:@"\n\nTESTING\n\n"];
        });
    } else {
        [[PrinterSDK defaultPrinterSDK] printText:@"\n\nTESTING\n\n"];
    }
    
    
}

- (void) sendError:(NSString*)text command:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                      messageAsString:text];
    
    [self.commandDelegate sendPluginResult:pluginResult
                                callbackId:command.callbackId];
}

@end
