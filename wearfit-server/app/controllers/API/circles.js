var mongoose = require('mongoose');
var Friend     = mongoose.model('Friend');
var Circle     = mongoose.model('Circle');
var Activity     = mongoose.model('Activity');
var User     = mongoose.model('User');
var Schema = mongoose.Schema;

var AccessToken     = mongoose.model('AccessToken');
var config   = require('../../config/config');
var utils    = require(config.root + '/app/helper/utils');
var token_utils    = require(config.root + '/app/helper/token_utils');
var async    = require('async');
var jwt      = require('jwt-simple');
var moment      = require('moment');
var async = require('async');
var _ = require('lodash');

var utility = require('utility');
var crypto = require('crypto');
var errorHelper = require(config.root + '/app/helper/errors');
var Mailer   = require(config.root + '/app/helper/mailer');


exports.details = function( req, res, next) {


  var token   = req.query.token;
  var user_id = req.query.user_id;
  var _id     = req.params.id;
 
  AccessToken.findOne({token: token} , function(err,tok) {
  
  
  var message = req.body;
  
  
  var msg = token_utils.verify_access_token(tok);
  
  //console.log(msg);
  
		 if(msg == 'valid') {
		  
			  var condition = { _id : _id}
			  
			  
			  Circle
				.where(condition)
				.sort({createdAt: -1})
				.exec(function(err, circles) {

                 var jcircles = circles[0].toObject();
                 
                 if(!circles)
                    return
                    
				                
                                 Friend.where( {_id : {$in : circles[0].friends }}).exec( function (err, doc) {
                                     
                                     if(err) console.log(err);
                                     
                                    var ids = doc.map(function(doc) { return doc.user_id; });
                                    
                                    
                                     User.where({'_id' :  {$in : ids } }).exec( function(err,user) {
                                        
                                        jcircles.friends = user;
                                       
                                        console.log(err);
                                         
                                        if(err) return utils.responses(res, 500, err)  
  
                                        return utils.responses(res, 200, { circles: jcircles} );
                                                                           
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

exports.detail_list = function( req, res, next) {


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
			 
			  var condition = { user_id : user_id}
			  var users= [];
			   
			  Circle
				.where(condition)
				.sort({createdAt: -1})
				.skip(options.perPage * options.page)
				.limit(options.perPage)
				.exec(function(err, circles) {
                
                
                           
                            var vCircles = circles.map(function(circle) { return circle});
                            
                                var oFriends = [];
                                
                                
                                for(var i=0;i < vCircles.length; i++)
                                 {
                                 
                                    for(var j=0; j < vCircles[i].friends.length ; j++) 
                                     {
                                         oFriends.push(vCircles[i].friends[j]);
                                     }
                                    
                                 }
                                 
                                 console.log(oFriends);
                                
                                 Friend.where( {_id : {$in : oFriends }}).exec( function (err, friend) {
                                     
                                     if(err) console.log(err);
                                     
                                     if(!friend) return;
                                     
                                       var idUsers = friend.map(function(doc) { return doc.user_id; });
                                       
                                        User.where({'_id' :  {$in : idUsers } }).exec( function(err,user) {
                                        
                                        var condition = {
                                                         $and : [
                                                                 { $or: [{track_type: 'Food'}, {track_type: 'Activity'} ]},
                                                                 {'user_id' : {$in: idUsers}}
                                                              ]
                                                         
                                                         }
                                        
                                         Activity
                                                .where(condition)
                                                .sort({activity_date : -1})
                                                .exec(function(err, activities) {

                                                 console.log(err);
                                                 
                                                  if(err) return utils.responses(res, 500, err)
                                                  
                                                
                                                  Activity.aggregate( [
                                                        { $match: condition},
                                                        { $group: {
                                                            _id : { user_id: "$user_id", month: { $month: "$activity_date" }},
                                                            user_id : { $push: "$user_id"} ,
                                                            calories_burnt: { $sum: "$calories_burnt" },
															calories_consumed: { $sum: "$consumed_value" },
                                                            distance: { $sum: "$distance" },				
															steps: { $sum: "$steps" }
                                                            } 
                                                        },
                                                        { "$sort": { month: -1 } }
                                                    ], function (err, activity) {
                                                            if (err) {
                                                                console.log(err);
                                                                    if(err) return utils.responses(res, 500, err)
                                                            }
                                                            
                                                                var zip=[];
                                        
                                                                for(var i=0;i< vCircles.length; i++)
                                                                {
                                                                  var ocircles = new Object();
                                                                  
                                                                
                                                                  var crcl =  _.where(circles,{_id: vCircles[i]._id});;
                                                                
                                                                    ocircles.circle = crcl[0];
                                                                  
                                                                    ocircles.users = [];
                                                                     
                                                                   
                                                                     for(var j=0; j < vCircles[i].friends.length ; j++) 
                                                                       {
                                                                       
                                                                       ocircles.users[j] = new Object();
                                                                       
																	      console.log("---------> Friend:"+ fnd[0]);   
                                                                          
																		  
                                                                            var fnd          = _.where(friend,{_id:  vCircles[i].friends[j]});
                                                                            var usr          = _.where(user, {_id: fnd[0].user_id}); 
                                                                            
                                                                          console.log("---------> User:"+ usr[0].first_name);   
                                                                          

                                                                           var userObj = new Object();
                                                                           userObj._id = usr[0]._id;
                                                                           userObj.profile_picture = usr[0].profile_picture;
                                                                           userObj.first_name      = usr[0].first_name;
                                                                           userObj.last_name       = usr[0].last_name;
                                                                          
                                                                         // userObj.activities = [];
                                                                          
                                                                          // for(var k=0; k< activity.length; k++){
                                                                               var calories     = _.where(activity, {user_id: [usr[0]._id]});                                                                             
                                                                            //   console.log("----------> Calories:"+ calories);
                                                                               userObj.activities      = calories;     
                                                                           //}
                                                                           
                                                                           
                                                                           
                                                                           ocircles.users[j] = userObj;
                                                                           
                                                                      }
                                                                      
                                                                      zip.push(ocircles);
                                                                                                                                           
                                                                  }
                                                                  
                                                                 return utils.responses(res, 200, {circles: zip, count: vCircles.length} );
                                                           
                                                           
                                                           
                                                        });    
                                                  
                                               });
                                                                        
                                        
                                        });
                                                                         
                                       });                                                                        
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
			 
			  var condition = { user_id : user_id}
			  var users= [];
			   
			  Circle
				.where(condition)
				.sort({createdAt: -1})
				.skip(options.perPage * options.page)
				.limit(options.perPage)
				.exec(function(err, circles) {
                
                
                            var resultCircles = circles.map(function(circle) {
                            
                                var tCircle = circle.toObject();
                                
                                 Friend.where( {_id : {$in : tCircle.friends }}).exec( function (err, doc) {
                                     
                                     if(err) console.log(err);
                                     
                                     tCircle.friends = doc;
                                });
                                
                                return tCircle;
                              });

                  
                           

                              Circle.count(condition, function (err, count) {

                                if (err) return console.log(err);
                                
                                
                                 return utils.responses(res, 200, {circles: resultCircles, count: count} );
                                
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
			
			                    circle             = new Circle(req.body);
								
								var message = new Object();
								
								circle.save(function(err) {
								
								  if(err){
								  
								   message.status= '401';
								   message.message = "Error Creating circle" 
                                   message.error   = err;
  
								   return utils.responses(res, 200, message)
								  }
								  else{
								  
								  Circle.findById(circle, function (err, doc) {
								
                                   message.circle	 = doc;								
							   	   message.status= '200';
								   message.message = "Circle created successfully";
  
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

exports.add_friend = function (req, res, next) {

  var token     = req.body.token;
  var _id       = req.body.circle_id;
  var friend_id = req.body.friend_id;
 
 
  AccessToken.findOne({token: token} , function(err,tok) {
  
  
  var message = req.body;
  
  var msg = token_utils.verify_access_token(tok);
  
  //console.log(msg);
  
		 if(msg == 'valid') {
		  
		            Circle.findOne({ _id : _id}, function(err,circle) {
			   		
					//console.log(circle);
					
					if(!circle){
							    message.status= '401';
								message.message = "No circle found";
								message.detail = err;
								return utils.responses(res, 401, message)
					}
					else{
                    if(friend_id) {
						
						//console.log(friend_id);
						
						if(friend_id.length > 1){
							for(var i= 0 ;i < friend_id.length;i++)
								circle.friends.addToSet (friend_id[i]);
                        }
						else
						{
							//console.log("------------------------------"+friend_id[0]);
							var id_friend = friend_id[0];
							circle.friends.addToSet (id_friend);
						}
                         circle.save(function (err, circle) {
						   if(err){
								message.status= '401';
								message.message = "Error adding friend to circle";
								message.detail = err;
								return utils.responses(res, 401, message)
							}
							else{
								message.status= '200';
								message.message = "Added friend to circle successfully";	
								return utils.responses(res, 200, message)
							}
							
						});
					}
					
				}
			    });
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
                                        }, function(user, evt, next) {
                                           
                                           user.share_by = user.first_name + ',' + user.last_name
                                              //   user.url_invitation = req.protocol + '://' + req.headers.host + '/invite/' + token

                                              Circle.findOne({ _id : circle_id}, function(err,circle) {
             
                                                console.log(circle.friends);
                
             
                                               circle.friends.forEach(function(friend_id){
             
                                                Friend.findOne({ _id : friend_id}, function(err,friend) {
               
                                                    Mailer.sendOne('share-event', "Numa Digital Fitness - Share Event", evt, function (err, responseStatus, html, text){
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
