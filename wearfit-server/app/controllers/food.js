var mongoose = require('mongoose');
var Food = mongoose.model('Food');
var tricks = require('express').Router();
var config = require('../config/config');
var request = require('request');
var _ = require('lodash');

/**
 * New Food
 */

exports.create = function(req, res) {
  res.render('food/create', {
    title: 'Add New Food',
    food: new Food({})
  })
}

exports.list = function (req, res) {
  res.render('food/list', {
    title: 'Foods List'
  })
}

exports.save = function(req, res) {
 
}


exports.details = function (req, res) {
  var _id = req.param.id;

  res.render('food/detail', {
    title: 'Food Details'
  })
}
