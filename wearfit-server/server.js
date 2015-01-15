// Module dependencies

process.env.TMPDIR = '.';
global.__base = '.';

var path          = require('path');
var fs            = require('fs');
var express       = require('express');
var mongoose      = require('mongoose');
var passport      = require('passport');
var config        = require(__dirname + '/app/config/config');
var view_helper   = require(__dirname + '/app/helper/views-helper');
var app           = express();

app.config = config;

// Database
require('./app/config/database')(app, mongoose);

var models_path = __dirname + '/app/models'
fs.readdirSync(models_path).forEach(function (file) {
  if (~file.indexOf('.js')) require(models_path + '/' + file)
});

app.locals.build_menu = view_helper.build_menu
app.locals.icon = view_helper.icon

app.set('view engine', 'jade');


require('./app/config/passport')(app, passport);

// express settings
require('./app/config/express')(app, express, passport);

// create a server instance
// passing in express app as a request event handler
app.listen(app.get('port'), function() {
  console.log("\nExpress server listening on port %d in %s mode", app.get('port'), app.get('env'));
});

module.exports = app;
