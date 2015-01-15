var mongoose = require('mongoose');
var Goal   = mongoose.model('Goal');
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


exports.details = function( req, res, next) {


  var token   = req.query.token;
  var user_id = req.query.user_id;
 
  AccessToken.findOne({token: token} , function(err,tok) {
  
  
  var message = req.body;
  
  var msg = token_utils.verify_access_token(tok);
  
  //console.log(msg);
  
		 if(msg == 'valid') {
		  var condition = { user_id : user_id}
			   
			  Goal
				.where(condition)
				.sort({createdAt: -1})
				.exec(function(err, goals) {

				  if(err) return utils.responses(res, 500, err)

				  if(goals.length == 0){
				     	 var goal = new Object();
						 goal.daily_distance = '3000';
						 goal.daily_steps    = '10000';
						 goal.daily_calories = '500';
						 goal.daily_percent = '2';			
                         goals[0] = goal;
				  }
				  
				     return utils.responses(res, 200, goals);
				  
				})		  			  
		  }else{
		  
			message.status= '401';
			message.message = msg;
  
			return utils.responses(res, 401, message)
 
		  }
  })    
}



exports.compute = function( req, res, next) {


  var token    = req.query.token;
  var user_id  = req.query.user_id;
  var date     = req.query.date;
 
  AccessToken.findOne({token: token} , function(err,tok) {
  
  
  var message = req.body;
  
  var msg = token_utils.verify_access_token(tok);
  
  //console.log(msg);
  
		 if(msg == 'valid') {
		  
			  var condition = { user_id : user_id}
			  
              if(!user_id && !date){
						
					var message = req.body;
					message.status= '401';
					message.message = "User and date are required";
		  		    return utils.responses(res, 401, message)
			   }
			   else{
			   
                      Goal
                        .where(condition)
                        .sort({createdAt: -1})
                        .exec(function(err, goal) {

                          if(err) return utils.responses(res, 500, err)

                          var objective = new Object();
                          
                         //console.log(goal);
						 //default goal
						 
						 
					    if(goal.length == 0){
				     	 
							 var g = new Object();
							 goal.daily_distance = '3000';
							 goal.daily_steps    = '10000';
							 goal.daily_calories = '500';
							 goal.daily_percent  = '2';				
							 goal[0] = g;						   
						 
                         }
						  
                          if(goal) {
                               goal = goal[0];
                                  var updatedAt = goal.updatedAt;
                                  var current_calories = 0;
                                  var delta = Math.ceil((new Date(date) - (new Date(new Date(date).getFullYear(),0,1))) / 86400000) -
                                                      Math.ceil((new Date(updatedAt) - (new Date(new Date(updatedAt).getFullYear(),0,1))) / 86400000);
                                     
                                     console.log( "Delta:" + delta);
                                     
                                     var goal_achieve =  goal.daily_calories + (  (delta + 1) * goal.daily_calories * (goal.daily_percent /100)) ; //ugly trick to get over $lte
                                    
                                      objective.goal_to_achieve = goal_achieve;
                                      //objective.goal_current    = goal_achieve;                                   
                                    
                                    
                                    var endDate = new Date();
                                    endDate.setDate(new Date(date).getDate() + 1);
                                    
                                    console.log('new Date(date).getDate() + 1 :' + endDate);
                                    
                                    
                                    condition = {
                                                $and: [
												        { $or: [ {track_type: 'Food'},{track_type: 'Activity'}] },
                                                        { user_id : user_id },						    
                                                          {
                                                          'activity_date':  {
                                                                $lte  : endDate
                                                            }   
                                                          }								

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
                                                { $group: {  _id : { day: { $dayOfYear: "$activity_date" } },
                                                    calories_burnt: { $sum: "$calories_burnt" },calories_consumed: { $sum: "$calories_consumed" } } }
                                            ], function (err, result) {
                                                    if (err) {
                                                        console.log(err);
                                                           
                                                            if(err) return utils.responses(res, 500, err)

                                                    }
                                                    
                                                    console.log(result);
                                                    var day_of_year = Math.ceil((new Date(date) - (new Date(new Date(date).getFullYear(),0,1))) / 86400000) + 1;
                                                    var way_to_go;
                                                    
                                                    console.log( "Day of Year:" + day_of_year);
                                                    
                                                    
                                                    for(var i = 0; i < result.length; i++){
                                                      if(result[i]._id.day == day_of_year) { //Ugly trick to get over $lte.
                                                        way_to_go = result[i];
                                                        console.log(result);
                                                      }
                                                    }
                                                    
                                                    //if nothing found then it is a future date.
                                                    if(!way_to_go){                                                    
                                                        way_to_go = new Object();
                                                        way_to_go.calories_burnt = 0;
                                                        way_to_go.calories_consumed = 0;
                                                    }
                                                    
                                                    //Compute current calories state
                                                    
                                                    var current_calories     = way_to_go.calories_burnt;
                                                    var consumption_calories = way_to_go.calories_consumed;
                                                    
                                                    objective.current_calories = current_calories
                                                    
                                                    if(objective.current_calories > objective.goal_to_achieve)
                                                       objective.notification = "You have achieved your goal of " + objective.goal_to_achieve + "." + "Your consumption calories are " + consumption_calories;
                                                    else  
                                                       objective.notification = "You are " +  (objective.current_calories - objective.goal_to_achieve)  + " calories away from your goal of " + objective.goal_to_achieve +
                                                                                                                      "." + "Your consumption calories are " + consumption_calories;
                                                       
                                                       
                                                     return utils.responses(res, 200, { objective: objective} );    
                                                });    
                                          
                                       });
                          }                          
                        })
                    }                
		  }else{
		  
			message.status= '401';
			message.message = msg;
  
			return utils.responses(res, 401, message)
 
		  }
  })    
}

