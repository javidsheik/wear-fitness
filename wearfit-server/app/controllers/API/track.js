var mongoose = require('mongoose');
var Activity   = mongoose.model('Activity');
var User     = mongoose.model('User');
var Food     = mongoose.model('Food');
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

exports.details = function( req, res, next) {


  var token   = req.query.token;
  var user_id = req.query.user_id;
  var _id     = req.query._id;
 
  AccessToken.findOne({token: token} , function(err,tok) {
  
  
  var message = req.body;
  
  var msg = token_utils.verify_access_token(tok);
  
  //console.log(msg);
  
		 if(msg == 'valid') {
		  
			  var condition = { _id : _id}
			  
			   
			  Activity
				.where(condition)
				.sort({createdAt: -1})
				.exec(function(err, activities) {

				  if(err) return utils.responses(res, 500, err)

				  Activity.count(condition, function (err, count) {

					if (err) return errorHelper.mongoose(res, err);

					return utils.responses(res, 200, { activities: activities, count: count} );

				  });
				})		  			  
		  }else{
		  
			message.status= '401';
			message.message = msg;
  
			return utils.responses(res, 401, message)
 
		  }
  })    
}

exports.list_types = function( req, res, next) {


  var token   = req.query.token;
  
  AccessToken.findOne({token: token} , function(err,tok) {
  
  
  var message = req.body;
  
  var msg = token_utils.verify_access_token(tok);
  
  //console.log(msg);
  
		 if(msg == 'valid') {
		  
		  var types = utils.activityTypes();
	      return utils.responses(res, 200, { activity_types: types} );
             		  
		  }else{
		  
			message.status= '401';
			message.message = msg;
  
			return utils.responses(res, 401, message)
 
		  }
  })    
}




