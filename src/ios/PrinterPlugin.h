
#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>

@interface PrinterPlugin : CDVPlugin {
}

- (void) cdvInit:(CDVInvokedUrlCommand*)command;
- (void) cdvFinish:(CDVInvokedUrlCommand*)command;
- (void) initBluetooth:(void (^)())completion;
- (void) scanAndConnect:(void (^)())completion;
- (void) cdvConnectPrinter:(CDVInvokedUrlCommand*)command;
- (void) connectPrinter;
- (void) disconnectPrinter;
- (void) cdvSendTextBuffer:(CDVInvokedUrlCommand*)command;
- (void) cdvSendHexBuffer:(CDVInvokedUrlCommand*)command;
- (void) cdvSendHex:(CDVInvokedUrlCommand*)command;
- (void) sendHex:(NSString*)cmd;
- (void) cdvPrintBuffer:(CDVInvokedUrlCommand*)command;
- (void) print:(NSString*)cmd;

@end