exports.search = function( req, res, next) {


  var token   = req.query.token;
  var user_id = req.query.user_id;
  var date     = req.query.date;
 
  AccessToken.findOne({token: token} , function(err,tok) {
  
  
  var message = req.body;
  
  var msg = token_utils.verify_access_token(tok);
  
  //console.log(msg);
  
		 if(msg == 'valid') {
		  
			  var condition = { user_id : user__id}
			  
			   
			  Goal
				.where(condition)
				.sort({createdAt: -1})
				.exec(function(err, goals) {

				  if(err) return utils.responses(res, 500, err)

				  //Default goal
				  if(goals.length == 0){
				     	 var goal = new Object();
						 goal.daily_distance = '3000';
						 goal.daily_steps    = '10000';
						 goal.daily_calories = '500';
						 goal.daily_percent = '2';			
						 goals[0] = goal;
				  }
                         
				  Goal.count(condition, function (err, count) {

					if (err) return errorHelper.mongoose(res, err);

					return utils.responses(res, 200, { goals: goals, count: count} );

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
			   
			   var message = new Object();
						
						if(!user_id){
						
						        var message = req.body;
								message.status= '401';
								message.message = "User is required";
		  
								return utils.responses(res, 401, message)
						}
						else{
			
			                  Goal.findOne({user_id: user_id}, function (err,doc) {
								
								console.log(doc);
								
                                if(doc)
								{
 								
								    doc.daily_calories     = req.body.daily_calories;
									doc.daily_percent      = req.body.daily_percent;
									doc.daily_distance     = req.body.daily_distance;
									doc.daily_steps        = req.body.daily_steps;
									
									doc.save(function(err) {
									
									  if(err){
									  
									   message.status= '401';
									   message.message = "Error Updating Goal" 
									   message.error   = err;
	  
									   return utils.responses(res, 200, message)
									  }
									  else{
									  
									  Goal.findById(doc, function (err,doc) {
									
									   message.goal	 = doc;								
									   message.status    = '200';
									   message.message   = "Goal updated successfully";
	  
									   return utils.responses(res, 200, message)
									   
									})
											
									}																			   
								   })
								}
								else
								{
								
										goal  = new Goal(req.body);
										
										
										
										goal.save(function(err) {
										
										  if(err){
										  
										   message.status= '401';
										   message.message = "Error Creating Goal" 
										   message.error   = err;
		  
										   return utils.responses(res, 200, message)
										  }
										  else{
										  
										  Goal.findById(goal, function (err,doc) {
										
										
											   message.goal	 = doc;								
											   message.status    = '200';
											   message.message   = "Goal created successfully";
			  
											   return utils.responses(res, 200, message)
											   
											})
											
										   
										   }
										});
								
									}
							    })								
						     }
			  	  			  
		  }else{
		  
			message.status= '401';
			message.message = msg;
  
			return utils.responses(res, 401, message)
 
		  }
  })
}  