exports.list = function( req, res, next) {

  var token         = req.query.token;
  var user_id       = req.query.user_id;
  var page          = req.query.page;
  var perPage       = req.query.perPage;
  
  var start_date = new Date();
  start_date.setDate(new Date(req.query.start_date).getDate() - 1);
  
  var end_date = new Date();
  end_date.setDate(new Date(req.query.end_date).getDate() + 1);
  
 
  AccessToken.findOne({token: token} , function(err,tok) {
  
  var message = req.body;
  
  var msg = token_utils.verify_access_token(tok);
  
  //console.log(msg);
  
		 if(msg == 'valid') {
		  
			  var page    = (req.param.page > 0    ? req.param.page : 1) - 1;
			  var perPage = (req.param.perPage > 0 ? req.param.perPage : 15)
			  
			  var options = {
				perPage: perPage,
				page: page
			  };

			//  console.log(user_id);
			 
			if(req.query.start_date && req.query.end_date) {
            
              var condition = {
					$and: [
							{ user_id : user_id },						    
							  {
							  'activity_date':  {
									$gte  : start_date,
									$lte  : end_date 
								}   
                              }								

						  ]
				}
			
            
            }
            else if(req.query.start_date) {
             
              var condition = {
					$and: [
							{ user_id : user_id },						    
							{'activity_date': {$gt:  start_date} }
						  ]
				}
			
            
            }  
            else{
               var condition = { user_id: user_id};
            }
			 
			  Activity
				.where(condition)
				.sort({createdAt: -1})
				.skip(options.perPage * options.page)
				.limit(options.perPage)
				.exec(function(err, activities) {

				  if(err) return utils.responses(res, 500, err)

				  Activity.count(condition, function (err, count) {

					if (err) return errorHelper.mongoose(res, err);
					
					var food_ids = activities.map(function(doc) { return doc.food_id; });
					var activity_ids = activities.map(function(doc) { return doc._id; });
														
					Food.where({'_id' :  {$in : food_ids } }).exec( function(err,food) {
					
					console.log('food ids:' + food_ids);
					console.log('food:' + food);
					
					var zip = [];
					
					 for(var i = 0; i < activity_ids.length; i++){

						var output        =  new Object();
					    var activity      = _.where(activities,{_id: activity_ids[i]});
						var f             = _.where(food,{_id: food_ids[i]});
						
						output.activity = activity;
						output.food = f;
					    zip.push(output);
						
					 }
					
					  
					      return utils.responses(res, 200, { activities: zip, count: count} );
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


exports.stats = function( req, res, next) {


  var token         = req.query.token;
  var user_id       = req.query.user_id;
  var group_by      = req.query.group_by;
  
  var start_date = new Date();
  start_date.setDate(new Date(req.query.start_date).getDate() - 1);
  
  var end_date = new Date();
  end_date.setDate(new Date(req.query.end_date).getDate() + 1);
                                       
									
  //console.log(start_date);
  //console.log(end_date);
 
  AccessToken.findOne({token: token} , function(err,tok) {
  
  var message = req.body;
  
  var msg = token_utils.verify_access_token(tok);
  
  
  
  if(!user_id){
						
		var message = req.body;
		message.status= '401';
		message.message = "User is required";
		  
		return utils.responses(res, 401, message)
    }
  else{
		 if(msg == 'valid') {
		  
            var condition;
			 
            if(req.query.start_date && req.query.end_date) {
            
              var condition = {
					$and: [
					        { $or: [ {track_type: 'Food'},{track_type: 'Activity'}] },
							{ user_id: user_id },						    
							  {
							  'activity_date':  {
									$gte: start_date,
									$lte: end_date 
								}   
                              }								

						  ]
				}
			}
            else{
              var condition = {
					$and: [
					        { $or: [{track_type : 'Food'},{track_type : 'Activity'}]},
							{ user_id : user_id },						    
					      ]
				}
			
            }
			 	   
			  console.log(condition);
			  
               Activity
				.where(condition)
				.sort({createdAt: -1})
				.exec(function(err, activities) {

                 console.log(err);
                 
				  if(err) return utils.responses(res, 500, err)
				  
                  var group_by_condition;
				  
				  if(!group_by){
				  group_by_condition = {  _id : { month: { $month: "$activity_date" }, 
                                             dayOfWeek: { $dayOfWeek: "$activity_date" },
                                             day: { $dayOfMonth: "$activity_date" }, 
                                             year: { $year: "$activity_date" } },
                            calories_burnt: { $sum: "$calories_burnt" },calories_consumed: { $sum: "$calories_consumed" },
							distance: { $sum: "$distance" },
							steps: { $sum: "$steps" }
							}
				  }
				  else if(group_by == "day") {
				  group_by_condition = {  _id : {day: { $dayOfMonth: "$activity_date" }},
                            calories_burnt: { $sum: "$calories_burnt" },calories_consumed: { $sum: "$calories_consumed" },distance: { $sum: "$distance" },
							steps: { $sum: "$steps" } }
				  }    
				  else if(group_by == "week") {
				  group_by_condition = {  _id : {dayOfWeek: { $dayOfWeek: "$activity_date" }},
                            calories_burnt: { $sum: "$calories_burnt" },calories_consumed: { $sum: "$calories_consumed" },distance: { $sum: "$distance" },
							steps: { $sum: "$steps" } }
				  }
				  else if(group_by == "month") {
				  group_by_condition = {  _id : {month: { $month: "$activity_date" }},
                            calories_burnt: { $sum: "$calories_burnt" },calories_consumed: { $sum: "$calories_consumed" } ,distance: { $sum: "$distance" },
							steps: { $sum: "$steps" }}
				  }
				  else if(group_by == "year") {
				  group_by_condition = {  _id : {dayOfYear: { $dayOfYear: "$activity_date" }},
                            calories_burnt: { $sum: "$calories_burnt" },calories_consumed: { $sum: "$calories_consumed" }, distance: { $sum: "$distance" },
							steps: { $sum: "$steps" }}
				  }
                  Activity.aggregate( [
                        { $match: condition},
                        { $group: group_by_condition }
                    ], function (err, result) {
                            if (err) {
                                console.log(err);
                                return utils.responses(res, 500, err)
                            }
                           console.log(result);
                           return utils.responses(res, 200, { stats: result} );
                        });    
                  
               })		  
                  
                  
					  			  
		  }else{
		  
			message.status= '401';
			message.message = msg;
  
			return utils.responses(res, 401, message)
 
		  }
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
			
			                    activity = new Activity(req.body);
								
								if(!req.body.activity_date)
								  activity.activity_date  = new Date().toISOString();
								
								var message = new Object();
								
								activity.save(function(err) {
								
								  if(err){
								  
								  console.log(err);
								   message.status= '401';
								   message.message = "Error tracking "  + activity.track_type;
                                   message.error   = "" + err;
  
								   return utils.responses(res, 200, message)
								  }
								  else{
								  
								  Activity.findById(activity, function (err,doc) {
								
                                   message.activity	 = doc;								
							   	   message.status= '200';
								   message.message = activity.track_type + " tracked successfully";
  
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


exports.load = function (req, res, next) {

  var token = req.body.token;
  var activities = req.body.activity;
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
			else if(!activities){
						
						        var message = req.body;
								message.status= '401';
								message.message = "Empty Activities to be loaded";
		  
								return utils.responses(res, 401, message)
			}
			else{
			
            //console.log("activities:"+ activities);
            var messages = [];
            var count = 0;
            for(var i=0 ; i < activities.length;i++)
            {
               console.log("activities:"+ activities[i]);
               
                    activity = new Activity(activities[i]);
								
								if(!activities[i].activity_date)
								  activity.activity_date  = new Date().toISOString();
								
								var message = new Object();
								
								activity.save(function(err,activity) {
								
								  if(err){
                                     console.log(err);
                                     
								     message.status= '401';
								     message.message = "Error tracking "  +  activities.track_type + ' ,Name: ' +  activities.name;
                                     message.error   = "" + err;
  
                                     messages.push(message);                                
								  
								  }	

                                    count++;
                                        if( count == activities.length ){
                                        if(messages.length <= 0 )
                                        {
                 
                                               message.status= '200';
                                               message.message = "All activities loaded successfully" ;
                                               messages.push(message);   
                                        }
                                        return utils.responses(res, 200, messages);  
                                        }                                  
                                  console.log('i;'+i);
                                  
                                  
								});                               
                }
	        }
			  	  			  
		  }else{
		  
			message.status= '401';
			message.message = msg;
  
			return utils.responses(res, 401, message)
 
		  }
    }) 
}

