
#import "PrinterPlugin.h"
#import "PrinterSDK.h"
#import <Cordova/CDVAvailability.h>

@interface PrinterPlugin ()
@property (nonatomic) NSUInteger printersFound;
@property (nonatomic) NSString* bufferToPrint;
@property (nonatomic) Boolean printerConnected;
@property (nonatomic) Printer* printer;

- (void) sendError:(NSString*)text command:(CDVInvokedUrlCommand*)command;
@end

@implementation PrinterPlugin

@synthesize printersFound;
@synthesize bufferToPrint;
@synthesize printerConnected;
@synthesize printer;

- (void) pluginInitialize {
    bufferToPrint = @"";
    printerConnected = false;
}

- (void) cdvInit:(CDVInvokedUrlCommand *)command {
    NSLog(@"INIT - CALLED");
    
    [self initBluetooth:^{
        [self scanAndConnect:^{
            NSLog(@"PRINTER CONNECTED");
            [self sendHex:@"0A"];
        }];
    }];
    
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"success: bluetooth started"];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}
    
- (void) cdvFinish:(CDVInvokedUrlCommand *)command {
    NSLog(@"FINISH - CALLED");
    
    [self disconnectPrinter];
    bufferToPrint = @"";
    
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"success: bluetooth finished"];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}
    
- (void)initBluetooth:(void (^)())completion {
    [PrinterSDK defaultPrinterSDK];
//    [[PrinterSDK defaultPrinterSDK] disconnect];
    
    double delayInSeconds = 0.1f;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
    {
       completion();
    });
    
}

- (void) scanAndConnect:(void (^)())completion {
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

            [self connectPrinter];

            double delayInSeconds = 1.5f;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
            {
                completion();
            });
        }
    }];
}

- (void) cdvConnectPrinter:(CDVInvokedUrlCommand*)command {
    NSLog(@"CONNECT - CALLED");
    
    [self connectPrinter];
    
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"success: connected"];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}
    
- (void) connectPrinter {
    if (!printerConnected) {
        printerConnected = true;
        [[PrinterSDK defaultPrinterSDK] connectBT:printer];
    }
}

- (void) disconnectPrinter {
    if (printerConnected) {
        printerConnected = false;
        [[PrinterSDK defaultPrinterSDK] disconnect];
    }
}
    
- (void) cdvSendTextBuffer:(CDVInvokedUrlCommand*)command {
    NSLog(@"BUFFER HEX - CALLED");
    NSString* cmd = @"";
    
    if (command.arguments.count == 1) {
        cmd = [command.arguments objectAtIndex:0];
    }
    
    NSString * hexStr = [NSString stringWithFormat:@"%@",
                         [NSData dataWithBytes:[cmd cStringUsingEncoding:NSUTF8StringEncoding]
                                        length:strlen([cmd cStringUsingEncoding:NSUTF8StringEncoding])]];
    
    for(NSString * toRemove in [NSArray arrayWithObjects:@"<", @">", @" ", nil])
    hexStr = [hexStr stringByReplacingOccurrencesOfString:toRemove withString:@""];
    
    bufferToPrint = [bufferToPrint stringByAppendingString:hexStr];
    
    NSLog(@"\nSTRING BUFFER >> \n%@", hexStr);
    
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"success: send text to buffer"];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}
    
- (void) cdvSendHexBuffer:(CDVInvokedUrlCommand*)command {
    NSLog(@"BUFFER HEX - CALLED");
    NSString* cmd = @"";
    
    if (command.arguments.count == 1) {
        cmd = [command.arguments objectAtIndex:0];
    }
    
    NSLog(@"\nHEX BUFFER >> \n%@", cmd);
    
    [cmd stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    bufferToPrint = [bufferToPrint stringByAppendingString:cmd];
    
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"success: send hex to buffer"];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}
    
- (void) cdvSendHex:(CDVInvokedUrlCommand*)command {
    NSString* cmd = @"";
    
    if (command.arguments.count == 1) {
        cmd = [command.arguments objectAtIndex:0];
    }
    
    NSLog(@"\nHEX >> \n%@", cmd);
    
    [self sendHex:cmd];

    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"success: send hex"];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}
    
- (void) sendHex:(NSString*)cmd {
    [[PrinterSDK defaultPrinterSDK] sendHex:[cmd stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
}
    
- (void) cdvPrintBuffer:(CDVInvokedUrlCommand*)command {
    NSLog(@"PRINT BUFFER - CALLED");
    NSLog(@"BUFFER FOUND\n%@", bufferToPrint);
    
    if (printerConnected) {
        [self sendHex:bufferToPrint];
        bufferToPrint = @"";
    } else {
        [self sendError:@"Printer is unavailable" command:command];
    }
    
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"success: hex"];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void) print:(NSString*)cmd {
    [[PrinterSDK defaultPrinterSDK] printText:cmd];
}

- (void) sendError:(NSString*)text command:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                      messageAsString:text];
    
    [self.commandDelegate sendPluginResult:pluginResult
                                callbackId:command.callbackId];
}

@end
