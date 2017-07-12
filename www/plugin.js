
var exec = require('cordova/exec');

var PLUGIN_NAME = 'PrinterPlugin';

var PrinterPlugin = {
  test: function(cb) {
    exec(cb, null, PLUGIN_NAME, 'test', []);
  }
};

module.exports = PrinterPlugin;