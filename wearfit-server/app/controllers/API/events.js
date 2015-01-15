var mongoose = require('mongoose');
var Event   = mongoose.model('Event');
var User     = mongoose.model('User');
var Friend     = mongoose.model('Friend');
var Circle     = mongoose.model('Circle');
var Schema = mongoose.Schema;

var AccessToken     = mongoose.model('AccessToken');
var config   = require('../../config/config');
var utils    = require(config.root + '/app/helper/utils');
var token_utils    = require(config.root + '/app/helper/token_utils');
var async    = require('async');
var jwt      = require('jwt-simple');
var moment      = require('moment');
var async = require('async');

var utility = require('utility');
var crypto = require('crypto');
var errorHelper = require(config.root + '/app/helper/errors');
var Mailer   = require(config.root + '/app/helper/mailer');


exports.details = function( req, res, next) {


  var token   = req.query.token;
  var _id     = req.params.id;
 
  AccessToken.findOne({token: token} , function(err,tok) {
  
  
  var message = req.body;
  
  var msg = token_utils.verify_access_token(tok);
  
  //console.log(msg);
  
		 if(msg == 'valid') {
		  
		  console.log(_id);
		  
			  var condition = { _id : _id}
			  
			   
			  Event
				.where(condition)
				.sort({createdAt: -1})
				.exec(function(err, events) {

				  if(err) return utils.responses(res, 500, err)

				  Event.count(condition, function (err, count) {

					if (err) return errorHelper.mongoose(res, err);

					return utils.responses(res, 200, { events: events, count: count} );

				  });
				})		  			  
		  }else{
		  
			message.status= '401';
			message.message = msg;
  
			return utils.responses(res, 401, message)
 
		  }
  })    
}

exports.list = function( req, res, next) {


  var token = req.query.token;
  var user_id = req.query.user_id;
 
  AccessToken.findOne({token: token} , function(err,tok) {
  
  
  var message = req.body;
  
  var msg = token_utils.verify_access_token(tok);
  
  //console.log(msg);
  
		 if(msg == 'valid') {
		  
			  var page = (req.query.page > 0 ? req.query.page : 1) - 1;
			  var perPage = 14;
			  var options = {
				perPage: perPage,
				page: page
			  };

			  console.log(user_id);
			 
			  var condition = { }
			  
			   
			  Event
				.where(condition)
				.sort({createdAt: -1})
				.skip(options.perPage * options.page)
				.limit(options.perPage)
				.exec(function(err, events) {

				  if(err) return utils.responses(res, 500, err)

				  Event.count(condition, function (err, count) {

					if (err) return errorHelper.mongoose(res, err);

					return utils.responses(res, 200, { events: events, count: count} );

				  });
				})		  			  
		  }else{
		  
			message.status= '401';
			message.message = msg;
  
			return utils.responses(res, 401, message)
 
		  }
  })    
}


exports.create = function (req, res, next) {

  var token = req.body.token;
  var user_id = req.body.user_id;
 
  AccessToken.findOne({token: token} , function(err,tok) {
  
  
  var message = req.body;
  
  var msg = token_utils.verify_access_token(tok);
  
  
  
		 if(msg == 'valid') {
			   
						
						if(!user_id){
						
						        var message = req.body;
								message.status= '401';
								message.message = "User is required";
		  
								return utils.responses(res, 401, message)
						}
						else{
			
			                    evt             = new Event(req.body);
								
								if(!req.body.event_date)
								  evt.event_date  = new Date().toISOString();
								
								var message = new Object();
								
								evt.save(function(err) {
								
								//console.log(err);
								
								  if(err){
								  
								   message.status= '401';
								   message.message = "Error Creating Event" 
                                   message.error   = "" + err;
  
								   return utils.responses(res, 200, message)
								  }
								  else{
								  
								  Event.findById(evt, function (err,doc) {
								
                                   message.event	 = doc;								
							   	   message.status= '200';
								   message.message = "Event created successfully";
  
								   return utils.responses(res, 200, message)
								   
									})
									
								   
								   }
								});
						}
			  	  			  
		  }else{
		  
			message.status= '401';
			message.message = msg;
  
			return utils.responses(res, 401, message)
 
		  }
  })    
 
}



exports.share = function( req, res, next) {


  var token = req.body.token;
  var user_id = req.body.user_id;
  var circle_id = req.body.circle_id;
  var event_id = req.body.event_id;
 
  AccessToken.findOne({token: token} , function(err,tok) {
  
  
  var message = req.body;
  
  var msg = token_utils.verify_access_token(tok);
  
  //console.log(msg);
  
		 if(msg == 'valid') {
		  
			 console.log(event_id);
             
			  var condition = { _id : event_id}
			  
                             async.waterfall([
                                        function(next) {
                                        User.findOne({ _id : user_id}, function(err,user) {
                                              next(err,user);
                                            });
                                        },
                                        function(user,next) {
                                            
                                            Event.findOne({ _id : event_id}, function(err,evt) {
                                              next(err,user, evt);
                                            });
                                        }, function(user, event, next) {
                                           
                                           user.share_by = user.first_name + ',' + user.last_name
                                              //   user.url_invitation = req.protocol + '://' + req.headers.host + '/invite/' + token

                                              Circle.findOne({ _id : circle_id}, function(err,circle) {
             
                                                console.log(circle.friends);
                
             
                                               circle.friends.forEach(function(friend_id){
             
                                                Friend.findOne({ _id : friend_id}, function(err,friend) {
               
			                                       var mail_content = new Object();
												   mail_content.share_by =  user.first_name + ',' + user.last_name;
												   mail_content.email = friend.email;
												   mail_content.name = event.name;
												   mail_content.description = event.name;
												   mail_content.start_longitude = event.start_longitude;
												   mail_content.start_latitude = event.start_latitude;
												   mail_content.end_longitude = event.end_longitude;
												   mail_content.end_latitude = event.end_latitude;
												   mail_content.event_date = event.event_date;
												   mail_content.start_time = event.start_time;
												   mail_content.end_time = event.end_time;
												   
												   
                                                    Mailer.sendOne('share-event', "Numa Digital Fitness - Share Event", mail_content, function (err, responseStatus, html, text){
                                                      next(err, responseStatus);
                                                    })
                                                    
                                                  });
                                                });
                                              });
                                                    
                                                    var message = req.body;
                                                    message.status = '200';
                                                    message.message = 'Event Shared successfully.';
                                                          
                                                    return utils.responses(res, 200, message)		

                                                                  
                                            
                                          }
                                        ], function(err) {
                                              if (err) {
                                              
                                              var message = req.body;
                                                  message.status = '500';
                                                  message.message = 'Failed sending email. please try again later. ' + err;
                                                  
                                                  return utils.responses(res, 200, message)
                                                
                                              }
                                         
                                        });
               		              
			 		  			  
		  }else{
		  
			message.status= '401';
			message.message = msg;
  
			return utils.responses(res, 401, message)
 
		  }
  })    
}
