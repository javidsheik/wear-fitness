var express = require('express');
var Route = express.Router();
var config = require('../config/config');
var passport = require('passport');
var lodash = require('lodash')
var Auth = require(config.root + '/app/middleware/authorization');
var fs = require('fs');

var userController = require(config.root + '/app/controllers/users');
var foodController = require(config.root + '/app/controllers/food');
var friendController = require(config.root + '/app/controllers/friend');
var circleController = require(config.root + '/app/controllers/circle');
var eventController = require(config.root + '/app/controllers/event');
var trackController = require(config.root + '/app/controllers/track');
var goalController = require(config.root + '/app/controllers/goal');


var API = {}
API.Users = require(config.root + '/app/controllers/API/users');
API.Friends = require(config.root + '/app/controllers/API/friends');
API.Circles = require(config.root + '/app/controllers/API/circles');
API.Events = require(config.root + '/app/controllers/API/events');
API.Foods = require(config.root + '/app/controllers/API/foods');
API.Goals = require(config.root + '/app/controllers/API/goals');
API.Track = require(config.root + '/app/controllers/API/track');
API.PushNotification = require(config.root + '/app/controllers/API/push_notify');


// API Routes
Route
  .get('/api',function(req, res) {
	  res.send('Numa Digital Fitness API');
  })
  .post('/api/oauth/login', API.Users.login)
  .post('/api/oauth/logout', API.Users.logout)
  .post('/api/oauth/signup', API.Users.signup)
  .get('/api/user/profile/:email', API.Users.get_profile)
  .post('/api/user/profile', API.Users.update_profile)
  .post('/api/oauth/fb_login', API.Users.fb_login)
  .post('/api/oauth/forgot_password', API.Users.postForgotPassword)
  
  
  .post('/api/friends/invite', API.Friends.create)
  .get('/api/friends', API.Friends.list)
  .get('/api/friends/requests', API.Friends.requests)  
  .post('/api/friends/update_request', API.Friends.update_request)
  .get('/api/friends/:id', API.Friends.details)
  
 
  .post('/api/circles/create', API.Circles.create) 
  .post('/api/circles/addfriend', API.Circles.add_friend) 
  .get('/api/circles', API.Circles.list)
  .get('/api/circles/detail_list', API.Circles.detail_list)
  .get('/api/circles/:id', API.Circles.details)
  
  .post('/api/track/create', API.Track.create)
  .post('/api/track/load', API.Track.load)
  .get('/api/activities', API.Track.list)  
  .get('/api/activities/types', API.Track.list_types)  
  .get('/api/activities/stats', API.Track.stats)
  .get('/api/activities/:id', API.Track.details)
  
  
  .post('/api/goals/create', API.Goals.create)
  .get('/api/goals', API.Goals.details)
  .get('/api/goals/:date', API.Goals.compute)
  
  
  .post('/api/foods/create', API.Foods.create)
  .get('/api/foods', API.Foods.list)
  .get('/api/foods/:id', API.Foods.details)
  .get('/api/foods/search/:name', API.Foods.search)
  
  .post('/api/events/create', API.Events.create)
  .post('/api/events/share', API.Events.share)
  .get('/api/events', API.Events.list)
  .get('/api/events/:id', API.Events.details)
 
  .post('/api/push_notifications/subscribe', API.PushNotification.subscribe)
  .post('/api/push_notifications/unsubscribe', API.PushNotification.unsubscribe)
  .post('/api/push_notifications/send', API.PushNotification.send)
  .get('/api/push_notifications', API.PushNotification.list)

 
// Frontend routes
Route
  .get('/login', userController.login)
  .get('/signup', userController.signup)
  .post('/signup', userController.sendInvitation)
  .get('/logout', userController.logout)
  .get('/forgot-password', userController.getForgotPassword)
  .post('/forgot-password',Auth.hasLogin, userController.postForgotPassword)
  .get('/reset/:token', Auth.hasLogin, userController.getResetPassword)
  .post('/reset/:token', Auth.hasLogin, userController.postResetPassword)
  .get('/invite/:token', userController.getInvitation)
  .post('/invite/:token', userController.create)
  .post('/users/create', userController.create)
  .get('/users/profile/:user_id', userController.user_profile)
  .get('/dashboard', Auth.requiresLogin, userController.show)
  .post('/users/session',
    passport.authenticate('local', {
    failureRedirect: '/login',
    failureFlash: true
  }), userController.session)
  .get('/auth/twitter', passport.authenticate('twitter'))
  .get('/auth/twitter/callback',
    passport.authenticate('twitter',{
    failureRedirect: '/login' }), function(req, res) {
    res.redirect(req.session.returnTo || '/');
  })
  .get('/auth/facebook', passport.authenticate('facebook', { scope: ['email', 'user_location'] }))
  .get('/auth/facebook/callback', passport.authenticate('facebook', { failureRedirect: '/login' }), function(req, res) {
    res.redirect(req.session.returnTo || '/');
  })
  .get('/', function(req, res) {
    res.render('index', {
      title: 'Numa Digital Fitness'
    });
  })
  

  
// #Other Routes
Route
  .get('/food/create',  Auth.requiresLogin, foodController.create)  
  .post('/food/create',  Auth.requiresLogin, foodController.save)  
  .get('/food',  Auth.requiresLogin, foodController.list)  
  .get('/food/:id',  Auth.requiresLogin, foodController.details)  
  .get('/goal',  Auth.requiresLogin, goalController.details)
  .get('/track',  Auth.requiresLogin, trackController.list)  
  .get('/circle',  Auth.requiresLogin, circleController.list)
  
  
module.exports = Route
