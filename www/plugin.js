var exec = require('cordova/exec');

var PLUGIN_NAME = 'PrinterPlugin';

var PrinterPlugin = {
    initBluetooth: function(successCallback, errorCallback) {
        exec(successCallback, errorCallback, PLUGIN_NAME, 'initBluetooth', []);
    },
    startScanningPrinters: function(successCallback, errorCallback) {
        exec(successCallback, errorCallback, PLUGIN_NAME, 'startScanningPrinters', []);
    },
    stopScanningPrinters: function(successCallback, errorCallback) {
        exec(successCallback, errorCallback, PLUGIN_NAME, 'stopScanningPrinters', []);
    },
    connectPrinter: function(successCallback, errorCallback) {
        exec(successCallback, errorCallback, PLUGIN_NAME, 'connectPrinter', []);
    },
    disconnectPrinter: function(successCallback, errorCallback) {
        exec(successCallback, errorCallback, PLUGIN_NAME, 'disconnectPrinter', []);
    },
    print: function(successCallback, errorCallback) {
        exec(successCallback, errorCallback, PLUGIN_NAME, 'print', []);
    }
};

module.exports = PrinterPlugin;
