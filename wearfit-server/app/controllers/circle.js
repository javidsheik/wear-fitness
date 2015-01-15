var mongoose = require('mongoose');
var Circle = mongoose.model('Circle');
var tricks = require('express').Router();
var config = require('../config/config');
var request = require('request');
var _ = require('lodash');

/**
 * New Circle
 */

exports.create = function(req, res) {
  res.render('circle/create', {
    title: 'New Circle',
    circle: new Circle({})
  })
}

exports.save = function(req, res) {
 
}


exports.list = function (req, res) {
  res.render('circle/list', {
    title: 'My Circles'
  })
}

exports.details = function (req, res) {
  var _id = req.param.id;

  res.render('circle/list', {
    title: 'My Circles'
  })
}
