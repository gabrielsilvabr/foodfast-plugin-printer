var exec = require('cordova/exec');

var PLUGIN_NAME = 'PrinterPlugin';

var PrinterPlugin = {
    cdvInit: function(successCallback, errorCallback) {
        exec(successCallback, errorCallback, PLUGIN_NAME, 'cdvInit', []);
    },
    cdvFinish: function(successCallback, errorCallback) {
        exec(successCallback, errorCallback, PLUGIN_NAME, 'cdvFinish', []);
    },
    cdvConnectPrinter: function(cmd, successCallback, errorCallback) {
        exec(successCallback, errorCallback, PLUGIN_NAME, 'cdvConnectPrinter', [cmd]);
    },
    cdvSendTextBuffer: function(cmd, successCallback, errorCallback) {
        exec(successCallback, errorCallback, PLUGIN_NAME, 'cdvSendTextBuffer', [cmd]);
    },
    cdvSendHexBuffer: function(cmd, successCallback, errorCallback) {
        exec(successCallback, errorCallback, PLUGIN_NAME, 'cdvSendHexBuffer', [cmd]);
    },
    cdvSendHex: function(cmd, successCallback, errorCallback) {
        exec(successCallback, errorCallback, PLUGIN_NAME, 'cdvSendHex', [cmd]);
    },
    cdvPrintBuffer: function(successCallback, errorCallback) {
        exec(successCallback, errorCallback, PLUGIN_NAME, 'cdvPrintBuffer', []);
    }
};

module.exports = PrinterPlugin;
