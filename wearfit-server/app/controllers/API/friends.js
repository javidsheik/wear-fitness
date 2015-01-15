var mongoose = require('mongoose');
var Friend     = mongoose.model('Friend');
var User     = mongoose.model('User');
var Activity     = mongoose.model('Activity');
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
var _ = require('lodash');


exports.requests = function( req, res, next) {


  var token = req.query.token;
  var user_id = req.query.user_id;

  AccessToken.findOne({token: token} , function(err,tok) {
  
  
  var message = req.body;
  
  var msg = token_utils.verify_access_token(tok);
  
		 if(msg == 'valid') {
		  
		   var condition = {
			    	$and: [
							{ user_id : user_id },						    
							{ status_flag : 'U'} 
                          ]
				}
			   
			  Friend
				.where(condition)
				.sort({createdAt: -1})
				.exec(function(err, friends) {

				  if(err) return utils.responses(res, 500, err)
				  
				                  var ids = friends.map(function(doc) { return doc.referred_by; });
                                    
									 var query = User.where({'_id' :  {$in : ids } })
									 
									 query.select('-hashed_password -tokens -invitation_token -salt -provider')
		 
									 query.exec( function(err,user) {
                                    
                                     var zip = [];
									 
									for(var i = 0; i < ids.length; i++){
									
										  var output = new Object();
									      var usr    = _.where(user,{_id: ids[i]});
										  var friend = _.where(friends,{referred_by: ids[i]})														
										  
										  output.user = usr;
										  
										  if(friend)
											output.friend_id = friend[0]._id
										  else
											output.friend_id = ""
											
										  zip.push(output);											
										
										}	
										
                                        return utils.responses(res, 200, { count : ids.length, users: zip} );        
                                    
									}); 					
				})		  			  
		  }else{
		  
			message.status= '401';
			message.message = msg;
  
			return utils.responses(res, 401, message)
 
		  }
  })    
}

