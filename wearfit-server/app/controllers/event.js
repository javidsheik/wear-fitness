var mongoose = require('mongoose');
var Event = mongoose.model('Event');
var tricks = require('express').Router();
var config = require('../config/config');
var request = require('request');
var _ = require('lodash');

/**
 * New Event
 */

exports.create = function(req, res) {
  res.render('event/create', {
    title: 'New Event',
    event: new Event({})
  })
}

exports.save = function(req, res) {
 
}

exports.list = function (req, res) {
  res.render('event/list', {
    title: 'My Events'
  })
}

exports.details = function (req, res) {
  var _id = req.param.id;

  res.render('event/detail', {
    title: 'Event Details'
  })
}
