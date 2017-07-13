
#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>

@interface PrinterPlugin : CDVPlugin {
}

- (void) initBluetooth:(CDVInvokedUrlCommand*)command;
- (void) startScanningPrinters:(CDVInvokedUrlCommand*)command;
- (void) stopScanningPrinters:(CDVInvokedUrlCommand*)command;
- (void) connectPrinter:(CDVInvokedUrlCommand*)command;
- (void) disconnectPrinter:(CDVInvokedUrlCommand*)command;
- (void) print:(CDVInvokedUrlCommand*)command;

@end