exports.update_request = function( req, res, next) {

  var token = req.query.token;
  var friend_id = req.query.friend_id;

  AccessToken.findOne({token: token} , function(err,tok) {
  
  var message = req.body;
  
  var msg = token_utils.verify_access_token(tok);
  
		 if(msg == 'valid') {
		  
		   var condition = {
			    	$and: [
							{ _id : friend_id },						    
							{ status_flag : 'U'} 
                          ]
				}
			   
			    Friend.findOne(condition, function (err,doc) {
				
                    var message = new Object();					
					
					if(doc)
					{
 						doc.status_flag = 'A'

							doc.save(function(err) {
									
									  if(err){
									  
									   message.status= '401';
									   message.message = "Error Updating Request" 
									   message.error   = err;
	  
									   return utils.responses(res, 200, message)
									  }
									  else
									  {
									  
									   message.status= '200';
									   message.message = "Updated Request" 
									   
	  
									   return utils.responses(res, 200, message)
									  }
									  
						    });						    
					}
			   });
			   
			  Friend
				.where(condition)
				.sort({createdAt: -1})
				.exec(function(err, friends) {

				  if(err) return utils.responses(res, 500, err)
				  
				      return utils.responses(res, 200, { count : ids.length, users: user} );        
                                    
					}); 					
					  			  
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
  var points_compute_formula = 80;
 
  AccessToken.findOne({token: token} , function(err,tok) {
  
  
  var message = req.body;
  
  var msg = token_utils.verify_access_token(tok);
  
		if(msg == 'valid') {
		  
			  var page = (req.param('page') > 0 ? req.param('page') : 1) - 1;
			  var perPage = 14;
			  var options = {
				perPage: perPage,
				page: page
			  };

			  console.log(user_id);
			 
			  var condition = { referred_by : user_id}
			  
			   
			  Friend
				.where(condition)
				.sort({createdAt: -1})
				.skip(options.perPage * options.page)
				.limit(options.perPage)
				.exec(function(err, friends) {

				  if(err) return utils.responses(res, 500, err)
				  
				                  var ids = friends.map(function(doc) { return doc.user_id; });
                                    
									 var query = User.where({'_id' :  {$in : ids } })
									 
									 query.select('-hashed_password -tokens -invitation_token -salt -provider')
		 
									 query.exec( function(err,user) {
                                        
                                        console.log(err);
                                        
										condition = {
                                                $and: [
												        { $or: [ {track_type: 'Food'},{track_type: 'Activity'}] },
														{'user_id' :  {$in : ids } }                                                        
                                                      ]
                                            }
                                            
                                    Activity
                                        .where(condition)
                                        .sort({createdAt: -1})
                                        .exec(function(err, activities) {

                                         console.log(err);
                                         
                                          if(err) return utils.responses(res, 500, err)
                                          
                                          
                                          Activity.aggregate( [
                                                { $match: condition},
												{ $group : {
													 _id :  "$user_id"  ,
													  calories_burnt: { $sum: "$calories_burnt" }
													 ,calories_consumed: { $sum: "$calories_consumed" } 
													 ,steps: { $sum: "$steps" } 
													 ,distance: { $sum: "$distance" } 
													}
											   }												
                                            ], function (err, result) {
                                                    if (err) {
                                                        console.log(err);
                                                        if(err) return utils.responses(res, 500, err)
													}
                                                    
                                                    //console.log(result);
                                                    //Compute current points state
                                                   
												   var zip = [];
												   
												   for(var i = 0; i < ids.length; i++){
														var  output= new Object();
														
														var usr      = _.where(user,{_id: ids[i]});
														var friend   = _.where(friends,{user_id: ids[i]})														
														var calories = _.where(result,{_id: ids[i]});
													
													   
                                                        output.user = usr;
														if(friend)
														  output.friend_id = friend[0]._id
														else
														  output.friend_id = ""
														
														if(calories[0]){
														
															output.current_calories = calories[0].calories_burnt;
															output.consumption_calories = calories[0].calories_consumed;
															output.steps = calories[0].steps;
															output.distance = calories[0].distance;
														}else{
															output.current_calories = 0;
															output.consumption_calories = 0;
															output.steps = 0;
															output.distance = 0;
                                                        }
														zip.push(output);
                                                    }
													
                                                  return utils.responses(res, 200, { count : ids.length, friends: zip} );    
                                                });    
                                       });
                        }); 					
				})		  			  
		  }else{
		  
			message.status= '401';
			message.message = msg;
  
			return utils.responses(res, 401, message)
 
		  }
  })    
}


exports.details = function( req, res, next) {


  var token = req.query.token;
  
 
  AccessToken.findOne({token: token} , function(err,tok) {
  
  
  var message = new Object();
  var _id = req.params.id;
  
  var msg = token_utils.verify_access_token(tok);
  
  //console.log(msg);
  
		 if(msg == 'valid') {
		  
			  var page = (req.param('page') > 0 ? req.param('page') : 1) - 1;
			  var perPage = 14;
			  var options = {
				perPage: perPage,
				page: page
			  };

			 // console.log(user_id);
			 
			  var condition = { _id : _id}
			  
			   
			  Friend
				.where(condition)
				.sort({createdAt: -1})
				.skip(options.perPage * options.page)
				.limit(options.perPage)
				.exec(function(err, friends) {

				  if(err) return utils.responses(res, 500, err)

				  Friend.count(condition, function (err, count) {

					if (err) return errorHelper.mongoose(res, err);

					return utils.responses(res, 200, { friends: friends, count: count} );

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

  var email = req.body.email;

  var token = req.body.token;
  var user_id = req.body.user_id;
 
  AccessToken.findOne({token: token} , function(err,tok) {
  
  
  var message = req.body;
  
  var msg = token_utils.verify_access_token(tok);
  
  //console.log(msg);
  
		 if(msg == 'valid') {
		  
		    if(!user_id){
						
			   var message = req.body;
				message.status= '401';
			    message.message = "User is required";
		  		return utils.responses(res, 401, message)
			}
            
             if(email)
                    {
                    //search for users with email and create a friend and add to circle.
                    
                         User.findOne({ email : email}, function(err,user) {
                            
                           if(user){
                            
                            var friend = new Friend({user_id: user._id, email: email, referred_by : user_id,status_flag : 'U' });
                                
                                friend.save(function(err) {
                                  console.log(err);
								  
								  if(err){
                                  
								        message.status= '401';
                                        message.message = "Existing User. Error inviting friend ";
                                        message.detail = err;
                                        return utils.responses(res, 401, message)
								  }
								  else{
								  
                                   Friend.findById(friend, function (err, doc) {
                                     
                                               if(err){
                                                    message.status= '401';
                                                    message.message = "Existing User. Error inviting friend ";
                                                    message.detail = err;
                                                    return utils.responses(res, 401, message)
                                                }
                                                else{
												    message.friend  = doc;
                                                    message.status  = '200';
                                                    message.message = "Existing User.Added friend successfully";	
                                                    return utils.responses(res, 200, message)
                                                }                                           
                                    });
								}
                            });
                                
                            }
                            else
                            {
                            
                              async.waterfall([
                                function(next) {
                                  crypto.randomBytes(16, function(err, buf) {
                                    var token = buf.toString('hex');
                                    next(err, token);
                                  });
                                },
                                function(token, next) {
                                    
                                    var user = new User();
                                    user.email = email;
                                    user.invitation_token = token;
                                    user.invitation_expires = Date.now() + 43200000; // 12 hour
                                    user.mode = 'invite';
                                    
                                    user.save(function(err) {
                                      next(err, token, user);
                                    });
                                    
                                    
                                    
                                }, function(token, user, next) {
                                    user.url_invitation = req.protocol + '://' + req.headers.host + '/invite/' + token

                                    Mailer.sendOne('invitation', "Numa Digital Fitness - Invitation", user, function (err, responseStatus, html, text){
                                      next(err, responseStatus);
                                    })
                                    
                                    var friend = new Friend({user_id: user._id, email: email, referred_by : user_id ,status_flag : 'P'});
                                    
                                    friend.save(function(err) {
                                      console.log(err);
                                    });
                                
                                     Friend.findById(friend, function (err, doc) {
                                            
                                          var message = new Object();
                                          
                                          message.friend  = doc;	
                                          message.status  = '200';
                                          message.message = 'Invitation sent successfully.';
                                          
                                          return utils.responses(res, 200, message)			  
                                          });
                                    
                                  }
                                ], function(err) {
                                      if (err) {
                                      
                                      var message = req.body;
                                          message.status = '500';
                                          message.message = 'Failed sending invitation. please try again later. ' + err;
                                          
                                          return utils.responses(res, 200, message)
                                        
                                      }
                                 
                                });
                            
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