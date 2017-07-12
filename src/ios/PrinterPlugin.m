#import "PrinterPlugin.h"

#import <Cordova/CDVAvailability.h>

@implementation PrinterPlugin

- (void)pluginInitialize {
}

- (void)test:(CDVInvokedUrlCommand *)command {
  // NSString* phrase = [command.arguments objectAtIndex:0];
  NSLog(@"TESTED");
}

@end
