var mongoose = require('mongoose');
var Friend = mongoose.model('Friend');
var tricks = require('express').Router();
var config = require('../config/config');
var request = require('request');
var _ = require('lodash');

/**
 * New Friend
 */

exports.create = function(req, res) {
  res.render('friend/create', {
    title: 'Invite New Friend',
    track: new Friend({})
  })
}

exports.invite = function(req, res) {
 
}

exports.list = function (req, res) {
  res.render('friend/list', {
    title: 'My Friends'
  })
}
	