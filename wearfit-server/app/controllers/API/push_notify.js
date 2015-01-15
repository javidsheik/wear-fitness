var mongoose = require('mongoose');
var User     = mongoose.model('User');
var AccessToken     = mongoose.model('AccessToken');
var PushNotification     = mongoose.model('PushNotification');
var config   = require('../../config/config');
var utils    = require(config.root + '/app/helper/utils');
var async    = require('async');
var push_notify   =require(config.root + '/app/helper/notify');
var token_utils    = require(config.root + '/app/helper/token_utils');
var _ = require('lodash');

exports.list = function( req, res, next) {


  var token   = req.query.token;
  var user_id = req.query.user_id;
  
 
  AccessToken.findOne({token: token} , function(err,tok) {
  
  
  var message = req.body;
  
  var msg = token_utils.verify_access_token(tok);
  
  //console.log(msg);
  
		 if(msg == 'valid') {
		  
			  var condition = { user_id : user_id}
			  
			   
			  PushNotification
				.where(condition)
				.sort({createdAt: -1})
				.exec(function(err, notifs) {

				  if(err) return utils.responses(res, 500, err)

				  PushNotification.count(condition, function (err, count) {

					if (err) return errorHelper.mongoose(res, err);

					return utils.responses(res, 200, { notifications: notifs, count: count} );

				  });
				})		  			  
		  }else{
		  
			message.status= '401';
			message.message = msg;
  
			return utils.responses(res, 401, message)
 
		  }
  })    
}


exports.subscribe = function (req, res, next) {

  var token        = req.body.token;
  var user_id      = req.body.user_id;
  var device_token = req.body.device_token;
 
  AccessToken.findOne({token: token} , function(err,tok) {
  
  
  var message = req.body;
  
  var msg = token_utils.verify_access_token(tok);
  
  
  
		 if(msg == 'valid') {
			   
						if(!device_token){
                               var message = req.body;
								message.status= '401';
								message.message = "Device Token is required. Please check push notification documentation";
		  
								return utils.responses(res, 401, message)
                                
                        }
						else if(!user_id){
						
						        var message = req.body;
								message.status= '401';
								message.message = "User is required";
		  
								return utils.responses(res, 401, message)
						}
						else{
			
			                    notification = new PushNotification(req.body);
								
								var message = new Object();
								
								notification.save(function(err) {
								
								  if(err){
								  
								  console.log(err);
								   message.status= '401';
								   message.message = "Error Creating subscription";
                                   message.error   = "" + err;
  
								   return utils.responses(res, 200, message)
								  }
								  else{
								  
								  PushNotification.findById(notification, function (err,doc) {
								
                                   message.notification	 = doc;								
							   	   message.status= '200';
								   message.message = "Device subscribed successfully";
  
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


exports.unsubscribe = function (req, res, next) {

  var token        = req.body.token;
  var user_id      = req.body.user_id;
  var device_token = req.body.device_token;
 
  AccessToken.findOne({token: token} , function(err,tok) {
  
  
  var message = req.body;
  
  var msg = token_utils.verify_access_token(tok);
  
  	 if(msg == 'valid') {
			   
                        
                        var condition = { user_id : user_id}
                        
						if(device_token){
                        
                                var condition = { device_token : device_token}
                                console.log('Removing Device from subscription');
                                
                        }
						else if(user_id){
                                var condition = { user_id : user_id}
                                console.log('Removing All Devices for this user from subscription');
						       
						}
						
                        
                        notification = PushNotification.where(condition);
			
			                   notification.remove(function(err) {
								
								  if(err){
								  
								  console.log(err);
								   message.status= '401';
								   message.message = "Error in unsubscription";
                                   message.error   = "" + err;
  
								   return utils.responses(res, 200, message)
								  }
								  else{
								
                                   message.status= '200';
								   message.message = "Unsubscribed successfully";
  
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
 
 
exports.send = function (req, res, next) {

  var token        = req.body.token;
  var notifs       = req.body.push_notifications;
 
  AccessToken.findOne({token: token} , function(err,tok) {
  
  
  var message = req.body;
  
  var msg = token_utils.verify_access_token(tok);
  
  	 if(msg == 'valid') {
			   
               notifs.forEach(function (notif) {
                            var users          = notif.users,
                                androidPayload = notif.android,
                                iosPayload     = notif.ios,
                                target;

                            if (androidPayload && iosPayload) {
                                target = 'all'
                            } else if (iosPayload) {
                                target = 'ios'
                            } else if (androidPayload) {
                                target = 'android';
                            }
                            
                            var condition = {}
                            
                            if(users) {
                            
                                     if (target !== 'all') {
                                     
                                        var condition = {
                                                $and: [
                                                        {user_id: { $in :[users]} },						    
                                                        {device_type:   target}
                                                      ]
                                            }
                                    
                                     }
                                     else
                                     {
                                      var condition =  {user_id: { $in :[users]} }
                                     }
                             }
                             else
                             {                             
                                     if (target !== 'all') {
                                             var condition =  {device_type: target}
                                      }
                                                                  
                             }
			   
                              PushNotification
                                .where(condition)
                                .sort({createdAt: -1})
                                .exec(function(err, pnotifs) {

                                console.log(err);
                                
                                //  if(err) return utils.responses(res, 500, err)

                                    var androidTokens = _(pnotifs).where({device_type: 'android'}).map('device_token').value();
                                    var iosTokens = _(pnotifs).where({device_type: 'ios'}).map('device_token').value();

                                    if (androidPayload && androidTokens.length > 0) {
                                        var gcmPayload = push_notify.android_build(androidPayload);
                                        push_notify.android_push(androidTokens, gcmPayload);
                                    }

                                    if (iosPayload && iosTokens.length > 0) {
                                        var apnPayload = push_notify.ios_build(iosPayload);
                                        push_notify.ios_push(iosTokens, apnPayload);
                                    }
                                  
                                })
                        });
                        
                        if(notifs.length > 0) {
								
                            message.status= '200';
                            message.message = "Notifications sent successfully";
      
                            return utils.responses(res, 200, message)
                        
						}
                        
                        
														  	  			  
		  }else{
		  
			message.status= '401';
			message.message = msg;
  
			return utils.responses(res, 401, message)
 
		  }
    }) 
}