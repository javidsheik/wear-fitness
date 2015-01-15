var mongoose = require('mongoose');
var Goal = mongoose.model('Goal');
var tricks = require('express').Router();
var config = require('../config/config');
var request = require('request');
var _ = require('lodash');

/**
 * New Goal
 */

exports.create = function(req, res) {
  res.render('goal/edit', {
    title: 'New Goal',
    track: new Goal({})
  })
}

exports.save = function(req, res) {
 
}

exports.details = function (req, res) {
  var _id = req.param.id;

  res.render('goal/detail', {
    title: 'Goal Details'
  })
}
