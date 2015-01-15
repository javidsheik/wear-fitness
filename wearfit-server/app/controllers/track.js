var mongoose = require('mongoose');
var Activity = mongoose.model('Activity');
var config = require('../config/config');
var request = require('request');
var _ = require('lodash');

/**
 * New Track Activities
 */

exports.create = function(req, res) {
  res.render('track/create', {
    title: 'Track New Activity',
    track: new Activity({})
  })
}

exports.save = function(req, res) {
 
}

exports.list = function (req, res) {
  res.render('track/list', {
    title: 'My Activities'
  })
}

exports.details = function (req, res) {
  var _id = req.param.id;

  res.render('track/detail', {
    title: 'Activity Details'
  })
}
